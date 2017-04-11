package com.terrypaton.effect {
	import data.settings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class WavingImage extends MovieClip {
		public var num1:Number=1;
		public var offset0:Point=new Point();
		public var offset1:Point=new Point();
		public var offset2:Object=new Point();
		public var rippleSize:Number=150;
		private var bmpd:BitmapData;
		private var bmp:DisplayObject;
		private var flag:Bitmap
		private var _flagBitmapData:BitmapData

		public function WavingImage() {
		}
		private var _flagWidth:Number
		private var _flagHeight:Number

		public function setup(flagSizeWidth:Number, flagSizeHeight:Number, _scale:Number=1, _squarecolour:uint=0x000066, _backgroundColour:uint=0x000033):void {
			var _back:a_backgroundClip=new a_backgroundClip()
			addChild(_back)
		/*
		   _flagWidth=flagSizeWidth;
		   _flagHeight=flagSizeHeight;
		   bmpd=new BitmapData((_flagWidth) * _scale, _flagHeight * _scale, false, 0x000022);
		   bmp=new Bitmap(bmpd);
		   //
		   offset1.x=10;
		   offset1.y=10;
		   offset0.x=10;
		   offset0.y=10;
		   offset2.x=10;
		   offset2.y=10;
		   //			_flagBitmapData=new bmpd_underwater(10, 10);
		   _flagBitmapData=new BitmapData(64, 32, false, 0x333333);
		   flag=new Bitmap(_flagBitmapData);
		   mapPoint=new Point(0, 0);
		   channels=BitmapDataChannel.RED;
		   componentX=channels;
		   componentY=channels;
		   dmode=DisplacementMapFilterMode.COLOR;
		   color=0;
		   dalpha=0;
		   addChild(flag);
		   addChild(bmp);
		   flag.scaleX=flag.scaleY=_scale
		   bmp.scaleX=bmp.scaleY=1
		   bmp.blendMode=BlendMode.OVERLAY
		   //
		   flag.x=flag.y=0
		   flag.width=settings.SCREEN_WIDTH
		   flag.height=settings.SCREEN_HEIGHT
		   flag.alpha=.6
		   bmp.alpha=.2
		 */
		}
		public var mapPoint:Point=new Point(0, 0);
		public var channels:uint=BitmapDataChannel.RED;
		public var componentX:uint=channels;
		public var componentY:uint=channels;
		public var scalex:Number=10;
		public var scaley:Number=10;
		public var dmode:String=DisplacementMapFilterMode.COLOR;
		public var color:uint=0;
		public var dalpha:Number=0;

		public function dispose():void {
			bmpd=null
			bmp=null
			flag=null
			_flagBitmapData=null
		}

		public function manage():void {
		/*
		   offset0.x+=2;
		   offset0.y+=1;
		   offset1.y-=1;
		   offset1.x-=2;
		   offset2.y+=1;
		   offset2.x+=2;
		   bmpd.perlinNoise(rippleSize, rippleSize, num1, 2, false, true, 3, true, [offset0, offset1, offset2]);
		   var _filter:DisplacementMapFilter=new DisplacementMapFilter(bmpd, mapPoint, componentX, componentY, scalex, scaley, dmode, color, dalpha);
		   var _filtersArray:Array=new Array(_filter);
		   flag.filters=_filtersArray;
		 */
		}
	}
}