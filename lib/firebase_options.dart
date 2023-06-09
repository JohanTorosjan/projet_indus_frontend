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
        return macos;
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
    apiKey: 'AIzaSyAxApYlKVjfhlLhCyEcLTnLcChJp-Esd3w',
    appId: '1:558159704744:web:7b6c93f8684a0a0327489d',
    messagingSenderId: '558159704744',
    projectId: 'sortircesoir-99c3d',
    authDomain: 'sortircesoir-99c3d.firebaseapp.com',
    storageBucket: 'sortircesoir-99c3d.appspot.com',
    measurementId: 'G-5RZVBVDS90',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHvU1nD8cy0tL-PYoLM6FF6mYBEJMjTbc',
    appId: '1:558159704744:android:ea6626047b67e4b627489d',
    messagingSenderId: '558159704744',
    projectId: 'sortircesoir-99c3d',
    storageBucket: 'sortircesoir-99c3d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsibae8Wcuk9t1eiz0_vUgSPJzp_BwtQ8',
    appId: '1:558159704744:ios:0879cd93324af74327489d',
    messagingSenderId: '558159704744',
    projectId: 'sortircesoir-99c3d',
    storageBucket: 'sortircesoir-99c3d.appspot.com',
    iosClientId: '558159704744-a0fh1s42as4quv49nu1n5h8jf6kpdufo.apps.googleusercontent.com',
    iosBundleId: 'com.example.projetIndus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsibae8Wcuk9t1eiz0_vUgSPJzp_BwtQ8',
    appId: '1:558159704744:ios:0879cd93324af74327489d',
    messagingSenderId: '558159704744',
    projectId: 'sortircesoir-99c3d',
    storageBucket: 'sortircesoir-99c3d.appspot.com',
    iosClientId: '558159704744-a0fh1s42as4quv49nu1n5h8jf6kpdufo.apps.googleusercontent.com',
    iosBundleId: 'com.example.projetIndus',
  );
}
