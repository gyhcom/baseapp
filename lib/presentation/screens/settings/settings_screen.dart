import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_settings_screen.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../di/service_locator.dart';

/// 설정 화면
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = '한국어';
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 사용자 프로필 섹션
            _buildUserProfileSection(),
            
            const SizedBox(height: 24),
            
            // 알림 설정
            _buildNotificationSection(),
            
            const SizedBox(height: 24),
            
            // 앱 설정
            _buildAppSettingsSection(),
            
            const SizedBox(height: 24),
            
            // 계정 관리
            _buildAccountSection(),
            
            const SizedBox(height: 24),
            
            // 지원 및 정보
            _buildSupportSection(),
          ],
        ),
      ),
    );
  }

  /// 사용자 프로필 섹션
  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '프로필',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              // 프로필 이미지
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF6366F1),
                  size: 30,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '사용자님',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '프리미엄 사용자',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '활성',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 편집 버튼
              IconButton(
                onPressed: () {
                  // TODO: 프로필 편집 화면으로 이동
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 알림 설정 섹션
  Widget _buildNotificationSection() {
    return _buildSettingCard(
      title: '알림 설정',
      children: [
        _buildNavigationTile(
          title: '알림 및 리마인더',
          subtitle: '루틴 알림, 리마인더 시간 설정',
          icon: Icons.notifications_outlined,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationSettingsScreen(),
              ),
            );
          },
        ),
        
        _buildSwitchTile(
          title: '소리',
          subtitle: '알림음 재생',
          value: _soundEnabled,
          onChanged: (value) {
            setState(() {
              _soundEnabled = value;
            });
          },
          icon: Icons.volume_up_outlined,
        ),
        
        _buildSwitchTile(
          title: '진동',
          subtitle: '알림 시 진동',
          value: _vibrationEnabled,
          onChanged: (value) {
            setState(() {
              _vibrationEnabled = value;
            });
          },
          icon: Icons.vibration,
        ),
      ],
    );
  }

  /// 앱 설정 섹션
  Widget _buildAppSettingsSection() {
    return _buildSettingCard(
      title: '앱 설정',
      children: [
        _buildSwitchTile(
          title: '다크 모드',
          subtitle: '어두운 테마 사용',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
          icon: Icons.dark_mode_outlined,
        ),
        
        _buildNavigationTile(
          title: '언어',
          subtitle: _selectedLanguage,
          icon: Icons.language_outlined,
          onTap: () {
            _showLanguageSelector();
          },
        ),
        
        _buildNavigationTile(
          title: '데이터 및 저장소',
          subtitle: '캐시, 백업 관리',
          icon: Icons.storage_outlined,
          onTap: () {
            // TODO: 데이터 관리 화면으로 이동
          },
        ),
      ],
    );
  }

  /// 계정 관리 섹션
  Widget _buildAccountSection() {
    return _buildSettingCard(
      title: '계정 관리',
      children: [
        _buildNavigationTile(
          title: '프리미엄 구독',
          subtitle: '구독 상태 및 관리',
          icon: Icons.star_outline,
          onTap: () {
            // TODO: 프리미엄 관리 화면으로 이동
          },
        ),
        
        _buildNavigationTile(
          title: '사용량 통계',
          subtitle: 'AI 생성 및 저장 현황',
          icon: Icons.analytics_outlined,
          onTap: () {
            _showUsageStatistics();
          },
        ),
        
        _buildNavigationTile(
          title: '데이터 백업',
          subtitle: '클라우드 백업 및 복원',
          icon: Icons.backup_outlined,
          onTap: () {
            // TODO: 백업 화면으로 이동
          },
        ),
        
        _buildNavigationTile(
          title: '계정 삭제',
          subtitle: '모든 데이터 삭제',
          icon: Icons.delete_outline,
          color: Colors.red,
          onTap: () {
            _showDeleteAccountDialog();
          },
        ),
      ],
    );
  }

  /// 지원 및 정보 섹션
  Widget _buildSupportSection() {
    return _buildSettingCard(
      title: '지원 및 정보',
      children: [
        _buildNavigationTile(
          title: '도움말',
          subtitle: '사용법 및 FAQ',
          icon: Icons.help_outline,
          onTap: () {
            // TODO: 도움말 화면으로 이동
          },
        ),
        
        _buildNavigationTile(
          title: '의견 보내기',
          subtitle: '앱 개선을 위한 피드백',
          icon: Icons.feedback_outlined,
          onTap: () {
            // TODO: 피드백 화면으로 이동
          },
        ),
        
        _buildNavigationTile(
          title: '개인정보 처리방침',
          subtitle: '데이터 사용 및 보호 정책',
          icon: Icons.privacy_tip_outlined,
          onTap: () {
            // TODO: 개인정보 처리방침 화면으로 이동
          },
        ),
        
        _buildNavigationTile(
          title: '서비스 이용약관',
          subtitle: '앱 사용 약관',
          icon: Icons.description_outlined,
          onTap: () {
            // TODO: 이용약관 화면으로 이동
          },
        ),
        
        _buildNavigationTile(
          title: '앱 정보',
          subtitle: '버전 1.0.0',
          icon: Icons.info_outline,
          onTap: () {
            _showAppInfo();
          },
        ),
      ],
    );
  }

  /// 설정 카드 빌더
  Widget _buildSettingCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...children,
        ],
      ),
    );
  }

  /// 스위치 타일 빌더
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 20,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  /// 네비게이션 타일 빌더
  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    final tileColor = color ?? const Color(0xFF6366F1);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tileColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: tileColor,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color ?? const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF64748B),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 언어 선택 다이얼로그
  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('한국어', '한국어'),
            _buildLanguageOption('English', 'English'),
            _buildLanguageOption('日本語', '日本語'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, String display) {
    return ListTile(
      title: Text(display),
      trailing: _selectedLanguage == language
          ? const Icon(Icons.check, color: Color(0xFF6366F1))
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  /// 사용량 통계 다이얼로그
  void _showUsageStatistics() async {
    final usageRepository = getIt<UsageRepository>();
    final usage = await usageRepository.getCurrentUsage();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용량 통계'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('오늘 AI 생성: ${usage.dailyGenerations}/3'),
            const SizedBox(height: 8),
            Text('보너스 생성: ${usage.bonusGenerations}'),
            const SizedBox(height: 8),
            Text('저장된 루틴: ?/5'), // TODO: 루틴 개수 조회
            const SizedBox(height: 16),
            Text('최근 활동: ${usage.date.year}년 ${usage.date.month}월 ${usage.date.day}일'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 계정 삭제 확인 다이얼로그
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('계정 삭제'),
          ],
        ),
        content: const Text(
          '계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.\n\n정말로 계정을 삭제하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 계정 삭제 로직
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('계정 삭제 기능 준비 중입니다')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  /// 앱 정보 다이얼로그
  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 정보'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RoutineCraft'),
            SizedBox(height: 8),
            Text('버전: 1.0.0'),
            SizedBox(height: 8),
            Text('빌드: 2024.01.01'),
            SizedBox(height: 16),
            Text('개인화된 일상 루틴을 AI로 생성하는 앱입니다.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
