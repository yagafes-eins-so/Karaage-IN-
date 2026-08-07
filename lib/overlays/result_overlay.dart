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
    final screenSize = MediaQuery.of(context).size;
    final compact = screenSize.height < 480;
    final cardWidth = (screenSize.width * 0.85).clamp(220.0, 340.0);
    final cardPadding = compact ? const EdgeInsets.all(18) : const EdgeInsets.all(24);
    final titleFontSize = compact ? 20.0 : 22.0;
    final scoreFontSize = compact ? 36.0 : 44.0;
    final statFontSize = compact ? 18.0 : 20.0;

    return Container(
      color: AppColors.charcoal.withValues(alpha: 0.6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Container(
                  width: cardWidth,
                  constraints: const BoxConstraints(maxWidth: 340),
                  padding: cardPadding,
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
                      Text(
                        'RESULT',
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w900,
                          fontSize: titleFontSize,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: compact ? 6 : 8),
                      _RankBadge(rank: rank, isPerfect: result.isPerfect),
                      SizedBox(height: compact ? 8 : 12),
                      Text(
                        '${result.totalScore}',
                        style: TextStyle(
                          color: AppColors.charcoal,
                          fontWeight: FontWeight.w900,
                          fontSize: scoreFontSize,
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
                      SizedBox(height: compact ? 12 : 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatColumn(
                            label: '成功数',
                            value: '${result.successCount} / ${result.throws.length}',
                            fontSize: statFontSize,
                          ),
                          _StatColumn(
                            label: '成功率',
                            value: '${(result.successRate * 100).round()}%',
                            fontSize: statFontSize,
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 24),
                      PopButton(
                        label: 'もう一度',
                        color: AppColors.red,
                        textColor: AppColors.cream,
                        onPressed: () {
                          AudioManager.instance.playClick();
                          viewModel.retry();
                        },
                      ),
                      SizedBox(height: compact ? 8 : 10),
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
            ),
          );
        },
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
            'PERFECT!!',
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
  const _StatColumn({required this.label, required this.value, this.fontSize = 20});
  final String label;
  final String value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
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
