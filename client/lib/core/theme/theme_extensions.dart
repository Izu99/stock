import 'package:flutter/material.dart';

// Design tokens for gradients
class AppGradients extends ThemeExtension<AppGradients> {
  final LinearGradient primaryGradient;
  final LinearGradient cardGradient;
  final LinearGradient successGradient;
  final LinearGradient warningGradient;
  final LinearGradient dangerGradient;
  final LinearGradient infoGradient;

  AppGradients({
    required this.primaryGradient,
    required this.cardGradient,
    required this.successGradient,
    required this.warningGradient,
    required this.dangerGradient,
    required this.infoGradient,
  });

  @override
  ThemeExtension<AppGradients> copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? cardGradient,
    LinearGradient? successGradient,
    LinearGradient? warningGradient,
    LinearGradient? dangerGradient,
    LinearGradient? infoGradient,
  }) {
    return AppGradients(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      cardGradient: cardGradient ?? this.cardGradient,
      successGradient: successGradient ?? this.successGradient,
      warningGradient: warningGradient ?? this.warningGradient,
      dangerGradient: dangerGradient ?? this.dangerGradient,
      infoGradient: infoGradient ?? this.infoGradient,
    );
  }

  @override
  ThemeExtension<AppGradients> lerp(
    ThemeExtension<AppGradients>? other,
    double t,
  ) {
    if (other is! AppGradients) return this;
    return AppGradients(
      primaryGradient: LinearGradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
      successGradient: LinearGradient.lerp(
        successGradient,
        other.successGradient,
        t,
      )!,
      warningGradient: LinearGradient.lerp(
        warningGradient,
        other.warningGradient,
        t,
      )!,
      dangerGradient: LinearGradient.lerp(
        dangerGradient,
        other.dangerGradient,
        t,
      )!,
      infoGradient: LinearGradient.lerp(infoGradient, other.infoGradient, t)!,
    );
  }

  static AppGradients get light => AppGradients(
    primaryGradient: const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardGradient: const LinearGradient(
      colors: [Colors.white, Color(0xFFF8FAFC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    successGradient: const LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF059669)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    warningGradient: const LinearGradient(
      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    dangerGradient: const LinearGradient(
      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    infoGradient: const LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

// Design tokens for shadows
class AppShadows extends ThemeExtension<AppShadows> {
  final List<BoxShadow> small;
  final List<BoxShadow> medium;
  final List<BoxShadow> large;
  final List<BoxShadow> card;

  AppShadows({
    required this.small,
    required this.medium,
    required this.large,
    required this.card,
  });

  @override
  ThemeExtension<AppShadows> copyWith({
    List<BoxShadow>? small,
    List<BoxShadow>? medium,
    List<BoxShadow>? large,
    List<BoxShadow>? card,
  }) {
    return AppShadows(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      card: card ?? this.card,
    );
  }

  @override
  ThemeExtension<AppShadows> lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) return this;
    return this; // Shadows don't interpolate well
  }

  static AppShadows get light => AppShadows(
    small: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
    medium: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
    large: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
    card: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

// Design tokens for spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// Design tokens for border radius
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

// Semantic colors
class AppColors {
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color dangerLight = Color(0xFFFEE2E2);
  static const Color infoLight = Color(0xFFDBEAFE);
}
