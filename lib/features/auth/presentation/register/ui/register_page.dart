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
import 'package:fitness_app/features/auth/presentation/register/widgets/role_dropdown.dart';
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
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController institutionEmailController =
      TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController =
      TextEditingController();
  bool _isDialogVisible = false;
  int _currentStep = 0;
  final PageController _pageController = PageController();
  bool _canProceed = false;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Password visibility handled inside extracted widgets

  @override
  void initState() {
    if (widget.user != null) {
      userNameController.text = widget.user!.name;
      emailController.text = widget.user!.email;
      institutionEmailController.text = widget.user!.institutionEmail;
      genderController.text = widget.user!.gender;
      ageController.text = widget.user!.age.toString();
      passwordController.text = widget.user!.password;
      userAddBloc.add(UserAddReadyToUpdateEvent(user: widget.user!));
    } else {
      userAddBloc.add(const UserAddInitialEvent());
    }
    _attachFieldListeners();
    // Compute initial proceed state
    _updateCanProceed();
    super.initState();
  }

  final RegisterBloc userAddBloc = sl<RegisterBloc>();
  final List<String> role = <String>["trainer", "standard"];
  String selectedRole = "standard";

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    institutionEmailController.dispose();
    genderController.dispose();
    ageController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
    _pageController.dispose();
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: _canProceed
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
            onPressed: _canProceed ? _goNextOrSubmit : null,
            child: Icon(
              _currentStep == 2 ? Icons.check : Icons.arrow_forward,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    AppRadius.r20,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppHeight.h40),
                    // Slide indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final active = _currentStep == index;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: AppWidth.w4),
                          width: active ? AppWidth.w16 : AppWidth.w10,
                          height: AppHeight.h10,
                          decoration: BoxDecoration(
                            color: active
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(AppRadius.r20),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: AppHeight.h20),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (i) {
                          setState(() => _currentStep = i);
                          _updateCanProceed();
                        },
                        children: [
                          // Basic Info
                          Form(
                            key: _formKeys[0],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Basic Info',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                SizedBox(height: AppHeight.h20),
                                CustomTextFormField(
                                  label: 'UserName',
                                  controller: userNameController,
                                  hint: 'User Name',
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? '*Required'
                                      : null,
                                ),
                                SizedBox(height: AppHeight.h10),
                                CustomTextFormField(
                                  label: 'Email',
                                  controller: emailController,
                                  hint: 'Email',
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? '*Required'
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: AppHeight.h10),
                                Text("Select Role",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall),
                                SizedBox(height: AppHeight.h10),
                                RoleDropdown(
                                  roles: role,
                                  selectedRole: selectedRole,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedRole = newValue ?? selectedRole;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // More Details
                          Form(
                            key: _formKeys[1],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('More Details',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                SizedBox(height: AppHeight.h20),
                                CustomTextFormField(
                                  label: 'Institution Email',
                                  controller: institutionEmailController,
                                  hint: 'Institution Email',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: AppHeight.h10),
                                CustomTextFormField(
                                  label: 'Gender',
                                  controller: genderController,
                                  hint: 'Gender',
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? '*Required'
                                      : null,
                                ),
                                SizedBox(height: AppHeight.h10),
                                CustomTextFormField(
                                  label: 'Age',
                                  controller: ageController,
                                  hint: 'Age',
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? '*Required'
                                      : null,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          // Security
                          Form(
                            key: _formKeys[2],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Security',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                SizedBox(height: AppHeight.h20),
                                CustomTextFormField(
                                  label: 'Password',
                                  controller: passwordController,
                                  hint: 'Password',
                                  isPassword: true,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? '*Required'
                                      : null,
                                ),
                                SizedBox(height: AppHeight.h10),
                                CustomTextFormField(
                                  label: 'Confirm Password',
                                  controller: conformPasswordController,
                                  hint: 'Confirm Password',
                                  isPassword: true,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return '*Required';
                                    }
                                    if (v != passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppHeight.h20),
                    if (_currentStep > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _goBack,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    SizedBox(height: AppHeight.h16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _validateStep(int step) {
    final key = _formKeys[step];
    final currentState = key.currentState;
    if (currentState == null) return true;
    return currentState.validate();
  }

  void _goBack() {
    if (_currentStep == 0) return;
    setState(() => _currentStep -= 1);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _updateCanProceed();
  }

  void _goNextOrSubmit() {
    final isLast = _currentStep == 2;
    if (!isLast) {
      if (!_validateStep(_currentStep)) return;
    }
    if (!isLast) {
      setState(() => _currentStep += 1);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateCanProceed();
      return;
    }
    // Validate all steps before final submit
    for (var i = 0; i < _formKeys.length; i++) {
      if (!_validateStep(i)) {
        setState(() => _currentStep = i);
        _pageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }
    }
    final username = userNameController.text;
    final email = emailController.text;
    final institutionEmail = institutionEmailController.text;
    final gender = genderController.text;
    final ageText = ageController.text;
    final password = passwordController.text;
    final selected = selectedRole;

    if (widget.user != null) {
      final parsedAge = int.tryParse(ageText) ?? 0;
      final updatedUser = User(
        age: parsedAge,
        email: email,
        gender: gender,
        id: widget.user!.id,
        institutionEmail: institutionEmail,
        name: username,
        password: password,
        role: selected,
      );
      userAddBloc.add(
        UserAddUpdateButtonPressEvent(updatedUser: updatedUser),
      );
    } else {
      final ageInt = int.tryParse(ageText);
      if (ageInt == null) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Please enter a valid age.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        return;
      }
      final newUser = User(
        age: ageInt,
        email: email,
        gender: gender,
        institutionEmail: institutionEmail,
        name: username,
        password: password,
        role: selected,
      );
      userAddBloc.add(
        UserAddSaveButtonPressEvent(user: newUser),
      );
    }
  }

  void _attachFieldListeners() {
    userNameController.addListener(_updateCanProceed);
    emailController.addListener(_updateCanProceed);
    genderController.addListener(_updateCanProceed);
    ageController.addListener(_updateCanProceed);
    passwordController.addListener(_updateCanProceed);
    conformPasswordController.addListener(_updateCanProceed);
  }

  void _updateCanProceed() {
    final can = _allRequiredValidForStep(_currentStep);
    if (can != _canProceed) {
      setState(() {
        _canProceed = can;
      });
    }
  }

  bool _allRequiredValidForStep(int step) {
    switch (step) {
      case 0:
        return userNameController.text.trim().isNotEmpty &&
            emailController.text.trim().isNotEmpty &&
            selectedRole.trim().isNotEmpty;
      case 1:
        final ageInt = int.tryParse(ageController.text.trim());
        return genderController.text.trim().isNotEmpty && ageInt != null;
      case 2:
        final pwd = passwordController.text;
        final cpwd = conformPasswordController.text;
        return pwd.isNotEmpty && cpwd.isNotEmpty && pwd == cpwd;
      default:
        return false;
    }
  }
}
