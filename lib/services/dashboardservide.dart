import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, double>> getSpendingData(String year) async {
    final data = <String, double>{};

    
    final querySnapshot = await _firestore.collection('transactions')
        .where('monthyear', isEqualTo: year) 
        .get();

    for (var doc in querySnapshot.docs) {
      final category = doc['category'] as String;
      final amount = doc['amount'] as double; 

      // Update the spending data for the category
      if (data.containsKey(category)) {
        data[category] = data[category]! + amount; 
      } else {
        data[category] = amount;
      }
    }
    return data;
  }
}
