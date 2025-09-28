import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'package:fitness_app/features/auth/presentation/login/ui/login_screen.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';
import 'package:fitness_app/features/auth/application/register/user_add_bloc.dart';
import 'package:fitness_app/features/auth/application/register/user_add_event.dart';
import 'package:fitness_app/features/auth/application/register/user_add_state.dart';
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
    super.initState();
  }

  final UserAddBloc userAddBloc = sl<UserAddBloc>();
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
    userAddBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    // var size = MediaQuery.of(context).size;
    return BlocConsumer<UserAddBloc, UserAddState>(
      bloc: userAddBloc,
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status == UserAddStatus.saving && !_isDialogVisible) {
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

        if (state.status == UserAddStatus.saved) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
              fullscreenDialog: true,
            ),
          );
        } else if (state.status == UserAddStatus.updated) {
          Navigator.pop(context);
        } else if (state.status == UserAddStatus.failure &&
            state.errorMessage != null) {
          Fluttertoast.showToast(
            msg: state.errorMessage!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(
                    AppRadius.r20,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppHeight.h40,
                    ),
                    CustomTextFormField(
                      label: 'UserName',
                      controller: userNameController,
                      hint: 'User Name',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '*Required' : null,
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    CustomTextFormField(
                      label: 'Email',
                      controller: emailController,
                      hint: 'Email',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '*Required' : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Select Role",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    RoleDropdown(
                      roles: role,
                      selectedRole: selectedRole,
                      onChanged: (newValue) {
                        setState(() {
                          selectedRole = newValue ?? selectedRole;
                        });
                      },
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    CustomTextFormField(
                      label: 'Institution Email',
                      controller: institutionEmailController,
                      hint: 'Institution Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    CustomTextFormField(
                      label: 'Gender',
                      controller: genderController,
                      hint: 'Gender',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '*Required' : null,
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    CustomTextFormField(
                      label: 'Age',
                      controller: ageController,
                      hint: 'Age',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '*Required' : null,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    CustomTextFormField(
                      label: 'Password',
                      controller: passwordController,
                      hint: 'Password',
                      isPassword: true,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '*Required' : null,
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    CustomTextFormField(
                      label: 'Confirm Password',
                      controller: conformPasswordController,
                      hint: 'Confirm Password',
                      isPassword: true,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '*Required' : null,
                    ),
                    SizedBox(
                      height: AppHeight.h30,
                    ),
                    CustomButton(
                      child: Text(
                        widget.user == null
                            ? strings.register
                            : strings.updateUser,
                        style: getRegularStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.white,
                        ),
                      ),
                      onPressed: () async {
                        var username = userNameController.text;
                        var email = emailController.text;
                        var institutionEmail = institutionEmailController.text;
                        var gender = genderController.text;
                        var age = ageController.text;
                        var password = passwordController.text;
                        var role = selectedRole;
                        if (username.isNotEmpty && email.isNotEmpty) {
                          if (widget.user != null) {
                            var updatedUser = User(
                              age: int.parse(age),
                              email: email,
                              gender: gender,
                              id: widget.user!.id,
                              institutionEmail: institutionEmail,
                              name: username,
                              password: password,
                              role: role,
                            );
                            userAddBloc.add(UserAddUpdateButtonPressEvent(
                                updatedUser: updatedUser));
                          } else {
                            final ageInt = int.tryParse(age);
                            if (ageInt == null) {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(
                                msg: 'Please enter a valid age.',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: ColorManager.error,
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
                              role: role,
                            );
                            userAddBloc.add(
                              UserAddSaveButtonPressEvent(user: newUser),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Login",
                          style: getBoldStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h16,
                    ),
                  ],
                ),
                // ),
              ),
            ),
          ),
        );
      },
    );
  }
}
