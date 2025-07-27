import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../theme/app_theme.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/entities/user_usage.dart';
import '../../../domain/entities/routine_concept.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../domain/services/routine_limit_service.dart';
import '../../../core/constants/routine_limits.dart';
import '../../../di/service_locator.dart';
import '../../widgets/usage/usage_indicator.dart';
import '../../providers/auth_provider.dart';
import '../../../core/config/app_router.dart';
import 'package:flutter/foundation.dart';

/// 프로필 화면 - 사용자 정보 표시 및 수정
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final RoutineRepository _routineRepository = getIt<RoutineRepository>();
  final UsageRepository _usageRepository = getIt<UsageRepository>();
  
  UserProfile? _userProfile;
  UserUsage? _userUsage;
  int _totalRoutines = 0;
  int _favoriteRoutines = 0;
  bool _isLoading = true;
  bool _isEditing = false;
  
  // 편집용 컨트롤러들
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _jobController = TextEditingController();
  final _hobbiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _jobController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() => _isLoading = true);
      
      // 사용자 프로필 로드
      final profile = await _routineRepository.getUserProfile();
      final usage = await _usageRepository.getCurrentUsage();
      
      // 루틴 통계 로드
      final allRoutines = await _routineRepository.getSavedRoutines();
      final favoriteRoutines = await _routineRepository.getFavoriteRoutines();
      
      setState(() {
        _userProfile = profile;
        _userUsage = usage;
        _totalRoutines = allRoutines.length;
        _favoriteRoutines = favoriteRoutines.length;
        _isLoading = false;
      });
      
      // 편집 컨트롤러 초기화
      if (profile != null) {
        _nameController.text = profile.name;
        _ageController.text = profile.age.toString();
        _jobController.text = profile.job;
        _hobbiesController.text = profile.hobbies.join(', ');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ToastUtils.showWithIcon(
          message: '프로필 로드 실패',
          icon: Icons.error_outline,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    try {
      final name = _nameController.text.trim();
      final ageText = _ageController.text.trim();
      final job = _jobController.text.trim();
      final hobbiesText = _hobbiesController.text.trim();

      if (name.isEmpty || ageText.isEmpty || job.isEmpty) {
        ToastUtils.showWarning('이름, 나이, 직업은 필수 입력 항목입니다');
        return;
      }

      final age = int.tryParse(ageText);
      if (age == null || age < 1 || age > 120) {
        ToastUtils.showWarning('올바른 나이를 입력해주세요 (1-120)');
        return;
      }

      final hobbies = hobbiesText.isEmpty 
          ? <String>[]
          : hobbiesText.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final updatedProfile = UserProfile(
        name: name,
        age: age,
        job: job,
        hobbies: hobbies,
        concept: _userProfile?.concept ?? RoutineConcept.workLifeBalance,
        additionalInfo: _userProfile?.additionalInfo ?? '',
        createdAt: _userProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _routineRepository.saveUserProfile(updatedProfile);
      
      setState(() {
        _userProfile = updatedProfile;
        _isEditing = false;
      });

      ToastUtils.showSuccess('프로필이 저장되었습니다');
    } catch (e) {
      ToastUtils.showWithIcon(
        message: '프로필 저장 실패: $e',
        icon: Icons.error_outline,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _handleLogout() async {
    try {
      // 로그아웃 확인 대화상자
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말로 로그아웃하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('로그아웃'),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        debugPrint('👋 로그아웃 시도 중...');
        final authController = ref.read(authControllerProvider.notifier);
        await authController.signOut();
        
        if (mounted) {
          debugPrint('✅ 로그아웃 성공 - 로그인 화면으로 이동');
          context.router.navigate(const LoginRoute());
          // 화면 전환 자체가 충분한 피드백이므로 토스트 불필요
        }
      }
    } catch (e) {
      debugPrint('❌ 로그아웃 실패: $e');
      if (mounted) {
        ToastUtils.showWithIcon(
          message: '로그아웃 실패: $e',
          icon: Icons.error_outline,
          backgroundColor: AppTheme.errorColor,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('프로필'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // 기본 뒤로 가기 버튼 비활성화
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: '홈으로',
          onPressed: () {
            // BottomNavigationBar를 사용하여 홈 탭으로 이동
            final tabsRouter = context.router.parent<TabsRouter>();
            if (tabsRouter != null) {
              tabsRouter.setActiveIndex(0); // 홈 탭으로 이동
            }
          },
        ),
        actions: [
          if (_userProfile != null)
            IconButton(
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
            ),
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  // 프로필 헤더
                  _buildProfileHeader(),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // 사용량 정보
                  _buildUsageSection(),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // 프리미엄 정보
                  _buildPremiumSection(),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // 통계 정보
                  _buildStatsSection(),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // 개인 정보
                  _buildPersonalInfoSection(),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // 앱 정보
                  _buildAppInfoSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradientDecoration,
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          // 프로필 아바타
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // 사용자 이름
          Text(
            _userProfile?.name ?? '익명 사용자',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          // 기본 정보
          if (_userProfile != null) ...[
            Text(
              '${_userProfile!.age}세 • ${_userProfile!.job}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            
            if (_userProfile!.hobbies.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingS),
              Text(
                '관심사: ${_userProfile!.hobbies.join(', ')}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // 프로필 헤더에 로그아웃 버튼 추가
            const SizedBox(height: AppTheme.spacingM),
            Container(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout, color: Colors.white, size: 18),
                label: const Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingS,
                    horizontal: AppTheme.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.mediumRadius,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsageSection() {
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
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '사용량 정보',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          const UsageIndicator(showDetails: true),
          
          if (_userUsage != null) ...[
            const SizedBox(height: AppTheme.spacingM),
            const Divider(),
            const SizedBox(height: AppTheme.spacingM),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildUsageStatItem(
                  '오늘 생성',
                  '${_userUsage!.dailyGenerations}',
                  Icons.today,
                ),
                _buildUsageStatItem(
                  '이번 달',
                  '${_userUsage!.monthlyGenerations}',
                  Icons.calendar_month,
                ),
                _buildUsageStatItem(
                  '보너스',
                  '${_userUsage!.bonusGenerations}',
                  Icons.stars,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsageStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
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
            children: [
              Icon(
                Icons.bar_chart,
                color: AppTheme.accentColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '루틴 통계',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '전체 루틴',
                  '$_totalRoutines',
                  Icons.event_note,
                  AppTheme.primaryColor,
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingM),
              
              Expanded(
                child: _buildStatCard(
                  '즐겨찾기',
                  '$_favoriteRoutines',
                  Icons.favorite,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppTheme.mediumRadius,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
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
            children: [
              Icon(
                Icons.person_outline,
                color: AppTheme.accentColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '개인 정보',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          if (_isEditing) ...[
            _buildEditField('이름', _nameController, TextInputType.text),
            const SizedBox(height: AppTheme.spacingM),
            _buildEditField('나이', _ageController, TextInputType.number),
            const SizedBox(height: AppTheme.spacingM),
            _buildEditField('직업', _jobController, TextInputType.text),
            const SizedBox(height: AppTheme.spacingM),
            _buildEditField('관심사 (쉼표로 구분)', _hobbiesController, TextInputType.text),
            
            const SizedBox(height: AppTheme.spacingL),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _isEditing = false);
                      // 원래 값으로 되돌리기
                      if (_userProfile != null) {
                        _nameController.text = _userProfile!.name;
                        _ageController.text = _userProfile!.age.toString();
                        _jobController.text = _userProfile!.job;
                        _hobbiesController.text = _userProfile!.hobbies.join(', ');
                      }
                    },
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ] else ...[
            if (_userProfile != null) ...[
              _buildInfoRow('이름', _userProfile!.name),
              _buildInfoRow('나이', '${_userProfile!.age}세'),
              _buildInfoRow('직업', _userProfile!.job),
              _buildInfoRow('선호 컨셉', _userProfile!.concept.displayName),
              if (_userProfile!.hobbies.isNotEmpty)
                _buildInfoRow('관심사', _userProfile!.hobbies.join(', ')),
              if (_userProfile!.createdAt != null)
                _buildInfoRow('가입일', _formatDate(_userProfile!.createdAt!)),
            ] else ...[
              const Text('프로필 정보가 없습니다.'),
              const SizedBox(height: AppTheme.spacingM),
              ElevatedButton(
                onPressed: () => setState(() => _isEditing = true),
                child: const Text('프로필 설정하기'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.number 
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: AppTheme.mediumRadius,
        ),
        filled: true,
        fillColor: AppTheme.backgroundColor,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
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
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.textSecondaryColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '앱 정보',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          _buildInfoRow('앱 버전', '2.1.0'),
          _buildInfoRow('개발자', 'RoutineCraft Team'),
          _buildInfoRow('문의', 'support@routinecraft.app'),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // 로그아웃 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 프리미엄 섹션
  Widget _buildPremiumSection() {
    return FutureBuilder<UserTier>(
      future: RoutineLimitService.getUserTier(),
      builder: (context, snapshot) {
        final userTier = snapshot.data ?? UserTier.free;
        final isPremium = userTier == UserTier.premium;
        
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            gradient: isPremium 
                ? LinearGradient(
                    colors: [Colors.amber.shade100, Colors.orange.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isPremium ? null : AppTheme.surfaceColor,
            borderRadius: AppTheme.mediumRadius,
            boxShadow: [AppTheme.cardShadow],
            border: isPremium 
                ? Border.all(color: Colors.amber.shade300, width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isPremium ? Icons.workspace_premium : Icons.upgrade,
                    color: isPremium ? Colors.amber.shade700 : AppTheme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    isPremium ? '프리미엄 사용자' : '무료 사용자',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPremium ? Colors.amber.shade700 : null,
                    ),
                  ),
                  if (isPremium) ...[
                    const SizedBox(width: AppTheme.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              if (isPremium) ...[
                Text(
                  '프리미엄 혜택을 모두 이용하고 계십니다!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildFeatureChip('무제한 루틴 생성', Colors.green),
                    _buildFeatureChip('무제한 루틴 활성화', Colors.blue),
                    _buildFeatureChip('루틴당 10개 활동', Colors.purple),
                    _buildFeatureChip('무제한 AI 생성', Colors.orange),
                    _buildFeatureChip('고급 통계', Colors.teal),
                    _buildFeatureChip('백업 & 복원', Colors.indigo),
                  ],
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 제한사항:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLimitationItem('루틴 저장', '2개'),
                    _buildLimitationItem('루틴 활성화', '1개'),
                    _buildLimitationItem('루틴당 활동', '5개'),
                    _buildLimitationItem('AI 루틴 생성', '1일 1회'),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showPremiumUpgradeDialog,
                        icon: const Icon(Icons.workspace_premium),
                        label: const Text('프리미엄으로 업그레이드'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.mediumRadius,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFeatureChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildLimitationItem(String title, String limit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Icons.radio_button_unchecked,
            size: 16,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            limit,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showPremiumUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber),
            SizedBox(width: 8),
            Text('프리미엄 업그레이드'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '프리미엄 업그레이드 시 모든 제한이 해제됩니다:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Text('✨ 무제한 루틴 생성 및 저장'),
            Text('✨ 무제한 루틴 활성화'),
            Text('✨ 루틴당 최대 10개 활동'),
            Text('✨ 무제한 AI 루틴 생성'),
            Text('✨ 고급 통계 및 분석 기능'),
            Text('✨ 클라우드 백업 및 복원'),
            Text('✨ 루틴 공유 및 템플릿'),
            Text('✨ 프리미엄 테마'),
            SizedBox(height: 16),
            Text(
              '💡 현재는 개발 단계로 무료로 모든 기능을 이용하실 수 있습니다!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ToastUtils.showWithIcon(
                message: '🚧 프리미엄 기능은 곧 출시될 예정입니다!',
                icon: Icons.construction,
                backgroundColor: AppTheme.primaryColor,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('업그레이드 알림 받기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
