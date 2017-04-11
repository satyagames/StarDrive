package preloader {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;

	// This becomes the new "root" of the movie, so it will exist forever.
	public class AbstractPreloader extends MovieClip {
		private var m_firstEnterFrame : Boolean;
		protected var VALID_URL : Array
	//	private var USE_EXTERNAL : Boolean = true
		private var m_loadTime : int
		protected var m_adLoaded : Boolean = false

		public function AbstractPreloader() {
			addEventListener(Event.ADDED_TO_STAGE, handleOnAddedToStage);
			stop();
		}

		private function handleOnAddedToStage(event : Event) : void {
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			m_loadTime = getTimer()
		}

		public function start() : void {
			trace("start")
			m_firstEnterFrame = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		// It's possible this function will never be called if the load is instant
		protected function updateLoading(a_percent : Number) : void {
		}

		// It's possible this function will never be called if the load is instant
		protected function beginLoading() : void {
		}

		// It's possible this function will never be called if the load is instant, if beginLoading was called, endLoading will be
		protected function endLoading() : void {
		}

		protected function get mainClassName() : String {
			return "Main";
		}

		private function onEnterFrame(event : Event) : void {
			if (m_firstEnterFrame) {
				m_firstEnterFrame = false;

				if (root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal) {
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					nextFrame();
					run()
				} else {
					beginLoading();
				}
				return;
			}

			if (root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				nextFrame();
				run()
				//if (USE_EXTERNAL) initialize();
				endLoading();
			} else {
				var percent : Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
				updateLoading(percent);
			}
		}

		protected function run() : void {
			startMain()
		}

		private function startMain() : void {
			var MainClass : Class = getDefinitionByName(mainClassName) as Class;

			if (MainClass == null) {
				throw new Error("AbstractPreloader:initialize. There was no class matching that name. Did you remember to override mainClassName?");
			}
			var main : DisplayObject = new MainClass() as DisplayObject;

			if (main == null) {
				throw new Error("AbstractPreloader:initialize. Main class needs to inherit from Sprite or MovieClip.");
			}
			MainClass.loadTime = int((getTimer() - m_loadTime) / 1000)
			addChildAt(main, 0);
		}
	}
}