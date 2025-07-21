import 'package:flutter/material.dart';

/// 추천 루틴 위젯 (참고 이미지 스타일)
class InsightsWidget extends StatelessWidget {
  const InsightsWidget({super.key});

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
                '추천 루틴',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  // TODO: 더 많은 추천 루틴 보기
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
        
        // 추천 루틴 카드들
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildRecommendationCard(
              title: '아침 운동 루틴',
              subtitle: '건강한 하루 시작',
              icon: Icons.fitness_center,
              color: const Color(0xFF059669),
              image: '🏃‍♂️',
            ),
            
            _buildRecommendationCard(
              title: '독서 습관',
              subtitle: '지식 쌓기',
              icon: Icons.menu_book,
              color: const Color(0xFF7C3AED),
              image: '📚',
            ),
            
            _buildRecommendationCard(
              title: '명상과 휴식',
              subtitle: '마음의 평화',
              icon: Icons.self_improvement,
              color: const Color(0xFFDC2626),
              image: '🧘‍♀️',
            ),
            
            _buildRecommendationCard(
              title: '물 마시기',
              subtitle: '수분 보충',
              icon: Icons.local_drink,
              color: const Color(0xFF0EA5E9),
              image: '💧',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          // 이미지/이모지 영역
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                image,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 텍스트 정보
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}