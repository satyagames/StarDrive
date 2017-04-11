package com.terrypaton.math{
	import flash.geom.Point;
	
	public class MathClass {
		
		private static var dx:Number
		private static var dy:Number
		private static var dist:Number
		private static var radians:Number
		private static var angle:Number
		private static var tempPoint:Point
		
		public function MathClass() {
			trace("MathClass init")
		}
		public static function findCircleArea(_radius:Number):Number {
			// finds the radius of circle based on it's radius
			var area:Number = Math.PI * (_radius * _radius)
			return area
		}
		public static function findDistance(_point1:Point, _point2:Point):Number {
			// returns the distance from _point1 to _point2
			dx = _point1.x - _point2.x;
			dy = _point1.y - _point2.y;
			dist = Math.floor(Math.sqrt(dx * dx + dy * dy));
			return dist
		}
		public static function findAngle(_point1:Point, _point2:Point):Number {
			// returns the angle from _point1 to _point2
			dx = _point1.x - _point2.x;
			dy = _point1.y - _point2.y;
			radians = Math.atan2(dy, dx)
			angle = radians * 180 / Math.PI
			return angle
		}
		public static function findRadians(_point1:Point, _point2:Point):Number {
			// returns the radians from _point1 to _point2
			dx = _point1.x - _point2.x;
			dy = _point1.y - _point2.y;
			radians = Math.atan2(dy, dx)
			return radians
		}
		public static function findXYSpeed(_rot:Number,_speed:Number):Point {
			radians = _rot/180*Math.PI
			tempPoint = new Point()
			tempPoint.x = Math.sin(radians)*_speed
			tempPoint.y = Math.cos(radians) * _speed
			return tempPoint
		}
	}
}