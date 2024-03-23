// test/test_setup.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afya_chapchap/firebase_options.dart';


void main() async {
  await setupFirebaseApp();
}

Future<void> setupFirebaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
