import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testbdgtt/screens/barchart.dart'; 
import 'package:testbdgtt/screens/chatbot.dart';
import 'package:testbdgtt/screens/home_screen.dart';
import 'package:testbdgtt/screens/transaction_screen.dart';
import 'package:testbdgtt/widgets/navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  late List<Widget> pageViewList;

  @override
  void initState() {
    super.initState();
    initPageViewList();
  }

  void initPageViewList() {
    pageViewList = [
      HomeScreen(),
      TransactionScreen(),
      ChatbotScreen(),
      SpendingCategoryScreen(), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      body: pageViewList[currentIndex],
    );
  }
}

class SpendingCategoryScreen extends StatefulWidget {
  @override
  _SpendingCategoryScreenState createState() => _SpendingCategoryScreenState();
}

class _SpendingCategoryScreenState extends State<SpendingCategoryScreen> {
  String selectedMonthYear = DateFormat('MMM y').format(DateTime.now());

  // Fetch spending data for a specific month/year
  Stream<QuerySnapshot> fetchSpendingData(String monthYear) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('monthyear', isEqualTo: monthYear) // Filter by selected month and year
          .snapshots();
    } else {
      throw Exception('No user logged in');
    }
  }

  // Dropdown to select month-year
  DropdownButton<String> buildMonthYearDropdown() {
    final now = DateTime.now();
    final List<String> months = List.generate(12, (index) {
      final date = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM y').format(date);
    });

    return DropdownButton<String>(
      value: selectedMonthYear,
      items: months.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedMonthYear = newValue!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Spending by Category"),
        backgroundColor:  Colors.orange[50],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildMonthYearDropdown(), // Dropdown in the top-right corner
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchSpendingData(selectedMonthYear),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No spending data available for $selectedMonthYear. Please add transactions.'),
            );
          }

          // Process the Firestore data
          Map<String, double> spendingData = {};
          Map<String, String> spendingTypes = {};

          snapshot.data!.docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;

            String category = data['category'] ?? 'Unknown';
            String type = data['type'] ?? 'debit';
            double amount = double.tryParse(data['amount'].toString()) ?? 0.0;

            if (spendingData.containsKey(category)) {
              spendingData[category] = spendingData[category]! + amount;
            } else {
              spendingData[category] = amount;
            }

            spendingTypes[category] = type;
          });

          return CategorySpendingPieChart(
            categorySpendingByMonth: spendingData,
            categoryTypes: spendingTypes,
          );
        },
      ),
    );
  }
}
