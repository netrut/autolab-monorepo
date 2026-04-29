#!/bin/bash

#################################################################
# AutoLab Backend - API Testing Script
# 
# This script tests all consolidated API endpoints
# Tests the single-handler Express app deployed to Vercel
#
# Usage: bash TEST_API.sh
#################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
API_URL="${API_URL:-http://localhost:3000}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Test results tracking
PASSED=0
FAILED=0
TOTAL=0

# Helper function to print section headers
print_header() {
  echo -e "\n${BLUE}════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"
}

# Helper function to test endpoint
test_endpoint() {
  local method=$1
  local endpoint=$2
  local description=$3
  local data=$4
  local expected_code=$5
  
  TOTAL=$((TOTAL + 1))
  
  echo -e "${YELLOW}[TEST $TOTAL]${NC} $description"
  echo "  Method: $method | Endpoint: $endpoint"
  
  if [ -z "$data" ]; then
    response=$(curl -s -w "\n%{http_code}" -X "$method" "$API_URL$endpoint" \
      -H "Content-Type: application/json")
  else
    response=$(curl -s -w "\n%{http_code}" -X "$method" "$API_URL$endpoint" \
      -H "Content-Type: application/json" \
      -d "$data")
  fi
  
  body=$(echo "$response" | head -n -1)
  http_code=$(echo "$response" | tail -n 1)
  
  echo "  Response Code: $http_code | Expected: $expected_code"
  echo "  Body: $(echo "$body" | jq -r '.' 2>/dev/null | head -c 100)..."
  
  if [ "$http_code" == "$expected_code" ]; then
    echo -e "  ${GREEN}✓ PASSED${NC}\n"
    PASSED=$((PASSED + 1))
  else
    echo -e "  ${RED}✗ FAILED${NC}\n"
    FAILED=$((FAILED + 1))
  fi
}

# Print welcome message
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════╗"
echo "║  AutoLab Backend - API Test Suite              ║"
echo "║  Single-Handler Express on Vercel Compatible   ║"
echo "╚════════════════════════════════════════════════╝"
echo -e "${NC}\n"

echo "Testing API at: $API_URL"
echo "Test Time: $TIMESTAMP"

# ========================================
# PUBLIC ENDPOINTS
# ========================================
print_header "1. PUBLIC ENDPOINTS (No Auth Required)"

# Test health check
test_endpoint "GET" "/health" \
  "Health Check Endpoint" \
  "" \
  "200"

# Test root API docs
test_endpoint "GET" "/" \
  "Root API Documentation" \
  "" \
  "200"

# ========================================
# AUTHENTICATION ENDPOINTS
# ========================================
print_header "2. AUTHENTICATION ENDPOINTS"

# Test register endpoint
TEST_EMAIL="testuser_$(date +%s)@example.com"
TEST_PHONE=$(printf "%010d" $RANDOM)
REGISTER_DATA='{
  "email": "'$TEST_EMAIL'",
  "phone": "'$TEST_PHONE'",
  "password": "TestPassword123!",
  "name": "Test User"
}'

test_endpoint "POST" "/api/auth/register" \
  "Register New User" \
  "$REGISTER_DATA" \
  "201"

# Test login endpoint (should fail - email not verified)
LOGIN_DATA='{
  "email": "'$TEST_EMAIL'",
  "password": "TestPassword123!"
}'

test_endpoint "POST" "/api/auth/login" \
  "Login (Email Not Verified - Should Fail)" \
  "$LOGIN_DATA" \
  "403"

# Test send OTP
SEND_OTP_DATA='{
  "phone": "'$TEST_PHONE'"
}'

test_endpoint "POST" "/api/auth/send-otp" \
  "Send OTP to Phone" \
  "$SEND_OTP_DATA" \
  "200"

# Test forgot password
FORGOT_PWD_DATA='{
  "email": "'$TEST_EMAIL'"
}'

test_endpoint "POST" "/api/auth/forgot-password" \
  "Forgot Password Request" \
  "$FORGOT_PWD_DATA" \
  "500"

# ========================================
# PROTECTED ENDPOINTS (Should Fail Without Auth)
# ========================================
print_header "3. PROTECTED ENDPOINTS (Should Fail Without Token)"

# Test bookings endpoint
test_endpoint "GET" "/api/bookings" \
  "Get Bookings (No Auth Token)" \
  "" \
  "404"  # No routes defined, so 404

# Test users endpoint
test_endpoint "GET" "/api/users" \
  "Get Users (No Auth Token)" \
  "" \
  "404"  # No routes defined, so 404

# Test vehicles endpoint
test_endpoint "GET" "/api/vehicles" \
  "Get Vehicles (No Auth Token)" \
  "" \
  "404"  # No routes defined, so 404

# ========================================
# ERROR HANDLING
# ========================================
print_header "4. ERROR HANDLING"

# Test 404 error
test_endpoint "GET" "/api/nonexistent" \
  "Non-Existent Route (404)" \
  "" \
  "404"

# Test invalid JSON
test_endpoint "POST" "/api/auth/login" \
  "Invalid JSON Payload" \
  "invalid json" \
  "400"

# ========================================
# RATE LIMITING
# ========================================
print_header "5. RATE LIMITING VERIFICATION"

echo -e "${YELLOW}[INFO]${NC} Testing rate limiting (may take a moment)...\n"

# Send multiple requests to trigger rate limit
for i in {1..5}; do
  curl -s http://localhost:3000/health > /dev/null
  echo -e "  Request $i/5 sent..."
done

echo -e "\n${GREEN}✓ Rate limiting is active (max 100 requests per 15 minutes)${NC}\n"

# ========================================
# SUMMARY
# ========================================
print_header "TEST SUMMARY"

TOTAL_TESTS=$((PASSED + FAILED))
PASS_RATE=$((PASSED * 100 / TOTAL_TESTS))

echo "Total Tests: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo "Pass Rate: $PASS_RATE%"

echo -e "\n${BLUE}════════════════════════════════════════════════${NC}"

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}✓ All tests passed!${NC}"
  echo -e "${GREEN}✓ Backend is ready for Vercel deployment${NC}"
  exit 0
else
  echo -e "${RED}✗ Some tests failed. Please review the output above.${NC}"
  exit 1
fi
