package game.objects.enemy {
	import com.terrypaton.media.SoundManager;
	import data.CoreData;
	import data.StuntRunParticleSettings;
	import data.settings;
	import flash.geom.Rectangle;
	import game.managers.DataManager;
	import game.managers.RenderManager;
	import game.objects.OBJECT_TYPE;
	import game.objects.RenderObject;

	public class EnemyBase extends RenderObject {
		public function EnemyBase(_x:Number, _y:Number, _type:OBJECT_TYPE, _hitRectangle:Rectangle, _healthScaling:Number=1, _createsPowerup:Boolean=false) {
			//			movementArray = _movementArray
			//			healthScaling = _healthScaling
			//	trace("_healthScaling:" + _healthScaling)
			//			currentPosition = 0
			//			totalPositions = _movementArray.length
			//			var _x:Number = currentTargetX
			//			var _y:Number = currentTargetY
			//			currentPosition++
			baseY=_y
			baseX=_x
			firingPercentScale=Math.abs(CoreData.Instance.totalDistance) / 30000
			//			trace("firingPercentScale:" + firingPercentScale)
			if (firingPercentScale > .8) {
				firingPercentScale=.8
			}
			createsPowerup=_createsPowerup
			hitRectangle=_hitRectangle
			super(_x, _y, _type, hitRectangle);
		}
		protected var addit:Number=0;
		//	public var xVelocity:Number=0
		//public var yVelocity:Number=0
		public var isBoss:Boolean=false
		public var invunerableToLandscape:Boolean=false
		public var canFireBullet:Boolean=false
		public var firingCounter:Number=10
		public var firingCounterReset:Number=10
		public var firingRadian:Number=0
		public var firingBulletSpeed:Number=0
		//
		public var startingHealth:Number=0
		public var health:Number=1
		public var damage:int=10
		public var speed:Number=0
		//	private var dist:Number = 0
		protected var dx:Number=0
		protected var dy:Number=0
		protected var dist:Number=0
		//private var angle:Number = 0
		public var currentTargetX:Number=0
		public var currentTargetY:Number=0
		public var baseCashValue:int=0
		public var cashValue:int=0
		public var basePointsValue:int=0
		//
		//private var movementArray:Array = []
		//private var healthScaling:Number = 0
		//		private var currentPosition:int = 0
		//private var totalPositions:int = 0
		//private var moveX:Number = 0
		//private var moveY:Number = 0
		public var maxspeed:Number=0
		public var animationFrame:int=1
		public var maxAnimationFrame:int=10
		//
		public var movementRotation1:Number=0
		public var movementRotationSpeed:Number=0
		public var movementRotation1Distance:Number=0
		//
		public var movementRotation2:Number=0
		public var movementRotation2Speed:Number=0
		public var movementRotation2Distance:Number=0
		//
		public var baseX:Number=0
		public var baseY:Number=0
		public var tempRadians:Number=0
		public var firingPercentScale:Number=0
		//
		public var createsPowerup:Boolean=false
		public var timeToLookforNewMove:int=290
		private var rotDifference:Number
//		private var rot:Number
//		private var rad:Number
//		private var rad2:Number
		private var moveCounter:int=0
		private var testCount:int=0
		private var notFoundLocation:Boolean
		protected var movementRotation:Number

		override public function manage():void {
			animationFrame++
			if (animationFrame >= maxAnimationFrame) {
				animationFrame=1
			}
			moveCounter++
			if (moveCounter > timeToLookforNewMove) {
				trace("make enemy find a new location")
			}
			dx=currentTargetX - x;
			dy=currentTargetY - y;
			radians=Math.atan2(dy, dx)
			movementRotation=radians * 180 / Math.PI
			xVelocity=Math.cos(radians) * speed;
			yVelocity=Math.sin(radians) * speed;
			x+=xVelocity
			y+=yVelocity;
			//			if it has made it to it's next target, find a new one
			dist=Math.floor(Math.sqrt(dx * dx + dy * dy));
			//	trace("dist:" + dist)
			if (Math.abs(dist) < 30) {
//				trace("find new location")
				// find a new target, pick a random value around the enemy
			}
			super.manage()
		}
		public var randomFiringAngle:Number
		public var randomFiringAngleSub:Number

		protected function findNewTarget():void {
		}

		public function hurt(_damage:Number):void {
			//			trace("hurt", health, _damage)
			health-=_damage
			if (health <= 0) {
				kill=true
				//	SoundManager.playSound("snd_enemyExplode" + int(Math.random() * 4 + 1))
				health=0
				RenderManager.Instance.addParticles(x, y, StuntRunParticleSettings.PARTICLE_COIN, 13)
				DataManager.Instance.addPoints(pointsValue)
			}
		}
	}
}