// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
    // TODO(Lyokone): Remove when FlutterFire CLI updated
      case TargetPlatform.windows:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7wZb2tO1-Fs6GbDADUSTs2Qs3w08Hovw',
    appId: '1:406099696497:web:87e25e51afe982cd3574d0',
    messagingSenderId: '406099696497',
    projectId: 'flutterfire-e2e-tests',
    authDomain: 'flutterfire-e2e-tests.firebaseapp.com',
    databaseURL:
    'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutterfire-e2e-tests.appspot.com',
    measurementId: 'G-JN95N1JV2E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjH9tmLtpl5IkEIIozD9YS8uBz-2VPmyw',
    appId: '1:742483661709:android:00027cb935e7b72662e3c4',
    messagingSenderId: '742483661709',
    projectId: 'swiftsketch-dde96',
    storageBucket: 'swiftsketch-dde96.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_YsFxETgspNN7kyOvqSADctSQODfF8zs',
    appId: '1:742483661709:ios:268b3da30b04b95162e3c4',
    messagingSenderId: '742483661709',
    projectId: 'swiftsketch-dde96',
    storageBucket: 'swiftsketch-dde96.firebasestorage.app',
    iosClientId: '742483661709-qj90re8koo4emjqcldrmf1t8heard28n.apps.googleusercontent.com',
    iosBundleId: 'com.swiftsketch.swiftSketch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDooSUGSf63Ghq02_iIhtnmwMDs4HlWS6c',
    appId: '1:406099696497:ios:acd9c8e17b5e620e3574d0',
    messagingSenderId: '406099696497',
    projectId: 'flutterfire-e2e-tests',
    databaseURL:
    'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutterfire-e2e-tests.appspot.com',
    androidClientId:
    '406099696497-tvtvuiqogct1gs1s6lh114jeps7hpjm5.apps.googleusercontent.com',
    iosClientId:
    '406099696497-taeapvle10rf355ljcvq5dt134mkghmp.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.tests',
  );
}