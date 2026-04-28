import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA1AQbhwng0c0qxOhqmKwZn3-KGO2ilT-w",
            authDomain: "autolab-o7oghn.firebaseapp.com",
            projectId: "autolab-o7oghn",
            storageBucket: "autolab-o7oghn.appspot.com",
            messagingSenderId: "552612158993",
            appId: "1:552612158993:web:a085713f2965fa3fe65bb0"));
  } else {
    await Firebase.initializeApp();
  }
}
