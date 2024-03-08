import 'package:fitness_app/features/call/call.dart';
import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/add_post/presentation/bloc/post_add_bloc.dart';
import 'features/home/presentation/bloc/routine_bloc.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
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
          home: CallPage(),
        ),
      ),
    );
  }
}
