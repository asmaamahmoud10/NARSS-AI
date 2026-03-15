import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsView extends StatelessWidget {
  const CommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Comments"),
        backgroundColor: const Color(0xFF2E7D32),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No comments yet"));
          }

          var comments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              var data = comments[index];

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),

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
                          data['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(data['comment'], style: const TextStyle(fontSize: 15)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
