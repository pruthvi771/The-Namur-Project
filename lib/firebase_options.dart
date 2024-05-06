import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvsmahZ-zyp9QuNbBo2CAjOQiDCKMJnHs',
    appId: '1:581813390000:android:be2f9158368c7521ae8975',
    messagingSenderId: '581813390000',
    projectId: 'namur-5095e',
    storageBucket: 'namur-5095e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5mBmkal_0t0dG1DVyCLSWJZZT3s_MEj8',
    appId: '1:581813390000:ios:fb81e29ad898f8b2ae8975',
    messagingSenderId: '581813390000',
    projectId: 'namur-5095e',
    storageBucket: 'namur-5095e.appspot.com',
    androidClientId: '581813390000-3a1134gmu9v843b7204ttbv138mgosuq.apps.googleusercontent.com',
    iosClientId: '581813390000-71tugo5f6j3uk6grgc6ftu4htkas3kcr.apps.googleusercontent.com',
    iosBundleId: 'com.activeitzone.ecommerceapplesignup',
  );

}