import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/config/app_router.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/routine_concept.dart';

/// 루틴 컨셉 선택 화면
class ConceptSelectionScreen extends StatefulWidget {
  final String name;
  final int age;
  final String job;
  final List<String> hobbies;
  final String additionalInfo;

  const ConceptSelectionScreen({
    super.key,
    required this.name,
    required this.age,
    required this.job,
    required this.hobbies,
    required this.additionalInfo,
  });

  @override
  State<ConceptSelectionScreen> createState() => _ConceptSelectionScreenState();
}

class _ConceptSelectionScreenState extends State<ConceptSelectionScreen>
    with TickerProviderStateMixin {
  RoutineConcept? _selectedConcept;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

  void _selectConcept(RoutineConcept concept) {
    setState(() {
      _selectedConcept = concept;
    });
  }

  void _generateRoutine() {
    if (_selectedConcept == null) return;

    // 루틴 생성 화면으로 이동
    context.router.navigate(RoutineGenerationRoute(
      name: widget.name,
      age: widget.age,
      job: widget.job,
      hobbies: widget.hobbies,
      additionalInfo: widget.additionalInfo,
      conceptName: _selectedConcept!.name,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('컨셉 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
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
                      Icons.palette_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  Text(
                    '${widget.name}님에게 어울리는\n루틴 스타일을 선택해주세요',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  Text(
                    '선택한 컨셉에 맞춰 개인화된 루틴을 생성해드릴게요',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // 컨셉 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                itemCount: RoutineConcept.values.length,
                itemBuilder: (context, index) {
                  final concept = RoutineConcept.values[index];
                  final isSelected = _selectedConcept == concept;
                  
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                    child: InkWell(
                      onTap: () => _selectConcept(concept),
                      borderRadius: AppTheme.mediumRadius,
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppTheme.primaryColor 
                              : AppTheme.surfaceColor,
                          borderRadius: AppTheme.mediumRadius,
                          border: Border.all(
                            color: isSelected 
                                ? AppTheme.primaryColor 
                                : AppTheme.dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected 
                              ? [AppTheme.buttonShadow] 
                              : [AppTheme.cardShadow],
                        ),
                        child: Row(
                          children: [
                            // 컨셉 아이콘 (이모지 추출)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.white.withOpacity(0.2)
                                    : AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  concept.displayName.split(' ')[0], // 이모지 부분만
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: AppTheme.spacingM),
                            
                            // 컨셉 정보
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    concept.displayName,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: isSelected 
                                          ? Colors.white 
                                          : AppTheme.textPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: AppTheme.spacingXS),
                                  
                                  Text(
                                    concept.description,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isSelected 
                                          ? Colors.white.withOpacity(0.9)
                                          : AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: AppTheme.spacingXS),
                                  
                                  Text(
                                    concept.category,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isSelected 
                                          ? Colors.white.withOpacity(0.7)
                                          : AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // 선택 표시
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // 루틴 생성 버튼
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  if (_selectedConcept != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: AppTheme.mediumRadius,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppTheme.accentColor,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Text(
                              '${_selectedConcept!.displayName} 컨셉으로 루틴을 생성합니다',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                  ],
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedConcept != null ? _generateRoutine : null,
                      child: const Text('AI 루틴 생성하기'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}