import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:testbdgtt/widgets/category_list.dart';
import 'package:testbdgtt/widgets/tab_bar_view.dart';
import 'package:testbdgtt/widgets/time_line_month.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var category = "All";
  var monthYear = "";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    monthYear = DateFormat('MMM y').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense History"),
        backgroundColor: Colors.orange[50],
      ),
      body: Column(
        children: [
          TimeLineMonth(
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  monthYear = value;
                });
              }
            },
          ),
          CategoryList(
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  category = value;
                });
              }
            },
          ),
          TypeTabBar(
            category: category,
            monthYear: monthYear,
          ),
        ],
      ),
    );
  }
}
