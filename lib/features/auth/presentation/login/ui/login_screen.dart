import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/auth/presentation/register/ui/register_page.dart';
import 'package:fitness_app/features/auth/application/login/login_bloc.dart';
import 'package:fitness_app/features/auth/application/login/login_event.dart';
import 'package:fitness_app/features/auth/application/login/login_state.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_event.dart';
import '../widgets/bear_log_in_controller.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';
import '../widgets/tracking_text_input.dart';
import 'package:fitness_app/features/auth/application/reset_password/reset_password_bloc.dart';
import 'package:fitness_app/features/auth/application/reset_password/reset_password_event.dart';
import 'package:fitness_app/features/auth/application/reset_password/reset_password_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitness_app/core/localization/app_strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _isDialogVisible = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late BearLogInController bearLogInController;
  Offset? caretView;

  @override
  void initState() {
    super.initState();
    bearLogInController = BearLogInController();
    loginBloc.add(const LoginInitialEvent());
  }

  final LoginBloc loginBloc = sl<LoginBloc>();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status == LoginStatus.loading && !_isDialogVisible) {
          _isDialogVisible = true;
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          ).whenComplete(() => _isDialogVisible = false);
          return;
        }

        if (_isDialogVisible) {
          final navigator = Navigator.of(context, rootNavigator: true);
          if (navigator.canPop()) {
            navigator.pop();
          }
          _isDialogVisible = false;
        }

        if (state.status == LoginStatus.success && state.user != null) {
          userNameController.clear();
          passwordController.clear();
          if (!mounted) return;
          context.read<AuthBloc>().add(AuthLoggedIn(state.user!));
          // Navigation is driven by AuthBloc listener in MyApp.
        } else if (state.status == LoginStatus.failure &&
            state.errorMessage != null) {
          Fluttertoast.showToast(
            msg: state.errorMessage!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final ok = await showExitPopup();
            if (ok && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: const [0.0, 1.0],
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                      .withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            left: AppWidth.w20,
                            right: AppWidth.w20,
                            top: devicePadding.top + AppHeight.h50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Fitness App",
                                style: getBoldStyle(
                                  fontSize: FontSize.s30,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.2,
                              padding: EdgeInsets.only(
                                  left: AppWidth.w30, right: AppWidth.w30),
                              child: FlareActor(
                                "assets/images/Teddy.flr",
                                shouldClip: false,
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                controller: bearLogInController,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppRadius.r25),
                                ),
                              ),
                              child: Form(
                                key: formKey,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppWidth.w20,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppWidth.w20,
                                      vertical: AppHeight.h20,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.r20,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: AppHeight.h10,
                                        ),
                                        Text(
                                          "UserName",
                                          style: getBoldStyle(
                                            fontSize: FontSize.s15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppHeight.h8,
                                        ),
                                        TrackingTextInput(
                                          hint: "UserName",
                                          textEditingController:
                                              userNameController,
                                          isObscured: false,
                                          icon: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: FontSize.s20,
                                            ),
                                          ),
                                          onCaretMoved: (Offset? caret) {
                                            caretView = caret;
                                            bearLogInController
                                                .coverEyes(caret == null);
                                            bearLogInController.lookAt(caret);
                                          },
                                        ),
                                        Text(
                                          "Password",
                                          style: getBoldStyle(
                                            fontSize: FontSize.s15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppHeight.h8,
                                        ),
                                        TrackingTextInput(
                                          hint: "Password",
                                          isObscured: !_passwordVisible,
                                          textEditingController:
                                              passwordController,
                                          icon: IconButton(
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            onPressed: () {
                                              setState(
                                                () {
                                                  _passwordVisible =
                                                      !_passwordVisible;
                                                  if (_passwordVisible ==
                                                          true &&
                                                      caretView != null) {
                                                    bearLogInController
                                                        .coverEyes(
                                                            caretView == null);
                                                    bearLogInController
                                                        .lookAt(caretView);
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          onCaretMoved: (Offset? caret) {
                                            if (_passwordVisible == false) {
                                              bearLogInController
                                                  .coverEyes(caret != null);
                                              bearLogInController.lookAt(null);
                                            } else {
                                              bearLogInController
                                                  .coverEyes(caretView == null);
                                              bearLogInController
                                                  .lookAt(caretView);
                                            }
                                          },
                                        ),
                                        CustomButton(
                                          child: Text(
                                            "Login",
                                            style: getRegularStyle(
                                              fontSize: FontSize.s16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                          onPressed: () {
                                            _onLogin(loginBloc);
                                          },
                                        ),
                                        SizedBox(
                                          height: AppHeight.h16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed:
                                                  _showForgotPasswordDialog,
                                              child: const Text(
                                                  'Forgot Password?'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegisterPage(),
                                                  ),
                                                );
                                              },
                                              child: const Text('Register'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: AppHeight.h10),
                                        // Divider with text: Or continue with
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outlineVariant,
                                                thickness: 1,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: AppWidth.w10),
                                              child: Text(
                                                'Or continue with',
                                                style: getRegularStyle(
                                                  fontSize: FontSize.s14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(178),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outlineVariant,
                                                thickness: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: AppHeight.h10),
                                        OutlinedButton.icon(
                                          icon: const FaIcon(
                                            FontAwesomeIcons.google,
                                            size: 20,
                                            color: Color(0xFF4285F4),
                                          ),
                                          label: Text(
                                            'Sign in with Google',
                                            style: getRegularStyle(
                                              fontSize: FontSize.s16,
                                              color: const Color(0xFF3C4043),
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                                color: Color(0xFFDADCE0)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: AppHeight.h12,
                                              horizontal: AppWidth.w20,
                                            ),
                                            minimumSize: Size(
                                                double.infinity, AppHeight.h50),
                                          ),
                                          onPressed: () {
                                            loginBloc.add(
                                                const GoogleSignInPressed());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onLogin(LoginBloc loginBloc) async {
    if (formKey.currentState!.validate()) {
      final email = userNameController.text.trim();
      final parts = email.split('@');
      final domain = parts.length == 2 ? parts[1].toLowerCase() : '';
      final allowed = domain == 'wlv.ac.uk' || domain.endsWith('.wlv.ac.uk');
      if (!allowed) {
        Fluttertoast.showToast(
          msg: AppStringsEn.domainRestriction,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        return;
      }
      // Build the entity from inputs
      final login = LoginCredentials(
        email: email,
        password: passwordController.text,
      );
      loginBloc.add(LoginButtonPressEvent(login: login));
    }
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit App',
              style: getBoldStyle(
                fontSize: FontSize.s18,
                color: ColorManager.error,
              ),
            ),
            content: Text(
              'Do you want to exit an App?',
              style: getRegularStyle(
                fontSize: FontSize.s16,
                color: ColorManager.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text(
                  'No',
                  style: getRegularStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.green,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: Text(
                  'Yes',
                  style: getRegularStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.error,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void _showForgotPasswordDialog() {
    final emailController =
        TextEditingController(text: userNameController.text.trim());
    showDialog<void>(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (_) => sl<ResetPasswordBloc>(),
          child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
            listenWhen: (p, c) =>
                p.status != c.status || p.errorMessage != c.errorMessage,
            listener: (context, state) {
              if (state.status == ResetPasswordStatus.success) {
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  msg: 'If an account exists, a reset email has been sent.',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                );
              } else if (state.status == ResetPasswordStatus.failure) {
                Fluttertoast.showToast(
                  msg: state.errorMessage ??
                      'Something went wrong. Please try again.',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Theme.of(context).colorScheme.error,
                );
              }
            },
            builder: (context, state) {
              final isSending = state.isLoading;
              return AlertDialog(
                title: Text(
                  'Reset Password',
                  style: getBoldStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.primary,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your email to receive a reset link.',
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.black,
                      ),
                    ),
                    SizedBox(height: AppHeight.h10),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: Text(
                      'Cancel',
                      style: getRegularStyle(
                        fontSize: FontSize.s14,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            final email = emailController.text.trim();
                            if (email.isEmpty || !_isValidEmail(email)) {
                              Fluttertoast.showToast(
                                msg: 'Invalid email address.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              );
                              return;
                            }
                            context
                                .read<ResetPasswordBloc>()
                                .add(ResetPasswordSubmitted(email));
                          },
                    child: isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Send',
                            style: getRegularStyle(
                              fontSize: FontSize.s14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
}
