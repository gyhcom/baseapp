import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/entities/user_usage.dart';
import '../../../domain/entities/routine_concept.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../di/service_locator.dart';
import '../../widgets/usage/usage_indicator.dart';
import '../../providers/auth_provider.dart';
import '../../../core/config/app_router.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 로드 실패: $e')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이름, 나이, 직업은 필수 입력 항목입니다')),
        );
        return;
      }

      final age = int.tryParse(ageText);
      if (age == null || age < 1 || age > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('올바른 나이를 입력해주세요 (1-120)')),
        );
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 저장되었습니다')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 저장 실패: $e')),
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
        print('👋 로그아웃 시도 중...');
        final authController = ref.read(authControllerProvider.notifier);
        await authController.signOut();
        
        if (mounted) {
          print('✅ 로그아웃 성공 - 로그인 화면으로 이동');
          context.router.navigate(const LoginRoute());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('로그아웃되었습니다'),
              backgroundColor: AppTheme.primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.mediumRadius,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ 로그아웃 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그아웃 실패: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.mediumRadius,
            ),
          ),
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
              color: Colors.white.withOpacity(0.2),
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
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            
            if (_userProfile!.hobbies.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingS),
              Text(
                '관심사: ${_userProfile!.hobbies.join(', ')}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
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
                  backgroundColor: Colors.white.withOpacity(0.1),
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
        color: color.withOpacity(0.1),
        borderRadius: AppTheme.mediumRadius,
        border: Border.all(color: color.withOpacity(0.3)),
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

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
