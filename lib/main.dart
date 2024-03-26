 import 'package:fitness_app/layers/presentation_layer/login/ui/login_screen.dart';
import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'injection_container.dart';
import 'injection_container.dart' as di;
import 'layers/presentation_layer/register/bloc/post_add_bloc.dart';
import 'layers/presentation_layer/routine/bloc/routine_bloc.dart';
import 'layers/presentation_layer/routine/ui/routine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoutineBloc>(
          create: (BuildContext context) => sl<RoutineBloc>(),
        ),
        BlocProvider<PostAddBloc>(
          create: (BuildContext context) => sl<PostAddBloc>(),
        ),
      ],
      child: const ScreenUtilInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.titleLabel,
          home: LoginPage(),
        ),
      ),
    );
  }
}
