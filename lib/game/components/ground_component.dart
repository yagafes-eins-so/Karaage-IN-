import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// 中央の投球エリア下端にある「地面」。
/// 唐揚げがここへ触れると「バウンド」または「地面へ落ちる」失敗扱いになる。
class GroundComponent extends PositionComponent
    with CollisionCallbacks {
  GroundComponent({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    // 地面の灰色バーは不要のため描画しません。
  }
}
