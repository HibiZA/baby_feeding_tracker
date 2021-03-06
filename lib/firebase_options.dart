// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDIwmJZxoal7RWwcuHoL95_x0otvwQQck8',
    appId: '1:1078606838256:web:ea2ad521a99216ab930535',
    messagingSenderId: '1078606838256',
    projectId: 'baby-feeding-tracker-2c16f',
    authDomain: 'baby-feeding-tracker-2c16f.firebaseapp.com',
    storageBucket: 'baby-feeding-tracker-2c16f.appspot.com',
    measurementId: 'G-896PFDV6GQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlR-FxSV7ebQfN8-hCKpAzowz0Lt_2CB0',
    appId: '1:1078606838256:android:fbe43fe54f34c86b930535',
    messagingSenderId: '1078606838256',
    projectId: 'baby-feeding-tracker-2c16f',
    storageBucket: 'baby-feeding-tracker-2c16f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2pg65gHX5892G2hVkshfBsLtZT2UTXTY',
    appId: '1:1078606838256:ios:18d083a129384ed3930535',
    messagingSenderId: '1078606838256',
    projectId: 'baby-feeding-tracker-2c16f',
    storageBucket: 'baby-feeding-tracker-2c16f.appspot.com',
    iosClientId: '1078606838256-2m2mp8obkv31hspuirocaproda07kj01.apps.googleusercontent.com',
    iosBundleId: 'com.example.babyFeedingTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2pg65gHX5892G2hVkshfBsLtZT2UTXTY',
    appId: '1:1078606838256:ios:18d083a129384ed3930535',
    messagingSenderId: '1078606838256',
    projectId: 'baby-feeding-tracker-2c16f',
    storageBucket: 'baby-feeding-tracker-2c16f.appspot.com',
    iosClientId: '1078606838256-2m2mp8obkv31hspuirocaproda07kj01.apps.googleusercontent.com',
    iosBundleId: 'com.example.babyFeedingTracker',
  );
}
