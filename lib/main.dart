//import 'package:fitness_app/layers/presentation/routine/get_routines/ui/routine.dart';
import 'package:fitness_app/resources/routes_manager.dart';
import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'injection_container.dart' as di;
//import 'layers/presentation/login/ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenUtilInit(
      child: MaterialApp(
        onGenerateRoute: RouteGenerator.getRoute,
        debugShowCheckedModeBanner: false,
        title: AppStrings.titleLabel,
        initialRoute: Routes.splashRoute,
      ),
    );
  }
}
