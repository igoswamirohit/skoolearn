import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/splash_screen.dart';
import 'package:flutter/material.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.microphone.request();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return OverlaySupport(
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
