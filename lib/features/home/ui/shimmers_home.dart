import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

/// ==========================================================
/// 🧭 HOME SCREEN SHIMMERS
/// ==========================================================


/// 🧭 Adaptive shimmer for AppBar balance section — blends with blue background
class AppBarBalanceShimmer extends StatelessWidget {
  final bool isDarkMode;
  const AppBarBalanceShimmer({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    // 🎨 Smooth adaptive tones for blue background
    final baseColor = isDarkMode
        ? Colors.blueGrey.shade700.withOpacity(0.4)
        : Colors.blue.shade300.withOpacity(0.35);
    final highlightColor = isDarkMode
        ? Colors.lightBlueAccent.withOpacity(0.6)
        : Colors.white.withOpacity(0.8);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: ShimmerDirection.ltr, // 👈 horizontal sweep
      period: const Duration(seconds: 2), // smooth Apple-like timing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 💠 Total Balance Label shimmer
          Container(
            width: 100,
            height: 14,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          // 💰 Balance Value shimmer
          Container(
            width: 150,
            height: 32,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🧩 2️⃣ TransactionDetails shimmer — full list shimmer
class TransactionDetailsShimmer extends StatelessWidget {
  const TransactionDetailsShimmer({super.key});

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
        itemCount: 10,
        itemBuilder: (context, index) {
          return const _TransactionItemShimmer();
        },
      ),
    );
  }
}

/// 💡 Small shimmer card for each transaction
class _TransactionItemShimmer extends StatelessWidget {
  const _TransactionItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left column (description + date)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(width: 100, height: 12, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right side (amount placeholder)
            Container(width: 60, height: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
