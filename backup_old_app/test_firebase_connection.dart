import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'lib/backend/firebase/firebase_config.dart';
import 'lib/backend/schema/users_record.dart';
import 'lib/flutter_flow/flutter_flow_util.dart';

/// Firebase Database Connection Test
/// This file tests Firebase Firestore connectivity
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing Firebase Database Connection...\n');

  try {
    // Initialize Firebase
    await initFirebase();
    print('✅ Firebase initialized successfully');

    // Test 1: Check Firestore instance
    final firestore = FirebaseFirestore.instance;
    print('✅ Firestore instance created');

    // Test 2: Try to read from Users collection
    print('\n📊 Testing Users Collection Access...');
    try {
      final usersSnapshot = await firestore
          .collection('users')
          .limit(1)
          .get()
          .timeout(Duration(seconds: 10));

      if (usersSnapshot.docs.isEmpty) {
        print('⚠️  Users collection exists but is empty');
        print('   Collection: users');
        print('   Documents: 0');
      } else {
        print('✅ Users collection accessible');
        print('   Collection: users');
        print('   Documents found: ${usersSnapshot.docs.length}');
        print('   Sample document ID: ${usersSnapshot.docs.first.id}');
        print(
            '   Sample data fields: ${usersSnapshot.docs.first.data().keys.join(", ")}');
      }
    } catch (e) {
      print('❌ Error accessing Users collection: $e');
    }

    // Test 3: Check all collections
    print('\n📚 Testing All Collections...');
    final collections = [
      'users',
      'service_center',
      'bike_service',
      'car_service',
      'profile',
      'vechile_details',
    ];

    for (var collectionName in collections) {
      try {
        final snapshot = await firestore
            .collection(collectionName)
            .limit(1)
            .get()
            .timeout(Duration(seconds: 5));

        print('✅ $collectionName: ${snapshot.docs.length} document(s)');
      } catch (e) {
        print('❌ $collectionName: Error - ${e.toString().substring(0, 50)}...');
      }
    }

    // Test 4: Check Firebase Auth
    print('\n🔐 Testing Firebase Authentication...');
    try {
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        print('✅ User is signed in');
        print('   UID: ${currentUser.uid}');
        print('   Email: ${currentUser.email ?? "No email"}');
      } else {
        print('⚠️  No user currently signed in (expected for fresh install)');
      }
    } catch (e) {
      print('❌ Auth check error: $e');
    }

    // Test 5: Test UsersRecord class
    print('\n🧪 Testing UsersRecord Schema...');
    try {
      final query = await UsersRecord.collection.limit(1).get();
      if (query.docs.isNotEmpty) {
        final userDoc = UsersRecord.fromSnapshot(query.docs.first);
        print('✅ UsersRecord schema working');
        print('   Email: ${userDoc.email}');
        print('   Display Name: ${userDoc.displayName}');
        print('   Role ID: ${userDoc.roleId}');
      } else {
        print('⚠️  No users in database to test schema');
      }
    } catch (e) {
      print('❌ UsersRecord error: $e');
    }

    print('\n' + '=' * 50);
    print('📋 FIREBASE DATABASE TEST SUMMARY');
    print('=' * 50);
    print('Firebase Project: autolab-o7oghn');
    print('Test completed successfully!');
    print('=' * 50);
  } catch (e, stackTrace) {
    print('\n❌ CRITICAL ERROR: $e');
    print('Stack trace: $stackTrace');
  }
}
