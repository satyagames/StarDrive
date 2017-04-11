package game.objects {
	import flash.geom.Rectangle;

	public class Item extends RenderObject {
		public var rx:Number;
		public var ry:Number;

		public function Item(_x:Number, _y:Number, _type:OBJECT_TYPE, _rotation:Number=0, _objectSubType:int=0) {
			objectSubType=_objectSubType
			var hitrect:Rectangle=new Rectangle(_x, _y, 20, 20)
			rotation=_rotation
			radians=rotation / 180 * Math.PI
			//trace("radians:"+radians)
			switch (_type) {
				case OBJECT_TYPE.COIN:
					pointsValue=250
					coinValue=3
					break
				case OBJECT_TYPE.TURBO_BOOST:
					pointsValue=500
					break
				default:
					pointsValue=100
					renderingDepth=0
					coinValue=1
					break
			}
			super(_x, _y, _type, hitrect);
		}
		public var coinValue:int
		public var scaleFactor:Number
		public var exitAnimationFrame:int

		public function collected():void {
			trace("collected")
			if (active) {
				active=false
				exitAnimationFrame=1
			}
		}

		override public function manage():void {
			switch (type) {
				case OBJECT_TYPE.MESSAGE_360:
				case OBJECT_TYPE.MESSAGE_180:
				case OBJECT_TYPE.MESSAGE_HUGE_JUMP:
				case OBJECT_TYPE.MESSAGE_LONG_JUMP:
				case OBJECT_TYPE.MESSAGE_MEDIUM_JUMP:
				case OBJECT_TYPE.MESSAGE_TURBO_BOOST:
				case OBJECT_TYPE.MESSAGE_COIN_COLLECTED:
				case OBJECT_TYPE.MESSAGE_COIN_COLLECTED:
					y-=1
					alpha-=.02
					if (alpha < .02) {
						kill=true
					}
					break
				default:
					if (!hide) {
						if (!active) {
							exitAnimationFrame++
							// use this for fading out the coin
							scale=1 + exitAnimationFrame / 10
							alpha=1 - exitAnimationFrame / 10
							if (exitAnimationFrame > 10) {
								hide=true
								exitAnimationFrame=1
								kill=true
							}
						} else {
							alpha=1
							animationStep++
							if (animationStep > animationStepMax) {
								animationStep-=animationStepMax
							}
						}
					}
					break
			}
			super.manage()
		}
	}
}