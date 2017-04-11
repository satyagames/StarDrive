package game.objects {
	import flash.geom.Rectangle;

	public class Scenery extends RenderObject {
		public var rx:Number;
		public var ry:Number;

		public function Scenery(_x:Number, _y:Number, _type:OBJECT_TYPE, _rotation:Number=0, _objectSubType:int=0) {
			var hitrect:Rectangle=new Rectangle(_x, _y, 20, 20)
			rotation=_rotation
			radians=rotation / 180 * Math.PI
			switch (_type) {
				case OBJECT_TYPE.START_FINISH_LINE:
				case OBJECT_TYPE.OIL:
					renderingDepth=0
					break
				case OBJECT_TYPE.OVERPASS:
					renderingDepth=1
					break
				case OBJECT_TYPE.TREE:
					renderingDepth=int(Math.random() * 2)
					collisionEnabled=false
					collisionRadius=20
					objectSubType=_objectSubType
					break
			}
			super(_x, _y, _type, hitrect);
		}

		override public function manage():void {
			super.manage()
		}
	}
}