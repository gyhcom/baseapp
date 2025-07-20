import 'package:flutter/material.dart';
import '../entities/routine_item.dart';
import '../entities/routine_concept.dart';
import '../entities/user_profile.dart';

/// 루틴 추천 로직을 담당하는 Use Case
/// 사용자 프로필과 컨셉에 따라 맞춤형 루틴을 생성합니다.
class RoutineRecommendationUseCase {
  /// 사용자 프로필을 기반으로 기본 루틴 항목들을 생성
  List<RoutineItem> generateBaseRoutine(UserProfile userProfile) {
    final items = <RoutineItem>[];

    // 기본 아침 루틴
    items.addAll(_getBaseMorningRoutine(userProfile.concept));
    
    // 기본 오후 루틴
    items.addAll(_getBaseAfternoonRoutine(userProfile.concept));
    
    // 기본 저녁 루틴
    items.addAll(_getBaseEveningRoutine(userProfile.concept));

    // 우선순위에 따라 정렬
    items.sort((a, b) => a.priority.compareTo(b.priority));
    
    return items;
  }

  /// 기본 아침 루틴 생성
  List<RoutineItem> _getBaseMorningRoutine(RoutineConcept concept) {
    final wakeUpTime = _getWakeUpTime(concept);
    
    return [
      RoutineItem(
        id: 'morning_1',
        title: '기상 및 세면',
        description: '상쾌한 하루를 위한 아침 준비',
        startTime: wakeUpTime,
        duration: const Duration(minutes: 30),
        category: '아침',
        priority: RoutinePriority.high,
      ),
      RoutineItem(
        id: 'morning_2',
        title: '아침 식사',
        description: '건강한 아침 식사로 에너지 충전',
        startTime: TimeOfDay(hour: wakeUpTime.hour, minute: wakeUpTime.minute + 30),
        duration: const Duration(minutes: 20),
        category: '아침',
        priority: RoutinePriority.medium,
      ),
    ];
  }

  /// 기본 오후 루틴 생성
  List<RoutineItem> _getBaseAfternoonRoutine(RoutineConcept concept) {
    return [
      RoutineItem(
        id: 'afternoon_1',
        title: '점심 시간',
        description: '균형 잡힌 점심 식사',
        startTime: const TimeOfDay(hour: 12, minute: 0),
        duration: const Duration(minutes: 60),
        category: '식사',
        priority: RoutinePriority.high,
      ),
      RoutineItem(
        id: 'afternoon_2',
        title: _getAfternoonActivityTitle(concept),
        description: _getAfternoonActivityDescription(concept),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        duration: const Duration(minutes: 90),
        category: '활동',
        priority: RoutinePriority.medium,
      ),
    ];
  }

  /// 기본 저녁 루틴 생성
  List<RoutineItem> _getBaseEveningRoutine(RoutineConcept concept) {
    return [
      RoutineItem(
        id: 'evening_1',
        title: '저녁 식사',
        description: '하루를 마무리하는 편안한 저녁 식사',
        startTime: const TimeOfDay(hour: 19, minute: 0),
        duration: const Duration(minutes: 45),
        category: '저녁',
        priority: RoutinePriority.high,
      ),
      RoutineItem(
        id: 'evening_2',
        title: _getEveningActivityTitle(concept),
        description: _getEveningActivityDescription(concept),
        startTime: const TimeOfDay(hour: 21, minute: 0),
        duration: const Duration(minutes: 60),
        category: '휴식',
        priority: RoutinePriority.medium,
      ),
    ];
  }

  /// 컨셉에 따른 기상 시간 결정
  TimeOfDay _getWakeUpTime(RoutineConcept concept) {
    switch (concept) {
      case RoutineConcept.godlife:
      case RoutineConcept.diligent:
        return const TimeOfDay(hour: 6, minute: 0);
      case RoutineConcept.physicalHealth:
        return const TimeOfDay(hour: 6, minute: 30);
      case RoutineConcept.relaxed:
      case RoutineConcept.lazyButRegular:
        return const TimeOfDay(hour: 8, minute: 0);
      case RoutineConcept.workLifeBalance:
        return const TimeOfDay(hour: 7, minute: 0);
      default:
        return const TimeOfDay(hour: 7, minute: 30);
    }
  }

  /// 컨셉에 따른 오후 활동 제목
  String _getAfternoonActivityTitle(RoutineConcept concept) {
    switch (concept) {
      case RoutineConcept.godlife:
        return '자기계발 시간';
      case RoutineConcept.physicalHealth:
        return '운동 시간';
      case RoutineConcept.relaxed:
        return '여유로운 휴식';
      case RoutineConcept.workLifeBalance:
        return '업무 집중 시간';
      default:
        return '개인 활동 시간';
    }
  }

  /// 컨셉에 따른 오후 활동 설명
  String _getAfternoonActivityDescription(RoutineConcept concept) {
    switch (concept) {
      case RoutineConcept.godlife:
        return '목표 달성을 위한 학습이나 스킬 개발';
      case RoutineConcept.physicalHealth:
        return '건강을 위한 운동이나 신체 활동';
      case RoutineConcept.relaxed:
        return '스트레스 해소를 위한 취미 활동';
      case RoutineConcept.workLifeBalance:
        return '효율적인 업무 처리 시간';
      default:
        return '개인적인 관심사나 취미 활동';
    }
  }

  /// 컨셉에 따른 저녁 활동 제목
  String _getEveningActivityTitle(RoutineConcept concept) {
    switch (concept) {
      case RoutineConcept.godlife:
        return '하루 정리 및 내일 계획';
      case RoutineConcept.relaxed:
        return '편안한 휴식 시간';
      case RoutineConcept.physicalHealth:
        return '요가 또는 명상';
      default:
        return '개인 시간';
    }
  }

  /// 컨셉에 따른 저녁 활동 설명
  String _getEveningActivityDescription(RoutineConcept concept) {
    switch (concept) {
      case RoutineConcept.godlife:
        return '오늘의 성과를 정리하고 내일을 준비';
      case RoutineConcept.relaxed:
        return '마음의 평화를 찾는 시간';
      case RoutineConcept.physicalHealth:
        return '몸과 마음을 이완시키는 활동';
      default:
        return '하루를 마무리하는 개인적인 시간';
    }
  }

  /// 특정 카테고리의 루틴 항목들을 가져오기
  List<RoutineItem> getRoutinesByCategory(List<RoutineItem> items, String category) {
    return items.where((item) => item.category == category).toList();
  }

  /// 우선순위가 높은 루틴 항목들만 가져오기
  List<RoutineItem> getHighPriorityRoutines(List<RoutineItem> items) {
    return items.where((item) => item.priority == RoutinePriority.high).toList();
  }
}