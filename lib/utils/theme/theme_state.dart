part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isDarkMode;

  const ThemeState(this.themeMode, this.isDarkMode);

  @override
  List<Object> get props => [themeMode, isDarkMode];

  @override
  String toString() => 'ThemeState(mode: $themeMode, isDark: $isDarkMode)';
}
