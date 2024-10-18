import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategorySpendingPieChart extends StatelessWidget {
  final Map<String, double> categorySpendingByMonth;
  final Map<String, String> categoryTypes;

  const CategorySpendingPieChart({
    Key? key,
    required this.categorySpendingByMonth,
    required this.categoryTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> debitColors = [
      Colors.orange,
      const Color.fromARGB(255, 160, 12, 1),
      Colors.purple,
      Colors.yellow,
      Colors.brown,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
      Colors.blue,
      Colors.indigo,
      Colors.amber,
      Colors.grey,
      Colors.purpleAccent,
    ];

    // Get all categories regardless of their amount value
    final categories = categorySpendingByMonth.keys.toList();
    final amounts = categorySpendingByMonth.values.toList();

    double totalCredit = 0;
    double totalDebit = 0;

    categoryTypes.forEach((category, type) {
      double amount = categorySpendingByMonth[category] ?? 0.0;
      if (type == 'credit') {
        totalCredit += amount;
      } else {
        totalDebit += amount;
      }
    });

    double totalAmount = totalCredit + totalDebit;
    double creditPercentage = totalAmount > 0 ? (totalCredit / totalAmount) * 100 : 0;
    double debitPercentage = totalAmount > 0 ? (totalDebit / totalAmount) * 100 : 0;

    String minCategory = '';
    String maxCategory = '';
    double minSpending = double.infinity;
    double maxSpending = double.negativeInfinity;

    // Adjust min and max only for categories with debit types
    for (int i = 0; i < categories.length; i++) {
      if (categoryTypes[categories[i]] == 'debit') {
        double amount = amounts[i];
        if (amount < minSpending) {
          minSpending = amount;
          minCategory = categories[i];
        }
        if (amount > maxSpending) {
          maxSpending = amount;
          maxCategory = categories[i];
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 255, 254, 253),
      ),
      child: categorySpendingByMonth.isEmpty
          ? Center(
              child: Text(
                'No spending data available.',
                style: TextStyle(fontSize: 18, color: Colors.orange[700]),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spending by Category',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: List.generate(categories.length, (i) {
                        String category = categories[i];
                        String type = categoryTypes[category] ?? 'debit';

                        Color color = type == 'credit'
                            ? Colors.green
                            : debitColors[i % debitColors.length];

                        return PieChartSectionData(
                          color: color,
                          value: amounts[i],
                          title: amounts[i] > 0 ? amounts[i].toString() : '',
                          radius: 60,
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    int index = categories.indexOf(category);
                    String type = categoryTypes[category] ?? 'debit';

                    Color color = type == 'credit'
                        ? Colors.green
                        : debitColors[index % debitColors.length];

                    String label = type == 'credit' ? 'Income' : category;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: color,
                        ),
                        SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(fontSize: 14, color: Colors.orange[900]),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  'Credit: ${creditPercentage.toStringAsFixed(2)}% | Debit: ${debitPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Min Spending Category: $minCategory ($minSpending)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Max Spending Category: $maxCategory ($maxSpending)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }
}
