import 'package:fitness_app/layers/presentation_layer/register/ui/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../../../../resources/colour_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/styles_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../routine/ui/routine.dart';
import '../widgets/bear_log_in_controller.dart';
import '../widgets/sign_in_button.dart';
import '../widgets/tracking_text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late BearLogInController bearLogInController;
  Offset? caretView;

  @override
  void initState() {
    super.initState();
    bearLogInController = BearLogInController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        // bottomSheet: SizedBox(
        //   width: double.infinity,
        //   height: size.height * 0.035,
        //   child: Container(
        //     color: ColorManager.blackOpacity87,
        //     padding: EdgeInsets.only(top: AppHeight.h4),
        //     // height: size.height * 0.02,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Powered by:   ',
        //           textAlign: TextAlign.center,
        //           style: getRegularStyle(
        //             fontSize: FontSize.s10,
        //             color: ColorManager.white,
        //           ),
        //         ),
        //         Image.asset(
        //           'assets/images/logo.jpeg',
        //           height: size.height * 0.03,
        //           width: size.width * 0.15,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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
                        ColorManager.primary,
                        ColorManager.primaryOpacity70,
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
                            color: ColorManager.white,
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
                          color: ColorManager.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppRadius.r25),
                          ),
                        ),
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: AppWidth.w20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppWidth.w20),
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
                                    height: AppHeight.h20,
                                  ),
                                  Text(
                                    "UserName",
                                    style: getBoldStyle(
                                      fontSize: FontSize.s15,
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppHeight.h8,
                                  ),
                                  TrackingTextInput(
                                    hint: "UserName",
                                    textEditingController: userNameController,
                                    isObscured: false,
                                    icon: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.person,
                                        color: ColorManager.blue,
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
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppHeight.h8,
                                  ),
                                  TrackingTextInput(
                                    hint: "Password",
                                    isObscured: !_passwordVisible,
                                    textEditingController: passwordController,
                                    icon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: ColorManager.blue,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            _passwordVisible =
                                                !_passwordVisible;
                                            if (_passwordVisible == true &&
                                                caretView != null) {
                                              bearLogInController
                                                  .coverEyes(caretView == null);
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
                                        bearLogInController.lookAt(caretView);
                                      }
                                    },
                                  ),
                                  SigninButton(
                                    child: Text(
                                      "Login",
                                      style: getRegularStyle(
                                        fontSize: FontSize.s16,
                                        color: ColorManager.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RoutinePage(),
                                        ),
                                      );

                                      // _onLogin(readLoginServiceProvider);
                                    },
                                  ),
                                  SizedBox(
                                    height: AppHeight.h10,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Register',
                                        )),
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
    );
  }

  // _onLogin(LoginServiceProvider readLoginServiceProvider) async {
  //   if (formKey.currentState!.validate()) {
  //     LoginModel loginModel = LoginModel(
  //       userName: userNameController!.text,
  //       password: passwordController.text,
  //     );
  //
  //     var login = await readLoginServiceProvider.getLogin(loginModel);
  //
  //     if (login != null) {
  //       if (!mounted) return;
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const HomePage(),
  //         ),
  //       );
  //     } else {
  //       Fluttertoast.cancel();
  //       return Fluttertoast.showToast(
  //         msg: 'Username or Password is Incorrect.',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: ColorManager.error,
  //       );
  //     }
  //   }
  // }

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
}
