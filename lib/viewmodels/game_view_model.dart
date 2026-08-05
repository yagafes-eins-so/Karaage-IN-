import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../core/difficulty.dart';
import '../models/game_result.dart';
import '../models/throw_result.dart';

enum SessionPhase { title, playing, result }

/// アプリ全体の状態を保持するViewModel。
///
/// - Flutter Widget (Overlay) と Flame Component (Game) の両方から参照される
///   「唯一の状態源(single source of truth)」。
/// - スコア計算のルールはここに閉じ込め、View側(UI・ゲーム描画)は
///   結果を表示するだけにする。
class GameViewModel extends ChangeNotifier {
  SessionPhase _phase = SessionPhase.title;
  int _throwsLeft = GameConfig.totalThrows;
  int _totalScore = 0;
  int _sessionCount = 0;
  final List<ThrowResult> _throwHistory = [];
  int _landedInCup = 0;
  int _currentStreak = 0;

  int get landedInCup => _landedInCup;

  SessionPhase get phase => _phase;
  int get throwsLeft => _throwsLeft;
  int get totalScore => _totalScore;
  List<ThrowResult> get throwHistory => List.unmodifiable(_throwHistory);

  Difficulty get currentDifficulty => Difficulty.forSession(_sessionCount);

  bool get canThrow => _phase == SessionPhase.playing && _throwsLeft > 0;

  /// タイトル画面からゲーム開始。
  void startGame() {
    _throwsLeft = GameConfig.totalThrows;
    _totalScore = 0;
    _throwHistory.clear();
    _landedInCup = 0;
    _phase = SessionPhase.playing;
    notifyListeners();
  }

  /// 1投分の結果を登録する。KaraageComponentの衝突判定確定時に呼ばれる。
  ///
  /// [success] カップに入ったか
  /// [noBounce] 地面に触れずダイレクトIN か
  /// [centerHit] カップ中央エリアに入ったか
  void registerThrow({
    required bool success,
    required bool noBounce,
    required bool centerHit,
  }) {
    if (_phase != SessionPhase.playing || _throwsLeft <= 0) return;

    int gained = 0;
    if (success) {
      // 連続成功のカウント
      _currentStreak += 1;
      _landedInCup += 1;

      // 基本点
      gained += GameConfig.scoreSuccess;
      // 連続ボーナス (2連: +100, 3連: +200, 4連: +300, 5連: +400)
      final streak = _currentStreak.clamp(0, 5);
      if (streak >= 2) {
        final streakBonus = (streak - 1) * 100;
        gained += streakBonus;
      }

      // ノーバウンス/中央ヒットのボーナスは廃止（基本点 + 連続成功ボーナスのみ）
      // （以前の仕様ではここで追加されていたが、要件により削除）
    } else {
      _currentStreak = 0;
    }

    final result = ThrowResult(
      success: success,
      noBounce: noBounce,
      centerHit: centerHit,
      scoreGained: gained,
    );
    _throwHistory.add(result);
    _totalScore += gained;
    _throwsLeft -= 1;

    if (_throwsLeft == 0) {
      _finishSession();
      return;
    }
    notifyListeners();
  }

  void _finishSession() {
    _sessionCount += 1;
    _phase = SessionPhase.result;
    notifyListeners();
  }

  GameResult buildResult() {
    return GameResult(throws: _throwHistory, totalScore: _totalScore);
  }

  /// リザルト画面から「もう一度」。難易度は_sessionCountに応じて自動で上がる。
  void retry() {
    startGame();
  }

  /// タイトルへ戻る(難易度もリセットしたい場合に使用)。
  void backToTitle() {
    _phase = SessionPhase.title;
    _sessionCount = 0;
    notifyListeners();
  }
}
