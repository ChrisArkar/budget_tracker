import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'model.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  TextEditingController promptController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  static const apiKey = "AIzaSyCoK0xbb2ydOtoc2NNlb03hRqLIaG5MJac";
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);
  final List<ModelMessage> prompt = [];
  bool isLoading = false;
  bool isButtonActive = false;

  // Quick questions list
  final List<String> quickQuestions = [
    "What are my recent transactions?",
    "How can I save more money?",
    "Can you suggest a budget?",
  ];

  @override
  void initState() {
    super.initState();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? "";

    if (userId.isNotEmpty) {
      final history = await getChatHistory(userId);
      setState(() {
        prompt.addAll(history);
      });
      _scrollToBottom();
    }
  }

  Future<List<ModelMessage>> getChatHistory(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_history')
        .orderBy('timestamp')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ModelMessage(
        message: data['message'],
        isPrompt: data['isPrompt'],
        time: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      );
    }).toList();
  }

  Future<void> sendMessage() async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? "";

    if (userId.isNotEmpty) {
      final message = promptController.text;
      final userMessage = ModelMessage(
        isPrompt: true,
        message: message,
        time: DateTime.now(),
      );

      setState(() {
        isLoading = true;
        promptController.clear();
        prompt.add(userMessage);
        isButtonActive = false;
      });

      await addMessageToFirestore(userId, userMessage);
      _scrollToBottom();

      try {
        if (message.toLowerCase().contains("recent transactions")) {
          await fetchRecentTransactions(userId);
        } else {
          final content = [Content.text(message)];
          final response = await model.generateContent(content);

          final botMessage = ModelMessage(
            isPrompt: false,
            message: response.text ?? "I'm still learning to help with that!",
            time: DateTime.now(),
          );

          setState(() {
            prompt.add(botMessage);
          });
          await addMessageToFirestore(userId, botMessage);
          _scrollToBottom();
        }
      } catch (error) {
        print("Error: $error");
        final botMessage = ModelMessage(
          isPrompt: false,
          message: "Sorry, there was an error. Please try again.",
          time: DateTime.now(),
        );

        setState(() {
          prompt.add(botMessage);
        });
        await addMessageToFirestore(userId, botMessage);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> getUserTransactions(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> fetchRecentTransactions(String userId) async {
    try {
      final transactions = await getUserTransactions(userId);

      if (transactions.isEmpty) {
        final botMessage = ModelMessage(
          isPrompt: false,
          message: "You have no recent transactions.",
          time: DateTime.now(),
        );
        setState(() {
          prompt.add(botMessage);
        });
        await addMessageToFirestore(userId, botMessage);
        return;
      }

      String transactionList = "Your recent transactions:\n";
      for (var transaction in transactions) {
        if (transaction.containsKey('title') &&
            transaction.containsKey('amount') &&
            transaction.containsKey('timestamp')) {
          transactionList +=
              "${transaction['title']}: \$${transaction['amount']} on ${DateFormat('yyyy-MM-dd')
              .format(DateTime.fromMillisecondsSinceEpoch(transaction['timestamp']))}\n";
        } else {
          print("Missing fields in transaction: $transaction");
        }
      }

      final botMessage = ModelMessage(
        isPrompt: false,
        message: transactionList,
        time: DateTime.now(),
      );

      setState(() {
        prompt.add(botMessage);
      });
      await addMessageToFirestore(userId, botMessage);
    } catch (error) {
      print("Error fetching transactions: $error");

      final botMessage = ModelMessage(
        isPrompt: false,
        message: "Error fetching transactions. Please try again later.",
        time: DateTime.now(),
      );

      setState(() {
        prompt.add(botMessage);
      });
      await addMessageToFirestore(userId, botMessage);
    }
  }

  Future<void> addMessageToFirestore(String userId, ModelMessage message) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat_history')
        .add({
      'message': message.message,
      'isPrompt': message.isPrompt,
      'timestamp': message.time.millisecondsSinceEpoch,
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showQuickQuestion(String question) {
    setState(() {
      promptController.text = question;
      isButtonActive = true;
    });
    sendMessage();
  }

  @override
  void dispose() {
    promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI ChatBot"),
        backgroundColor: Colors.orange[50],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: prompt.length,
              itemBuilder: (context, index) {
                final msg = prompt[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Align(
                    alignment: msg.isPrompt ? Alignment.centerRight : Alignment.centerLeft,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      color: msg.isPrompt ? Colors.orange[100] : Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.message,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              DateFormat('hh:mm a').format(msg.time),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promptController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                    onChanged: (text) {
                      setState(() {
                        isButtonActive = text.trim().isNotEmpty;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: isButtonActive ? sendMessage : null,
                  color: Color(0xFFFB8C2B),
                  iconSize: 28,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: quickQuestions.map((question) {
                return ActionChip(
                  label: Text(question),
                  onPressed: () => _showQuickQuestion(question),
                  backgroundColor: Color(0xFFFB8C2B).withOpacity(0.1),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
