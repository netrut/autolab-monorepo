import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/backend/firebase/firebase_config.dart';

void main() async {
  print('🔧 Setting up password for test user...\n');

  await initFirebase();

  final firestore = FirebaseFirestore.instance;

  // Check users with emails
  print('📧 Fetching users with email addresses...');
  final usersSnapshot =
      await firestore.collection('users').where('email', isNull: false).get();

  print('Found ${usersSnapshot.docs.length} users with emails:\n');

  for (var doc in usersSnapshot.docs) {
    final data = doc.data();
    print('User: ${doc.id}');
    print('  Email: ${data['email']}');
    print('  Name: ${data['display_name'] ?? 'N/A'}');
    print('  Phone: ${data['phone_number'] ?? 'N/A'}');
    print('  UID: ${data['uid'] ?? 'N/A'}');
    print('');
  }

  print('\n📝 To reset password for a user:');
  print('1. Go to Firebase Console: https://console.firebase.google.com/');
  print('2. Select your project: autolab-o7oghn');
  print('3. Go to Authentication → Users');
  print('4. Find user by email (e.g., netru8@gmail.com)');
  print('5. Click the 3 dots → Reset password');
  print('6. Firebase will send a password reset email');
  print('7. Use that to set a new password');
  print('8. Then you can login with email + password\n');

  print(
      '⚠️  NOTE: Email/password login is NOT currently implemented in your app.');
  print('   You need to add it to the login page first!\n');
}
