import 'package:flutter/material.dart';

/// 최근 활동 위젯 (참고 이미지 스타일)
class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 활동',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  // TODO: 활동 기록 전체 보기
                },
                child: Text(
                  '더보기',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 활동 카드들 - 가로 스크롤
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            children: [
              _buildActivityCard(
                title: '아침 운동',
                subtitle: '완료됨',
                time: '2시간 전',
                color: const Color(0xFF059669),
                image: '🏃‍♂️',
              ),
              
              const SizedBox(width: 12),
              
              _buildActivityCard(
                title: '독서 루틴',
                subtitle: '생성됨',
                time: '1일 전',
                color: const Color(0xFF6366F1),
                image: '📚',
              ),
              
              const SizedBox(width: 12),
              
              _buildActivityCard(
                title: '명상 시간',
                subtitle: '즐겨찾기',
                time: '2일 전',
                color: const Color(0xFFDC2626),
                image: '🧘‍♀️',
              ),
              
              const SizedBox(width: 12),
              
              _buildActivityCard(
                title: '물 마시기',
                subtitle: '알림 설정',
                time: '3일 전',
                color: const Color(0xFF0EA5E9),
                image: '💧',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String subtitle,
    required String time,
    required Color color,
    required String image,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이미지/이모지
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                image,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 제목
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 2),
          
          // 부제목
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          // 시간
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}