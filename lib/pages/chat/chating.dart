// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// const String ADMIN_EMAIL = 'ticpin.inc@gmail.com';
// Color main_blue = Color(0xFF100d67);
// Color dark_blue = Color(0xFF000070);
// Color blue_grad = Color(0xFF5231ea);
// // PushService in `lib/push_service.dart` provides a client-side helper.
// // WARNING: storing server keys in client code is insecure - prefer server-side sending.

// /// ---------------- LOGIN SCREEN ----------------
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _pass = TextEditingController();

//   Future<void> login() async {
//     try {
//       final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _email.text.trim(),
//         password: _pass.text.trim(),
//       );
//       if (cred.user != null) {
//         final loggedEmail = cred.user?.email ?? '';
//         if (loggedEmail.toLowerCase() == ADMIN_EMAIL.toLowerCase()) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const AdminInbox()),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const Chatbot(
//                 peerId: ADMIN_EMAIL,
//                 peerName: 'Ticpin',
//               ),
//             ),
//           );
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _email,
//               decoration: const InputDecoration(hintText: 'Email'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _pass,
//               decoration: const InputDecoration(hintText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: login, child: const Text('Login')),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ---------------- CHATBOT ----------------
// class Chatbot extends StatefulWidget {
//   final String peerId;
//   final String peerName;
//   final bool canSend;

//   const Chatbot({super.key, required this.peerId, required this.peerName, this.canSend = true});

//   @override
//   State<Chatbot> createState() => _ChatbotState();
// }

// class _ChatbotState extends State<Chatbot> {
//   final TextEditingController _con = TextEditingController();
//   final ScrollController _sco = ScrollController();
//   final ScrollController _inputScroll = ScrollController();
//   String inpmsg = '';
//   String chatId = '';
//   final int msgLimit = 50;

//   @override
//   void initState() {
//     super.initState();
//     _initChat();
//   }

//   String tim(DateTime timestamp) => DateFormat('hh:mm a').format(timestamp);

//   String getChatId(String id1, String id2) {
//     final ids = [id1, id2]..sort();
//     return ids.join('_');
//   }

//   String? myId() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return null;
//     return (user.email != null && user.email!.isNotEmpty) ? user.email! : user.uid;
//   }

//   Future<void> _initChat() async {
//     final id = myId();
//     if (id == null) return;

//     chatId = getChatId(id, widget.peerId);

//     final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
//     final snap = await chatRef.get();
//     if (!snap.exists) {
//       await chatRef.set({
//         'chatType': 'single',
//         'lastMsg': '',
//         'lastUpdated': FieldValue.serverTimestamp(),
//         'members': [id, widget.peerId],
//         // helper flag to allow efficient admin queries without composite index
//         'hasAdmin': (id == ADMIN_EMAIL || widget.peerId == ADMIN_EMAIL),
//       });
//     }

//     setState(() {});
//   }

//   Future<void> sendMessage(String v) async {
//     if (!widget.canSend) return;
//     if (v.trim().isEmpty || chatId.isEmpty) return;
//     final id = myId();
//     if (id == null) return;

//     final msgData = {
//       'from': id,
//       'to': widget.peerId,
//       'text': v.trim(),
//       'createdAt': FieldValue.serverTimestamp(),
//       'deliver': true,
//       'deliverTime': FieldValue.serverTimestamp(),
//       'seen': false,
//       'seenAt': null,
//     };

//     final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
//     await chatRef.collection('messages').add(msgData);
//     await chatRef.update({'lastMsg': v.trim(), 'lastUpdated': FieldValue.serverTimestamp()});
//     _con.clear();
//     setState(() => inpmsg = '');

//     // Send push notification via PushService (client-side helper).
//     try {
//       PushService.serverKey = PushService.serverKey; // keep placeholder if not set
//       PushService.sendNotification(
//         to: widget.peerId,
//         title: 'New message from $id',
//         body: v.trim(),
//         data: {'chatId': chatId, 'from': id},
//       );
//     } catch (_) {
//       // ignore - push failure should not block chat flow
//     }
//   }

//   // Push sending is handled by `PushService` in `lib/push_service.dart`.

//   Future<void> markSeen(String msgId) async {
//     final msgRef = FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').doc(msgId);
//     await msgRef.update({'seen': true, 'seenAt': FieldValue.serverTimestamp()});
//   }

//   Future<void> markDelivered(String msgId) async {
//     final msgRef = FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').doc(msgId);
//     await msgRef.update({'deliver': true, 'deliverTime': FieldValue.serverTimestamp()});
//   }

//   Widget input(double hei, double fs) {
//     // Multiline input with camera + message area + send button.
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white, 
//           borderRadius: BorderRadius.all(Radius.circular(30)),
//           border: Border.all(color: dark_blue),
//           ),
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 4.0, right: 6.0, bottom: 2),
//               child: IconButton(
//                 icon: const Icon(Icons.message_outlined, size: 24),
//                 color: dark_blue,
//                 onPressed: () {},
//                 splashRadius: 20,
//               ),
//             ),

//             // Message input area (constrained, TextField handles internal scrolling)
//             Expanded(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxHeight: 120), // approx 4 lines
//                 child: TextField(
//                   controller: _con,
//                   scrollController: _inputScroll,
//                   keyboardType: TextInputType.multiline,
//                   textInputAction: TextInputAction.newline,
//                   minLines: 1,
//                   maxLines: 4,
//                   onChanged: (v) => setState(() => inpmsg = v),
//                   decoration: InputDecoration(
//                     hintText: 'Message...',
//                     isDense: true,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ),

//             // Send button anchored bottom-right
//             Padding(
//               padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 3.0),
//               child: InkWell(
//                 onTap: () => sendMessage(inpmsg),
//                 child: CircleAvatar(backgroundColor: main_blue, radius: 20, child: const Icon(Icons.send, color: Colors.white70)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scrWid = MediaQuery.of(context).size.width;
//     final scrHei = MediaQuery.of(context).size.height;
//     final wid = scrWid > 460 ? 438.0 : scrWid;
//     final hei = scrHei > 700 ? 600.0 : scrHei * 0.9;
//     final fs = wid * 0.3;

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(211, 201, 255, 0.95),
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(widget.peerName, style: const TextStyle(color: Colors.white)),
//         backgroundColor: main_blue,
//         leading: IconButton(onPressed: () => Navigator.pop(context), icon: const CircleAvatar(radius: 13, backgroundColor: Colors.white60, child: Icon(Icons.arrow_back, size: 15))),
//         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
//       ),
//       body: Container(
//         constraints: const BoxConstraints(maxWidth: 500, minWidth: 300),
//         margin: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Expanded(
//               child: chatId.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').orderBy('createdAt', descending: false).limit(msgLimit).snapshots(),
//                       builder: (context, snap) {
//                         if (!snap.hasData) return const Center(child: CircularProgressIndicator());
//                         final docs = snap.data!.docs;
//                         if (docs.isEmpty) return const Center(child: Text('No messages yet'));
//                         return ListView.builder(
//                           controller: _sco,
//                           reverse: true,
//                           itemCount: docs.length,
//                           itemBuilder: (context, ind) {
//                             final revind = docs.length - 1 - ind;
//                             final data = docs[revind].data() as Map<String, dynamic>;
//                             final fromUser = data['from'] == myId();

//                             // If this message is incoming and not yet marked delivered, mark it delivered
//                             if (!fromUser && !(data['deliver'] ?? false) && (data['to'] == myId())) {
//                               markDelivered(docs[revind].id);
//                             }

//                             // Mark as seen (read) when this client renders an incoming message that's not seen
//                             if (!fromUser && !(data['seen'] ?? false)) markSeen(docs[revind].id);

//                             // Determine whether to show a date divider above this message
//                             bool showDateDivider = false;
//                             DateTime? currDt;
//                             if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
//                               currDt = (data['createdAt'] as Timestamp).toDate();
//                             }
//                             DateTime? prevDt;
//                             if (revind > 0) {
//                               final prevData = docs[revind - 1].data() as Map<String, dynamic>?;
//                               if (prevData != null && prevData['createdAt'] != null && prevData['createdAt'] is Timestamp) {
//                                 prevDt = (prevData['createdAt'] as Timestamp).toDate();
//                               }
//                             }

//                             bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

//                             if (currDt != null) {
//                               if (prevDt == null) {
//                                 showDateDivider = true;
//                               } else if (!sameDay(currDt, prevDt)) {
//                                 showDateDivider = true;
//                               }
//                             }

//                             Widget dateDivider() {
//                               final txt = currDt != null ? DateFormat('dd MMM yyyy').format(currDt) : '';
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Center(
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(color: blue_grad.withAlpha(100), borderRadius: BorderRadius.circular(20)),
//                                         child: Text(txt, style: const TextStyle(color: Colors.white, fontSize: 12)),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }

//                             return Align(
//                               alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                                   children: [
//                                     if (showDateDivider) dateDivider(),
//                                     Container(
//                                       constraints: BoxConstraints(maxWidth: wid * 0.7),
//                                       decoration: BoxDecoration(
//                                         color: fromUser ? main_blue.withAlpha(200) : Colors.grey[300],
//                                         borderRadius: BorderRadius.only(
//                                           topLeft:  Radius.circular(20),
//                                           topRight:  Radius.circular(20),
//                                           bottomLeft: fromUser ? Radius.zero : const Radius.circular(20),
//                                           bottomRight: fromUser ? const Radius.circular(20) : Radius.zero,
//                                         ),
//                                         border: Border.all(color: Colors.black12),
//                                       ),
//                                       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                                       child: Text(data['text'] ?? '', style: TextStyle(fontSize: fs * 0.14, fontWeight: FontWeight.w500, color: fromUser ? Colors.white : Colors.black87)),
//                                     ),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(data['createdAt'] != null ? tim((data['createdAt'] as Timestamp).toDate()) : '', style: TextStyle(fontSize: fs * 0.1)),
//                                         const SizedBox(width: 6),
//                                         if (fromUser)
//                                           // Show single tick (sent), double gray ticks (delivered), or double blue ticks (seen)
//                                           Icon(
//                                             data['seen'] == true
//                                                 ? Icons.done_all
//                                                 : (data['deliver'] == true ? Icons.done_all : Icons.done),
//                                             size: 16,
//                                             color: data['seen'] == true
//                                                 ? Colors.blue
//                                                 : (data['deliver'] == true ? Colors.black54 : Colors.black54),
//                                           ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//             ),
//             SafeArea(child: widget.canSend ? input(hei, fs) : const SizedBox()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ---------------- ADMIN INBOX ----------------
// class AdminInbox extends StatefulWidget {
//   const AdminInbox({super.key});

//   @override
//   State<AdminInbox> createState() => _AdminInboxState();
// }

// class _AdminInboxState extends State<AdminInbox> {
//   bool useFallback = false;
//   final int _maxRetries = 2;
//   bool _checked = false; // whether initial probe completed

//   String get adminId => ADMIN_EMAIL;

//   String fmt(Timestamp? t) {
//     if (t == null) return '';
//     return DateFormat('dd MMM yy\nhh:mm a').format(t.toDate());
//   }

//   @override
//   void initState() {
//     super.initState();
//     _probePrimaryQuery();
//   }

//   Future<void> _probePrimaryQuery() async {
//     // Probe the primary (hasAdmin) query briefly during init.
//     // Retry a couple times here; if it fails, enable fallback so the UI won't get stuck later.
//     int attempts = 0;
//     while (attempts <= _maxRetries) {
//       try {
//         await FirebaseFirestore.instance
//             .collection('chats')
//             .where('hasAdmin', isEqualTo: true)
//             .orderBy('lastUpdated', descending: false)
//             .limit(1)
//             .get();
//         // success => primary query works
//         if (mounted) setState(() {
//           useFallback = false;
//           _checked = true;
//         });
//         return;
//       } catch (e) {
//         attempts++;
//         if (attempts > _maxRetries) {
//           if (mounted) setState(() {
//             useFallback = true;
//             _checked = true;
//           });
//           return;
//         }
//         // // small backoff
//         // await Future.delayed(const Duration(milliseconds: 500));
//       }
//     }
//   }
//   Widget build(BuildContext context) {
//     // Show init-time loader until probe completes so retries happen during init
//     if (!_checked) {
//       return Scaffold(
//         backgroundColor: const Color.fromRGBO(211, 201, 255, 0.95),
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text("Admin Inbox", style: const TextStyle(color: Colors.white)),
//           backgroundColor: main_blue,
//           leading: IconButton(onPressed: () => Navigator.pop(context), icon: const CircleAvatar(radius: 13, backgroundColor: Colors.white60, child: Icon(Icons.arrow_back, size: 15))),
//           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     // Primary query: use boolean `hasAdmin` to avoid requiring composite index
//     final Stream<QuerySnapshot> stream = useFallback
//       ? FirebaseFirestore.instance.collection('chats').where('members', arrayContains: adminId).snapshots()
//       : FirebaseFirestore.instance.collection('chats').where('hasAdmin', isEqualTo: true).orderBy('lastUpdated', descending: true).snapshots();

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(211, 201, 255, 0.95),
//       appBar:AppBar(
//         centerTitle: true,
//         title: Text("Admin Inbox", style: const TextStyle(color: Colors.white)),
//         backgroundColor: main_blue,
//         leading: IconButton(onPressed: () => Navigator.pop(context), icon: const CircleAvatar(radius: 13, backgroundColor: Colors.white60, child: Icon(Icons.arrow_back, size: 15))),
//         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: stream,
//         builder: (context, snap) {
//           if (snap.hasError && !useFallback) {
//             // If stream errors at runtime, immediately enable fallback as a safety net.
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (mounted) setState(() => useFallback = true);
//             });
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snap.hasData) return const Center(child: CircularProgressIndicator());

//           var docs = snap.data!.docs;
//           if (useFallback) {
//             docs = List.from(docs);
//             docs.sort((a, b) {
//               final aMap = a.data() as Map<String, dynamic>? ?? {};
//               final bMap = b.data() as Map<String, dynamic>? ?? {};
//               final aTs = aMap['lastUpdated'] is Timestamp ? (aMap['lastUpdated'] as Timestamp).toDate() : null;
//               final bTs = bMap['lastUpdated'] is Timestamp ? (bMap['lastUpdated'] as Timestamp).toDate() : null;
//               if (aTs == null && bTs == null) return 0;
//               if (aTs == null) return 1;
//               if (bTs == null) return -1;
//               return bTs.compareTo(aTs);
//             });
//           }

//           if (docs.isEmpty) return const Center(child: Text('No chats yet'));
//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, i) {
//               final data = docs[i].data() as Map<String, dynamic>;
//               final members = List<String>.from(data['members'] ?? []);
//               final other = members.firstWhere((m) => m != adminId, orElse: () => 'Unknown');
//               return ListTile(
//                 title: Text(other , style: TextStyle(color: dark_blue) , overflow: TextOverflow.ellipsis,),
//                 leading: Text((i+1).toString(),style : TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: blue_grad),),
//                 subtitle: Text(data['lastMsg'] ?? '' , style: TextStyle(color: blue_grad),overflow: TextOverflow.ellipsis,),
//                 trailing: Text(fmt(data['lastUpdated'] as Timestamp?)),
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (_) => Chatbot(peerId: other, peerName: other, canSend: true)));
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
