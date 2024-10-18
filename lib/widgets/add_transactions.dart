import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:testbdgtt/ultis/appvalidator.dart';
import 'package:testbdgtt/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';

class AddTransactionsForm extends StatefulWidget {
  const AddTransactionsForm({super.key});

  @override
  State<AddTransactionsForm> createState() => _AddTransactionsFormState();
}

class _AddTransactionsFormState extends State<AddTransactionsForm> {
  var type = "credit";
  var category = "Others";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();
  DateTime? selectedDateTime;
  TimeOfDay? selectedTime;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      var amount = int.tryParse(amountEditController.text) ?? 0;
      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(selectedDateTime ?? DateTime.now());

      // Create timestamp from selected date and time
      int timestamp = DateTime(
        selectedDateTime?.year ?? DateTime.now().year,
        selectedDateTime?.month ?? DateTime.now().month,
        selectedDateTime?.day ?? DateTime.now().day,
        selectedTime?.hour ?? DateTime.now().hour,
        selectedTime?.minute ?? DateTime.now().minute,
      ).millisecondsSinceEpoch;

      try {
        // Fetch the user document and update remaining amount, total credit, and debit
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

        int remainingAmount = userDoc['remainingAmount'];
        int totalCredit = userDoc['totalCredit'];
        int totalDebit = userDoc['toatlDebit']; 

        if (type == 'credit') {
          remainingAmount += amount;
          totalCredit += amount;
        } else {
          remainingAmount -= amount;
          totalDebit += amount;
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          "remainingAmount": remainingAmount,
          "totalCredit": totalCredit,
          "toatlDebit": totalDebit, 
          "updatedAt": timestamp,
        });

        // Save the transaction data
        var data = {
          "id": id,
          "title": titleEditController.text,
          "amount": amount,
          "type": type,
          "timestamp": timestamp,
          "totalCredit": totalCredit,
          "toatlDebit": totalDebit, 
          "remainingAmount": remainingAmount,
          "monthyear": monthyear,
          "category": category,
        };

        print('Transaction Data: $data');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("transactions")
            .doc(id)
            .set(data);

        Navigator.pop(context);
      } catch (error) {
        print('Error adding transaction: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add transaction: $error')),
        );
      } finally {
        setState(() {
          isLoader = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDateTime = picked;
      });
      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            CategoryDropdown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedDateTime != null
                    ? DateFormat('MMMM dd, yyyy').format(selectedDateTime!)
                    : "No date selected"),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date & Time'),
                ),
              ],
            ),
            DropdownButtonFormField(
              value: 'credit',
              items: [
                DropdownMenuItem(child: Text('Credit'), value: 'credit'),
                DropdownMenuItem(child: Text('Debit'), value: 'debit'),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!isLoader) {
                  _submitForm();
                }
              },
              child: isLoader
                  ? Center(child: CircularProgressIndicator())
                  : Text("Add Transaction"),
            )
          ],
        ),
      ),
    );
  }
}
