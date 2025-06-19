import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management_system/model/worker.dart';
import 'package:worker_task_management_system/myconfig.dart';
import 'package:worker_task_management_system/view/mainscreen.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final String workerId;
  const ProfileUpdateScreen({super.key, required this.workerId});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Update", style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage("assets/images/userprofile.png"), // Add a placeholder image in your assets folder
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Update Your Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          buildTextField("Name", nameController, Icons.person),
                          buildTextField("Email", emailController, Icons.email),
                          buildTextField("Phone", phoneController, Icons.phone),
                          buildTextField("Address", addressController, Icons.home),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save, color: Colors.white),
                              label: const Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: updateProfileDialog,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red.shade700),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> fetchProfile() async {
    final response = await http.post(
      Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/get_profile.php"),
      body: {'worker_id': widget.workerId},
    );
    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Profile loaded successfully!")),
      );
      final profile = data['data'];
      setState(() {
        nameController.text = profile['worker_name'] ?? '';
        emailController.text = profile['worker_email'] ?? '';
        phoneController.text = profile['worker_phone'] ?? '';
        addressController.text = profile['worker_address'] ?? '';
        _loading = false;
      });
    }
  }

  
  void updateProfileDialog() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String address = addressController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all fields"),
      ));
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid email format"),
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
          title: const Text("Update Profile"),
          content: const Text("Are you sure to update current profile?"),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Update", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                updateProfile();
              },
            ),
          ],
        );
      }
    );     
  }

  Future<void> updateProfile() async {
    final response = await http.post(
      Uri.parse("${MyConfig.myurl}/worker_task_management_system/php/update_profile.php"),
      body: {
        'worker_id': widget.workerId,
        'worker_name': nameController.text,
        'worker_email': emailController.text,
        'worker_phone': phoneController.text,
        'worker_address': addressController.text,
      },
    );
    final result = json.decode(response.body);
    if (result['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        _createRoute(MainScreen(worker: Worker(
            workerId: widget.workerId,
            workerName: nameController.text,
            workerEmail: emailController.text,
            workerPhone: phoneController.text,
            workerAddress: addressController.text,
          )
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Profile updated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to update profile.")),
      );
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
