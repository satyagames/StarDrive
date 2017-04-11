package game.objects.enemy {
	import data.CoreData;
	import flash.geom.Rectangle;
	import game.objects.OBJECT_TYPE;

	public class Enemy_10 extends EnemyBase {
		public function Enemy_10(_x:Number, _y:Number, _hitRect:Rectangle, _healthScaling:Number=1, _createsPowerup:Boolean=false) {
			baseCashValue=1;
			basePointsValue=25;
			////cashValue = baseCashValue * _healthScaling
			cashValue=baseCashValue;
			pointsValue=basePointsValue * _healthScaling;
			super(_x, _y, OBJECT_TYPE.ENEMY_10, _hitRect, _healthScaling, _createsPowerup);
			health=1.2;
			health*=_healthScaling;
			startingHealth=health;
			maxspeed=speed=1.2;
			damage=7;
			maxAnimationFrame=15;
			//
			movementRotationSpeed=5;
			movementRotation1Distance=20;
		}

		override public function manage():void {
			// this enemy follows a sine path
			// move the y based on movementRotation1
			movementRotation1+=movementRotationSpeed;
			tempRadians=movementRotation1 / 180 * Math.PI;
			y=baseY + Math.cos(tempRadians) * movementRotation1Distance;
			// move the enemy
			// x += CoreData.Instance.moveSpeed;
			//
//			trace(dist)
			if (x < -20) {
				kill=true;
			}
			super.manage();
		}
	}
}