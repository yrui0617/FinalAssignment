import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_task_management_system/model/worker.dart';
import 'package:worker_task_management_system/myconfig.dart';
import 'package:worker_task_management_system/view/mainscreen.dart';
import 'package:worker_task_management_system/view/loginscreen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 163, 93, 255),
              const Color.fromARGB(255, 69, 66, 238),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/worker.png", scale: 1),
              Text('Worker Task Management System',
              style:TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              const CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadUserCredentials() async {
    print("HELLOOO");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool rem = (prefs.getBool('remember')) ?? false;

    print("EMAIL: $email");
    print("PASSWORD: $password");
    print("ISCHECKED: $rem");
    if (rem == true) {
      http.post(Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/login_worker.php"), body: {
        "email": email,
        "password": password,
      }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata['status'] == 'success') {
            var workerdata = jsondata['data'];
            Worker worker = Worker.fromJson(workerdata[0]);
            print(worker.workerName);

            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(worker: worker)),
            );
            });
          } else {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
            });
          }
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      });
    }
  }
}
