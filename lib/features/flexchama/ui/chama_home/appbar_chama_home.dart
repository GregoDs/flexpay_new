import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'package:flexpay/features/flexchama/ui/modals/borrow_loan.dart';
import 'package:flexpay/features/flexchama/ui/modals/repay_loan.dart';
import 'package:flexpay/features/flexchama/ui/modals/statements_chama.dart';
import 'package:flexpay/features/flexchama/ui/modals/withdraw_savings.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/utils/services/service_repo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';

class AppBarChama extends StatefulWidget {
  const AppBarChama(BuildContext context, {super.key});

  @override
  State<AppBarChama> createState() => _AppBarChamaState();
}

class _AppBarChamaState extends State<AppBarChama> {
  bool _isHomeBalanceVisible = true;

  void toggleBalanceVisibility() {
    setState(() {
      _isHomeBalanceVisible = !_isHomeBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ChamaCubit, ChamaState>(
      builder: (context, state) {
        double maturedSavings = 0;

        if (state is ChamaSavingsFetched) {
          maturedSavings = state
              .savingsResponse
              .data!
              .chamaDetails
              .withdrawableAmount
              .toDouble();
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.040,
            vertical: screenHeight * 0.066,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/appbarbackground.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(58),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile and Notifications
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/icon/logos/logo.png',
                        height: 30.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.04),

                /// Wallet Balance Label
                Text(
                  'Matured Savings',
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: screenWidth.clamp(12.0, 20.0) * 1.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: screenHeight * 0.008),

                /// Balance & Toggle Visibility
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _isHomeBalanceVisible
                            ? 'Kshs ${AppUtils.formatDecimal(maturedSavings.toDouble())}'
                            : '******',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: screenWidth.clamp(20.0, 40.0) * 0.75,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: toggleBalanceVisibility,
                      child: Icon(
                        _isHomeBalanceVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                        size: screenWidth.clamp(16.0, 28.0) * 0.8,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.048),

                /// Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        Icons.account_balance_wallet,
                        'Withdraw',
                        context,
                        screenWidth,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: _buildActionButton(
                        Icons.payments,
                        'Pay Loan',
                        context,
                        screenWidth,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: _buildActionButton(
                        FontAwesomeIcons.handHoldingDollar,
                        'Borrow',
                        context,
                        screenWidth,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: _buildNavigationActionButton(
                        FontAwesomeIcons.fileInvoiceDollar,
                        'Statement',
                        2,
                        const ChamaStatementPage(),
                        context,
                        screenWidth,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    BuildContext context,
    double screenWidth,
  ) {
    return GestureDetector(
      onTap: () {
        if (label == 'Borrow') {
          showBorrowLoanModalSheet(context);
        } else if (label.toLowerCase() == 'pay loan') {
          // Show custom messenger for upcoming feature
          // CustomSnackBar.showSuccess(
          //   context,
          //   title: "Feature Coming Soon",
          //   message:
          //       "💡 The Pay Loan  feature will be available in an upcoming update. Stay tuned!",
          // );
          showPayLoanModalSheet(context);
        } else if (label == 'Withdraw') {
          showWithdrawModalSheet(context);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: screenWidth.clamp(28.0, 40.0) * 0.40,
            child: Icon(
              icon,
              color: Colors.white,
              size: screenWidth.clamp(18.0, 28.0) * 0.8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: screenWidth.clamp(10.0, 16.0) * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationActionButton(
    IconData icon,
    String label,
    int index,
    Widget page,
    BuildContext context,
    double screenWidth,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ChamaCubit(ChamaRepo())..fetchChamaUserProfile(),
              child: page,
            ),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: screenWidth.clamp(28.0, 40.0) * 0.4,
            child: Icon(
              icon,
              color: Colors.white,
              size: screenWidth.clamp(18.0, 28.0) * 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: screenWidth.clamp(10.0, 16.0) * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
