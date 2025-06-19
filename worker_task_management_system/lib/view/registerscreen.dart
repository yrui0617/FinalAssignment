import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management_system/myconfig.dart';
import 'package:worker_task_management_system/view/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register Screen",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          backgroundColor: Colors.red.shade900,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(16.0),
                child: Card(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Your Name",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: "Address",
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          onPressed: registerWorkerDialog,
                          child: const Text("Register",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              )),
                        ))
                    
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
                onTap: () {
                Navigator.push(
                      context,
                      _createRoute(const LoginScreen()),
                      );
                }, child: const Text("Already have an account?")),
          ],
        )
      )
    );
        
  }

  void registerWorkerDialog() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all fields"),
      ));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match"),
      ));
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid email format"),
      ));
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords should be at least 6 characters long"),
      ));
      return;
    }
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Phone number should be at least 10 digits long"),
      ));
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Register this account?"),
            content: const Text("Are you sure?"),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  registerWorker();
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
        
  }

  void registerWorker() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    http.post(Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/register_worker.php"),
        body: {
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "address": address,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success!"),
          ));
          Navigator.of(context).pop();
          Navigator.push(
            context,
            _createRoute(const LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to register"),
          ));
        }
      }
    });
  }

  Route _createRoute(screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

}
