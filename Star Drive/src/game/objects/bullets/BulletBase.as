package game.objects.bullets {
	import game.objects.RenderObject;
	import data.settings;
	import flash.geom.Rectangle;
	import game.objects.OBJECT_TYPE;

	public class BulletBase extends RenderObject {
		public function BulletBase(_x:Number, _y:Number, _type:OBJECT_TYPE) {
			power = 5
			var hitrect:Rectangle = new Rectangle(_x, _y, 8, 8)
			super(_x, _y, _type, hitrect);
		}
		public var power:Number = 0
		public var speed:Number = 0
		public var life:int = 200

		override public function manage():void {
			x += Math.cos(radians) * speed
			y += Math.sin(radians) * speed
			if (xVelocity > 0 && x > settings.GAME_PLAY_WIDTH + 10) {
				kill = true
			}
			if (xVelocity < 0 && x < -10) {
				kill = true
			}
			life--
			if (life < 1) {
				kill = true
			}
			super.manage()
		}
	}
}