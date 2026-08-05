import 'package:flame/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karaage_in/game/physics/projectile_physics.dart';

void main() {
  group('ProjectilePhysics.velocityFromDrag', () {
    test('drag to the lower-left launches up and to the right', () {
      final drag = Vector2(-100, 100); // 左下へドラッグ
      final v = ProjectilePhysics.velocityFromDrag(drag);
      expect(v.x, greaterThan(0)); // 右へ飛ぶ
      expect(v.y, lessThan(0)); // 上へ飛ぶ(スリングショットの逆方向)
    });

    test('speed is clamped to maxLaunchSpeed', () {
      final drag = Vector2(-5000, 0);
      final v = ProjectilePhysics.velocityFromDrag(drag);
      expect(v.length, lessThanOrEqualTo(900.0 + 0.001));
    });

    test('zero drag does not throw and returns a finite vector', () {
      final v = ProjectilePhysics.velocityFromDrag(Vector2.zero());
      expect(v.x.isFinite, isTrue);
      expect(v.y.isFinite, isTrue);
    });
  });

  group('ProjectilePhysics.isValidThrow', () {
    test('rejects drags below the minimum distance', () {
      expect(ProjectilePhysics.isValidThrow(Vector2(2, 2)), isFalse);
    });

    test('accepts drags above the minimum distance', () {
      expect(ProjectilePhysics.isValidThrow(Vector2(50, 50)), isTrue);
    });
  });

  group('ProjectilePhysics.integratePosition / integrateVelocity', () {
    test('gravity pulls the projectile downward over time', () {
      var pos = Vector2(0, 0);
      var vel = Vector2(100, -300);
      for (int i = 0; i < 60; i++) {
        pos = ProjectilePhysics.integratePosition(
            position: pos, velocity: vel, dt: 1 / 60);
        vel = ProjectilePhysics.integrateVelocity(velocity: vel, dt: 1 / 60);
      }
      // 1秒後には重力の影響で下向き速度に転じているはず。
      expect(vel.y, greaterThan(0));
    });
  });
}
