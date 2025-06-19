import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management_system/model/worker.dart';
import 'package:worker_task_management_system/myconfig.dart';
import 'package:worker_task_management_system/view/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_task_management_system/view/registerscreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen", style: TextStyle(
          fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,)),
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/worker.png",
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
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
                        Row(
                          children: [
                            const Text("Remember Me"),
                            Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  if (isChecked) {
                                    if (email.isEmpty && password.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Please fill all fields"),
                                        backgroundColor: Colors.red,
                                      ));
                                      isChecked = false;
                                      return;
                                    }
                                  }
                                  storeCredentials(email, password, isChecked);
                                }),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              loginUser();
                            },
                            child: const Text("Login"))
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                Navigator.push(
                      context,
                      _createRoute(RegisterScreen()),
                      );
                }, child: const Text("Register an account?")),
              const SizedBox(height: 10),
            ],
          )
        ),
      ),
    );
  }

  Future<void> loginUser() async{
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all fields"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    await http.post(Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/login_worker.php"), body: {
      "email": email,
      "password": password,
    }).then((response) {
      //  print(response.body);
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          var workerdata = jsondata['data'];
          Worker worker = Worker.fromJson(workerdata[0]);
          print(worker.workerName);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Welcome ${worker.workerName} !"),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
          Navigator.push(
            context,
            _createRoute(MainScreen(worker: worker)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed!"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  Future<void> storeCredentials(
      String email, String password, bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('remember', isChecked);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Pref Stored Success!"),
        backgroundColor: Colors.green,
      ));
    } else {
      await prefs.remove('email');
      await prefs.remove('pass');
      await prefs.remove('remember');
      emailController.clear();
      passwordController.clear();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Pref Removed!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('pass');
    bool? isChecked = prefs.getBool('remember');
    if (email != null && password != null && isChecked != null) {
      emailController.text = email;
      passwordController.text = password;
      setState(() {
        this.isChecked = isChecked!;
      });
    } else {
      emailController.clear();
      passwordController.clear();
      isChecked = false;
      setState(() {});
    }
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
