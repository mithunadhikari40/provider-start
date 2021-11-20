import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:places/src/api/auth_api.dart';
import 'package:places/src/screens/dashboard/dashboard_screen.dart';
import 'package:places/src/screens/auth/signup_screen.dart';
import 'package:places/src/utils/snackbar_helper.dart';
import 'package:places/src/widgets/custom_app_bar.dart';
import 'package:places/src/widgets/input_email.dart';
import 'package:places/src/widgets/input_password.dart';
import 'package:places/src/widgets/shared/app_colors.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController(text:"outlook@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "Nepal@123");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        // leading: Icon(Icons.close),
        leading: Container(),
        context: context,
        subTitle: "Login to your \n account",
      ),
      body:
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 24),
                    InputEmail(
                      controller: _emailController,
                    ),
                    InputPassword(
                      controller: _passwordController,
                    ),
                    _buildOption(context),
                    _buildSubmitButton(context),
                    SizedBox(height: 12),
                    _buildTermsAndConditions(context),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              _buildSignUpSection(context)
            ],
          ),

    );
  }

  Widget _buildOption(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {},
            child: Text(
              "Forget Password ?",
              style: TextStyle(
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: primaryColor, height: 1.5),
              children: [
                TextSpan(
                    text: 'By continuing, you agree to our\n ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  style: TextStyle(color: primaryColor),
                  children: [
                    TextSpan(
                        text: 'Terms and conditions ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Terms and conditions clicked");
                          }),
                    TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Privacy policy clicked");
                          })
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide.none),
            padding: EdgeInsets.all(18.0),
            primary: primaryColor,
          ),
          onPressed:() {
                  _onSubmit(context);
                },
          child:  Text("Submit"),
        ),
      ),
    );
  }

  Future _onSubmit(BuildContext context) async {
    final api = AuthApi();
    final response =
        await api.login(_emailController.text, _passwordController.text);
    if (response.status) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return DashboardScreen();
      }));
    } else {
      showSnackBar(context, response.message!);
    }
  }

  Widget _buildSignUpSection(BuildContext context) {
    return Column(
      children: [
        Divider(),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
              child: Text("Sign up"),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: primaryColor)),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
