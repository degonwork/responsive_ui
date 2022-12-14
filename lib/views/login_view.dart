import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_login_ui/controller/address_controller.dart';
import '../constants.dart';
import '../controller/login_controller.dart';
import '../controller/simple_ui_controller.dart';
import '../routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController loginController = Get.find<LoginController>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: GetBuilder<SimpleUIController>(
            builder: (simpleUIController) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return _buildLargeScreen(size, simpleUIController);
                  } else {
                    return _buildSmallScreen(size, simpleUIController);
                  }
                },
              );
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        SizedBox(width: size.width * 0.2),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * 0.2,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            AppLocalizations.of(context)!.login,
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            AppLocalizations.of(context)!.welcome("Catchy"),
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// username or Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: AppLocalizations.of(context)!.username_or_gmail,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: nameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } else if (value.length < 4) {
                      return 'at least enter 4 characters';
                    } else if (value.length > 13) {
                      return 'maximum character is 13';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: passwordController,
                  obscureText: simpleUIController.isObscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_open),
                    suffixIcon: IconButton(
                      icon: Icon(
                        simpleUIController.isObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        simpleUIController.isObscureActive();
                      },
                    ),
                    hintText: AppLocalizations.of(context)!.password,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else if (value.length < 7) {
                      return 'at least enter 6 characters';
                    } else if (value.length > 13) {
                      return 'maximum character is 13';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  AppLocalizations.of(context)!.decriptionLogin,
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Login Button
                loginButton(),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.signUp);
                    nameController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();
                    simpleUIController.isObscure = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.noAcount,
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                          text: " ${AppLocalizations.of(context)!.signUp}",
                          style: kLoginOrSignUpTextStyle(
                            size,
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
      ],
    );
  }

  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          // if (_formKey.currentState!.validate()) {
          //   String userName = nameController.text.trim();
          //   String password = passwordController.text.trim();

          //   print("Before encode: " + password);
          //   print("Before encode: " + userName);

          //   String passwordEncode = loginController.generateMd5(password);
          //   String userNameEnCode = loginController.generateMd5(userName);

          //   print("After encode: " + passwordEncode);
          //   print("After encode: " + userNameEnCode);

          Get.offNamed(Routes.country);
          Get.find<AddressController>().createProvincesToDB();
          // }
        },
        // },
        child: Text(AppLocalizations.of(context)!.login),
      ),
    );
  }
}
