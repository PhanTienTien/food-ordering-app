import 'package:flutter/material.dart';
import '../constants/colors.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController =
  TextEditingController();
  final TextEditingController passwordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
        IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              /// 🔹 IMAGE
              Center(
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/3075/3075977.png",
                  height: 120,
                ),
              ),

              SizedBox(height: 20),

              /// 🔹 TITLE
              Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              /// 🔹 SOCIAL
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

              Center(child: Text("Or register with email")),

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
                ),
              ),

              SizedBox(height: 15),

              /// 🔹 CONFIRM PASSWORD
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              SizedBox(height: 20),

              /// 🔹 REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: call API register
                  },
                  child: Text("Sign up"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border:
        Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 30),
    );
  }
}