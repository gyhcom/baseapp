import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 기본 단계 레이아웃
class StepLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onNext;
  final String nextButtonText;
  final IconData? stepIcon;

  const StepLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.onNext,
    this.nextButtonText = '다음',
    this.stepIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppTheme.spacingXL),
          
          // 단계 아이콘
          if (stepIcon != null) ...[
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradientDecoration,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [AppTheme.cardShadow],
                ),
                child: Icon(
                  stepIcon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],
          
          // 제목
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          // 부제목
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacingXXL),
          
          // 입력 영역
          Expanded(child: child),
          
          // 다음 버튼
          if (onNext != null) ...[
            const SizedBox(height: AppTheme.spacingL),
            ElevatedButton(
              onPressed: onNext,
              child: Text(nextButtonText),
            ),
          ],
          
          const SizedBox(height: AppTheme.spacingL),
        ],
      ),
    );
  }
}

/// 1단계: 이름 입력
class UserInputStep1 extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback? onNext;

  const UserInputStep1({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<UserInputStep1> createState() => _UserInputStep1State();
}

class _UserInputStep1State extends State<UserInputStep1>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StepLayout(
      title: '안녕하세요! 👋',
      subtitle: '먼저 이름을 알려주세요',
      stepIcon: Icons.person_outline,
      onNext: widget.onNext,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: '이름',
              hintText: '홍길동',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
            onFieldSubmitted: (_) => widget.onNext?.call(),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          Text(
            '닉네임이나 원하는 이름을 입력해주세요',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 2단계: 나이 입력
class UserInputStep2 extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final VoidCallback onNext;

  const UserInputStep2({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onNext,
  });

  @override
  State<UserInputStep2> createState() => _UserInputStep2State();
}

class _UserInputStep2State extends State<UserInputStep2>
    with AutomaticKeepAliveClientMixin {
  late int _selectedAge;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedAge = widget.initialValue;
  }

  void _updateAge(int age) {
    setState(() {
      _selectedAge = age;
    });
    widget.onChanged(age);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StepLayout(
      title: '나이를 선택해주세요 🎂',
      subtitle: '연령대에 맞는 루틴을 추천해드릴게요',
      stepIcon: Icons.cake_outlined,
      onNext: widget.onNext,
      child: Column(
        children: [
          // 슬라이더
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  Text(
                    '$_selectedAge세',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  Slider(
                    value: _selectedAge.toDouble(),
                    min: 10,
                    max: 80,
                    divisions: 70,
                    onChanged: (value) => _updateAge(value.round()),
                  ),
                  
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('10세', style: TextStyle(fontSize: 12)),
                      Text('80세', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // 연령대 안내
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: AppTheme.mediumRadius,
            ),
            child: Text(
              _getAgeGroupText(_selectedAge),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getAgeGroupText(int age) {
    if (age < 20) return '10대 - 활기차고 에너지 넘치는 루틴';
    if (age < 30) return '20대 - 성장과 도전의 루틴';
    if (age < 40) return '30대 - 균형과 안정의 루틴';
    if (age < 50) return '40대 - 성숙하고 지혜로운 루틴';
    if (age < 60) return '50대 - 여유롭고 건강한 루틴';
    return '60대+ - 편안하고 의미있는 루틴';
  }
}

/// 3단계: 직업 입력
class UserInputStep3 extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback? onNext;

  const UserInputStep3({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<UserInputStep3> createState() => _UserInputStep3State();
}

class _UserInputStep3State extends State<UserInputStep3>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;
  final List<String> _commonJobs = [
    '학생', '회사원', '개발자', '디자이너', '마케터', '교사', '의료진',
    '프리랜서', '자영업자', '주부', '취업준비생', '기타'
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectJob(String job) {
    if (job == '기타') {
      _controller.clear();
    } else {
      _controller.text = job;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StepLayout(
      title: '직업이 궁금해요 💼',
      subtitle: '직업에 맞는 스케줄을 고려해드릴게요',
      stepIcon: Icons.work_outline,
      onNext: widget.onNext,
      child: Column(
        children: [
          // 직접 입력
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: '직업',
              hintText: '개발자',
              prefixIcon: Icon(Icons.business_center_outlined),
            ),
            onFieldSubmitted: (_) => widget.onNext?.call(),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // 일반적인 직업 선택
          Text(
            '또는 아래에서 선택하세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: AppTheme.spacingS,
                mainAxisSpacing: AppTheme.spacingS,
              ),
              itemCount: _commonJobs.length,
              itemBuilder: (context, index) {
                final job = _commonJobs[index];
                final isSelected = _controller.text == job;
                
                return InkWell(
                  onTap: () => _selectJob(job),
                  borderRadius: AppTheme.smallRadius,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : AppTheme.surfaceColor,
                      borderRadius: AppTheme.smallRadius,
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.primaryColor 
                            : AppTheme.dividerColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        job,
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white 
                              : AppTheme.textPrimaryColor,
                          fontSize: 12,
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 4단계: 취미 입력
class UserInputStep4 extends StatefulWidget {
  final List<String> initialValue;
  final ValueChanged<List<String>> onChanged;
  final VoidCallback? onNext;

  const UserInputStep4({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<UserInputStep4> createState() => _UserInputStep4State();
}

class _UserInputStep4State extends State<UserInputStep4>
    with AutomaticKeepAliveClientMixin {
  late List<String> _selectedHobbies;
  final TextEditingController _customHobbyController = TextEditingController();
  
  final List<String> _commonHobbies = [
    '독서', '운동', '영화감상', '음악감상', '요리', '여행', '게임',
    '사진촬영', '그림그리기', '글쓰기', '명상', '요가', '등산',
    '수영', '자전거', '춤', '악기연주', '원예', '반려동물', '쇼핑'
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedHobbies = List.from(widget.initialValue);
  }

  @override
  void dispose() {
    _customHobbyController.dispose();
    super.dispose();
  }

  void _toggleHobby(String hobby) {
    setState(() {
      if (_selectedHobbies.contains(hobby)) {
        _selectedHobbies.remove(hobby);
      } else {
        if (_selectedHobbies.length < 5) { // 최대 5개 제한
          _selectedHobbies.add(hobby);
        }
      }
    });
    widget.onChanged(_selectedHobbies);
  }

  void _addCustomHobby() {
    final customHobby = _customHobbyController.text.trim();
    if (customHobby.isNotEmpty && !_selectedHobbies.contains(customHobby)) {
      if (_selectedHobbies.length < 5) {
        setState(() {
          _selectedHobbies.add(customHobby);
        });
        widget.onChanged(_selectedHobbies);
        _customHobbyController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StepLayout(
      title: '취미를 알려주세요 🎨',
      subtitle: '관심사에 맞는 활동을 추천해드릴게요 (선택사항)',
      stepIcon: Icons.favorite_outline,
      onNext: widget.onNext,
      child: Column(
        children: [
          // 선택된 취미 표시
          if (_selectedHobbies.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: AppTheme.mediumRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선택된 취미 (${_selectedHobbies.length}/5)',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Wrap(
                    spacing: AppTheme.spacingS,
                    children: _selectedHobbies.map((hobby) {
                      return Chip(
                        label: Text(hobby),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => _toggleHobby(hobby),
                        backgroundColor: AppTheme.primaryColor,
                        labelStyle: const TextStyle(color: Colors.white),
                        deleteIconColor: Colors.white,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],
          
          // 일반적인 취미 선택
          Text(
            '관심있는 활동을 선택해주세요 (최대 5개, 선택하지 않아도 괜찮아요)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: AppTheme.spacingS,
                mainAxisSpacing: AppTheme.spacingS,
              ),
              itemCount: _commonHobbies.length,
              itemBuilder: (context, index) {
                final hobby = _commonHobbies[index];
                final isSelected = _selectedHobbies.contains(hobby);
                final isDisabled = !isSelected && _selectedHobbies.length >= 5;
                
                return InkWell(
                  onTap: isDisabled ? null : () => _toggleHobby(hobby),
                  borderRadius: AppTheme.smallRadius,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : isDisabled 
                              ? AppTheme.dividerColor.withOpacity(0.3)
                              : AppTheme.surfaceColor,
                      borderRadius: AppTheme.smallRadius,
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.primaryColor 
                            : AppTheme.dividerColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        hobby,
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white 
                              : isDisabled
                                  ? AppTheme.textSecondaryColor.withOpacity(0.5)
                                  : AppTheme.textPrimaryColor,
                          fontSize: 12,
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 직접 추가
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _customHobbyController,
                  decoration: const InputDecoration(
                    labelText: '직접 추가',
                    hintText: '다른 취미가 있다면 입력해주세요',
                    prefixIcon: Icon(Icons.add_circle_outline),
                  ),
                  onFieldSubmitted: (_) => _addCustomHobby(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              IconButton(
                onPressed: _addCustomHobby,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 5단계: 추가 정보 (선택사항)
class UserInputStep5 extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onComplete;

  const UserInputStep5({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.onComplete,
  });

  @override
  State<UserInputStep5> createState() => _UserInputStep5State();
}

class _UserInputStep5State extends State<UserInputStep5>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StepLayout(
      title: '마지막으로... ✨',
      subtitle: '특별히 고려해야 할 사항이 있나요?',
      stepIcon: Icons.edit_note_outlined,
      onNext: widget.onComplete,
      nextButtonText: '루틴 생성하기',
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: '추가 정보 (선택사항)',
              hintText: '예: 새벽에 일어나기 어려워요, 저녁에 시간이 많아요',
              prefixIcon: Icon(Icons.info_outline),
            ),
            maxLines: 3,
            maxLength: 200,
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: AppTheme.mediumRadius,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  '준비 완료!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'AI가 당신만의 특별한 루틴을 생성합니다',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}