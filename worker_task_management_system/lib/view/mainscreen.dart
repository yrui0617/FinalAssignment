import 'package:flutter/material.dart';
import 'package:worker_task_management_system/model/worker.dart';
import 'package:worker_task_management_system/view/loginscreen.dart';
import 'package:worker_task_management_system/view/registerscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:worker_task_management_system/model/task.dart';
import 'package:worker_task_management_system/myconfig.dart';
import 'package:worker_task_management_system/view/tasklistscreen.dart';
import 'package:worker_task_management_system/view/submissionhistoryscreen.dart';
import 'package:worker_task_management_system/view/profileupdatescreen.dart';


class MainScreen extends StatefulWidget {
  final Worker worker;
  const MainScreen({super.key, required this.worker});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Profile",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                _createRoute(LoginScreen()),
              );
            },
            icon: const Icon(Icons.login),
            color: Colors.white,
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/userprofile.png",
                scale: 4,
              ),
              Container(
                height: 600,
                width: 400,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 27, 27),
                      Color.fromARGB(255, 88, 141, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.all(16.0),
                
                child: Card(
                  color: const Color.fromARGB(255, 232, 234, 255),
                  
                  child: Padding(
                  padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Worker ID :  ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(0, 0, 0, 1))),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 2,  
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("${widget.worker.workerId}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      
                        Text("Full Name : ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 2,  
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("${widget.worker.workerName}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      
                        const SizedBox(
                          height: 20,
                        ),
                      
                        Text("Email : ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 2,  
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("${widget.worker.workerEmail}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      
                        const SizedBox(
                          height: 20,
                        ),
                    
                        Text("Phone Number : ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 2,  
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("${widget.worker.workerPhone}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                    
                        Text("Address : ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 300,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 2,  
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("${widget.worker.workerAddress}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          height: 65,
          color: Colors.red.shade900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      fetchTasks();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task, color: Colors.white, size: 24),
                        Text("Tasks", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        _createRoute(SubmissionHistoryScreen(workerId: widget.worker.workerId?? '')),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, color: Colors.white, size: 24),
                        Text("History", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        _createRoute(ProfileUpdateScreen(workerId: widget.worker.workerId?? '')),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, color: Colors.white, size: 24),
                        Text("Profile", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      
      floatingActionButton:
          FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Do you want register another account?"),
                  content: const Text("Are you sure?"),
                  actions: [
                    TextButton(
                      child: const Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
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
              });
            
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          ),
          
    );
  }

 void fetchTasks() async {
  List<Task> tasklist = [];
  await http.post(
    Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/get_works.php"),
    body: {
      "worker_id": widget.worker.workerId,
    },
  ).then((response) {
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata['status'] == 'success') {
        var taskData = jsondata['data'];
        tasklist = (taskData as List).map((data) => Task.fromJson(data)).toList();
        if (tasklist.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You have ${tasklist.length} tasks assigned."),
            backgroundColor: Colors.green,
          ));
          
          Navigator.push(
            context,
            _createRoute(TaskListScreen(
              tasklist: tasklist,
            )),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed!"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No tasks found."),
          backgroundColor: Colors.orange,
        ));
      }
    }}).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error: $error"),
      backgroundColor: Colors.red,
    ));
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