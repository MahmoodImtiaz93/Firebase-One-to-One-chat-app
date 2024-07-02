import 'package:echat/constant/app_colors.dart';
import 'package:echat/providers/auth_provider.dart';
import 'package:echat/screens/home_screen.dart';
import 'package:echat/screens/registration_scree.dart';
import 'package:echat/widgets/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/echat.jpg",
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "E-chat",
                style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40,
                    color: AppColors.primaryColor),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Let's Get Started",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Never a better time to start",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: CustomeButton(
                  text: "Let's Go!",
                  onPressed: () {
                    if (authProvider.isSignedIn) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
