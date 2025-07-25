import 'package:flutter/material.dart';

/// App theme configuration for Routine Generation App
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // 🎨 클린하고 사용자 친화적인 색상 시스템
  // 메인 컬러 - 편안하고 신뢰감 있는 블루
  static const Color primaryColor = Color(0xFF2563EB); // 깔끔한 블루
  static const Color primaryLightColor = Color(0xFF3B82F6); // 라이트 블루
  static const Color primaryDarkColor = Color(0xFF1D4ED8); // 다크 블루
  
  // 액센트 컬러 - 활기찬 그린
  static const Color accentColor = Color(0xFF10B981); // 상쾌한 그린
  static const Color accentLightColor = Color(0xFF34D399); // 라이트 그린
  
  // 배경 색상 시스템
  static const Color backgroundColor = Color(0xFFFAFAFA); // 아주 밝은 회색 배경
  static const Color surfaceColor = Color(0xFFFFFFFF); // 순백색 표면
  static const Color cardColor = Color(0xFFFFFFFF); // 카드 배경
  
  // 텍스트 색상 시스템
  static const Color textPrimaryColor = Color(0xFF111827); // 진한 검정
  static const Color textSecondaryColor = Color(0xFF6B7280); // 중간 회색
  static const Color textTertiaryColor = Color(0xFF9CA3AF); // 연한 회색
  
  // 보더 및 구분선
  static const Color borderColor = Color(0xFFE5E7EB); // 연한 회색 보더
  static const Color dividerColor = Color(0xFFF3F4F6); // 아주 연한 구분선
  
  // 상태 색상
  static const Color successColor = Color(0xFF10B981); // 성공 (그린)
  static const Color warningColor = Color(0xFFF59E0B); // 경고 (앰버)
  static const Color errorColor = Color(0xFFEF4444); // 에러 (레드)
  static const Color infoColor = Color(0xFF3B82F6); // 정보 (블루)
  
  // 그라데이션 컬러
  static const List<Color> primaryGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];
  
  // 서브틸한 그라데이션
  static const List<Color> subtleGradient = [
    Color(0xFFF8FAFC),
    Color(0xFFE2E8F0),
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
        outline: borderColor,
        outlineVariant: dividerColor,
      ),
      
      // 배경색
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar 테마
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimaryColor,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: textPrimaryColor,
        ),
      ),
      
      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 1,
          shadowColor: primaryColor.withValues(alpha: 0.2),
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
      
      // 아웃라인 버튼 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryColor,
          side: const BorderSide(color: borderColor, width: 1.5),
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
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 1),
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
          color: textTertiaryColor,
          fontSize: 14,
        ),
      ),
      
      // 카드 테마
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 1),
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

  // ========== 단일 라이트 테마만 사용 ==========
  // 다크 테마는 제거하고 깔끔한 라이트 테마만 유지
  
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
  
  // 그림자 유틸리티 - 더 서브틸하고 깔끔하게
  static BoxShadow get cardShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    offset: const Offset(0, 1),
    blurRadius: 8,
    spreadRadius: 0,
  );
  
  static BoxShadow get elevatedShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.08),
    offset: const Offset(0, 2),
    blurRadius: 12,
    spreadRadius: 0,
  );
  
  static BoxShadow get buttonShadow => BoxShadow(
    color: primaryColor.withValues(alpha: 0.15),
    offset: const Offset(0, 2),
    blurRadius: 8,
    spreadRadius: 0,
  );
  
  // 추가 그림자 옵션
  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      offset: const Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
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
