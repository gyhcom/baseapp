import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/routine_item.dart';
import '../../providers/routine_detail_provider.dart';
import '../../widgets/routine/detail/routine_detail_header.dart';
import '../../widgets/routine/detail/routine_progress_summary.dart';
import '../../widgets/routine/detail/routine_items_list.dart';
import '../../widgets/common/common_app_bar.dart';
import 'routine_edit_screen.dart';

/// 리팩토링된 루틴 상세 화면
@RoutePage()
class RoutineDetailScreenNew extends StatelessWidget {
  final DailyRoutine routine;

  const RoutineDetailScreenNew({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoutineDetailProvider(routine),
      child: Consumer<RoutineDetailProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: _buildAppBar(context, provider),
            body: RefreshIndicator(
              onRefresh: provider.refreshRoutine,
              child: provider.isLoading
                  ? _buildLoadingWidget()
                  : _buildBody(context, provider),
            ),
          );
        },
      ),
    );
  }

  /// 앱바 구성
  PreferredSizeWidget _buildAppBar(BuildContext context, RoutineDetailProvider provider) {
    return CommonAppBar(
      title: '루틴 상세',
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editRoutine(context, provider),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, provider, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8),
                  Text('공유'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [
                  Icon(Icons.copy),
                  SizedBox(width: 8),
                  Text('복사'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('삭제', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 본문 구성
  Widget _buildBody(BuildContext context, RoutineDetailProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 헤더 섹션
          RoutineDetailHeader(
            routine: provider.routine,
            isActive: provider.isActive,
            onToggleActive: () => _toggleActive(context, provider),
            onToggleFavorite: () => _toggleFavorite(context, provider),
          ),
          
          const SizedBox(height: 16),
          
          // 진행률 요약
          RoutineProgressSummary(
            routine: provider.routine,
            progress: provider.progress,
            completedCount: provider.completedCount,
            totalCount: provider.totalCount,
          ),
          
          const SizedBox(height: 16),
          
          // 루틴 항목 목록
          RoutineItemsList(
            routine: provider.routine,
            onToggleCompletion: (itemId) => _toggleItemCompletion(context, provider, itemId),
            onEditItem: (item) => _editItem(context, provider, item),
          ),
          
          const SizedBox(height: 80), // 하단 여백
        ],
      ),
    );
  }

  /// 로딩 위젯
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            '루틴 정보를 불러오는 중...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 메뉴 액션 처리
  void _handleMenuAction(BuildContext context, RoutineDetailProvider provider, String action) {
    switch (action) {
      case 'share':
        _shareRoutine(provider.routine);
        break;
      case 'copy':
        _copyRoutine(context, provider.routine);
        break;
      case 'delete':
        _confirmDelete(context, provider);
        break;
    }
  }

  /// 루틴 편집
  void _editRoutine(BuildContext context, RoutineDetailProvider provider) async {
    final result = await Navigator.of(context).push<DailyRoutine>(
      MaterialPageRoute(
        builder: (context) => RoutineEditScreen(routine: provider.routine),
      ),
    );

    if (result != null) {
      provider.updateRoutine(result);
    }
  }

  /// 활성화 토글
  void _toggleActive(BuildContext context, RoutineDetailProvider provider) async {
    try {
      await provider.toggleActive();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.isActive ? '루틴이 활성화되었습니다' : '루틴이 비활성화되었습니다',
            ),
            backgroundColor: provider.isActive ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('활성화 상태 변경에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 즐겨찾기 토글
  void _toggleFavorite(BuildContext context, RoutineDetailProvider provider) async {
    try {
      await provider.toggleFavorite();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.routine.isFavorite
                  ? '즐겨찾기에 추가되었습니다'
                  : '즐겨찾기에서 제거되었습니다',
            ),
            backgroundColor: provider.routine.isFavorite ? Colors.red : Colors.grey,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('즐겨찾기 상태 변경에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 항목 완료 토글
  void _toggleItemCompletion(BuildContext context, RoutineDetailProvider provider, String itemId) async {
    try {
      await provider.toggleItemCompletion(itemId);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('항목 상태 변경에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 항목 편집
  void _editItem(BuildContext context, RoutineDetailProvider provider, RoutineItem item) {
    showDialog(
      context: context,
      builder: (context) => _ItemEditDialog(
        item: item,
        onSave: (updatedItem) {
          // TODO: 개별 항목 편집 로직 구현
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// 루틴 공유
  void _shareRoutine(DailyRoutine routine) {
    final shareText = '''
${routine.title}

${routine.description}

활동 목록:
${routine.items.map((item) => '• ${item.title}').join('\n')}

RoutineCraft에서 만든 루틴입니다.
''';

    Share.share(shareText, subject: routine.title);
  }

  /// 루틴 복사
  void _copyRoutine(BuildContext context, DailyRoutine routine) {
    // TODO: 루틴 복사 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('루틴이 복사되었습니다')),
    );
  }

  /// 삭제 확인
  void _confirmDelete(BuildContext context, RoutineDetailProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 삭제'),
        content: Text('\'${provider.routine.title}\' 루틴을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                await provider.deleteRoutine();
                
                if (context.mounted) {
                  context.router.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('루틴이 삭제되었습니다'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('루틴 삭제에 실패했습니다: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

/// 항목 편집 다이얼로그
class _ItemEditDialog extends StatefulWidget {
  final RoutineItem item;
  final Function(RoutineItem) onSave;

  const _ItemEditDialog({
    required this.item,
    required this.onSave,
  });

  @override
  State<_ItemEditDialog> createState() => _ItemEditDialogState();
}

class _ItemEditDialogState extends State<_ItemEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _descriptionController = TextEditingController(text: widget.item.description);
    _selectedTime = widget.item.startTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('항목 편집'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '제목',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: '설명 (선택)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(_selectedTime != null
                ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                : '시간 설정 (선택)'),
            trailing: _selectedTime != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _selectedTime = null),
                  )
                : null,
            onTap: _selectTime,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('저장'),
        ),
      ],
    );
  }

  /// 시간 선택
  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (time != null && mounted) {
      setState(() => _selectedTime = time);
    }
  }

  /// 저장
  void _save() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }

    final updatedItem = widget.item.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _selectedTime!,
    );

    widget.onSave(updatedItem);
  }
}