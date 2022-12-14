// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBI3NIZPiiSMXNcSoUWpbDfKRcb970gOOE',
    appId: '1:233860587621:web:8a52eabe0863425c9a668c',
    messagingSenderId: '233860587621',
    projectId: 'heddinmind',
    authDomain: 'heddinmind.firebaseapp.com',
    storageBucket: 'heddinmind.appspot.com',
    measurementId: 'G-PM3ERT4WKQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqZ0RabpVykLgpYtJrJzSVNDNmiaOj8Ps',
    appId: '1:233860587621:android:982dcc113175c4c09a668c',
    messagingSenderId: '233860587621',
    projectId: 'heddinmind',
    storageBucket: 'heddinmind.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDt1D2bo5HT6LBHOE0MHunY-WcdisqutTk',
    appId: '1:233860587621:ios:d0a4a827c7dd0c029a668c',
    messagingSenderId: '233860587621',
    projectId: 'heddinmind',
    storageBucket: 'heddinmind.appspot.com',
    iosClientId: '233860587621-4k5an8cg4kl2quk900p6hj90rc986j32.apps.googleusercontent.com',
    iosBundleId: 'com.example.hiddenmind',
  );
}
