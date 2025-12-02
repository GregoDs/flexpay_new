import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionDetailsPage extends StatelessWidget {
  final List<TransactionData> transactions;

  const TransactionDetailsPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "All Transactions",
          style: GoogleFonts.montserrat(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final isIncome = tx.paymentAmount >= 0;
          final amountText = _formatAmount(tx.paymentAmount);

          return _transactionItem(
            tx.date,
            tx.productName,
            amountText,
            isIncome,
          );
        },
      ),
    );
  }

  Widget _transactionItem(
      String dateTime, String description, String amount, bool isIncome) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 👇 Expanded makes sure text respects available space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: description, // full text shows here
                  waitDuration: const Duration(milliseconds: 000),
                  child: Text(
                    description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                Text(
                  dateTime,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8), // small gap before amount

          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double value, {String prefix = 'Ksh '}) {
    final isNegative = value < 0;
    final abs = value.abs();
    final hasCents = abs.truncateToDouble() != abs;
    final text = hasCents ? abs.toStringAsFixed(2) : abs.toStringAsFixed(0);
    return isNegative ? '-$prefix$text' : '+$prefix$text';
  }
}