import 'package:flutter/material.dart';

import '../core/audio_manager.dart';
import '../core/constants.dart';
import '../game/karaage_game.dart';
import '../viewmodels/game_view_model.dart';
import '../widgets/pop_button.dart';

/// タイトル画面。ゲームタイトル・簡単な説明・スタートボタンのみのシンプル構成。
class TitleOverlay extends StatelessWidget {
  const TitleOverlay({super.key, required this.game, required this.viewModel});

  final KaraageGame game;
  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.charcoal.withOpacity(0.55),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.charcoal, width: 4),
                boxShadow: const [
                  BoxShadow(color: AppColors.charcoal, offset: Offset(6, 6)),
                ],
              ),
              child: const Text(
                'からあげ in!',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ヤガあげクンを操作して、紙コップに唐揚げを投げ入れよう!\n'
              'ドラッグして狙いを定め、指を離すと発射!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.cream,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            PopButton(
              label: 'スタート',
              color: AppColors.red,
              textColor: AppColors.cream,
              onPressed: () {
                AudioManager.instance.playClick();
                viewModel.startGame();
              },
            ),
          ],
        ),
      ),
    );
  }
}
