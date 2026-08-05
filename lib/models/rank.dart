/// リザルトランク。合計スコアから一意に決定する。
enum Rank {
  s('S'),
  a('A'),
  b('B'),
  c('C'),
  d('D');

  const Rank(this.label);
  final String label;

  /// 5投分の最大理論値は概算で 1000(Perfect) + 5*100 + 5*150(bonus) = 2250 だが、
  /// 実運用上のボーダーは大会運営側で調整しやすいようここに集約する。
  static Rank fromScore(int score) {
    if (score >= 1400) return Rank.s;
    if (score >= 900) return Rank.a;
    if (score >= 500) return Rank.b;
    if (score >= 200) return Rank.c;
    return Rank.d;
  }
}
