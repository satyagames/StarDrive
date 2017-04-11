package game.objects {
	import flash.geom.Rectangle;
	public class Checkpoint extends RenderObject {
		public var rx : Number;
		public var ry : Number;
		

		public function Checkpoint(_x : Number, _y : Number, _type : OBJECT_TYPE,_rotation : Number = 0,_checkpointID : int = 1) {
			checkpointID = _checkpointID
			var hitrect : Rectangle = new Rectangle(_x, _y, 20, 20)
			rotation = _rotation
			radians = rotation / 180 * Math.PI
			animationStepMax = 30			exitAnimationFrame = 1
			pointsValue = 150
			super(_x, _y, _type, hitrect);
		}

		public var scaleFactor : Number		public var exitAnimationFrame : int		public var checkpointID : int		
		public function reset() : void {
			hide = false
			active = true
			animationStep = 1
			exitAnimationFrame = 1
			scale = 1		}

		public function collected() : void {
			trace("COLLECETED checkpoint:" + checkpointID)
			if (active) {
				active = false
				exitAnimationFrame = 1			}
		}

		override public function manage() : void {
			if (!hide) {
				if (!active) {
					exitAnimationFrame++
					
					// use this for fading out the coin
					scale = 1 + exitAnimationFrame / 20					alpha = 1 - exitAnimationFrame / 20
					if (exitAnimationFrame > 20) {
						hide = true
						
						exitAnimationFrame = 1
					}
				} else {
					alpha = 1
					animationStep++
					if (animationStep > animationStepMax) {
						animationStep -= animationStepMax
					}
				}
			}
			super.manage()
		}
	}
}