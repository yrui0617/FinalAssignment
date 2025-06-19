import 'package:flutter/material.dart';
import 'package:worker_task_management_system/model/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:worker_task_management_system/myconfig.dart';

class SubmitCompletionScreen extends StatefulWidget {
  final Task task;
  const SubmitCompletionScreen({super.key, required this.task});

  @override
  State<SubmitCompletionScreen> createState() => _SubmitCompletionScreen();
}

class _SubmitCompletionScreen extends State<SubmitCompletionScreen> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Form",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.red.shade900,
        centerTitle: true,      
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 6,
                shadowColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title?? "Untitled Task",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.task.description?? "No description provided",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Due: ${widget.task.dueDate}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Status: ${widget.task.status}",
                            style: TextStyle(
                              fontSize: 15,
                              color: widget.task.status?.toLowerCase() != 'pending'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: textController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: "What did you complete?",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  String inputText = textController.text;
                  
                  if (inputText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please decribe what did you complete')),
                    );
                    return;
                  }
                  sumbitCompletion();
                },
                child: const Text('Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ), 
      ),
    );
  }

  void sumbitCompletion() async {
    await http.post(
      Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/submit_work.php"),
      body: {
        "work_id": widget.task.taskId,
        "worker_id": widget.task.workerId,
        "submission_text": textController.text,
      },
    ).then((response) {
      print(response.body); // helpful for debugging

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text("Success to submit !"),
          ));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text("Failed ! Please try again."),
          ));
        }
      }
    });
  }
  
}