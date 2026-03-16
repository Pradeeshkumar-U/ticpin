import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/glass_container.dart';

class Chatbot extends StatefulWidget {
  final String peerId;
  final String peerName;
  final bool canSend;

  const Chatbot({
    super.key,
    required this.peerId,
    required this.peerName,
    this.canSend = true,
  });

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _con = TextEditingController();
  final ScrollController _sco = ScrollController();
  String inpmsg = "";
  final int msgLimit = 50;
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email ?? user.phoneNumber ?? "";
    }
  }

  String tim(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp);
  }

  Future<void> sendMessage(String v) async {
    if (v.trim().isEmpty || !widget.canSend) return;
    _con.clear();
    setState(() => inpmsg = "");

    try {
      await FirebaseFirestore.instance
          .collection("chat")
          .doc(userEmail)
          .collection("messages")
          .add({
            "from": userEmail,
            "text": v.trim(),
            "createdAt": FieldValue.serverTimestamp(),
            "seen": false,
          });

      _sco.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  Future<void> markSeen(String msgId) async {
    if (userEmail.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection("chat")
          .doc(userEmail)
          .collection("messages")
          .doc(msgId)
          .update({"seen": true, "seenAt": FieldValue.serverTimestamp()});
    } catch (e) {
      debugPrint("Error marking seen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes();
    final double wid = size.width;
    final double fs = wid * 0.3;

    return Scaffold(
      backgroundColor:
          Platform.isIOS
              ? Colors.black
              : const Color.fromRGBO(211, 201, 255, 0.95),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Platform.isIOS ? Colors.black : whiteColor,
        title: Text(
          widget.peerName,
          style: TextStyle(
            color: Platform.isIOS ? whiteColor : Colors.white,
            fontFamily: 'Regular',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Platform.isIOS ? Colors.black : gradient1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: whiteColor),
        ),
      ),
      body: Stack(
        children: [
          if (Platform.isIOS)
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradient1, gradient2, Colors.black],
                ),
              ),
            ),
          Column(
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
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snap.hasData || snap.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  "No messages yet",
                                  style: TextStyle(
                                    color:
                                        Platform.isIOS
                                            ? whiteColor
                                            : Colors.black54,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                              );
                            }

                            final docs = snap.data!.docs;

                            return ListView.builder(
                              controller: _sco,
                              reverse: true,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: docs.length,
                              itemBuilder: (context, ind) {
                                final data =
                                    docs[ind].data() as Map<String, dynamic>? ??
                                    {};
                                final fromUser = data["from"] == userEmail;

                                if (!fromUser && !(data["seen"] ?? false)) {
                                  markSeen(docs[ind].id);
                                }

                                return _buildChatBubble(
                                  data,
                                  fromUser,
                                  wid,
                                  fs,
                                );
                              },
                            );
                          },
                        ),
              ),
              _buildInputArea(size, fs),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(
    Map<String, dynamic> data,
    bool fromUser,
    double wid,
    double fs,
  ) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: TicpinGlassContainer(
          width: wid * 0.75,
          height: 60, // Fixed height required by TicpinGlassContainer
          borderRadius: 18,
          child: Container(
            constraints: BoxConstraints(maxWidth: wid * 0.75),
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color:
                  fromUser
                      ? (Platform.isIOS
                          ? Colors.white.withOpacity(0.15)
                          : gradient1.withOpacity(0.9))
                      : (Platform.isIOS
                          ? Colors.black.withOpacity(0.3)
                          : Colors.white),
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(18),
                topLeft: const Radius.circular(18),
                bottomRight: fromUser ? Radius.zero : const Radius.circular(18),
                bottomLeft: fromUser ? const Radius.circular(18) : Radius.zero,
              ),
              border: Border.all(
                color: Platform.isIOS ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data["text"] ?? "",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Regular',
                    color:
                        fromUser || Platform.isIOS
                            ? Colors.white
                            : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data["createdAt"] != null
                          ? tim((data["createdAt"] as Timestamp).toDate())
                          : "",
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            fromUser || Platform.isIOS
                                ? Colors.white70
                                : Colors.black54,
                        fontFamily: 'Regular',
                      ),
                    ),
                    if (fromUser) ...[
                      const SizedBox(width: 4),
                      Icon(
                        data["seen"] == true ? Icons.done_all : Icons.done,
                        size: 14,
                        color:
                            data["seen"] == true
                                ? Colors.blueAccent
                                : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(Sizes size, double fs) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TicpinGlassContainer(
                width: size.width - 80,
                height: 50,
                borderRadius: 25,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Platform.isIOS
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _con,
                    onChanged: (v) => setState(() => inpmsg = v),
                    onSubmitted: (v) => sendMessage(v),
                    style: TextStyle(
                      color: Platform.isIOS ? whiteColor : Colors.black87,
                      fontFamily: 'Regular',
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      hintText: "Message...",
                      hintStyle: TextStyle(
                        color: Platform.isIOS ? Colors.white54 : Colors.black38,
                        fontFamily: 'Regular',
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => sendMessage(inpmsg),
              child: CircleAvatar(
                radius: 24,
                backgroundColor:
                    inpmsg.trim().isEmpty
                        ? greyColor.withOpacity(0.5)
                        : gradient1,
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
