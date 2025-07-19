import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/config/app_router.dart';
import '../../theme/app_theme.dart';

/// 루틴 앱의 사용자 친화적인 로그인 화면
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutQuart,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // 개발용: 검증 없이 바로 진행
    setState(() => _isLoading = true);

    try {
      // 개발용: 짧은 딜레이
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // 사용자 입력 화면으로 이동
        context.router.navigate(const UserInputRoute());
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('루틴 생성을 시작합니다! ✨'),
            backgroundColor: AppTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.mediumRadius,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.mediumRadius,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    // TODO: Google 로그인 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google 로그인 준비 중입니다')),
    );
  }

  Future<void> _handleAppleLogin() async {
    // TODO: Apple 로그인 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple 로그인 준비 중입니다')),
    );
  }

  void _handleSkip() {
    // 건너뛰기 - 루틴 생성 시작
    context.router.navigate(const UserInputRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _slideController,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppTheme.spacingXXL),
                    
                    // 환영 메시지 영역
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradientDecoration,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [AppTheme.cardShadow],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        Text(
                          '환영해요!',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: AppTheme.spacingS),
                        
                        Text(
                          '당신만의 루틴을 생성해볼까요?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXXL),
                    
                    // 이메일 입력
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: '이메일',
                        hintText: 'your@email.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일을 입력해주세요';
                        }
                        if (!value.contains('@')) {
                          return '올바른 이메일 형식을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // 비밀번호 입력
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        hintText: '6자 이상 입력해주세요',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        if (value.length < 6) {
                          return '비밀번호는 6자 이상이어야 합니다';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXL),
                    
                    // 로그인 버튼
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('로그인'),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // OR 구분선
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                          ),
                          child: Text(
                            '또는',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // 소셜 로그인 버튼들
                    OutlinedButton.icon(
                      onPressed: _handleGoogleLogin,
                      icon: const Icon(Icons.g_mobiledata, size: 24),
                      label: const Text('Google로 계속하기'),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    OutlinedButton.icon(
                      onPressed: _handleAppleLogin,
                      icon: const Icon(Icons.apple, size: 20),
                      label: const Text('Apple로 계속하기'),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXL),
                    
                    // 하단 버튼들
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: 회원가입 화면으로 이동
                            context.router.navigate(const RegisterRoute());
                          },
                          child: const Text('회원가입'),
                        ),
                        
                        Container(
                          width: 1,
                          height: 16,
                          color: AppTheme.dividerColor,
                        ),
                        
                        TextButton(
                          onPressed: _handleSkip,
                          child: Text(
                            '건너뛰기',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // 비밀번호 찾기
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: 비밀번호 찾기 화면으로 이동
                        },
                        child: Text(
                          '비밀번호를 잊으셨나요?',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
