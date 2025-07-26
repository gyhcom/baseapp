import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

/// Toast 유틸리티 클래스
/// SnackBar 대신 BotToast를 사용하여 더 나은 UX 제공
class ToastUtils {
  /// 성공 메시지 토스트
  static void showSuccess(String message) {
    BotToast.showText(
      text: message,
      contentColor: Colors.green,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      duration: const Duration(seconds: 2),
      align: Alignment.topCenter,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// 에러 메시지 토스트
  static void showError(String message) {
    BotToast.showText(
      text: message,
      contentColor: Colors.red,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      duration: const Duration(seconds: 3),
      align: Alignment.topCenter,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// 정보 메시지 토스트
  static void showInfo(String message) {
    BotToast.showText(
      text: message,
      contentColor: Colors.blue,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      duration: const Duration(seconds: 2),
      align: Alignment.topCenter,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// 경고 메시지 토스트
  static void showWarning(String message) {
    BotToast.showText(
      text: message,
      contentColor: Colors.orange,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      duration: const Duration(seconds: 2),
      align: Alignment.topCenter,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// 커스텀 아이콘과 함께 토스트 표시
  static void showWithIcon({
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    BotToast.showCustomText(
      duration: duration,
      align: Alignment.topCenter,
      toastBuilder: (textCancel) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 로딩 토스트 표시
  static CancelFunc showLoading({String message = '처리 중...'}) {
    return BotToast.showLoading();
  }

  /// 모든 토스트 숨기기
  static void hideAll() {
    BotToast.cleanAll();
  }
}