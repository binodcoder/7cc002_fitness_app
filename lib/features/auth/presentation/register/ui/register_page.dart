import 'package:fitness_app/features/auth/application/register/register_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:fitness_app/app/injection_container.dart';
// Colors are sourced from Theme.of(context).colorScheme
import 'package:fitness_app/core/theme/values_manager.dart';

import 'package:fitness_app/features/auth/presentation/login/ui/login_screen.dart';
import 'package:fitness_app/features/auth/application/register/register_bloc.dart';
import 'package:fitness_app/features/auth/application/register/register_state.dart';
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    this.user,
  });

  final User? user;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController =
      TextEditingController();
  bool _isDialogVisible = false;

  // Password visibility handled inside extracted widgets

  @override
  void initState() {
    if (widget.user != null) {
      emailController.text = widget.user!.email;
      passwordController.text = widget.user!.password;
      userAddBloc.add(UserAddReadyToUpdateEvent(user: widget.user!));
    } else {
      userAddBloc.add(const UserAddInitialEvent());
    }
    // Nothing to precompute in single-step form
    super.initState();
  }

  final RegisterBloc userAddBloc = sl<RegisterBloc>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
    userAddBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return BlocConsumer<RegisterBloc, RegisterState>(
      bloc: userAddBloc,
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status == RegisterStatus.saving && !_isDialogVisible) {
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

        if (state.status == RegisterStatus.saved) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
              fullscreenDialog: true,
            ),
          );
        } else if (state.status == RegisterStatus.updated) {
          Navigator.pop(context);
        } else if (state.status == RegisterStatus.failure &&
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
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppHeight.h20),
                      CustomTextFormField(
                        label: 'Email',
                        controller: emailController,
                        hint: 'Email',
                        validator: (v) {
                          if (v == null || v.isEmpty) return '*Required';
                          final parts = v.split('@');
                          if (parts.length != 2) return 'Invalid email';
                          final domain = parts[1].toLowerCase();
                          final allowed = domain == 'wlv.ac.uk' ||
                              domain.endsWith('.wlv.ac.uk');
                          if (!allowed) {
                            return 'Use your wlv.ac.uk email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: AppHeight.h20),
                      CustomTextFormField(
                        label: 'Password',
                        controller: passwordController,
                        hint: 'Password',
                        isPassword: true,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(height: AppHeight.h20),
                      CustomTextFormField(
                        label: 'Confirm Password',
                        controller: conformPasswordController,
                        hint: 'Confirm Password',
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return '*Required';
                          if (v != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppHeight.h30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submit(context),
                          child:
                              Text(widget.user == null ? 'Register' : 'Update'),
                        ),
                      ),
                      SizedBox(height: AppHeight.h20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (widget.user != null) {
      final updatedUser = User(
        id: widget.user!.id,
        email: email,
        password: password,
        role: 'standard',
      );
      userAddBloc.add(UserAddUpdateButtonPressEvent(updatedUser: updatedUser));
    } else {
      final newUser = User(
        email: email,
        password: password,
        role: 'standard',
      );
      userAddBloc.add(UserAddSaveButtonPressEvent(user: newUser));
    }
  }
}
