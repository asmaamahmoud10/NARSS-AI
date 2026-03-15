import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'write_comment_screen.dart';
import 'comments_view.dart';

class HomeScreen extends StatelessWidget {
  final String phone;
  final String name;

  const HomeScreen({super.key, required this.phone, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 233, 221),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 233, 221),
        title: Row(
          children: [
            Image.asset("assets/images/logo.jpeg", height: 35),
            const SizedBox(width: 10),
            Text(name),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF2E7D32),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "This is a sample post. Welcome to my social app built with Flutter and Firebase!",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/logo.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined),
                        SizedBox(width: 5),
                        Text("Like"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CommentsView(),
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.comment_outlined),
                          SizedBox(width: 5),
                          Text("Comment"),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 30),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("No comments yet");
                    }

                    var comments = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var data = comments[index];

                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFF2E7D32),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              Text(data['comment']),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            color: const Color.fromARGB(255, 217, 233, 221),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 249, 242),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WriteCommentScreen(name: name),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
