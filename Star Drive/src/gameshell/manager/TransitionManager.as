package gameshell.manager {
	import com.gs.TweenLite;
	import data.settings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	//import flash.geom.ColorTransform;
	//import flash.geom.Matrix;
	//import flash.geom.Point;
	//import flash.geom.Rectangle;
	public class TransitionManager extends MovieClip {
		public function TransitionManager() {
//			trace("TransitionManager")
			this.mouseEnabled = false
			this.mouseChildren = false
			_bmpData = new BitmapData(settings.SCREEN_WIDTH, settings.SCREEN_HEIGHT, false, 0x000000)
			_bmp = new Bitmap(_bmpData)
//			addChild(_bmp)
		}
	//	private var matrix:Matrix = new Matrix()

		public function startTransition(_screen:MovieClip):void {
//			trace("HEY")
			// capture the sprite passed as a bitmapData and then fade it out
			removeEventListener(Event.ENTER_FRAME, loop)
			addEventListener(Event.ENTER_FRAME, loop)
			try {
				_bmpData.draw(_screen)
			} catch (e:Error) {
			}
			_slices = []
			var yLoc:int = 0
			var step:Number = 0
			var toggle:Boolean = true
			var _delay:Number = 0
			// split the screen up
//			for (var i : int = 0; i < splitArray.length; i++) {
			while (yLoc < 480) {
				step += (10 + int(Math.random() * 5))
				var _bmpD:BitmapData = new BitmapData(settings.SCREEN_WIDTH, step, false, 0x000000)
				var _bmp:Bitmap = new Bitmap(_bmpD)
		//		var rect:Rectangle = new Rectangle(0, yLoc, settings.SCREEN_WIDTH, step)
//				_bmpD.copyPixels(_bmpData, rect, new Point(0, 0))
				_bmp.y = yLoc
				yLoc += step
				addChild(_bmp)
				var time:Number = .75 + Math.random() * .25
				if (toggle) {
//					TweenLite.to(_bmp, time, {x: -_bmp.width, tint: 0xFFFFFF})
					TweenLite.to(_bmp, time, {x: -_bmp.width, delay: _delay})
				} else {
//					TweenLite.to(_bmp, time, {x: settings.SCREEN_WIDTH, tint: 0xFFFFFF})
					TweenLite.to(_bmp, time, {x: settings.SCREEN_WIDTH, delay: _delay})
				}
				toggle = !toggle
				_slices.push(_bmp)
			}
			count = 60;
//			cTransform.alphaMultiplier = .98;
		}
	//	private var scrollSpeed:int
		private var _slices:Array

		public function loop(event:Event):void {
			//trace(count)
			count--
			if (count < 1) {
//				_bmpData.fillRect(_bmpData.rect, 0)
// remove all the clips
				var n:int = this.numChildren
				while (n--) {
					this.removeChildAt(0)
				}
				removeEventListener(Event.ENTER_FRAME, loop)
			} else {
				// transition the image
//				_bmpData.colorTransform(_bmpData.rect, cTransform)
			}
		}

		public function get Instance():TransitionManager {
			return _instance
		}
	//	private var transitionStep:Number
		private var count:int
		private var _instance:TransitionManager
		private var _bmp:Bitmap
		private var _bmpData:BitmapData
	//	private var zeroPoint:Point = new Point(0, 0)
	//	private var cTransform:ColorTransform = new ColorTransform();
	}
}