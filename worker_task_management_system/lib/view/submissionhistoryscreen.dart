import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management_system/myconfig.dart';
import 'package:worker_task_management_system/model/submission.dart';
import 'package:worker_task_management_system/view/editsubmissionscreen.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final String workerId;
  const SubmissionHistoryScreen({super.key, required this.workerId});

  @override
  State<SubmissionHistoryScreen> createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  late Future<List<Submission>> _submissionList;

  @override
  void initState() {
    super.initState();
    _submissionList = fetchSubmissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submission History", style: TextStyle(
          fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,)),
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Submission>>(
        future: _submissionList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Failed to load submissions.'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No submissions found.'));
          }

          final submissions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final sub = submissions[index];
              return Card(
                elevation: 6,
                shadowColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sub.taskTitle ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.red),
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                _createRoute(
                                  EditSubmissionScreen(
                                    submissionId: sub.submissionId ?? '',
                                    initialText: sub.submissionPreview ?? '',
                                    sub: sub,
                                  ),
                                ),
                              );
                              if (updated == true) {
                                setState(() {
                                  _submissionList = fetchSubmissions();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("📅 ${sub.submittedAt ?? ''}", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                        sub.submissionPreview ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Submission>> fetchSubmissions() async {
    final response = await http.post(
      Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/get_submissions.php"),
      body: {'worker_id': widget.workerId},
    );

    final responseData = json.decode(response.body);

    if (responseData['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        content: Text("Submissions loaded successfully!")),
      );
      List submissions = responseData['data'];
      return submissions.map((json) => Submission.fromJson(json)).toList();
    } else {
      return [];
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
