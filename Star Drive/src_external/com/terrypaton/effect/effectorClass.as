package com.terrypaton.effect{
	import flash.display.*;
	import flash.geom.Point;
	
	public class effectorClass  {
		
		
		
		public function effectorClass(_x:int, _y:int, _clip:MovieClip,  _effectorType:int,_effectorStrength:Number,_effectorAngle:Number,_range:Number) {
			effectorType = _effectorType
			clip = _clip
			x = _x
			y = _y
			angle = _effectorAngle
			strength = _effectorStrength
			range = _range
			// now change the defaults depending on the particle
			switch(effectorType) {
				case EFFECTOR_MAGNET:
					
				break
				
			}
			// calulate gravity effect
			 radians = (angle) * Math.PI / 180;
			gx = (strength * Math.cos(radians));
			gy = (strength * Math.sin(radians))
			
			clip.x = x
			clip.y = y
		}
		public function getEffectorType():int {
			return effectorType
		}
		public function getStrength():Number {
			return strength
		}
		public function getLoc():Point {
			return new Point(x,y)
		}
		public function getRange():Number {
			return range
		}
		public function getRadians():Number {
			return radians
		}
		public function getClip():MovieClip {
			return clip
		}
		public function getAngle():Number {
			return angle
		}
		public var effectorType:int;
	   private static var EFFECTOR_MAGNET:int = 1;
	
   public var range:Number;
   public var x:Number;
		public var y:Number;
		
		//private var gravity:Number;
		
		public var dist:Number;
		public var gx:Number;
		public var gy:Number;
		public var dx:Number;
		public var dy:Number;
		public var radians:Number;
		
		public var strength:Number;
	       private var angle:Number;
		private var clip:MovieClip;
		
		
	}
	
}