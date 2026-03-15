// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ai_service.dart';

class WriteCommentScreen extends StatefulWidget {
  final String name;

  const WriteCommentScreen({super.key, required this.name});

  @override
  State<WriteCommentScreen> createState() => _WriteCommentScreenState();
}

class _WriteCommentScreenState extends State<WriteCommentScreen> {
  TextEditingController commentController = TextEditingController();
  Future<void> submitComment() async {
    String comment = commentController.text.trim();

    if (comment.isEmpty) return;

    bool isRelevant = checkCommentRelevance(comment);

    if (!isRelevant) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Comment rejected (spam or link detected)"),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('comments').add({
      "name": widget.name,
      "comment": comment,
      "time": Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 233, 221),

      appBar: AppBar(
        title: const Text("Write Comment"),
        backgroundColor: const Color.fromARGB(255, 217, 233, 221),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF2E7D32),
                  child: Icon(Icons.person, color: Colors.white),
                ),

                const SizedBox(width: 10),

                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: commentController,
              maxLines: 8,

              decoration: InputDecoration(
                hintText: "Write your comment here...",

                filled: true,
                fillColor: const Color.fromARGB(255, 241, 249, 242),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: ElevatedButton(
                onPressed: submitComment,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Text(
                  "Post Comment",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
