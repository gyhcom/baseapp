import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/routine_limits.dart';
import '../../../providers/routine_list_provider.dart';

/// 루틴 저장 공간 표시기 위젯
class RoutineStorageIndicator extends StatelessWidget {
  final VoidCallback onUpgradePressed;

  const RoutineStorageIndicator({
    super.key,
    required this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineListProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTierBadge(provider.userTier),
                  const Spacer(),
                  if (provider.userTier == UserTier.free)
                    TextButton(
                      onPressed: onUpgradePressed,
                      child: const Text('업그레이드'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _buildProgressBar(provider),
              const SizedBox(height: 8),
              _buildStatusMessage(provider),
            ],
          ),
        );
      },
    );
  }

  /// 티어 배지
  Widget _buildTierBadge(UserTier tier) {
    final isPremium = tier == UserTier.premium;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPremium ? Colors.amber : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPremium ? Icons.star : Icons.person,
            size: 16,
            color: isPremium ? Colors.white : Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            isPremium ? 'Premium' : 'Free',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPremium ? Colors.white : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 진행률 바
  Widget _buildProgressBar(RoutineListProvider provider) {
    final maxRoutines = provider.userTier == UserTier.premium 
        ? double.infinity 
        : RoutineLimits.freeMaxRoutines;
    
    if (maxRoutines == double.infinity) {
      return Container(
        height: 6,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );
    }

    final progress = provider.currentCount / maxRoutines;
    final progressColor = _getProgressColor(provider.storageStatus);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  /// 상태 메시지
  Widget _buildStatusMessage(RoutineListProvider provider) {
    final isUnlimited = provider.userTier == UserTier.premium;
    
    if (isUnlimited) {
      return Text(
        '무제한 루틴 저장 가능 (현재 ${provider.currentCount}개)',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      );
    }

    final maxRoutines = RoutineLimits.freeMaxRoutines;
    final statusText = _getStatusText(provider.storageStatus, provider.currentCount, maxRoutines);
    final statusColor = _getStatusColor(provider.storageStatus);

    return Text(
      statusText,
      style: TextStyle(
        fontSize: 12,
        color: statusColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// 진행률 색상
  Color _getProgressColor(LimitStatus status) {
    switch (status) {
      case LimitStatus.available:
        return Colors.blue;
      case LimitStatus.warning:
        return Colors.orange;
      case LimitStatus.exceeded:
        return Colors.red;
      case LimitStatus.unlimited:
        return Colors.green;
    }
  }

  /// 상태 색상
  Color _getStatusColor(LimitStatus status) {
    switch (status) {
      case LimitStatus.available:
        return Colors.grey[600]!;
      case LimitStatus.warning:
        return Colors.orange[700]!;
      case LimitStatus.exceeded:
        return Colors.red[700]!;
      case LimitStatus.unlimited:
        return Colors.green[700]!;
    }
  }

  /// 상태 텍스트
  String _getStatusText(LimitStatus status, int current, int max) {
    switch (status) {
      case LimitStatus.available:
        return '$current/$max개 사용 중 (${max - current}개 더 추가 가능)';
      case LimitStatus.warning:
        return '$current/$max개 사용 중 (${max - current}개만 더 추가 가능)';
      case LimitStatus.exceeded:
        return '$current/$max개 사용 중 (저장 공간이 가득함)';
      case LimitStatus.unlimited:
        return '무제한 루틴 저장 가능 (현재 $current개)';
    }
  }
}