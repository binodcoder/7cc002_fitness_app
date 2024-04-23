import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/model/user_model.dart';
import '../../../../injection_container.dart';
import '../../../../resources/colour_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../resources/styles_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../login/ui/login_screen.dart';
import '../../login/widgets/sign_in_button.dart';
import '../bloc/user_add_bloc.dart';
import '../bloc/user_add_event.dart';
import '../bloc/user_add_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    this.userModel,
  });

  final UserModel? userModel;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController institutionEmailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    if (widget.userModel != null) {
      userNameController.text = widget.userModel!.name;
      emailController.text = widget.userModel!.email;
      institutionEmailController.text = widget.userModel!.institutionEmail;
      genderController.text = widget.userModel!.gender;
      ageController.text = widget.userModel!.age.toString();
      passwordController.text = widget.userModel!.password;
      userAddBloc.add(UserAddReadyToUpdateEvent(widget.userModel!));
    } else {
      userAddBloc.add(UserAddInitialEvent());
    }
    super.initState();
  }

  final UserAddBloc userAddBloc = sl<UserAddBloc>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<UserAddBloc, UserAddState>(
      bloc: userAddBloc,
      listenWhen: (previous, current) => current is UserAddActionState,
      buildWhen: (previous, current) => current is! UserAddActionState,
      listener: (context, state) {
        if (state is AddUserSavedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
        } else if (state is AddUserUpdatedState) {
          // sourceController.clear();
          // descriptionController.clear();
          Navigator.pop(context);
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
                    Text(
                      "UserName",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: userNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: ColorManager.redWhite,
                        filled: true,
                        hintText: 'User Name',
                        suffixIcon: Icon(
                          Icons.person,
                          color: ColorManager.blue,
                          size: FontSize.s20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Email",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: ColorManager.redWhite,
                        filled: true,
                        hintText: 'Email',
                        suffixIcon: Icon(
                          Icons.person,
                          color: ColorManager.blue,
                          size: FontSize.s20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Institution Email",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: institutionEmailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: ColorManager.redWhite,
                        filled: true,
                        hintText: 'Institution Email',
                        suffixIcon: Icon(
                          Icons.person,
                          color: ColorManager.blue,
                          size: FontSize.s20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Gender",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: genderController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: ColorManager.redWhite,
                        filled: true,
                        hintText: 'Gender',
                        suffixIcon: Icon(
                          Icons.person,
                          color: ColorManager.blue,
                          size: FontSize.s20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Age",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: ageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: ColorManager.redWhite,
                        filled: true,
                        hintText: 'Age',
                        suffixIcon: Icon(
                          Icons.person,
                          color: ColorManager.blue,
                          size: FontSize.s20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Password",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: ColorManager.redWhite,
                        filled: true,
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: ColorManager.blue,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _passwordVisible = !_passwordVisible;
                              },
                            );
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    Text(
                      "Confirm Password",
                      style: getBoldStyle(
                        fontSize: FontSize.s15,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h10,
                    ),
                    TextFormField(
                      controller: conformPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: ColorManager.redWhite,
                        filled: true,
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: ColorManager.blue,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _confirmPasswordVisible = !_confirmPasswordVisible;
                              },
                            );
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.blueGrey),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.red),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h30,
                    ),
                    SigninButton(
                      child: Text(
                        widget.userModel == null ? AppStrings.register : AppStrings.updateUser,
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
                        var role = "standard";
                        if (username.isNotEmpty && email.isNotEmpty) {
                          if (widget.userModel != null) {
                            var updatedUser = UserModel(
                              age: int.parse(age),
                              email: email,
                              gender: gender,
                              id: widget.userModel!.id,
                              institutionEmail: institutionEmail,
                              name: username,
                              password: password,
                              role: role,
                            );
                            userAddBloc.add(UserAddUpdateButtonPressEvent(updatedUser));
                          } else {
                            var newUser = UserModel(
                              age: int.parse(age),
                              email: email,
                              gender: gender,
                              // id: widget.userModel!.id,
                              institutionEmail: institutionEmail,
                              name: username,
                              password: password,
                              role: role,
                            );
                            userAddBloc.add(UserAddSaveButtonPressEvent(newUser));
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
