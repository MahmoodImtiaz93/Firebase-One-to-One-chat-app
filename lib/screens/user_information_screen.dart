import 'dart:io';

import 'package:echat/constant/app_colors.dart';
import 'package:echat/model/user_model.dart';
import 'package:echat/providers/auth_provider.dart';
import 'package:echat/screens/home_screen.dart';
import 'package:echat/utils/image_pick.dart';
import 'package:echat/widgets/custom_text_field.dart';
import 'package:echat/widgets/custome_button.dart';
import 'package:echat/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  File? imageFile;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  void selectImage() async {
    imageFile = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 5.0),
                    child: Center(
                      child: Column(children: [
                        const Text(
                          "E-chat",
                          style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontSize: 40,
                              color: AppColors.primaryColor),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () => selectImage(),
                          child: imageFile == null
                              ? const CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  radius: 50,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(imageFile!),
                                  radius: 50,
                                ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: customeTextField(
                                    hintText: "Enter Your Name!",
                                    icon: Icons.account_circle_rounded,
                                    inputType: TextInputType.name,
                                    maxLines: 1,
                                    controller: nameController),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: customeTextField(
                                    hintText: "Enter Your Email!",
                                    icon: Icons.email,
                                    inputType: TextInputType.emailAddress,
                                    maxLines: 1,
                                    controller: emailController),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: CustomeButton(
                                      text: "Submit",
                                      onPressed: () => storeData()),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                )),
    );
  }

  void storeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "");

    if (imageFile != null) {
      authProvider.saveUserDataToFirebase(
          context: context,
          userModel: userModel,
          profilePic: imageFile!,
          onSuccess: () {
            authProvider.saveUserDataToSharedPreference().then(
                  (value) => authProvider.setSignIn().then(
                        (value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false),
                      ),
                );
          });
    } else {
      showSnackbar(context, "Please upload your profile picture!");
    }
  }
}
