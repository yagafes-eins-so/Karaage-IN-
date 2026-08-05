/// 1投分の結果。判定ロジックそのものは持たず、確定した事実のみを保持する
/// (イミュータブルなデータクラス = Model層の責務)。
class ThrowResult {
  const ThrowResult({
    required this.success,
    required this.noBounce,
    required this.centerHit,
    required this.scoreGained,
  });

  final bool success;

  /// ノーバウンドでカップに入ったか(地面に触れず直接IN)。
  final bool noBounce;

  /// カップ中央エリアに入ったか。
  final bool centerHit;

  /// この1投で加算されたスコア(Perfectボーナスは含まない。加算は集計側で行う)。
  final int scoreGained;

  factory ThrowResult.miss() => const ThrowResult(
        success: false,
        noBounce: false,
        centerHit: false,
        scoreGained: 0,
      );
}
