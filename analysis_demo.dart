import 'lib/domain/services/user_data_analyzer.dart';

/// 사용자 데이터 분석 데모
void main() {
  print('📊 사용자 루틴 패턴 분석 시작...\n');
  
  // 샘플 데이터 생성 (실제로는 사용자의 실제 로그 데이터 사용)
  final userLogs = UserDataAnalyzer.generateSampleData();
  
  print('📋 수집된 로그 데이터: ${userLogs.length}개');
  print('📅 분석 기간: 최근 3주간\n');
  
  // 데이터 분석 수행
  final analysis = UserDataAnalyzer.analyzeUserBehavior(userLogs);
  
  // 결과 출력
  _printAnalysisResult(analysis);
}

void _printAnalysisResult(AnalysisResult result) {
  print('=' * 50);
  print('✅ 루틴 분석 결과');
  print('=' * 50);
  
  print('- 가장 높은 성공률 시간: ${result.bestTime.dayName} ${result.bestTime.timeSlot} (성공률 ${result.bestTime.successRate.round()}%)');
  print('- 알림 반응 평균 시간: ${result.averageResponseMinutes}분');
  
  // 추천 알림 시간 (실제 루틴 시간보다 평균 반응시간만큼 일찍)
  final recommendedHour = result.bestTime.hour;
  final recommendedMinute = 60 - result.averageResponseMinutes;
  final adjustedMinute = recommendedMinute >= 60 ? recommendedMinute - 60 : recommendedMinute;
  final adjustedHour = recommendedMinute >= 60 ? recommendedHour : recommendedHour - 1;
  
  print('- 추천 알림 시간: ${result.bestTime.dayName} ${_formatTime(adjustedHour, adjustedMinute)}');
  
  print('\n💡 개인화된 알림 메시지 제안:');
  print('"${result.personalizedMessage}"');
  
  print('\n📈 상세 분석 데이터:');
  print('─' * 30);
  
  // 시간별 성공률 상위 3개
  final topHours = result.hourlySuccessRate.entries
      .where((e) => e.value > 0)
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  print('🕐 시간별 성공률 TOP 3:');
  for (int i = 0; i < 3 && i < topHours.length; i++) {
    final entry = topHours[i];
    print('   ${i + 1}. ${entry.key}시: ${entry.value.round()}%');
  }
  
  // 요일별 성공률
  final topDays = result.dailySuccessRate.entries
      .where((e) => e.value > 0)
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  print('\n📅 요일별 성공률 TOP 3:');
  for (int i = 0; i < 3 && i < topDays.length; i++) {
    final entry = topDays[i];
    final dayName = _getDayName(entry.key);
    print('   ${i + 1}. $dayName: ${entry.value.round()}%');
  }
  
  print('\n' + '=' * 50);
  print('🎯 다음 주 추천 전략:');
  print('- ${result.bestTime.dayName} ${result.bestTime.timeSlot} 집중 공략');
  print('- 알림을 ${result.averageResponseMinutes}분 일찍 설정');
  print('- 성공률이 낮은 시간대는 피하거나 루틴 강도 조절');
  print('=' * 50);
}

String _formatTime(int hour, int minute) {
  final adjustedHour = hour < 0 ? hour + 24 : hour;
  final period = adjustedHour < 12 ? '오전' : '오후';
  final displayHour = adjustedHour > 12 ? adjustedHour - 12 : adjustedHour;
  return '$period ${displayHour}:${minute.toString().padLeft(2, '0')}';
}

String _getDayName(int dayOfWeek) {
  const days = ['', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  return days[dayOfWeek];
}