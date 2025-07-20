import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/routine_item.dart';
import '../../widgets/routine/routine_item_card.dart';

/// 루틴 상세 화면
class RoutineDetailScreen extends StatefulWidget {
  final DailyRoutine routine;

  const RoutineDetailScreen({
    super.key,
    required this.routine,
  });

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late DailyRoutine _currentRoutine;

  @override
  void initState() {
    super.initState();
    _currentRoutine = widget.routine;
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleItemComplete(String itemId) {
    setState(() {
      final updatedItems = _currentRoutine.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isCompleted: !item.isCompleted);
        }
        return item;
      }).toList();
      
      _currentRoutine = _currentRoutine.copyWith(items: updatedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_currentRoutine.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _currentRoutine.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _currentRoutine.isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareRoutine,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // 루틴 헤더 정보
            _buildRoutineHeader(),
            
            // 진행률 표시
            _buildProgressSection(),
            
            // 루틴 아이템 목록
            Expanded(
              child: _buildRoutineItemsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _customizeRoutine,
        icon: const Icon(Icons.edit),
        label: const Text('루틴 수정'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildRoutineHeader() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingL),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradientDecoration,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 컨셉 이모지
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    _currentRoutine.concept.displayName.split(' ')[0], // 이모지
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingM),
              
              // 루틴 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentRoutine.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    Text(
                      _currentRoutine.concept.displayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white.withOpacity(0.8),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_currentRoutine.items.length}개 활동',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Icon(
                          Icons.timer,
                          color: Colors.white.withOpacity(0.8),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTotalDuration(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (_currentRoutine.description.isNotEmpty) ...[ 
            const SizedBox(height: AppTheme.spacingM),
            const Divider(color: Colors.white24),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              _currentRoutine.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final completedCount = _currentRoutine.items.where((item) => item.isCompleted).length;
    final totalCount = _currentRoutine.items.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '진행률',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '$completedCount/$totalCount 완료',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Text(
            '${(progress * 100).round()}% 완료',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineItemsList() {
    // 시간대별로 그룹화
    final groupedItems = _groupItemsByTimeOfDay();
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final group = groupedItems[index];
        return _buildTimeGroup(group);
      },
    );
  }

  Widget _buildTimeGroup(Map<String, dynamic> group) {
    final timeLabel = group['label'] as String;
    final items = group['items'] as List<RoutineItem>;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 시간대 라벨
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                timeLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // 해당 시간대 아이템들
        ...items.map((item) => RoutineItemCard(
          item: item,
          onToggleComplete: () => _toggleItemComplete(item.id),
          onEdit: () => _editItem(item),
        )).toList(),
        
        const SizedBox(height: AppTheme.spacingL),
      ],
    );
  }

  List<Map<String, dynamic>> _groupItemsByTimeOfDay() {
    final groups = <String, List<RoutineItem>>{
      '🌅 새벽 (05:00 - 07:59)': [],
      '🌞 오전 (08:00 - 11:59)': [],
      '☀️ 점심 (12:00 - 13:59)': [],
      '🌤️ 오후 (14:00 - 17:59)': [],
      '🌆 저녁 (18:00 - 20:59)': [],
      '🌙 밤 (21:00 - 23:59)': [],
      '🌃 심야 (00:00 - 04:59)': [],
    };
    
    for (final item in _currentRoutine.items) {
      final hour = item.startTime.hour;
      
      if (hour >= 5 && hour < 8) {
        groups['🌅 새벽 (05:00 - 07:59)']!.add(item);
      } else if (hour >= 8 && hour < 12) {
        groups['🌞 오전 (08:00 - 11:59)']!.add(item);
      } else if (hour >= 12 && hour < 14) {
        groups['☀️ 점심 (12:00 - 13:59)']!.add(item);
      } else if (hour >= 14 && hour < 18) {
        groups['🌤️ 오후 (14:00 - 17:59)']!.add(item);
      } else if (hour >= 18 && hour < 21) {
        groups['🌆 저녁 (18:00 - 20:59)']!.add(item);
      } else if (hour >= 21 && hour < 24) {
        groups['🌙 밤 (21:00 - 23:59)']!.add(item);
      } else {
        groups['🌃 심야 (00:00 - 04:59)']!.add(item);
      }
    }
    
    // 빈 그룹 제거하고 시간순으로 정렬
    return groups.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) {
          // 각 그룹 내에서 시간순 정렬
          entry.value.sort((a, b) {
            final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
            final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
            return aMinutes.compareTo(bMinutes);
          });
          
          return {
            'label': entry.key,
            'items': entry.value,
          };
        })
        .toList();
  }

  String _formatTotalDuration() {
    final totalMinutes = _currentRoutine.items.fold<int>(
      0,
      (sum, item) => sum + item.duration.inMinutes,
    );
    
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  void _toggleFavorite() {
    setState(() {
      _currentRoutine = _currentRoutine.copyWith(
        isFavorite: !_currentRoutine.isFavorite,
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentRoutine.isFavorite 
              ? '즐겨찾기에 추가되었습니다' 
              : '즐겨찾기에서 제거되었습니다',
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _shareRoutine() {
    // TODO: 루틴 공유 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('루틴 공유 기능은 준비 중입니다'),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('루틴 복사'),
              onTap: () {
                Navigator.pop(context);
                _copyRoutine();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('루틴 수정'),
              onTap: () {
                Navigator.pop(context);
                _customizeRoutine();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('루틴 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteRoutine();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _customizeRoutine() {
    // TODO: 루틴 커스터마이징 화면으로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('루틴 수정 기능은 준비 중입니다'),
      ),
    );
  }

  void _editItem(RoutineItem item) {
    // TODO: 개별 아이템 수정 기능
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} 수정 기능은 준비 중입니다'),
      ),
    );
  }

  void _copyRoutine() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('루틴이 복사되었습니다'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _deleteRoutine() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 삭제'),
        content: const Text('이 루틴을 삭제하시겠습니까?\n삭제된 루틴은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.router.maybePop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('루틴이 삭제되었습니다'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}