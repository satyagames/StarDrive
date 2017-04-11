package com.terrypaton.utils{
	import flash.geom.Point
	public class FindSmoothPathBetweenNodes {
		public function FindSmoothPathBetweenNodes():void {
			
		}
	
		public static function getArrayOfPoints(_nodeArray:Array,_evenSpacing:Boolean = false,_dotDistance:Number = 10):Array {
			/**
			 * Pass in an array of points that mark where the main nodes are, this routine will then return an array of points that are pathways between all those nodes
			 * NOTE: The path will only begin from the second node and the second to last node, this is to allow for smooth curve transitions
			 * If the var '_evenSpacing' is set to true, the dots will be draw 'fairly' evenly (the amount of dots between each node will be adjusted), if not the same amount of dots will be draw between each node
			 * the var '_dotDistance' is used with '_evenSpacing=true' and is the amount of pixel spacing required for each dot
			 */	
			if (_dotDistance < .1) {
				_dotDistance = .1
			}
			var pathArray:Array = []
			var theAngle:Number = 0
			var percent:Number = 0
			var percentStepping:Number = 0.05
			var drawCurrentItem:int = 0
			var stopRender:Boolean = false
			var dist:Number 
			while (!stopRender){
				if (percent >= 1) {
					percent = 0;
					drawCurrentItem += 1;
					if (drawCurrentItem < _nodeArray.length - 1) {
						var subItem:Point = _nodeArray[drawCurrentItem - 1];
						var firstItem:Point = _nodeArray[drawCurrentItem];
						var secondItem:Point = _nodeArray[(drawCurrentItem + 1)];
						var thirdItem:Point = _nodeArray[(drawCurrentItem + 2)];
						if (thirdItem == null) {
							theAngle = 0;
							stopRender = true;
						}else {
							var theSubAngle:Number = findTheAngle (subItem, secondItem);
							theAngle = findTheAngle (firstItem, thirdItem);
							//findTheAngle (firstItem, thirdItem);
							if (_evenSpacing) {
								// calcuate the distance for a node stepping
								 dist = findDistance(firstItem, secondItem);
								percentStepping = (_dotDistance / dist)
							}
							var firstDist:Number = findDistance(secondItem, subItem) * .15
							var radians:Number = theSubAngle / 180 * Math.PI;
							var x0speed:Number = Math.cos (radians) * firstDist;
							var y0speed:Number = Math.sin (radians) * firstDist;
							
							var secondDist:Number = findDistance(firstItem, thirdItem) * .15
							radians = theAngle / 180 * Math.PI;
							var xspeed:Number = Math.cos (radians) * secondDist;
							var yspeed:Number = Math.sin (radians) * secondDist;
							var node1:Point = new Point (firstItem.x - x0speed, firstItem.y - y0speed);
							var node2:Point = new Point (secondItem.x + xspeed, secondItem.y + yspeed);
						}
					} else {
						stopRender = true;
					}
				} else {
					var _point:Point = new Point()
					if (firstItem!=null && secondItem !=null&& node1 !=null&& node2 !=null){
						_point.x = findValue (firstItem.x, node1.x, node2.x, secondItem.x, percent);
						_point.y = findValue (firstItem.y, node1.y, node2.y, secondItem.y, percent);
						pathArray.push(_point)
					}
				}
				percent += percentStepping
			}
			return pathArray
		}
		public static function findDistance(_point1:Point, _point2:Point):Number {
			// returns the distance from _point1 to _point2
			var dx:Number = _point1.x - _point2.x;
			var dy:Number = _point1.y - _point2.y;			
			return Math.floor(Math.sqrt(dx * dx + dy * dy))
		}
		private static function findTheAngle (point1:Point, point2:Point):Number {
			// find the angle between to points
			var px:Number = point1.x - point2.x;
			var py:Number = point1.y - point2.y;
			var radians:Number = Math.atan2 (py, px);
			var tempAngle:Number = Math.floor (radians * 180 / Math.PI);
			return tempAngle;
		}
		
		private static function findValue (point0:Number, point1:Number, point2:Number, point3:Number, time:Number):Number {
			
			var timeSub:Number = (1 - time);
			var returnVal:Number = Math.pow (timeSub, 3) * point0;
			returnVal += 3 * time * Math.pow (timeSub, 2) * point1;
			returnVal += 3 * Math.pow (time, 2) * timeSub * point2;
			returnVal += Math.pow (time, 3) * point3;
			return returnVal;
		}
		
	
		
	}
	
}