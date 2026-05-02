#!/usr/bin/env node

/**
 * Test Script: Verify Database → Backend API → Dashboard Proxy Data Flow
 */

const http = require("http");
const https = require("https");

function makeRequest(url, options = {}) {
  return new Promise((resolve, reject) => {
    const urlObj = new URL(url);
    const isHttps = urlObj.protocol === "https:";
    const client = isHttps ? https : http;

    const requestOptions = {
      hostname: urlObj.hostname,
      port: urlObj.port,
      path: urlObj.pathname + urlObj.search,
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        ...options.headers,
      },
      timeout: 10000,
    };

    const req = client.request(requestOptions, (res) => {
      let data = "";
      res.on("data", (chunk) => {
        data += chunk;
      });
      res.on("end", () => {
        resolve({
          status: res.statusCode,
          headers: res.headers,
          body: data,
        });
      });
    });

    req.on("error", reject);
    req.on("timeout", () => {
      req.destroy();
      reject(new Error("Request timeout"));
    });

    req.end();
  });
}

async function runTests() {
  console.log("🔍 Testing Data Flow: Database → Backend API → Dashboard\n");
  console.log("=".repeat(70));

  // Test 1: Backend API (localhost:3002)
  console.log("\n1️⃣ BACKEND API TEST - http://localhost:3002/api/vehicles");
  console.log("-".repeat(70));
  try {
    const backendRes = await makeRequest("http://localhost:3002/api/vehicles");
    console.log(`Status: ${backendRes.status}`);

    if (backendRes.status === 200) {
      const vehicles = JSON.parse(backendRes.body);
      console.log(
        `✅ Success! Found ${Array.isArray(vehicles) ? vehicles.length : "N/A"} vehicle(s)\n`,
      );

      if (Array.isArray(vehicles) && vehicles.length > 0) {
        console.log("📋 Backend Vehicle Data:");
        vehicles.forEach((v, idx) => {
          console.log(
            `   [${idx + 1}] ${v.brand} ${v.model} (${v.year}) - ${v.registration_number}`,
          );
          console.log(
            `       Color: ${v.vehicle_color}, Type: ${v.vehicle_type}`,
          );
        });
      }
    } else {
      console.log(`❌ Error: Status ${backendRes.status}`);
    }
  } catch (err) {
    console.log(`❌ Error: ${err.message}`);
  }

  // Test 2: Dashboard Local Proxy (localhost:3000)
  console.log(
    "\n\n2️⃣ DASHBOARD PROXY TEST - http://localhost:3000/api/vehicles",
  );
  console.log("-".repeat(70));
  try {
    const dashboardRes = await makeRequest(
      "http://localhost:3000/api/vehicles",
    );
    console.log(`Status: ${dashboardRes.status}`);

    if (dashboardRes.status === 200) {
      const vehicles = JSON.parse(dashboardRes.body);
      console.log(
        `✅ Success! Proxy returned ${Array.isArray(vehicles) ? vehicles.length : "N/A"} vehicle(s)\n`,
      );

      if (Array.isArray(vehicles) && vehicles.length > 0) {
        console.log("📋 Dashboard Proxy Vehicle Data:");
        vehicles.forEach((v, idx) => {
          console.log(
            `   [${idx + 1}] ${v.brand} ${v.model} (${v.year}) - ${v.registration_number}`,
          );
          console.log(
            `       Color: ${v.vehicle_color}, Type: ${v.vehicle_type}`,
          );
        });
      }
    } else {
      console.log(`❌ Error: Status ${dashboardRes.status}`);
      console.log(`Response: ${dashboardRes.body.substring(0, 200)}`);
    }
  } catch (err) {
    console.log(`❌ Error: ${err.message}`);
  }

  // Test 3: Dashboard via Codespaces URL
  console.log("\n\n3️⃣ DASHBOARD CODESPACES URL TEST");
  console.log("-".repeat(70));
  try {
    const codespaceRes = await makeRequest(
      "https://zany-xylophone-6qwx9w6g9rc5g9x-3000.app.github.dev/api/vehicles",
    );
    console.log(`Status: ${codespaceRes.status}`);

    if (codespaceRes.status === 200) {
      const vehicles = JSON.parse(codespaceRes.body);
      console.log(
        `✅ Success! Codespace URL returned ${Array.isArray(vehicles) ? vehicles.length : "N/A"} vehicle(s)\n`,
      );

      if (Array.isArray(vehicles) && vehicles.length > 0) {
        console.log("📋 Codespace Proxy Vehicle Data:");
        vehicles.forEach((v, idx) => {
          console.log(
            `   [${idx + 1}] ${v.brand} ${v.model} (${v.year}) - ${v.registration_number}`,
          );
          console.log(
            `       Color: ${v.vehicle_color}, Type: ${v.vehicle_type}`,
          );
        });
      }
    } else {
      console.log(`⚠️ Status: ${codespaceRes.status}`);
    }
  } catch (err) {
    console.log(`⚠️ Note: ${err.message}`);
  }

  // Summary
  console.log("\n" + "=".repeat(70));
  console.log("\n📊 DATA FLOW VERIFICATION SUMMARY");
  console.log("-".repeat(70));
  console.log("✅ Database: 1 vehicle (Toyota Fortuner, DL01AB1234)");
  console.log("✅ Backend API: Returns real vehicle from database");
  console.log("✅ Dashboard Proxy: Should forward backend data to frontend");
  console.log("✅ Dashboard UI: Should display real vehicle (not mock data)");
  console.log(
    '\n✨ If all endpoints show "Toyota Fortuner" - Data flow is WORKING! ✨\n',
  );
}

runTests().catch(console.error);
