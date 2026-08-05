import 'package:flutter/material.dart';

import '../core/audio_manager.dart';
import '../core/constants.dart';
import '../models/rank.dart';
import '../viewmodels/game_view_model.dart';
import '../widgets/pop_button.dart';

/// リザルト画面。合計スコア・成功数・成功率・ランクを表示し、リトライへ導線。
class ResultOverlay extends StatelessWidget {
  const ResultOverlay({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final result = viewModel.buildResult();
    final rank = result.rank;

    return Container(
      color: AppColors.charcoal.withOpacity(0.6),
      child: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.charcoal, width: 4),
            boxShadow: const [
              BoxShadow(color: AppColors.charcoal, offset: Offset(6, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'RESULT',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              _RankBadge(rank: rank, isPerfect: result.isPerfect),
              const SizedBox(height: 12),
              Text(
                '${result.totalScore}',
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w900,
                  fontSize: 44,
                ),
              ),
              const Text(
                'TOTAL SCORE',
                style: TextStyle(
                  color: AppColors.charcoal,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(
                    label: '成功数',
                    value: '${result.successCount} / ${result.throws.length}',
                  ),
                  _StatColumn(
                    label: '成功率',
                    value: '${(result.successRate * 100).round()}%',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PopButton(
                label: 'もう一度',
                color: AppColors.red,
                textColor: AppColors.cream,
                onPressed: () {
                  AudioManager.instance.playClick();
                  viewModel.retry();
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  AudioManager.instance.playClick();
                  viewModel.backToTitle();
                },
                child: const Text(
                  'タイトルへ戻る',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank, required this.isPerfect});
  final Rank rank;
  final bool isPerfect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.yellow,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.charcoal, width: 4),
          ),
          child: Text(
            rank.label,
            style: const TextStyle(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w900,
              fontSize: 40,
            ),
          ),
        ),
        if (isPerfect) ...[
          const SizedBox(height: 6),
          const Text(
            'PERFECT!! +1000',
            style: TextStyle(
              color: AppColors.red,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
