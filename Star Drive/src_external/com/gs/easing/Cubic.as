SC /   w      �      .    GetFile          wSC    
      c   '   F      7   B     
 descrip      V   `     	 status   ScFileChanStatus package gs.easing {
	public class Cubic {
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t + b;
		}
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		public st