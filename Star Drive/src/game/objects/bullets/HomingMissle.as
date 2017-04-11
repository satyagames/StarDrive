package game.objects.bullets {
	import data.StuntRunParticleSettings;
	import data.settings;
	import flash.geom.Rectangle;
	import game.managers.EnemyManager;
	import game.managers.RenderManager;
	import game.objects.OBJECT_TYPE;
	import game.objects.enemy.EnemyBase;

	public class HomingMissle extends BulletBase {
		public function HomingMissle(_x:Number, _y:Number, _type:OBJECT_TYPE) {
			super(_x, _y, _type);
			hitRectangle=new Rectangle(_x, _y, 25, 8)
		}
		private var _enemyTarget:EnemyBase=null
		private var _findTargetCount:uint=1
		private var targetRadians:Number=0
		private var dx:Number=0
		private var dy:Number=0

		override public function manage():void {
			if (!_enemyTarget) {
				if (_findTargetCount < 1) {
					_findTargetCount=5
					// find an enemy that's close 
					_enemyTarget=EnemyManager.Instance.findCloseEnemy(x, y);
					trace("find enemy target")
				} else {
					_findTargetCount--
				}
					// missle needs a new target
			}
			if (_enemyTarget) {
				if (_enemyTarget.kill) {
					_enemyTarget=null
				} else {
					dx=_enemyTarget.x - x;
					dy=_enemyTarget.y - y;
					targetRadians=Math.atan2(dy, dx)
					var radiansDiff:Number=targetRadians - radians
					radians+=radiansDiff * .5
					radians=targetRadians
				}
			}
//			radians += 5/180*Math.PI
			x+=Math.cos(radians) * speed
			y+=Math.sin(radians) * speed
			if (Math.random() < .5) {
				RenderManager.Instance.addParticles(x + Math.cos(radians) * 10, y + Math.sin(radians) * 10, StuntRunParticleSettings.PARTICLE_EXHAUST_SMOKE, 1);
			}
			if (y > settings.GAME_PLAY_HEIGHT + 10 || x > settings.GAME_PLAY_WIDTH + 10) {
				kill=true
			} else if (x < -10 || y < -10) {
				kill=true
			}
			life--
			if (life < 1) {
				kill=true
			}
			super.manage()
		}
	}
}