import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/home.dart';
import 'package:my_wallet/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    decoration: const InputDecoration(hintText: "email"),
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    decoration: const InputDecoration(hintText: "password"),
                    controller: passwordController,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  child: const Text("Login"),
                  onPressed: () async {
                    User? user;
                    try {
                      user = (await auth.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      ))
                          .user;
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    }

                    if (user != null) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: ((context) => HomeScreen(
                                    email: emailController.text,
                                  ))),
                          (route) => false);
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const RegisterScreen())));
                    },
                    child: const Text("Create new account")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
