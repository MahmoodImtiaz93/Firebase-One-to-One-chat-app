// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:echat/constant/app_colors.dart';
import 'package:echat/providers/auth_provider.dart';
import 'package:echat/screens/home_screen.dart';
import 'package:echat/screens/user_information_screen.dart';
import 'package:echat/widgets/custome_button.dart';
import 'package:echat/widgets/show_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "E-chat",
                      style: TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 40,
                          color: AppColors.primaryColor),
                    ),
                    Image.asset(
                      "assets/enterotp.jpg",
                      height: 250,
                    ),
                    const Text(
                      "Verification",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Enter the OTP send to your phone number.",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Pinput(
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        onCompleted: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: CustomeButton(
                          text: "Verify",
                          onPressed: () {
                            if (otpCode != null) {
                              verifyOtp(context, otpCode!);
                              print(otpCode);
                            } else {
                              showSnackbar(context, "Enter 6-Degit code");
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Don't receive any code?",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Resend New Code",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () async {
        bool userExists = await authProvider.checkExistingUser();
        if (userExists) {
          // Existing user
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        } else {
          // New user
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserInformationScreen()),
            (route) => false,
          );
        }
      },
    );
  }
}
