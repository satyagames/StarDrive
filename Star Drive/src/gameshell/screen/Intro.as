package gameshell.screen {
	import flash.display.DisplayObject;

	import data.CoreData;

	import com.terrypaton.utils.Broadcaster;

	import data.settings;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import mochi.as3.*;
		
	import gameshell.events.ShellEvents;
	public dynamic class Intro extends Screen {
		public function Intro() {
			_clip = new assets_screen_Intro()
			_clip.x = settings.SCREEN_WIDTH * .5
			_clip.y = settings.SCREEN_HEIGHT * .5
			addChild(DisplayObject(_clip))
			
			_clip.buttonMode = true
			_clip.addEventListener(MouseEvent.CLICK, introClicked)
			addEventListener(Event.ENTER_FRAME, loop)
			//
			/*MochiServices.connect("657c43c98b85eab0", root);
			MochiAd.showPreGameAd({clip:root, id:"657c43c98b85eab0", res:"640x480",ad_finished:startGame});*/
		}
		/*private function startGame() : void {
			
				CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_MAIN_MENU)
				_clip = null
		}*/
		private function loop(event : Event) : void {
			if (_clip.currentFrame >= _clip.totalFrames) {
				CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_MAIN_MENU)			}
		}

		private function introClicked(event : Event) : void {
			Broadcaster.dispatchEvent(new ShellEvents(ShellEvents.GO_SPONSOR_URL))
		}

		private var _clip : assets_screen_Intro;

		override public function dispose() : void {
			removeEventListener(Event.ENTER_FRAME, loop)
			_clip = null
			super.dispose()
		}
	}
}