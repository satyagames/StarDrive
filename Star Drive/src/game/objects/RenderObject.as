package game.objects {
	import flash.geom.Rectangle;

	public class RenderObject {
		public var alpha:Number;
		public var pointsValue:int;

		public function RenderObject(_x:Number, _y:Number, _type:OBJECT_TYPE, _hitRectangle:Rectangle=null) {
			x=_x
			y=_y
			type=_type
			scale=1
			alpha=1
			_hitRectangle
		}

		public function dispose():void {
			type=null
		}
		public var xRectOffset:int=0
		public var yRectOffset:int=0
		public var xVelocity:Number=0
		public var yVelocity:Number=0
		public var scale:Number=1
		public var x:Number=0
		public var y:Number=0
		public var rotation:Number=0
		public var radians:Number=0
		public var type:OBJECT_TYPE
		public var animationStep:int=0
		public var animationStepMax:int=0
		public var depth:int
		public var renderingDepth:int=0
		public var collisionEnabled:Boolean=false;
		public var collisionRadius:Number=0
		public var kill:Boolean=false
		public var active:Boolean=true
		public var hitRectangle:Rectangle
		public var hide:Boolean=false
		public var objectSubType:int=0
		public var objectValue:int=0

		public function manage():void {
			//hitRectangle.x = x - xRectOffset
			//hitRectangle.y = y - yRectOffset
		}
	}
}