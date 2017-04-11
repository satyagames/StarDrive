package com.terrypaton.effect {
	import flash.display.*
	import flash.geom.Matrix;
	
	public class PixelateBitmap {
		public function PixelateBitmap ():void {
			_instance = this
			
		}
		public function setup (_bitmapData:BitmapData):void {
			_bmpData = _bitmapData
		}
		public function process (_source:BitmapData,amount:Number):void {
			
			var scaleFactor:Number = 1 / amount
			var bmpX:int = scaleFactor*_bmpData.width
			var bmpY:int = scaleFactor * _bmpData.height
			if (bmpX < 1) {
				bmpX = 10
			}
			if (bmpY < 1) {
				bmpY = 10
			}
			// scale image down
			_pixelateMatrix.identity ()
			_pixelateMatrix.scale (scaleFactor, scaleFactor)
			try {
				var _tempBmpData:BitmapData = new BitmapData (bmpX,bmpY,false,0xFF0000)
			}catch (e:Error) {
				trace("bmpX = "+bmpX)
				trace("bmpY = "+bmpY)
			}
			
			_tempBmpData.draw (_source, _pixelateMatrix)
			// now scale it back
			_pixelateMatrix.identity ()
			_pixelateMatrix.scale (amount, amount)
			
			_bmpData.draw(_tempBmpData,_pixelateMatrix)
		}
		public var _pixelateMatrix:Matrix = new Matrix()
		public var _bmpData:BitmapData
		
		public static function getInstance():PixelateBitmap {
			return _instance
		}
		public static var _instance:PixelateBitmap
	}
}