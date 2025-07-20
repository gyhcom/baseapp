import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/routine_item.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../di/service_locator.dart';

/// 루틴 수정 화면
class RoutineEditScreen extends StatefulWidget {
  final DailyRoutine routine;

  const RoutineEditScreen({
    super.key,
    required this.routine,
  });

  @override
  State<RoutineEditScreen> createState() => _RoutineEditScreenState();
}

class _RoutineEditScreenState extends State<RoutineEditScreen> {
  final RoutineRepository _routineRepository = getIt<RoutineRepository>();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<RoutineItem> _items;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.routine.title);
    _descriptionController = TextEditingController(text: widget.routine.description);
    _items = List.from(widget.routine.items);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('루틴 수정'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 루틴 기본 정보
              _buildBasicInfoSection(),
              
              const SizedBox(height: AppTheme.spacingXL),
              
              // 루틴 항목들
              _buildItemsSection(),
              
              const SizedBox(height: AppTheme.spacingXL),
              
              // 새 항목 추가 버튼
              _buildAddItemButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기본 정보',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // 제목
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '루틴 제목',
              hintText: '루틴의 제목을 입력하세요',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '제목을 입력해주세요';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // 설명
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: '설명 (선택사항)',
              hintText: '루틴에 대한 설명을 입력하세요',
            ),
            maxLines: 3,
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // 컨셉 정보 (읽기 전용)
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: widget.routine.concept.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.routine.concept.color.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.routine.concept.displayName.split(' ')[0], // 이모지
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  '컨셉: ${widget.routine.concept.displayName}',
                  style: TextStyle(
                    color: widget.routine.concept.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '루틴 항목 (${_items.length}개)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '총 ${_calculateTotalDuration()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          if (_items.isEmpty)
            _buildEmptyItemsState()
          else
            ..._items.asMap().entries.map(
              (entry) => _buildItemCard(entry.key, entry.value),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyItemsState() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        children: [
          Icon(
            Icons.event_note,
            size: 48,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '루틴 항목이 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '새로운 항목을 추가해보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(int index, RoutineItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          // 항목 헤더
          Row(
            children: [
              // 시간
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatTime(item.startTime),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingS),
              
              // 제목
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // 액션 버튼들
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editItem(index),
                    icon: const Icon(Icons.edit, size: 16),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(index),
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // 설명 (있는 경우)
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingS),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
          ],
          
          // 소요시간
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${item.duration.inMinutes}분',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addNewItem,
        icon: const Icon(Icons.add),
        label: const Text('새 항목 추가'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppTheme.spacingM),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _calculateTotalDuration() {
    final totalMinutes = _items.fold<int>(
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

  void _addNewItem() {
    _showItemEditDialog(
      title: '새 항목 추가',
      onSave: (item) {
        setState(() {
          _items.add(item);
        });
      },
    );
  }

  void _editItem(int index) {
    final item = _items[index];
    _showItemEditDialog(
      title: '항목 수정',
      initialItem: item,
      onSave: (updatedItem) {
        setState(() {
          _items[index] = updatedItem;
        });
      },
    );
  }

  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('항목 삭제'),
        content: const Text('이 항목을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _items.removeAt(index);
              });
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showItemEditDialog({
    required String title,
    RoutineItem? initialItem,
    required Function(RoutineItem) onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => _ItemEditDialog(
        title: title,
        initialItem: initialItem,
        onSave: onSave,
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 1개의 루틴 항목이 필요합니다'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 수정된 루틴 생성
      final updatedRoutine = widget.routine.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        items: _items,
        updatedAt: DateTime.now(),
      );

      // 저장
      await _routineRepository.updateRoutine(updatedRoutine);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('루틴이 성공적으로 수정되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // 변경사항이 있음을 알림
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('루틴 수정에 실패했어요: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// 항목 편집 다이얼로그
class _ItemEditDialog extends StatefulWidget {
  final String title;
  final RoutineItem? initialItem;
  final Function(RoutineItem) onSave;

  const _ItemEditDialog({
    required this.title,
    this.initialItem,
    required this.onSave,
  });

  @override
  State<_ItemEditDialog> createState() => _ItemEditDialogState();
}

class _ItemEditDialogState extends State<_ItemEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay _startTime;
  late int _durationMinutes;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    final item = widget.initialItem;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descriptionController = TextEditingController(text: item?.description ?? '');
    _startTime = item?.startTime ?? TimeOfDay.now();
    _durationMinutes = item?.duration.inMinutes ?? 30;
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
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 제목
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '활동 제목',
                  hintText: '예: 아침 식사, 운동, 독서 등',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // 설명
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '설명 (선택사항)',
                  hintText: '활동에 대한 간단한 설명',
                ),
                maxLines: 2,
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // 시작 시간
              ListTile(
                title: const Text('시작 시간'),
                subtitle: Text(_formatTime(_startTime)),
                trailing: const Icon(Icons.access_time),
                onTap: _selectTime,
                contentPadding: EdgeInsets.zero,
              ),
              
              // 소요 시간
              ListTile(
                title: const Text('소요 시간'),
                subtitle: Text('${_durationMinutes}분'),
                trailing: const Icon(Icons.schedule),
                onTap: _selectDuration,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: const Text('저장'),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  void _selectDuration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('소요 시간 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int minutes in [15, 30, 45, 60, 90, 120])
              ListTile(
                title: Text('${minutes}분'),
                leading: Radio<int>(
                  value: minutes,
                  groupValue: _durationMinutes,
                  onChanged: (value) {
                    setState(() => _durationMinutes = value!);
                    Navigator.of(context).pop();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _saveItem() {
    if (!_formKey.currentState!.validate()) return;

    final item = RoutineItem(
      id: widget.initialItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _startTime,
      duration: Duration(minutes: _durationMinutes),
      isCompleted: widget.initialItem?.isCompleted ?? false,
    );

    widget.onSave(item);
    Navigator.of(context).pop();
  }
}