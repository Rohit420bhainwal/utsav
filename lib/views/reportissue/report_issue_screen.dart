import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class ReportIssueScreen extends StatelessWidget {
  ReportIssueScreen({super.key});

  final titleController = TextEditingController();
  final descController = TextEditingController();

  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Issue")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitIssue,
                child: const Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submitIssue() async {
    /*
    if (titleController.text.isEmpty ||
        descController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    final res = await api.post("support/report-issue", {
      "title": titleController.text,
      "description": descController.text,
    });

    if (res["success"] == true) {
      Get.back();
      Get.snackbar("Success", "Issue submitted");
    }
    */
  }
}