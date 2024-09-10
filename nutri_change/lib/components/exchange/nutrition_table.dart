import 'package:flutter/material.dart';

class NutritionTable extends StatelessWidget {
  const NutritionTable(
      {super.key, required this.cho, required this.protein, required this.fat});
  final double cho;
  final double protein;
  final double fat;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(20)), // Outer radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ClipRRect(
          // Clip the DataTable to give it rounded corners
          borderRadius: BorderRadius.circular(20), // Apply border radius here
          child: DataTable(
            headingRowColor: WidgetStateColor.resolveWith(
                (states) => Colors.blueAccent.shade100),
            dataRowColor: WidgetStateColor.resolveWith(
                (states) => Colors.white), // Background color for rows
            columnSpacing: 30, // Reduces the spacing between columns
            columns: const [
              DataColumn(
                label: Text(
                  'Group',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              DataColumn(
                label: Text('Gram',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
              DataColumn(
                label: Text(
                  'Calori',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  '%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            rows: [
              _buildDataRow(
                  'CHO',
                  '${cho.toStringAsFixed(2)}g',
                  '${(4 * cho).toStringAsFixed(2)}cal',
                  getTotal() > 0
                      ? '${(cho * 4 / getTotal() * 100).toStringAsFixed(1)}%'
                      : '0.0%'),
              _buildDataRow(
                  'Protein',
                  '${protein.toStringAsFixed(2)}g',
                  '${(4 * protein).toStringAsFixed(2)}cal',
                  getTotal() > 0
                      ? '${(protein * 4 / getTotal() * 100).toStringAsFixed(1)}%'
                      : '0.0%'),
              _buildDataRow(
                  'Fat',
                  '${fat.toStringAsFixed(2)}g',
                  '${(fat * 9).toStringAsFixed(2)}cal',
                  getTotal() > 0
                      ? '${(fat * 9 / getTotal() * 100).toStringAsFixed(1)}%'
                      : '0.0%'),
              _buildDataRow(
                  'Total',
                  '${(cho + protein + fat).toStringAsFixed(2)}g',
                  '${(cho * 4 + protein * 4 + fat * 9).toStringAsFixed(2)}cal',
                  getTotal() > 0 ? '100%' : '0.0%',
                  color: Colors.lightBlue.shade50), // Highlight row
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
      String label, String gram, String calori, String percent,
      {Color? color}) {
    return DataRow(
      color: WidgetStateProperty.resolveWith((states) => color ?? Colors.white),
      cells: [
        DataCell(Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(gram)),
        DataCell(Text(calori)),
        DataCell(Text(percent)),
      ],
    );
  }

  double getTotal() {
    return cho * 4 + protein * 4 + fat * 9;
  }
}
