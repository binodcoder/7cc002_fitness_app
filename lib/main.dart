import 'package:flutter/material.dart';
import 'package:fitness_app/app/app.dart';
import 'app/injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/config/backend_config.dart';
//import 'features/auth/login/presentation/login/ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (BackendConfig.isFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await di.init();
  runApp(const MyApp());
}
