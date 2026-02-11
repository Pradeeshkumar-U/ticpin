import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

/// ---------------- LOGIN SCREEN ----------------
class DhamoScreen extends StatefulWidget {
  const DhamoScreen({super.key});

  @override
  State<DhamoScreen> createState() => _DhamoScreenState();
}

class _DhamoScreenState extends State<DhamoScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  Future<void> login() async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );
      if (cred.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => Chatbot(peerId: "dhamo06@gmail.com", peerName: "Dhamo"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pass,
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: login, child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- CHATBOT ----------------
class Chatbot extends StatefulWidget {
  final String peerId;
  final String peerName;

  const Chatbot({super.key, required this.peerId, required this.peerName});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _con = TextEditingController();
  final ScrollController _sco = ScrollController();
  String inpmsg = "";
  final int msgLimit = 50;

  String get userEmail => FirebaseAuth.instance.currentUser?.email ?? "";

  /// Format time
  String tim(DateTime timestamp) => DateFormat('hh:mm a').format(timestamp);

  /// Send message
  Future<void> sendMessage(String v) async {
    if (v.isEmpty || userEmail.isEmpty) return;

    final chatRef = FirebaseFirestore.instance
        .collection("chat")
        .doc(userEmail);

    // Update chat meta info
    await chatRef.set({
      "chatType": "single",
      "lastMsg": v,
      "lastUpdated": FieldValue.serverTimestamp(),
      "members": [userEmail, widget.peerId],
    }, SetOptions(merge: true));

    // Add message
    await chatRef.collection("messages").add({
      "from": userEmail,
      "to": widget.peerId,
      "text": v,
      "createdAt": FieldValue.serverTimestamp(),
      "deliver": true,
      "seen": false,
    });

    _con.clear();
    setState(() => inpmsg = "");
  }

  /// Mark seen
  Future<void> markSeen(String msgId) async {
    final msgRef = FirebaseFirestore.instance
        .collection("chat")
        .doc(userEmail)
        .collection("messages")
        .doc(msgId);

    await msgRef.update({"seen": true, "seenAt": FieldValue.serverTimestamp()});
  }

  /// Input widget
  Widget input(double hei, double fs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(fs)),
        ),
        child: TextField(
          controller: _con,
          onChanged: (v) => setState(() => inpmsg = v),
          onSubmitted: (v) => sendMessage(v),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.message_outlined),
            hintText: "\tMessage...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(fs)),
            ),
            suffixIcon: InkWell(
              onTap: () => sendMessage(inpmsg),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: gradient1,
                  child: const Icon(Icons.send, color: Colors.white70),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double scrWid = Sizes().safeWidth;
  double scrHei = Sizes().safeHeight;

  @override
  Widget build(BuildContext context) {
    final wid = scrWid > 460 ? 438.0 : scrWid;
    final hei = scrHei > 700 ? 600.0 : scrHei * 0.9;
    final fs = wid * 0.3;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(211, 201, 255, 0.95),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.peerName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: gradient1,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                userEmail.isEmpty
                    ? const Center(child: Text("Not logged in"))
                    : StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection("chat")
                              .doc(userEmail)
                              .collection("messages")
                              .orderBy("createdAt", descending: true)
                              .limit(msgLimit)
                              .snapshots(),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snap.hasData || snap.data!.docs.isEmpty) {
                          return const Center(child: Text("No messages yet"));
                        }

                        final docs = snap.data!.docs;

                        return ListView.builder(
                          controller: _sco,
                          reverse: true,
                          itemCount: docs.length,
                          itemBuilder: (context, ind) {
                            final data =
                                docs[ind].data() as Map<String, dynamic>? ?? {};
                            final fromUser = data["from"] == userEmail;

                            if (!fromUser && !(data["seen"] ?? false)) {
                              markSeen(docs[ind].id);
                            }

                            return Align(
                              alignment:
                                  fromUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      fromUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: wid * 0.7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withAlpha(100),
                                        borderRadius: BorderRadius.only(
                                          topRight: const Radius.circular(20),
                                          topLeft: const Radius.circular(20),
                                          bottomRight:
                                              fromUser
                                                  ? Radius.zero
                                                  : const Radius.circular(20),
                                          bottomLeft:
                                              fromUser
                                                  ? const Radius.circular(20)
                                                  : Radius.zero,
                                        ),
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            data["text"] ?? "",
                                            style: TextStyle(
                                              fontSize: fs * 0.14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                data["createdAt"] != null
                                                    ? tim(
                                                      (data["createdAt"]
                                                              as Timestamp)
                                                          .toDate(),
                                                    )
                                                    : "",
                                                style: TextStyle(
                                                  fontSize: fs * 0.1,
                                                ),
                                              ),
                                              if (fromUser)
                                                Icon(
                                                  data["seen"] == true
                                                      ? Icons.done_all
                                                      : Icons.done,
                                                  size: 16,
                                                  color:
                                                      data["seen"] == true
                                                          ? Colors.blue
                                                          : Colors.black54,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
          SafeArea(child: input(hei, fs)),
        ],
      ),
    );
  }
}
