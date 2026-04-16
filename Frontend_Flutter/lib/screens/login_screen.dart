import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController =
  TextEditingController();
  final TextEditingController passwordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                /// 🔹 IMAGE
                Center(
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/512/1046/1046784.png",
                    height: 120,
                  ),
                ),

                SizedBox(height: 20),

                /// 🔹 TITLE
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                /// 🔹 EMAIL
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                SizedBox(height: 15),

                /// 🔹 PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixText: "Forgot?",
                  ),
                ),

                SizedBox(height: 20),

                /// 🔹 LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                    },
                    child: Text("Login"),
                  ),
                ),

                SizedBox(height: 20),

                /// 🔹 SOCIAL LOGIN
                Center(child: Text("Or login with")),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialButton(Icons.g_mobiledata),
                    _socialButton(Icons.facebook),
                    _socialButton(Icons.apple),
                  ],
                ),

                SizedBox(height: 20),

                /// 🔹 REGISTER NAVIGATION
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RegisterScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have account? ",
                        style: TextStyle(
                            color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                              color:
                              AppColors.primary,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 30),
    );
  }
}