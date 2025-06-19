import 'package:flutter/material.dart';
import 'package:worker_task_management_system/model/task.dart';
import 'package:worker_task_management_system/view/submitcompletionscreen.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasklist;
  const TaskListScreen({super.key, required this.tasklist});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      ),
      body: widget.tasklist.isEmpty
      ? const Center(
          child: Text(
            "No Tasks Available",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        )
      : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: widget.tasklist.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final task = widget.tasklist[index];
            return Card(
              elevation: 6,
              shadowColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),

              child:InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    _createRoute(SubmitCompletionScreen(task: task)),
                  );
                },
                
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title?? "Untitled Task",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        task.description ?? "No description provided",
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
                            "Due: ${task.dueDate}",
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
                            "Status: ${task.status}",
                            style: TextStyle(
                              fontSize: 15,
                              color: task.status == 'Completed' ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
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

