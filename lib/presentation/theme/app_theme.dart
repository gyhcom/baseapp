import 'package:flutter/material.dart';

/// App theme configuration for Routine Generation App
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // 🎨 App Color Palette for Routine App
  static const Color primaryColor = Color(0xFF4F86F7); // 갓생 블루
  static const Color accentColor = Color(0xFFFBAF5D); // 햇살 오렌지
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF2E2E2E);
  static const Color textSecondaryColor = Color(0xFF8A8A8A);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color errorColor = Color(0xFFEF4444);
  
  // 그라데이션 컬러
  static const List<Color> primaryGradient = [
    Color(0xFF4F86F7),
    Color(0xFF6B94F8),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFFBAF5D),
    Color(0xFFFFC478),
  ];

  // ========== LIGHT THEME ==========
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard', // 폰트 설정 (나중에 추가 예정)
      
      // 컬러 스킴
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
        onBackground: textPrimaryColor,
        error: errorColor,
      ),
      
      // 배경색
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar 테마
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textPrimaryColor,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // 아웃라인 버튼 테마 (소셜 로그인용)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryColor,
          side: const BorderSide(color: dividerColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
        ),
      ),
      
      // 카드 테마
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // 텍스트 테마
      textTheme: const TextTheme(
        // 큰 제목
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        // 중간 제목
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        // 작은 제목
        headlineSmall: TextStyle(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        // 본문 큰 글씨
        bodyLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        // 본문 중간 글씨
        bodyMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        // 본문 작은 글씨
        bodySmall: TextStyle(
          color: textSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // 라벨
        labelLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ========== DARK THEME ==========
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        error: errorColor,
      ),
      
      scaffoldBackgroundColor: const Color(0xFF121212),
      
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  // ========== UTILITY METHODS ==========
  
  // 그라데이션 유틸리티
  static LinearGradient get primaryGradientDecoration => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: primaryGradient,
  );
  
  static LinearGradient get accentGradientDecoration => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: accentGradient,
  );
  
  // 그림자 유틸리티
  static BoxShadow get cardShadow => BoxShadow(
    color: Colors.black.withOpacity(0.08),
    offset: const Offset(0, 2),
    blurRadius: 12,
    spreadRadius: 0,
  );
  
  static BoxShadow get buttonShadow => BoxShadow(
    color: primaryColor.withOpacity(0.3),
    offset: const Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );
  
  // 둥근 모서리 유틸리티
  static BorderRadius get smallRadius => BorderRadius.circular(8);
  static BorderRadius get mediumRadius => BorderRadius.circular(12);
  static BorderRadius get largeRadius => BorderRadius.circular(16);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(24);
  
  // 간격 유틸리티
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;
}
