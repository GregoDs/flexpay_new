import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/goals/cubits/goals_cubit.dart';
import 'package:flexpay/features/goals/cubits/goals_state.dart';
import 'package:flexpay/features/goals/repo/goals_repo.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CreateGoalPage extends StatefulWidget {
  final Map<String, dynamic>? prefilledGoal;
  const CreateGoalPage({Key? key, this.prefilledGoal}) : super(key: key);

  @override
  State<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController amountController;
  late TextEditingController productNameController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController frequencyContributionController;
  late TextEditingController depositController;

  // Replace frequency controller with a selected frequency variable
  String _selectedFrequency = 'DAILY';

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.prefilledGoal?['amount'] ?? '',
    );
    productNameController = TextEditingController(
      text: widget.prefilledGoal?['product_name'] ?? '',
    );
    startDateController = TextEditingController(
      text: widget.prefilledGoal?['start_date'] ?? '',
    );
    endDateController = TextEditingController(
      text: widget.prefilledGoal?['end_date'] ?? '',
    );
    // Initialize frequency from prefilled data if available
    _selectedFrequency = widget.prefilledGoal?['frequency'] ?? 'DAILY';
    frequencyContributionController = TextEditingController(
      text: widget.prefilledGoal?['frequency_contribution'] ?? '',
    );
    depositController = TextEditingController(
      text: widget.prefilledGoal?['deposit'] ?? '',
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    productNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    frequencyContributionController.dispose();
    depositController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final fieldColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;
    final textColor = isDark ? Colors.white : Colors.black87;

    return BlocProvider(
      create: (_) => GoalsCubit(GoalsRepo()),
      child: BlocConsumer<GoalsCubit, GoalsState>(
        listener: (context, state) {
          if (state is CreateGoalsSuccess) {
            CustomSnackBar.showSuccess(
              context,
              title: "Goal Created!",
              message:
                  "Reference: ${state.response.data?.first.booking?.data?.bookingReference ?? "N/A"}",
            );
            Navigator.pop(context);
          } else if (state is CreateGoalsError) {
            CustomSnackBar.showError(
              context,
              title: "Goal Creation Failed",
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<GoalsCubit>();

          return Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: isDark ? Colors.black : Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                "Create a Goal",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 2,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Start saving smartly by setting your target, frequency, and deposit — track your progress easily with FlexPay.",
                          style: GoogleFonts.montserrat(
                            color: textColor.withOpacity(0.8),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Center(
                        child: Lottie.asset(
                          'assets/images/goals_imgs/Saving.json',
                          width: 0.8.sw,
                          height: 0.26.sh,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      _buildTextField(
                        label: "Goal Name",
                        hint: "Enter a goal name",
                        controller: productNameController,
                        icon: Icons.flag_outlined,
                        fieldColor: fieldColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 12.h),
                      _buildTextField(
                        label: "Target Amount",
                        hint: "Kshs 20,000",
                        controller: amountController,
                        icon: Icons.attach_money_outlined,
                        keyboardType: TextInputType.number,
                        fieldColor: fieldColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              label: "Start Date",
                              controller: startDateController,
                              icon: Icons.calendar_today_outlined,
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildDateField(
                              label: "End Date",
                              controller: endDateController,
                              icon: Icons.event_available_outlined,
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Frequency Selection Tabs
                      _buildFrequencyTabs(textColor),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: "Contribution",
                              hint: "Kshs 500",
                              controller: frequencyContributionController,
                              icon: Icons.savings_outlined,
                              keyboardType: TextInputType.number,
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildTextField(
                              label: "Initial Deposit",
                              hint: "Kshs 1000",
                              controller: depositController,
                              icon: Icons.account_balance_wallet_outlined,
                              keyboardType: TextInputType.number,
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorName.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: state is CreateGoalsLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.createGoal(
                                      productName: productNameController.text
                                          .trim(),
                                      targetAmount: amountController.text
                                          .trim(),
                                      startDate: startDateController.text
                                          .trim(),
                                      endDate: endDateController.text.trim(),
                                      frequency: _selectedFrequency,
                                      frequencyContribution:
                                          frequencyContributionController.text
                                              .trim(),
                                      deposit: depositController.text.trim(),
                                    );
                                  }
                                },
                          child: state is CreateGoalsLoading
                              ? const SizedBox(
                                  height: 24,
                                  child: Center(
                                    child: SpinKitWave(
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Create Goal",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Custom Text Field with styled validator
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.montserrat(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(icon, color: Colors.blue[800]),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            errorStyle: GoogleFonts.montserrat(
              color: Colors.redAccent,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (val) =>
              val == null || val.isEmpty ? "This field is required" : null,
        ),
      ],
    );
  }

  // ✅ Updated Date Field for proper dark mode visibility
  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();

            final isDark = Theme.of(context).brightness == Brightness.dark;

            // Determine the appropriate date constraints
            DateTime initialDate = DateTime.now();
            DateTime firstDate =
                DateTime.now(); // Default to today for start date
            DateTime lastDate = DateTime(2030);

            // For start date: can only select current date or future dates
            if (label == "Start Date") {
              firstDate = DateTime.now(); // Cannot select past dates
              initialDate = DateTime.now();
            }
            // If this is the end date field and start date is selected
            else if (label == "End Date" &&
                startDateController.text.isNotEmpty) {
              try {
                final startDate = DateTime.parse(startDateController.text);
                // End date must be the same as start date or later
                firstDate = startDate;
                // Set initial date to start date for convenience
                initialDate = startDate;

                // If the initial date exceeds the last date, use the last date
                if (initialDate.isAfter(lastDate)) {
                  initialDate = lastDate;
                }
              } catch (e) {
                // If start date parsing fails, use current date as minimum
                firstDate = DateTime.now();
                initialDate = DateTime.now();
                print("Error parsing start date: $e");
              }
            }
            // If this is the start date field and end date is already selected
            else if (label == "Start Date" &&
                endDateController.text.isNotEmpty) {
              try {
                final endDate = DateTime.parse(endDateController.text);
                // Start date can be between today and the end date
                firstDate = DateTime.now(); // Still cannot select past dates
                lastDate = endDate;

                // Ensure we don't have invalid date ranges
                if (DateTime.now().isAfter(endDate)) {
                  // If current date is after end date, clear end date
                  endDateController.clear();
                  lastDate = DateTime(2030);
                  if (mounted) {
                    CustomSnackBar.showWarning(
                      context,
                      title: "Date Cleared",
                      message:
                          "End date was cleared because it was in the past",
                    );
                  }
                }
              } catch (e) {
                // If end date parsing fails, keep default values
                firstDate = DateTime.now();
                print("Error parsing end date: $e");
              }
            }

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: isDark
                        ? const ColorScheme.dark(
                            primary: ColorName.primaryColor, // accent color
                            onPrimary: Colors.white, // text color on accent
                            surface: Color(0xFF121212), // dialog bg
                            onSurface: Colors.white, // calendar numbers
                          )
                        : ColorScheme.light(
                            primary: ColorName.primaryColor,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black87,
                          ),
                    dialogBackgroundColor: isDark
                        ? const Color(0xFF1C1C1E)
                        : Colors.white,
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            ColorName.primaryColor, // OK/Cancel color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              controller.text =
                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

              // If start date was changed and end date exists, validate end date
              if (label == "Start Date" && endDateController.text.isNotEmpty) {
                try {
                  final endDate = DateTime.parse(endDateController.text);
                  if (endDate.isBefore(pickedDate)) {
                    // Clear end date if it's now before the new start date
                    endDateController.clear();
                    if (mounted) {
                      CustomSnackBar.showWarning(
                        context,
                        title: "Date Updated",
                        message:
                            "End date was cleared because it was before the new start date",
                      );
                    }
                  }
                } catch (e) {
                  print("Error validating end date: $e");
                }
              }
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              style: GoogleFonts.montserrat(color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldColor,
                prefixIcon: Icon(icon, color: textColor),
                hintText: "YYYY-MM-DD",
                hintStyle: GoogleFonts.montserrat(
                  color: textColor.withOpacity(0.6),
                ),
                errorStyle: GoogleFonts.montserrat(
                  color: Colors.redAccent,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Date required" : null,
            ),
          ),
        ),
      ],
    );
  }

  // Frequency Selection Tabs
  Widget _buildFrequencyTabs(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Frequency",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFrequencyTab("DAILY", textColor),
            _buildFrequencyTab("WEEKLY", textColor),
            _buildFrequencyTab("MONTHLY", textColor),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyTab(String frequency, Color textColor) {
    final isSelected = _selectedFrequency == frequency;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = frequency;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? ColorName.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorName.primaryColor : textColor,
          ),
        ),
        child: Text(
          frequency,
          style: GoogleFonts.montserrat(
            color: isSelected ? Colors.white : textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
