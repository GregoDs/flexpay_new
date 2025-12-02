import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/theme/theme_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeToggleWidget extends StatelessWidget {
  final bool showLabel;
  final EdgeInsetsGeometry? padding;
  final bool isCompact;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.padding,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[600];

        return Container(
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: isCompact ? 12 : 16,
                vertical: isCompact ? 8 : 12,
              ),
          child: isCompact
              ? _buildCompactToggle(context, themeState, textColor)
              : _buildFullToggle(context, themeState, textColor, subtitleColor),
        );
      },
    );
  }

  Widget _buildCompactToggle(
    BuildContext context,
    ThemeState themeState,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () => context.read<ThemeCubit>().toggleTheme(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorName.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorName.primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getThemeIcon(themeState.themeMode),
              color: ColorName.primaryColor,
              size: 20,
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                _getThemeLabel(themeState.themeMode),
                style: GoogleFonts.montserrat(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFullToggle(
    BuildContext context,
    ThemeState themeState,
    Color textColor,
    Color? subtitleColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorName.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getThemeIcon(themeState.themeMode),
            color: ColorName.primaryColor,
            size: 24,
          ),
        ),
        if (showLabel) ...[
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Theme",
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _getThemeDescription(themeState.themeMode),
                  style: GoogleFonts.montserrat(
                    color: subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(width: 12),
        _buildThemeSelector(context, themeState),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeState themeState) {
    return PopupMenuButton<ThemeMode>(
      offset: const Offset(-20, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        _buildThemeMenuItem(
          context,
          ThemeMode.system,
          Icons.brightness_auto,
          "System",
          "Follow device setting",
          themeState.themeMode,
        ),
        _buildThemeMenuItem(
          context,
          ThemeMode.light,
          Icons.light_mode,
          "Light",
          "Light theme",
          themeState.themeMode,
        ),
        _buildThemeMenuItem(
          context,
          ThemeMode.dark,
          Icons.dark_mode,
          "Dark",
          "Dark theme",
          themeState.themeMode,
        ),
      ],
      onSelected: (mode) => context.read<ThemeCubit>().setThemeMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorName.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getThemeLabel(themeState.themeMode),
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<ThemeMode> _buildThemeMenuItem(
    BuildContext context,
    ThemeMode mode,
    IconData icon,
    String title,
    String subtitle,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorName.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? ColorName.primaryColor
                    : (isDark ? Colors.white70 : Colors.black54),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? ColorName.primaryColor
                          : (isDark ? Colors.white : Colors.black87),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: ColorName.primaryColor, size: 18),
          ],
        ),
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.system:
        return "Auto";
    }
  }

  String _getThemeDescription(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "Light theme is active";
      case ThemeMode.dark:
        return "Dark theme is active";
      case ThemeMode.system:
        return "Follows system setting";
    }
  }
}
