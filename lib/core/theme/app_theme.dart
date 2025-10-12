import 'package:flutter/material.dart';

import 'tokens/app_colors.dart';
import 'tokens/app_spacing.dart';
import 'tokens/app_text_styles.dart';
import 'tokens/app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ColorScheme get _lightScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.secondaryContainer,
        onTertiary: AppColors.onSecondaryContainer,
        error: AppColors.error,
        onError: AppColors.onPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.shadow,
        scrim: AppColors.shadow,
        inverseSurface: AppColors.onBackground,
        onInverseSurface: AppColors.onPrimary,
        inversePrimary: AppColors.secondary,
      );

  static TextTheme _textTheme(ColorScheme scheme) {
    final TextTheme base = Typography.material2021().black;
    return base.copyWith(
      displayLarge: AppTextStyles.semiBold(
        fontSize: FontSizeTokens.display,
        color: scheme.onSurface,
      ),
      headlineMedium: AppTextStyles.semiBold(
        fontSize: FontSizeTokens.xxl,
        color: scheme.onSurface,
      ),
      titleLarge: AppTextStyles.medium(
        fontSize: FontSizeTokens.xl,
        color: scheme.onSurface,
      ),
      titleMedium: AppTextStyles.medium(
        fontSize: FontSizeTokens.lg,
        color: scheme.onSurface,
      ),
      titleSmall: AppTextStyles.medium(
        fontSize: FontSizeTokens.md,
        color: scheme.primary,
      ),
      bodyLarge: AppTextStyles.regular(
        fontSize: FontSizeTokens.lg,
        color: scheme.onSurface,
      ),
      bodyMedium: AppTextStyles.regular(
        fontSize: FontSizeTokens.md,
        color: scheme.onSurface,
      ),
      bodySmall: AppTextStyles.regular(
        fontSize: FontSizeTokens.sm,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: AppTextStyles.medium(
        fontSize: FontSizeTokens.md,
        color: scheme.onPrimary,
      ),
      labelMedium: AppTextStyles.medium(
        fontSize: FontSizeTokens.sm,
        color: scheme.onPrimary,
      ),
      labelSmall: AppTextStyles.medium(
        fontSize: FontSizeTokens.xs,
        color: scheme.onPrimary,
      ),
    );
  }

  static ThemeData light() {
    final ColorScheme scheme = _lightScheme;
    final TextTheme textTheme = _textTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.scaffold,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: true,
        elevation: AppSizeTokens.elevation,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onPrimary,
          fontWeight: AppTypography.semiBold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: AppSizeTokens.elevation,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        shadowColor: scheme.shadow,
        elevation: AppSizeTokens.elevation,
        shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.md),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.lg),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: scheme.surface,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: scheme.primary),
          shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        hintStyle:
            textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        labelStyle: textTheme.bodyMedium,
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.outlineVariant),
          borderRadius: AppRadiusTokens.md,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.primary),
          borderRadius: AppRadiusTokens.md,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.error),
          borderRadius: AppRadiusTokens.md,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.primary),
          borderRadius: AppRadiusTokens.md,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.primary,
        secondarySelectedColor: scheme.primary,
        checkmarkColor: scheme.onPrimary,
        labelStyle: textTheme.labelLarge?.copyWith(color: scheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.sm),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.primary,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: AppSpacing.md,
      ),
    );
  }
}
