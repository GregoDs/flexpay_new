import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ChamaStatementPage extends StatelessWidget {
  const ChamaStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Savings Statement",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF009AC1),
      ),
      body: BlocBuilder<ChamaCubit, ChamaState>(
        builder: (context, state) {
          // 1. Show loading spinner immediately on initial or loading
          if ( state is ChamaSavingsLoading) {
            return const Center(
              child: SpinKitWave(
                color: Color(0xFF009AC1),
                size: 40,
              ),
            );
          }

          // 2. Show data when fetched
          else if (state is ChamaSavingsFetched) {
            final payments = state.savingsResponse.data?.payments.data ?? [];

            if (payments.isEmpty) {
              return Center(
                child: Text(
                  "No transactions available",
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final payment = payments[index];
                return _buildStatementTile(payment);
              },
            );
          }

          // 3. Error state
          else if (state is ChamaError) {
            return Center(
              child: Text(
                state.message,
                style: GoogleFonts.montserrat(color: Colors.red),
              ),
            );
          }

          // Fallback (should rarely happen)
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatementTile(payment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.teal.withOpacity(0.2),
        child: const Icon(
          Icons.receipt_long,
          color: Colors.teal,
        ),
      ),
      title: Text(
        "Ksh ${payment.paymentAmount}",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Source: ${payment.paymentSource}",
              style: GoogleFonts.montserrat(fontSize: 13)),
          Text("Ref: ${payment.txnRef}",
              style: GoogleFonts.montserrat(fontSize: 13)),
          Text("Date: ${payment.createdAt}",
              style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey)),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}