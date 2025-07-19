import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/config/app_router.dart';
import '../../theme/app_theme.dart';

/// 루틴 생성 앱의 감성적인 스플래시 화면
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _dotController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _dotAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // 페이드 애니메이션
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // 스케일 애니메이션
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // 점 로딩 애니메이션
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _dotAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotController,
      curve: Curves.easeInOut,
    ));

    // 애니메이션 시작
    _fadeController.forward();
    _scaleController.forward();
    _dotController.repeat();
  }

  Future<void> _initializeApp() async {
    print('🌟 루틴 앱 초기화 시작...');

    // 앱 초기화 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));
    print('✅ 루틴 앱 초기화 완료');

    // 로그인 화면으로 이동
    if (mounted) {
      print('📱 로그인 화면으로 이동...');
      try {
        context.router.navigate(const LoginRoute());
        print('✅ 로그인 화면 이동 성공');
      } catch (e) {
        print('❌ 화면 이동 실패: $e');
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradientDecoration,
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 메인 로고 영역
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacingXL),
                      
                      // 앱 이름
                      const Text(
                        'RoutineCraft',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacingS),
                      
                      // 서브 타이틀
                      Text(
                        '당신만의 루틴을 시작해보세요',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacingXXL),
                      
                      // 로딩 점 애니메이션
                      AnimatedBuilder(
                        animation: _dotAnimation,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: AnimatedContainer(
                                  duration: Duration(
                                    milliseconds: 300 + (index * 100),
                                  ),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      0.3 + (0.7 * 
                                        ((_dotAnimation.value + index * 0.3) % 1.0).abs()),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
