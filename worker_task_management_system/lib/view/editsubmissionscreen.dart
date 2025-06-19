import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management_system/myconfig.dart';
import 'package:worker_task_management_system/model/submission.dart';

class EditSubmissionScreen extends StatefulWidget {
  final String submissionId;
  final String initialText;
  final Submission sub;

  const EditSubmissionScreen({
    super.key,
    required this.submissionId,
    required this.initialText,
    required this.sub,
  });

  @override
  State<EditSubmissionScreen> createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  TextEditingController editController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Submission", style: TextStyle(
          fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,)),
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
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.sub.taskTitle ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("📅 ${widget.sub.submittedAt ?? ''}", style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(
                        widget.sub.submissionPreview ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: editController= TextEditingController(text: widget.initialText),
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: "Your Submission",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: confirmUpdate,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text("Save Changes", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateSubmission() async {

    final response = await http.post(
      Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/edit_submission.php"),
      body: {
        'submission_id': widget.submissionId,
        'updated_text': editController.text,
      },
    );
    print(response.body);
    final data = json.decode(response.body);
      if (data['status'] == 'success') {
        Navigator.pop(context,true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
            content: Text("Success to update submission!"),
          ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text("❌ Failed to update submission."),
        ));
      }
  }

  void confirmUpdate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Update"),
        content: const Text("Are you sure you want to overwrite this submission?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel", style: TextStyle(color: Colors.black))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              updateSubmission();
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

}
