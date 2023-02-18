import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:hourouf_fighter/game/enemy.dart';
import 'package:hourouf_fighter/game/player_bullet.dart';
import 'package:hourouf_fighter/game_manager.dart';

class EnemyBullet extends SpriteAnimationComponent
    with HasGameRef<GameManager>, GestureHitboxes, CollisionCallbacks {
  double _speed = 100;
  final Function(Vector2) onTouch;
  var hitboxRectangle = RectangleHitbox();
  late int letterEnemyId;

  EnemyBullet(this.onTouch, this.letterEnemyId);

  @override
  Future<void> onLoad() async {
    var spriteSheet = SpriteSheet(
        image: await Flame.images.load('sprite_letters.png'),
        srcSize: Vector2(256.0, 256.0));
    animation = spriteSheet.createAnimation(row: letterEnemyId, stepTime: 0.2);
    var size = 128.0;
    width = size;
    height = size;
    anchor = Anchor.center;
    add(hitboxRectangle);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print('collision enemyBullet');
    if (other is PlayerBullet && letterEnemyId == other.letterBulletId) {
      print('playerBullet touche enemybullet');
      _speed = _speed * (-2);
      onTouch.call(other.position);
    }
    if (other is Enemy) {
      removeFromParent();
      remove(hitboxRectangle);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(1, 0) * _speed * dt;
    if (position.x > gameRef.size.x) {
      removeFromParent();
      remove(hitboxRectangle);
    }
  }
}