import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  decoration: const InputDecoration(hintText: "username"),
                  controller: usernameController,
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
                      email: usernameController.text,
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
                        MaterialPageRoute(builder: ((context) => const HomeScreen())), (route) => false);
                  }
                  // if (usernameController.text == "abed" && passwordController.text == "123") {
                  //   Navigator.of(context).pushAndRemoveUntil(
                  //       MaterialPageRoute(builder: ((context) => const HomeScreen())), (route) => false);
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text("Wrong username or password"),
                  //     ),
                  //   );
                  // }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
