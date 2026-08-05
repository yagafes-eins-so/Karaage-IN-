import 'package:flame/extensions.dart';
import '../../core/constants.dart';

/// 放物線運動の計算を担う純粋ロジック。
/// Flameのコンポーネントに依存しないため単体テストしやすい。
class ProjectilePhysics {
  ProjectilePhysics._();

  /// ドラッグベクトル(開始点→終了点)から発射速度ベクトルを求める。
  ///
  /// ヤガあげクンから「引っ張って離す」操作(スリングショット式)を想定しているため、
  /// 実際に投げる方向はドラッグ方向と "逆" になる(パチンコを引く動きと同じ)。
  /// - ドラッグ距離 → 初速の大きさ(パワー)
  /// - ドラッグ方向 → 発射角度(の逆方向)
  static Vector2 velocityFromDrag(Vector2 dragVector) {
    final distance = dragVector.length;
    final clampedDistance =
        distance.clamp(0, GameConfig.maxLaunchSpeed / GameConfig.powerScale);

    // 逆方向(スリングショット)に正規化したベクトルを作る。
    final direction =
        distance == 0 ? Vector2(1, -1) : (-dragVector)..normalize();

    final speed = clampedDistance * GameConfig.powerScale;
    return direction * speed;
  }

  /// dt秒後の位置を、重力を考慮して積分する(空気抵抗なし = 等加速度運動)。
  static Vector2 integratePosition({
    required Vector2 position,
    required Vector2 velocity,
    required double dt,
  }) {
    return Vector2(
      position.x + velocity.x * dt,
      position.y + velocity.y * dt + 0.5 * GameConfig.gravity * dt * dt,
    );
  }

  /// dt秒後の速度(重力による鉛直方向の加速のみ)。
  static Vector2 integrateVelocity({
    required Vector2 velocity,
    required double dt,
  }) {
    return Vector2(velocity.x, velocity.y + GameConfig.gravity * dt);
  }

  /// ドラッグ距離が最小しきい値を超えているか(誤操作でない有効な投球か)。
  static bool isValidThrow(Vector2 dragVector) {
    return dragVector.length >= GameConfig.minDragDistance;
  }
}
