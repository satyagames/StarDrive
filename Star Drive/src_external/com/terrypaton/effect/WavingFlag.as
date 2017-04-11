package com.terrypaton.effect {
	import flash.filters.DisplacementMapFilter;
	import flash.display.BlendMode;
	import flash.filters.DisplacementMapFilterMode;
	import flash.display.BitmapDataChannel;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * @author terrypaton1
	 */
	import flash.display.MovieClip;
	public class WavingFlag extends MovieClip {
		public var num1 : Number = 1;
		public var offset0 : Point = new Point();
		public var offset1 : Point = new Point();
		public var offset2 : Object = new Point();
		public var rippleSize : Number = 150;
		private var bmpd : BitmapData;
		private var bmp : DisplayObject;		private var flag : Bitmap		private var _flagBitmapData : BitmapData 

		public function WavingFlag() {
		}

		private var _flagWidth : Number		private var _flagHeight : Number

		public function setup(flagSizeWidth : Number,flagSizeHeight : Number,_scale : Number = 1,_squarecolour : uint = 0x000066,_backgroundColour : uint = 0x000033) : void {
			_flagWidth = flagSizeWidth;			_flagHeight = flagSizeHeight;			
			bmpd = new BitmapData(_flagWidth * _scale, _flagHeight * _scale, false, 0x000022);
			bmp = new Bitmap(bmpd);
			
			//
			offset1.x = 10;
			offset1.y = 10;
			offset0.x = 10;
			offset0.y = 10;
			offset2.x = 10;
			offset2.y = 10;
			
			//var _tempFlag : BitmapData = new BitmapData(160, 0);
			//var _tflag2 : BitmapData = new BitmapData(_tempFlag.width, _tempFlag.height, false, 0x000055);
			//var flagRect : Rectangle = new Rectangle(0, 0, _flagWidth, _flagHeight);			var flagRect : Rectangle = new Rectangle(0, 0, _flagWidth, _flagHeight);
			//_tflag2.copyPixels(_tempFlag, flagRect, new Point());
			//trace("flag rect:"+flagRect);
			var blockSize : int = _flagWidth * .15
			trace("blockSize:")
			
			rippleSize = blockSize * 2.8
			_flagBitmapData = new BitmapData(_flagWidth, _flagHeight, false, _backgroundColour);
			var square : Rectangle = new Rectangle(0, 0, blockSize, blockSize)
			flagRect = new Rectangle(0, 0, _flagWidth, _flagHeight);
			var toggle : Boolean = false
			for (var j : int = 0;j < 10;j += 1) {				for (var i : int = 0;i < 10;i += 2) {
					square.x = i * blockSize 
					if (toggle) {
						square.x += blockSize 					} 					square.y = j * blockSize  
					_flagBitmapData.fillRect(square, _squarecolour)
				}
				toggle = !toggle
			}
			
			
			//
			var matrix : Matrix = new Matrix();
			var scaleVal : Number = 1;
			matrix.scale(scaleVal, scaleVal);
			flagRect.width *= scaleVal;
			flagRect.height *= scaleVal;
			//_flagBitmapData.draw(_tflag2, matrix, null, null, flagRect, true);
			//
			flag = new Bitmap(_flagBitmapData);
			mapPoint = new Point(0, 0);
			channels = BitmapDataChannel.RED;
			componentX = channels;
			componentY = channels;
			
			dmode = DisplacementMapFilterMode.COLOR;
			color = 0;
			dalpha = 0;
			addChild(flag);
			addChild(bmp);
			flag.scaleX = flag.scaleY = _scale			bmp.scaleX = bmp.scaleY = 1
			bmp.blendMode = BlendMode.OVERLAY
			bmp.alpha = .93
		}

		public 	var mapPoint : Point = new Point(0, 0);
		public 	var channels : uint = BitmapDataChannel.RED;
		public 	var componentX : uint = channels;
		public 	var componentY : uint = channels;
		public var scalex : Number = 70;
		public var scaley : Number = 70;
		public var dmode : String = DisplacementMapFilterMode.COLOR;
		public 	var color : uint = 0;
		public 	var dalpha : Number = 0;

		public function dispose() : void {
			bmpd = null			bmp = null			flag = null			_flagBitmapData = null
		}

		public function manage() : void {
			offset0.x += 2;
			offset0.y += 1;
			offset1.y -= 1;
			offset1.x -= 2;
			offset2.y += 1;
			offset2.x += 2;
			bmpd.perlinNoise(rippleSize, rippleSize, num1, 2, true, true, 3, true, [offset0,offset1,offset2]);
			var _filter : DisplacementMapFilter = new DisplacementMapFilter(bmpd, mapPoint, componentX, componentY, scalex, scaley, dmode, color, dalpha);

			var _filtersArray : Array = new Array(_filter);
			flag.filters = _filtersArray;
		}
	}
}





