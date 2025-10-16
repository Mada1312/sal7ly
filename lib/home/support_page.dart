import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sal7ly/services/app_config_service.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  String? ticketId;
  bool _loadingTicket = true;
  bool _chatStarted = false;
  String userName = "User";
  String userId = "";
  String ticketStatus = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// ✅ Load user data
  Future<void> _loadUserData() async {
    try {
      userId = user?.uid ?? '';
      if (userId.isEmpty) return;

      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data()!;
        if (data['role'] != 'admin') {
          userName = data['name'] ?? 'User';
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading user data: $e');
    } finally {
      setState(() => _loadingTicket = false);
    }
  }

  /// ✅ Start chat (create new ticket)
  Future<void> _startChat() async {
    setState(() => _loadingTicket = true);

    try {
      final newTicket = await _firestore.collection('supportTickets').add({
        'userId': userId,
        'userName': userName,
        'userType': 'Customer',
        'status': 'pending',
        'issue': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ticketId = newTicket.id;
      ticketStatus = "pending";
      _chatStarted = true;
    } catch (e) {
      Get.snackbar(
        "error_title".tr, // "Error"
        "error_start_chat".tr, // "Failed to start chat."
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _loadingTicket = false);
    }
  }

  /// ✅ Send message
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || ticketId == null) return;

    try {
      await _firestore
          .collection('supportTickets')
          .doc(ticketId)
          .collection('messages')
          .add({
            'message': text,
            'sender': 'user',
            'timestamp': FieldValue.serverTimestamp(),
          });

      _messageController.clear();
    } catch (e) {
      Get.snackbar(
        "error_title".tr, // "Error"
        "error_send_message".tr, // "Failed to send message."
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// ✅ Listen for ticket status
  Stream<DocumentSnapshot>? getTicketStream() {
    if (ticketId == null) return null;
    return _firestore.collection('supportTickets').doc(ticketId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final config = Get.find<AppConfigService>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Customer Support".tr, // "Customer Support"
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(
          int.parse(config.themePrimaryColor.value.replaceFirst('#', '0xff')),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loadingTicket
          ? const Center(child: CircularProgressIndicator())
          : !_chatStarted
          // 💬 Before starting chat
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.support_agent, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    "How i can help you ?"
                        .tr, // "Hello 👋\nDo you need help or have an issue?"
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _startChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                        int.parse(
                          config.themeAccentColor.value.replaceFirst(
                            '#',
                            '0xff',
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Start Chat".tr, // "Start Chat"
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: getTicketStream(),
              builder: (context, ticketSnapshot) {
                if (!ticketSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data =
                    ticketSnapshot.data!.data() as Map<String, dynamic>?;
                ticketStatus = data?['status'] ?? 'pending';

                // 🎯 Ticket closed
                if (ticketStatus == 'closed') {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "ticket_closed_message"
                              .tr, // "We hope we solved your issue ❤️"
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ticketId = null;
                              _chatStarted = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              int.parse(
                                config.themeAccentColor.value.replaceFirst(
                                  '#',
                                  '0xff',
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Start New Chat".tr, // "Start New Chat"
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // 💬 Chat active
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('supportTickets')
                            .doc(ticketId)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final messages = snapshot.data!.docs;

                          if (messages.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "You will be answered within 5 minutes".tr,
                                  // "Please describe your issue. Our support team will respond shortly."
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg =
                                  messages[index].data()
                                      as Map<String, dynamic>;
                              final isUser = msg['sender'] == 'user';

                              return Align(
                                alignment: isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? Color(
                                            int.parse(
                                              config.themeAccentColor.value
                                                  .replaceFirst('#', '0xff'),
                                            ),
                                          )
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    msg['message'] ?? '',
                                    style: TextStyle(
                                      color: isUser
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // 📨 Message input
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey.shade100,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: "Type Your Message".tr,
                                // "Type your message..."
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                int.parse(
                                  config.themeAccentColor.value.replaceFirst(
                                    '#',
                                    '0xff',
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
