package game.objects.enemy {
	import com.terrypaton.math.MathClass;
	import data.CoreData;
	import data.settings;
	import flash.geom.Rectangle;
	import game.managers.DataManager;
	import game.objects.OBJECT_TYPE;

	public class Enemy_9 extends EnemyBase {
		public function Enemy_9(_x:Number, _y:Number, _hitRect:Rectangle, _healthScaling:Number=1, _createsPowerup:Boolean=false) {
			baseCashValue=1
			basePointsValue=25
			////cashValue = baseCashValue * _healthScaling
			cashValue=baseCashValue
			pointsValue=basePointsValue * _healthScaling
			currentTargetX=_x
			currentTargetY=_y
			super(_x, _y, OBJECT_TYPE.ENEMY_9, _hitRect, _healthScaling, _createsPowerup)
			health=1
			health*=_healthScaling
			startingHealth=health
			maxspeed=speed=2
			damage=5
			maxAnimationFrame=15
			//
			movementRotation=Math.random() * 360
			movementRotationSpeed=5.5
			//
		}
	}
}