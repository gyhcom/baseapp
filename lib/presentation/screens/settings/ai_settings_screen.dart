import 'package:flutter/material.dart';
import '../../../domain/repositories/ai_service_repository.dart';
import '../../theme/app_theme.dart';
import '../../../core/config/ai_config.dart';
import '../../../core/di/ai_service_provider.dart';

/// AI 서비스 설정 화면 (개발자용)
class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('AI 서비스 설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 서비스 상태
            _buildCurrentServiceCard(),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // 사용 가능한 서비스들
            Text(
              '사용 가능한 AI 서비스',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            ...AIConfig.supportedServices.map(_buildServiceTile),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // 서비스 상태 정보
            _buildServiceStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentServiceCard() {
    final config = AIConfig.config;
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradientDecoration,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '현재 AI 서비스',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          Text(
            config.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Text(
            config.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          Row(
            children: [
              _buildStatusChip(
                AIConfig.isDummyMode ? '개발 모드' : '실제 API',
                AIConfig.isDummyMode ? Colors.orange : Colors.green,
              ),
              const SizedBox(width: AppTheme.spacingS),
              _buildStatusChip(
                '최대 ${config.maxTokens} 토큰',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildServiceTile(AIServiceType type) {
    final isCurrentService = AIConfig.currentService == type;
    final canSwitch = AIServiceProvider.canSwitchTo(type);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCurrentService 
              ? AppTheme.primaryColor 
              : AppTheme.dividerColor,
          child: Icon(
            _getServiceIcon(type),
            color: isCurrentService ? Colors.white : AppTheme.textSecondaryColor,
          ),
        ),
        title: Text(
          type.displayName,
          style: TextStyle(
            fontWeight: isCurrentService ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(_getServiceSubtitle(type)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCurrentService)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '사용 중',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            if (!canSwitch && !isCurrentService)
              Icon(
                Icons.lock,
                color: AppTheme.textSecondaryColor,
                size: 20,
              ),
          ],
        ),
        tileColor: isCurrentService 
            ? AppTheme.primaryColor.withValues(alpha: 0.1) 
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.mediumRadius,
          side: BorderSide(
            color: isCurrentService 
                ? AppTheme.primaryColor 
                : AppTheme.dividerColor,
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon(AIServiceType type) {
    switch (type) {
      case AIServiceType.dummy:
        return Icons.code;
      case AIServiceType.claude:
        return Icons.smart_toy;
      case AIServiceType.openai:
        return Icons.psychology;
      case AIServiceType.local:
        return Icons.storage;
      case AIServiceType.gemini:
        return Icons.auto_awesome;
    }
  }

  String _getServiceSubtitle(AIServiceType type) {
    switch (type) {
      case AIServiceType.dummy:
        return '개발/테스트용 더미 데이터 (무료)';
      case AIServiceType.claude:
        return 'Anthropic Claude API (API 키 필요)';
      case AIServiceType.openai:
        return 'OpenAI ChatGPT API (준비 중)';
      case AIServiceType.local:
        return '로컬 규칙 기반 서비스 (무료)';
      case AIServiceType.gemini:
        return 'Google Gemini API (준비 중)';
    }
  }

  Widget _buildServiceStatusCard() {
    final status = AIServiceProvider.getServiceStatus();
    
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
            '서비스 상태 정보',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          ...status.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getStatusLabel(entry.key),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    entry.value.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getStatusLabel(String key) {
    switch (key) {
      case 'service_type':
        return '서비스 타입';
      case 'service_name':
        return '서비스 이름';
      case 'is_dummy':
        return '더미 모드';
      case 'requires_api_key':
        return 'API 키 필요';
      case 'is_available':
        return '사용 가능';
      case 'max_tokens':
        return '최대 토큰';
      case 'average_response_time_seconds':
        return '평균 응답시간 (초)';
      default:
        return key;
    }
  }
}