import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/navigation/app_router.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'injection_container.dart' as di;
//import 'features/login/presentation/login/ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          debugShowCheckedModeBanner: false,
          title: AppStringsEn.appTitle,
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: Routes.splashRoute,
        );
      },
    );
  }
}
