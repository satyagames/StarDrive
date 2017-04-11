package game.objects {
	import flash.geom.Rectangle;

	public class Points extends RenderObject {
		public var rx:Number;
		public var ry:Number;

		public function Points(_x:Number, _y:Number, _type:OBJECT_TYPE) {
			var hitrect:Rectangle=new Rectangle(_x, _y, 20, 20)
			rotation=0
			radians=rotation / 180 * Math.PI
			renderingDepth=1
			counter=1
			super(_x, _y, _type, hitrect);
		}
		public var scaleFactor:Number
		public var counter:int

		override public function manage():void {
			if (active) {
				y-=2
				counter++
				// use this for fading out the coin
				scale=1 + counter / 40
				alpha=1 - counter / 40
				if (counter > 40) {
					kill=true
				}
			}
			super.manage()
		}
	}
}