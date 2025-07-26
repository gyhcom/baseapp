import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/config/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/routine/user_input_steps.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../domain/entities/user_usage.dart';
import '../../../di/service_locator.dart';
import 'package:flutter/foundation.dart';

/// 단계별 사용자 정보 입력 화면
class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  
  int _currentStep = 0;
  final int _totalSteps = 5;
  
  // 사용자 입력 데이터
  String _name = '';
  int _age = 25;
  String _job = '';
  List<String> _hobbies = [];
  String _additionalInfo = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
      );
      _updateProgress();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
      );
      _updateProgress();
    }
  }

  void _updateProgress() {
    final progress = (_currentStep + 1) / _totalSteps;
    _progressController.animateTo(progress);
  }

  Future<void> _completeInput() async {
    // 사용량 체크
    final usageRepository = getIt<UsageRepository>();
    final canGenerate = await usageRepository.canGenerate();

    if (!canGenerate && mounted) {
      _showUsageLimitDialog();
      return;
    }

    // 컨셉 선택 화면으로 이동
    debugPrint('사용자 입력 완료:');
    debugPrint('이름: $_name, 나이: $_age, 직업: $_job');
    debugPrint('취미: $_hobbies, 추가정보: $_additionalInfo');
    
    // 컨셉 선택 화면으로 이동하면서 데이터 전달
    context.router.navigate(ConceptSelectionRoute(
      name: _name,
      age: _age,
      job: _job,
      hobbies: _hobbies,
      additionalInfo: _additionalInfo,
    ));
  }

  void _showUsageLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일일 생성 횟수 초과'),
        content: const Text('오늘 AI 루틴 생성 횟수를 모두 사용했습니다.\n내일 다시 시도해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          '${_currentStep + 1}단계 / $_totalSteps단계', 
          style: TextStyle(
            fontSize: 16, 
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: _currentStep > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppTheme.textPrimaryColor),
                onPressed: _previousStep,
              )
            : IconButton(
                icon: Icon(Icons.close, color: AppTheme.textPrimaryColor),
                onPressed: () => context.router.maybePop(),
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined, color: AppTheme.textPrimaryColor),
            tooltip: '홈으로',
            onPressed: () async {
              // 여러 방법으로 시도
              try {
                // 방법 1: AutoRoute pushAndPopUntil
                await context.router.pushAndPopUntil(
                  const HomeWrapperRoute(),
                  predicate: (route) => false,
                );
              } catch (e) {
                try {
                  // 방법 2: 네이티브 Navigator
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                } catch (e2) {
                  // 방법 3: 마지막 수단
                  context.router.popUntilRoot();
                  context.router.push(const HomeWrapperRoute());
                }
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: AppTheme.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                  minHeight: 3,
                );
              },
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
        children: [
          // 1단계: 이름 입력
          UserInputStep1(
            initialValue: _name,
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
            onNext: _name.isNotEmpty ? _nextStep : null,
          ),
          
          // 2단계: 나이 입력
          UserInputStep2(
            initialValue: _age,
            onChanged: (value) {
              setState(() {
                _age = value;
              });
            },
            onNext: _nextStep,
          ),
          
          // 3단계: 직업 입력
          UserInputStep3(
            initialValue: _job,
            onChanged: (value) {
              setState(() {
                _job = value;
              });
            },
            onNext: _job.isNotEmpty ? _nextStep : null,
          ),
          
          // 4단계: 취미 입력
          UserInputStep4(
            initialValue: _hobbies,
            onChanged: (value) {
              setState(() {
                _hobbies = value;
              });
            },
            onNext: _nextStep, // 취미 선택 없이도 다음으로 진행 가능
          ),
          
          // 5단계: 추가 정보 (선택사항)
          UserInputStep5(
            initialValue: _additionalInfo,
            onChanged: (value) {
              setState(() {
                _additionalInfo = value;
              });
            },
            onComplete: _completeInput,
          ),
        ],
      ),
    );
  }
}