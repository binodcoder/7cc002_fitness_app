import 'package:flutter/material.dart';
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
import '../widgets/login_header.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/username_field.dart';
import '../widgets/password_field.dart';
import '../widgets/or_divider.dart';
import '../widgets/google_sign_in_button.dart';
import 'package:fitness_app/features/auth/application/reset_password/reset_password_bloc.dart';
import 'package:fitness_app/features/auth/application/reset_password/reset_password_event.dart';
import 'package:fitness_app/features/auth/application/reset_password/reset_password_state.dart';
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
    // MediaQuery size if needed later

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
                      child: SafeArea(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: AppWidth.w20,
                            right: AppWidth.w20,
                            top: AppHeight.h50,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              LoginHeader(controller: bearLogInController),
                              AuthFormCard(
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UsernameField(
                                        controller: userNameController,
                                        bearController: bearLogInController,
                                        onCaretChanged: (caret) {
                                          caretView = caret;
                                        },
                                      ),
                                      PasswordField(
                                        controller: passwordController,
                                        isVisible: _passwordVisible,
                                        bearController: bearLogInController,
                                        usernameCaret: caretView,
                                        onToggleVisibility: () {
                                          setState(() {
                                            _passwordVisible = !_passwordVisible;
                                            if (_passwordVisible &&
                                                caretView != null) {
                                              bearLogInController
                                                  .coverEyes(caretView == null);
                                              bearLogInController
                                                  .lookAt(caretView);
                                            }
                                          });
                                        },
                                      ),
                                      CustomButton(
                                        child: Text(
                                          'Login',
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
                                      SizedBox(height: AppHeight.h16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed:
                                                _showForgotPasswordDialog,
                                            child:
                                                const Text('Forgot Password?'),
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
                                      const OrDivider(),
                                      GoogleSignInButton(
                                        onPressed: () {
                                          loginBloc
                                              .add(const GoogleSignInPressed());
                                        },
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
