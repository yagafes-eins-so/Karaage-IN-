/// FlameGame の `overlays` API で使うオーバーレイ識別子。
/// 文字列の直書きによるタイプミスを防ぐため定数化する。
class GameOverlays {
  GameOverlays._();

  static const String title = 'title';
  static const String hud = 'hud';
  static const String result = 'result';
  static const String feedback = 'feedback';
}
