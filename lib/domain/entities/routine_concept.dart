import 'package:flutter/material.dart';

enum RoutineConcept {
  // 🔥 자기계발형
  godlife('🔥 갓생살기', '새벽 기상, 독서, 운동, 목표 달성 중심'),
  diligent('⚡️ 부지런하게', '생활 리듬을 잡고 하루를 꽉 채우는 컨셉'),
  
  // ☁️ 휴식형
  relaxed('☁️ 여유롭게', '스트레스 없는 루틴, 충분한 여유 시간 포함'),
  restful('🛋️ 쉬면서 살기', '재충전을 중시, 활동량 낮음'),
  
  // 🎨 창의형
  creative('🎨 크리에이티브 모드', '창작, 상상, 몰입을 위한 루틴'),
  
  // 🧠 집중형
  minimal('🧠 미니멀 집중', '하루 핵심 활동만 수행 (딥워크, 무소음)'),
  
  // 💼 실용형
  workLifeBalance('💼 워라밸 유지', '업무와 여가의 적절한 밸런스'),
  
  // 🐢 느긋형
  lazyButRegular('🐢 게으르지만 규칙적인', '느긋하지만 최소 루틴은 지키는 구조'),
  
  // 🧘‍♀️ 웰니스형
  mindfulness('🧘‍♀️ 마음챙김 중심', '명상, 감정 일기, 스트레칭 포함'),
  
  // 💪 건강형
  physicalHealth('💪 피지컬 헬스', '운동과 신체 건강 중심 루틴'),
  
  // 🛡 회복형
  mentalRecovery('🛡️ 멘탈 회복용', '우울/번아웃 회복 루틴 중심 (루즈하게)'),
  
  // 🎯 챌린지형
  challenge('🎯 3일 도전 루틴', '작심삼일 전용 챌린지 루틴');

  const RoutineConcept(this.displayName, this.description);

  final String displayName;
  final String description;
  
  // 컨셉 분류를 위한 헬퍼 메서드
  String get category {
    switch (this) {
      case RoutineConcept.godlife:
      case RoutineConcept.diligent:
        return '자기계발형';
      case RoutineConcept.relaxed:
      case RoutineConcept.restful:
        return '휴식형';
      case RoutineConcept.creative:
        return '창의형';
      case RoutineConcept.minimal:
        return '집중형';
      case RoutineConcept.workLifeBalance:
        return '실용형';
      case RoutineConcept.lazyButRegular:
        return '느긋형';
      case RoutineConcept.mindfulness:
        return '웰니스형';
      case RoutineConcept.physicalHealth:
        return '건강형';
      case RoutineConcept.mentalRecovery:
        return '회복형';
      case RoutineConcept.challenge:
        return '챌린지형';
    }
  }
  
  // 추천 기상 시간
  String get recommendedWakeUpTime {
    switch (this) {
      case RoutineConcept.godlife:
        return '05:30';
      case RoutineConcept.diligent:
      case RoutineConcept.physicalHealth:
        return '06:00';
      case RoutineConcept.minimal:
      case RoutineConcept.workLifeBalance:
        return '07:00';
      case RoutineConcept.creative:
      case RoutineConcept.mindfulness:
        return '07:30';
      case RoutineConcept.relaxed:
      case RoutineConcept.lazyButRegular:
        return '08:00';
      case RoutineConcept.restful:
      case RoutineConcept.mentalRecovery:
        return '08:30';
      case RoutineConcept.challenge:
        return '06:30';
    }
  }
  
  // 추천 취침 시간
  String get recommendedBedTime {
    switch (this) {
      case RoutineConcept.godlife:
      case RoutineConcept.physicalHealth:
        return '22:00';
      case RoutineConcept.diligent:
      case RoutineConcept.minimal:
        return '22:30';
      case RoutineConcept.workLifeBalance:
      case RoutineConcept.mindfulness:
        return '23:00';
      case RoutineConcept.creative:
        return '23:30';
      case RoutineConcept.relaxed:
      case RoutineConcept.lazyButRegular:
        return '23:30';
      case RoutineConcept.restful:
      case RoutineConcept.mentalRecovery:
        return '24:00';
      case RoutineConcept.challenge:
        return '22:00';
    }
  }
  
  // 컨셉별 대표 색상
  Color get color {
    switch (this) {
      case RoutineConcept.godlife:
        return const Color(0xFFFF6B35); // 활기찬 주황색
      case RoutineConcept.diligent:
        return const Color(0xFF4CAF50); // 성실한 초록색
      case RoutineConcept.relaxed:
        return const Color(0xFF81C784); // 여유로운 연한 초록색
      case RoutineConcept.restful:
        return const Color(0xFF90CAF9); // 휴식의 연한 파란색
      case RoutineConcept.creative:
        return const Color(0xFF9C27B0); // 창의적인 보라색
      case RoutineConcept.minimal:
        return const Color(0xFF607D8B); // 집중의 회색빛
      case RoutineConcept.workLifeBalance:
        return const Color(0xFF2196F3); // 균형의 파란색
      case RoutineConcept.lazyButRegular:
        return const Color(0xFFFFC107); // 느긋한 노란색
      case RoutineConcept.mindfulness:
        return const Color(0xFF8BC34A); // 마음챙김의 연두색
      case RoutineConcept.physicalHealth:
        return const Color(0xFFE91E63); // 건강한 분홍색
      case RoutineConcept.mentalRecovery:
        return const Color(0xFF00BCD4); // 회복의 청록색
      case RoutineConcept.challenge:
        return const Color(0xFFFF5722); // 도전의 빨간색
    }
  }
}