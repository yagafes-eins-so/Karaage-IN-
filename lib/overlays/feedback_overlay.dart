import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../game/karaage_game.dart';

/// 投球結果に応じて一瞬だけ表示される "IN!!" / "MISS" のポップアップ。
/// 表示内容は KaraageGame.feedbackText (ValueNotifier) が保持する。
class FeedbackOverlay extends StatelessWidget {
  const FeedbackOverlay({super.key, required this.game});

  final KaraageGame game;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ValueListenableBuilder<String?>(
        valueListenable: game.feedbackText,
        builder: (context, text, _) {
          if (text == null) return const SizedBox.shrink();
          final isSuccess = text.contains('IN');
          return Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1.0),
              duration: const Duration(milliseconds: 220),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: isSuccess ? AppColors.red : AppColors.charcoal,
                  shadows: const [
                    Shadow(
                      color: AppColors.cream,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
