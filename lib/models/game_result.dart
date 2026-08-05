import 'rank.dart';
import 'throw_result.dart';

/// 1セッション(5投)分の集計結果。リザルト画面はこれを表示するだけでよい。
class GameResult {
  const GameResult({
    required this.throws,
    required this.totalScore,
  });

  final List<ThrowResult> throws;
  final int totalScore;

  int get successCount => throws.where((t) => t.success).length;

  double get successRate =>
      throws.isEmpty ? 0 : successCount / throws.length;

  bool get isPerfect => throws.isNotEmpty && successCount == throws.length;

  Rank get rank => Rank.fromScore(totalScore);

  factory GameResult.empty() => const GameResult(throws: [], totalScore: 0);
}
