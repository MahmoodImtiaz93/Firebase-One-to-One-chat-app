import 'package:echat/constant/app_colors.dart';
import 'package:echat/providers/auth_provider.dart';
import 'package:echat/widgets/custome_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String phoneNumberwithCode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: Image.asset(
                  "assets/login.jpg",
                  height: 250,
                ),
              ),
              const Text(
                "Register",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Add your phone number .\n We will send you a verification code.",
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: IntlPhoneField(
                  cursorColor: AppColors.primaryColor,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color:
                            AppColors.primaryColor, // Color for focused state
                        width:
                            2.0, // Example: make it thicker to highlight focus
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors
                            .warningColor, // Red color for error state when focused
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color:
                            AppColors.warningColor, // Red color for error state
                      ),
                    ),
                  ),
                  initialCountryCode: 'BD',
                  onChanged: (phone) {
                    // print(phone.completeNumber);
                    phoneNumberwithCode = phone.completeNumber;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: CustomeButton(
                    text: "Login",
                    onPressed: () {
                      sendPhoneNumber();
                      if (kDebugMode) {
                        print(phoneNumberwithCode);
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneNumberwithCode;
    authProvider.signInWithPhone(context, phoneNumber);
  }
}
