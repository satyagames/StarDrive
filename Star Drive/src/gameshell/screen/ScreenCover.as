package gameshell.screen {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	public dynamic class ScreenCover extends Screen {
		public function ScreenCover() {
			_clip = new Sprite()
			var _shape : Shape = new Shape()
			_shape.graphics.beginFill(0xff0000)
			_shape.graphics.drawRect(0, 0, 640, 480)
			_clip.addChild(_shape)
			addChild(DisplayObject(_clip))
			
			addEventListener(Event.ENTER_FRAME, loop)
			//
		}

		private function loop(event : Event) : void {
			trace("this should probably fade out")
			_clip.alpha -=.15
			if (_clip.alpha<.05){
				
			}
		}

		private var _clip : Sprite;

		override public function dispose() : void {
			removeEventListener(Event.ENTER_FRAME, loop)
			
			_clip = null
			super.dispose()
		}
	}
}