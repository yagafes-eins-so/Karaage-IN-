import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../viewmodels/game_view_model.dart';

/// プレイ中に常時表示するHUD。残投球数(ボールアイコンの点灯/消灯)とスコア。
class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.viewModel});

  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Badge(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) {
                      final used = i < (5 - viewModel.throwsLeft);
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.circle,
                          size: 14,
                          color: used
                              ? AppColors.charcoal.withOpacity(0.25)
                              : AppColors.red,
                        ),
                      );
                    }),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Badge(
                      child: Text(
                        'SCORE ${viewModel.totalScore}',
                        style: const TextStyle(
                          color: AppColors.charcoal,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _Badge(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.whatshot, size: 14, color: AppColors.charcoal),
                          const SizedBox(width: 6),
                          Text(
                            'IN ${viewModel.landedInCup}',
                            style: const TextStyle(
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.charcoal, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.charcoal, offset: Offset(3, 3)),
        ],
      ),
      child: child,
    );
  }
}
