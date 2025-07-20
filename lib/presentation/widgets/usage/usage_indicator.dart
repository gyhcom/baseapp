import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/user_usage.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../di/service_locator.dart';

/// 사용량 표시 위젯
/// 현재 사용 가능한 생성 횟수와 제한 정보를 표시
class UsageIndicator extends ConsumerWidget {
  final bool showDetails;
  final EdgeInsets? padding;

  const UsageIndicator({
    super.key,
    this.showDetails = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<UserUsage>(
      future: getIt<UsageRepository>().getCurrentUsage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        }
        
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorIndicator();
        }
        
        final usage = snapshot.data!;
        return _buildUsageIndicator(context, usage);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            '사용량 확인 중...',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIndicator() {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Colors.red,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            '사용량 확인 실패',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageIndicator(BuildContext context, UserUsage usage) {
    final available = usage.availableGenerationsToday;
    final isPremium = usage.isPremium && 
        (usage.premiumExpiryDate?.isAfter(DateTime.now()) ?? false);
    
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: _getBackgroundColor(available, isPremium),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(available, isPremium),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 메인 표시
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIcon(available, isPremium),
                size: 18,
                color: _getIconColor(available, isPremium),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                _getMainText(available, isPremium),
                style: TextStyle(
                  color: _getTextColor(available, isPremium),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          // 상세 정보
          if (showDetails && !isPremium) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              _getDetailText(usage),
              style: TextStyle(
                color: _getTextColor(available, isPremium).withOpacity(0.8),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor(int available, bool isPremium) {
    if (isPremium) return AppTheme.primaryColor.withOpacity(0.1);
    if (available > 0) return Colors.green.withOpacity(0.1);
    return Colors.red.withOpacity(0.1);
  }

  Color _getBorderColor(int available, bool isPremium) {
    if (isPremium) return AppTheme.primaryColor.withOpacity(0.3);
    if (available > 0) return Colors.green.withOpacity(0.3);
    return Colors.red.withOpacity(0.3);
  }

  IconData _getIcon(int available, bool isPremium) {
    if (isPremium) return Icons.star;
    if (available > 0) return Icons.check_circle_outline;
    return Icons.block;
  }

  Color _getIconColor(int available, bool isPremium) {
    if (isPremium) return AppTheme.primaryColor;
    if (available > 0) return Colors.green;
    return Colors.red;
  }

  Color _getTextColor(int available, bool isPremium) {
    if (isPremium) return AppTheme.primaryColor;
    if (available > 0) return Colors.green;
    return Colors.red;
  }

  String _getMainText(int available, bool isPremium) {
    if (isPremium) return '프리미엄 무제한';
    if (available > 0) return '오늘 $available개 가능';
    return '오늘 사용량 초과';
  }

  String _getDetailText(UserUsage usage) {
    if (usage.bonusGenerations > 0) {
      return '보너스 ${usage.bonusGenerations}개 + 일일 ${UsageLimits.dailyFreeGenerations - usage.dailyGenerations}개';
    } else {
      final remaining = UsageLimits.dailyFreeGenerations - usage.dailyGenerations;
      if (remaining > 0) {
        return '일일 무료 $remaining개 남음';
      } else {
        return '${usage.hoursUntilReset}시간 후 리셋';
      }
    }
  }
}

/// 간단한 사용량 뱃지 위젯
class UsageBadge extends ConsumerWidget {
  const UsageBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<UserUsage>(
      future: getIt<UsageRepository>().getCurrentUsage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        
        final usage = snapshot.data!;
        final available = usage.availableGenerationsToday;
        final isPremium = usage.isPremium && 
            (usage.premiumExpiryDate?.isAfter(DateTime.now()) ?? false);
        
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isPremium 
                ? AppTheme.primaryColor 
                : available > 0 
                    ? Colors.green 
                    : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isPremium 
                ? '프리미엄' 
                : available > 0 
                    ? '$available' 
                    : '0',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}