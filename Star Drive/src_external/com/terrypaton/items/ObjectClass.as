package com.terrypaton.items{
	import flash.geom.Point;
	public class ObjectClass {
		public var theScale:Number
		public var distortFactor:Number
		public var renderx:Number
		public var rendery:Number
		public var tx:int
		public var ty:int
		public var tz:int
		public var objectType:int
		public var thisLoc:Point
		public var _testforCollision:Boolean
		
		
		public function ObjectClass(_newx:Number,_newy:Number,_newz:Number,_objectType:int) {
			tx = _newx
			ty = _newy
			tz = _newz
			objectType = _objectType
			_testforCollision = true
			thisLoc = new Point()
		}
		public function setNoCollision():void {
			_testforCollision = false
		}
		public function get testforCollision():Boolean {
			return _testforCollision
		}
		public function getObjectType():int {
			return objectType
		}
		public function getLoc():Point {
			thisLoc.x = tx
			thisLoc.y = tz
			return thisLoc
		}
	}
}