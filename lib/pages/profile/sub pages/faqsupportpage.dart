import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:url_launcher/url_launcher.dart';

// ==================== FAQ PAGE ====================

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<FAQ> faqs = [
    FAQ(
      question: 'How do I book tickets?',
      answer:
          'You can book tickets by browsing events, selecting your preferred date and time, and completing the checkout process. Make sure to complete your profile before booking.',
    ),
    FAQ(
      question: 'Can I cancel my booking?',
      answer:
          'Cancellation policies vary by event/turf. Generally, you can cancel up to 24 hours before the event for a full refund. Check the specific terms on your booking page.',
    ),
    FAQ(
      question: 'How do I add items to my TicList?',
      answer:
          'Tap the bookmark icon on any event, turf, artist, or restaurant page to add it to your TicList. You can access your saved items from your profile.',
    ),
    FAQ(
      question: 'What payment methods are accepted?',
      answer:
          'We accept all major credit/debit cards, UPI, net banking, and digital wallets. All payments are secure and encrypted.',
    ),
    FAQ(
      question: 'How do I get my tickets?',
      answer:
          'After successful payment, your tickets will be available in the "My Bookings" section. You can show the digital ticket at the venue or download it as PDF.',
    ),
    FAQ(
      question: 'What if the event is cancelled?',
      answer:
          'If an event is cancelled by the organizer, you will receive a full automatic refund within 5-7 business days. You\'ll also be notified via email and app notification.',
    ),
    FAQ(
      question: 'How do I contact customer support?',
      answer:
          'You can reach our support team via the "Chat with us" option in your profile, or email us at support@ticpin.com. We typically respond within 24 hours.',
    ),
    FAQ(
      question: 'Can I transfer my tickets?',
      answer:
          'Yes, most tickets can be transferred to another person. Go to your booking details and select "Transfer Ticket" option. The recipient will receive the ticket via email.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Frequently Asked Questions',
          style: TextStyle(fontFamily: 'Regular'),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return _buildFAQTile(faqs[index]);
        },
      ),
    );
  }

  Widget _buildFAQTile(FAQ faq) {
    return Card(
      color: whiteColor,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          collapsedIconColor: blackColor,
          iconColor: blackColor,
          shape: Border(), // removes expanded border
          collapsedShape: Border(), // removes collapsed border
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.all(16),
          title: Text(
            faq.question,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
            ),
          ),
          children: [
            Text(
              faq.answer,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Regular',
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

// ==================== CHAT SUPPORT PAGE ====================

class ChatSupportPage extends StatefulWidget {
  const ChatSupportPage({Key? key}) : super(key: key);

  @override
  State<ChatSupportPage> createState() => _ChatSupportPageState();
}

class _ChatSupportPageState extends State<ChatSupportPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    // Simulate bot response
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text:
                  'Thank you for contacting us! Our support team will get back to you shortly.',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Customer Support',
              style: TextStyle(fontFamily: 'Regular', fontSize: 18),
            ),
            Text(
              'Online',
              style: TextStyle(
                fontFamily: 'Regular',
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child:
                _messages.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Start a conversation',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Regular',
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We typically reply within minutes',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Regular',
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
          ),

          // Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(fontFamily: 'Regular'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: blackColor,
                    child: IconButton(
                      icon: Icon(Icons.send, color: whiteColor),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: Sizes().width * 0.7),
        decoration: BoxDecoration(
          color: message.isUser ? blackColor : whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Regular',
                color: message.isUser ? whiteColor : blackColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Regular',
                color:
                    message.isUser
                        ? whiteColor.withOpacity(0.7)
                        : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// ==================== FEEDBACK PAGE ====================

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isSending = false;

  final List<String> categories = [
    'General',
    'Bug Report',
    'Feature Request',
    'Payment Issue',
    'Booking Issue',
    'App Performance',
    'Other',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    // Simulate sending feedback
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSending = false);

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 32),
                  SizedBox(width: 12),
                  Text('Thank You!', style: TextStyle(fontFamily: 'Regular')),
                ],
              ),
              content: Text(
                'Your feedback has been submitted successfully. We appreciate your input!',
                style: TextStyle(fontFamily: 'Regular'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Done', style: TextStyle(fontFamily: 'Regular')),
                ),
              ],
            ),
      );

      _feedbackController.clear();
    }
  }

  Sizes size = Sizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Share Feedback', style: TextStyle(fontFamily: 'Regular')),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We\'d love to hear from you!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your feedback helps us improve',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Regular',
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Category Selection
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return ChoiceChip(
                            label: Text(
                              category,
                              style: TextStyle(fontFamily: 'Regular'),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            selectedColor: blackColor,
                            labelStyle: TextStyle(
                              color: isSelected ? whiteColor : blackColor,
                            ),
                          );
                        }).toList(),
                  ),

                  SizedBox(height: 24),

                  // Feedback Text
                  Text(
                    'Your Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Tell us what you think...',
                      hintStyle: TextStyle(fontFamily: 'Regular'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your feedback';
                      }
                      if (value.trim().length < 10) {
                        return 'Please provide more details (at least 10 characters)';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32),

                  // Submit Button
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: SizedBox(
                width: size.safeWidth * 0.9,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blackColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isSending
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: whiteColor,
                            ),
                          )
                          : Text(
                            'Submit Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                              color: whiteColor,
                            ),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
