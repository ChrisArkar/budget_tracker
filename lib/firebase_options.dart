// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAwt8abudG97O5NRzkbNe1Rg5g04Qe-vsE',
    appId: '1:819916068900:web:5c163fd8b39e825d5620b1',
    messagingSenderId: '819916068900',
    projectId: 'budget-tracker-test',
    authDomain: 'budget-tracker-test.firebaseapp.com',
    storageBucket: 'budget-tracker-test.appspot.com',
    measurementId: 'G-3XB7S09EGS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlO-8556_eS_eD-1SGwCKyuDmbkIGPYdw',
    appId: '1:819916068900:android:73aa33ba77d1e8b05620b1',
    messagingSenderId: '819916068900',
    projectId: 'budget-tracker-test',
    storageBucket: 'budget-tracker-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQdptYPhCQdNNfbQUgpveodnO6h2gdXJ0',
    appId: '1:819916068900:ios:423bfcca5b0420225620b1',
    messagingSenderId: '819916068900',
    projectId: 'budget-tracker-test',
    storageBucket: 'budget-tracker-test.appspot.com',
    iosBundleId: 'com.example.testbdgtt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQdptYPhCQdNNfbQUgpveodnO6h2gdXJ0',
    appId: '1:819916068900:ios:423bfcca5b0420225620b1',
    messagingSenderId: '819916068900',
    projectId: 'budget-tracker-test',
    storageBucket: 'budget-tracker-test.appspot.com',
    iosBundleId: 'com.example.testbdgtt',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAwt8abudG97O5NRzkbNe1Rg5g04Qe-vsE',
    appId: '1:819916068900:web:122a877df14666995620b1',
    messagingSenderId: '819916068900',
    projectId: 'budget-tracker-test',
    authDomain: 'budget-tracker-test.firebaseapp.com',
    storageBucket: 'budget-tracker-test.appspot.com',
    measurementId: 'G-S7HC4SKZ32',
  );
}
