import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'game/game_state.dart';
import 'game/karaage_game.dart';
import 'overlays/feedback_overlay.dart';
import 'overlays/hud_overlay.dart';
import 'overlays/result_overlay.dart';
import 'overlays/title_overlay.dart';
import 'viewmodels/game_view_model.dart';

class KaraageInApp extends StatelessWidget {
  const KaraageInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(),
      child: MaterialApp(
        title: 'からあげ in!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: null, // pubspec側でPopFontを追加したら指定する
          useMaterial3: true,
        ),
        home: const _GameScreen(),
      ),
    );
  }
}

class _GameScreen extends StatefulWidget {
  const _GameScreen();

  @override
  State<_GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<_GameScreen> {
  late final KaraageGame _game;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<GameViewModel>();
    _game = KaraageGame(viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameViewModel>();

    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            // デザイン基準比率にフィットさせ、PC/スマホどちらでも
            // レターボックス表示で崩れないようにする。
            aspectRatio: GameConfig.designWidth / GameConfig.designHeight,
            child: GameWidget<KaraageGame>(
              game: _game,
              overlayBuilderMap: {
                GameOverlays.title: (context, game) =>
                    TitleOverlay(game: game, viewModel: viewModel),
                GameOverlays.hud: (context, game) =>
                    HudOverlay(viewModel: viewModel),
                GameOverlays.result: (context, game) =>
                    ResultOverlay(viewModel: viewModel),
                GameOverlays.feedback: (context, game) =>
                    FeedbackOverlay(game: game),
              },
            ),
          ),
        ),
      ),
    );
  }
}
