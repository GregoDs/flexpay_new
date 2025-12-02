import 'package:flexpay/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flexpay/features/auth/cubit/auth_cubit.dart';
import 'package:flexpay/features/auth/cubit/auth_state.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController referralPhoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? gender;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool agreedToTerms = false;

  // Validation state
  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? phoneError;
  String? referralPhoneError;
  String? dobError;
  String? genderError;
  String? passwordError;
  String? confirmPasswordError;

  void _validateFields() {
    setState(() {
      firstNameError = firstNameController.text.trim().isEmpty
          ? "First name is required"
          : null;

      lastNameError = lastNameController.text.trim().isEmpty
          ? "Last name is required"
          : null;

      emailError = emailController.text.trim().isEmpty
          ? "Email is required"
          : (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                  .hasMatch(emailController.text.trim())
              ? "Enter a valid email address"
              : null);

      phoneError = phoneController.text.trim().isEmpty
          ? "Phone number is required"
          : (!RegExp(r'^\d{10,13}$').hasMatch(phoneController.text.trim())
              ? "Enter a valid phone number"
              : null);

      referralPhoneError = referralPhoneController.text.trim().isNotEmpty &&
              !RegExp(r'^\d{10,13}$').hasMatch(referralPhoneController.text.trim())
          ? "Enter a valid referral phone number"
          : null;

      // DOB optional
      dobError = null;

      genderError = gender == null ? "Select your gender" : null;

      passwordError = passwordController.text.length < 8
          ? "Password must be at least 8 characters"
          : (!RegExp(r'[0-9]').hasMatch(passwordController.text)
              ? "Password must contain at least one number"
              : null);

      confirmPasswordError =
          confirmPasswordController.text != passwordController.text
              ? "Passwords do not match"
              : null;
    });
  }

  void _submit() {
    _validateFields();
    if (firstNameError == null &&
        lastNameError == null &&
        emailError == null &&
        phoneError == null &&
        referralPhoneError == null &&
        genderError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        agreedToTerms) {
      context.read<AuthCubit>().createAccount(
            emailController.text.trim(),
            passwordController.text,
            confirmPasswordController.text,
            firstNameController.text.trim(),
            lastNameController.text.trim(),
            phoneController.text.trim(),
            "1", // userType
            gender ?? "",
            dobController.text.trim(),
            referralPhoneController.text.trim(), 
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = GoogleFonts.montserratTextTheme(
      Theme.of(context).textTheme,
    );
    final fieldColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.login),
        ),
        centerTitle: true,
        title: Text(
          "Create Account",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUserUpdated) {
            CustomSnackBar.showSuccess(
              context,
              title: "Success",
              message: "Registration successful!",
            );
            Navigator.pushReplacementNamed(
              context,
              Routes.home,
              arguments: state.userModel,
            );
          } else if (state is AuthError) {
            CustomSnackBar.showError(
              context,
              title: "Error",
              message: state.errorMessage,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                children: [
                  // Fields
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: firstNameController,
                              label: "First Name",
                              hint: "John",
                              icon: Icons.person_outline,
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: firstNameError,
                              onChanged: (_) {
                                if (firstNameError != null &&
                                    firstNameController.text.isNotEmpty) {
                                  setState(() => firstNameError = null);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: lastNameController,
                              label: "Last Name",
                              hint: "Doe",
                              icon: Icons.person_outline,
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: lastNameError,
                              onChanged: (_) {
                                if (lastNameError != null &&
                                    lastNameController.text.isNotEmpty) {
                                  setState(() => lastNameError = null);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      _buildTextField(
                        controller: emailController,
                        label: "Email",
                        hint: "example@email.com",
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: emailError,
                        onChanged: (_) {
                          if (emailError != null &&
                              RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(emailController.text.trim())) {
                            setState(() => emailError = null);
                          }
                        },
                      ),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: phoneController,
                              label: "Phone",
                              hint: "0712345678",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: phoneError,
                              onChanged: (_) {
                                if (phoneError != null &&
                                    RegExp(r'^\d{10,13}$')
                                        .hasMatch(phoneController.text.trim())) {
                                  setState(() => phoneError = null);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: referralPhoneController,
                              label: "Referral num (optional)",
                              hint: "0712345678",
                              icon: Icons.group_outlined,
                              keyboardType: TextInputType.phone,
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: referralPhoneError,
                              onChanged: (_) {
                                if (referralPhoneError != null &&
                                    (referralPhoneController.text.trim().isEmpty ||
                                    RegExp(r'^\d{10,13}$')
                                        .hasMatch(referralPhoneController.text.trim()))) {
                                  setState(() => referralPhoneError = null);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      _buildDobField(
                        label: "Date of Birth (optional)",
                        controller: dobController,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: dobError,
                      ),
                      SizedBox(height: 12.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Gender",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          _buildGenderButton("Male", Icons.male),
                          const SizedBox(width: 12),
                          _buildGenderButton("Female", Icons.female),
                        ],
                      ),
                      if (genderError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              genderError!,
                              style: GoogleFonts.montserrat(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildPasswordField(
                              controller: passwordController,
                              label: "Password",
                              hint: "Enter password",
                              visible: passwordVisible,
                              toggleVisibility: () => setState(() {
                                passwordVisible = !passwordVisible;
                              }),
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: passwordError,
                              onChanged: (_) {
                                if (passwordController.text.length >= 8 &&
                                    RegExp(r'[0-9]')
                                        .hasMatch(passwordController.text)) {
                                  setState(() => passwordError = null);
                                }
                                if (confirmPasswordController.text.isNotEmpty) {
                                  setState(() {
                                    confirmPasswordError =
                                        confirmPasswordController.text ==
                                                passwordController.text
                                            ? null
                                            : "Passwords do not match";
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPasswordField(
                              controller: confirmPasswordController,
                              label: "Confirm Password",
                              hint: "Re-enter password",
                              visible: confirmPasswordVisible,
                              toggleVisibility: () => setState(() {
                                confirmPasswordVisible =
                                    !confirmPasswordVisible;
                              }),
                              fieldColor: fieldColor,
                              textColor: textColor,
                              errorText: confirmPasswordError,
                              onChanged: (_) {
                                setState(() {
                                  confirmPasswordError =
                                      confirmPasswordController.text ==
                                              passwordController.text
                                          ? null
                                          : "Passwords do not match";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Checkbox(
                            value: agreedToTerms,
                            activeColor: ColorName.primaryColor,
                            onChanged: (val) =>
                                setState(() => agreedToTerms = val ?? false),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text("I agree to the ",
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: textColor)),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Terms & Conditions",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: ColorName.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(" and Privacy Policy",
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: textColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  isLoading
                    ? Center(
                        child: SpinKitWave(
                          color: ColorName.primaryColor,
                          size: 28,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            backgroundColor: ColorName.primaryColor,
                            shadowColor: ColorName.primaryColor.withOpacity(0.4),
                          ),
                          child: Text(
                            "Create Account",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 17.sp,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: textColor)),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, Routes.login),
                        child: Text(
                          "Sign In",
                          style: textTheme.bodyMedium?.copyWith(
                            color: ColorName.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -----------------------------
  // FIELD HELPERS
  // -----------------------------

  Widget _buildDobField({
    required String label,
    required TextEditingController controller,
    required Color fieldColor,
    required Color textColor,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000, 1, 1),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: ColorName.primaryColor,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    dialogTheme: DialogThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    textTheme: GoogleFonts.montserratTextTheme(
                      Theme.of(context).textTheme,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              setState(() {
                controller.text =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              });
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              style: GoogleFonts.montserrat(color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldColor,
                prefixIcon:
                    Icon(Icons.calendar_today_outlined, color: Colors.blue[800]),
                hintText: "yyyy-MM-dd",
                hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(errorText,
                style:
                    GoogleFonts.montserrat(color: Colors.red, fontSize: 13)),
          ),
      ],
    );
  }

  Widget _buildGenderButton(String label, IconData icon) {
    final isSelected = gender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            gender = label;
            genderError = null; // ✅ Clear validation immediately
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? ColorName.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black87),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.montserrat(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.montserrat(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(icon, color: Colors.blue[800]),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(errorText,
                style:
                    GoogleFonts.montserrat(color: Colors.red, fontSize: 13)),
          ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool visible,
    required VoidCallback toggleVisibility,
    required Color fieldColor,
    required Color textColor,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: !visible,
          style: GoogleFonts.montserrat(color: textColor),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[800]),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                visible ? Icons.visibility : Icons.visibility_off,
                color: Colors.blue[800],
              ),
              onPressed: toggleVisibility,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(errorText,
                style:
                    GoogleFonts.montserrat(color: Colors.red, fontSize: 13)),
          ),
      ],
    );
  }
}