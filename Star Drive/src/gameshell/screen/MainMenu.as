package gameshell.screen {
	import com.terrypaton.effect.WavingImage;
	import data.CoreData;
	import data.StuntRunParticleSettings;
	import data.settings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.setTimeout;
	import game.managers.SRParticleManager;
	import game.objects.StuntRunParticle;
	import gameshell.ui.GameLogo;
	import gameshell.ui.GraphicBtnClass;
	import gameshell.ui.SponsorLogo;

	public dynamic class MainMenu extends Screen {
		public function MainMenu() {
			setupMainMenu()
		}
		//	public var _bubblesBitmap:Bitmap
		//public var _particleManager:DSDParticleManager
		//private var _bubblesBitmapData:BitmapData
		private var _highscoresBtn:GraphicBtnClass
		private var _startbtn:GraphicBtnClass
		//private var flag:WavingImage
		private var loopX:Number=0
		private var loopY:Number=0
		private var ref:assets_screen_mainMenu

		override public function dispose():void {
			trace("****dispose of the main menu")
			_startbtn.dispose();
			_highscoresBtn.dispose();
			_startbtn=null
			_highscoresBtn=null
			//
			//
			CoreData.Instance.KeyPressedSignal.remove(keyListener)
			_sponsorLogo.dispose()
			_sponsorLogo=null
			_logo.dispose()
			_logo=null
			ref=null;
//			removeEventListener(Event.ENTER_FRAME, loop)
			super.dispose();
		}

		public function keyListener(event:KeyboardEvent):void {
			//trace("keyDownHandler: " + event.keyCode);
			switch (event.keyCode) {
				case 32:
					trace("space pressed")
					// play game button was pressed
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_CHOOSER)
					// destroy the key listener
					break
			}
		}

//		public function loop(event:Event):void {
//			//	trace("main menu")
//		}

		public function setupKeyPress():void {
			CoreData.Instance.KeyPressedSignal.add(keyListener)
//			addEventListener(Event.ENTER_FRAME, loop)		}
		private var _sponsorLogo:SponsorLogo
		private var _logo:GameLogo

		public function setupMainMenu():void {
			ref=new assets_screen_mainMenu()
			addChild(DisplayObject(ref))
			_logo=new GameLogo(ref.gamelogo)
			_startbtn=new GraphicBtnClass(ref.startGameBtn)
			_highscoresBtn=new GraphicBtnClass(ref.highscoresBtn)
			if (!CoreData.Instance.mochiHighscoresEnabled) {
				ref.highscoresBtn.visible=false;
			}
			_sponsorLogo=new SponsorLogo(ref.sponsorLogo)
			setTimeout(setupKeyPress, 100)
//			var _back:a_backgroundClip=new a_backgroundClip()
//			ref.backgroundHolder.addChild(_back);
		}
	}
}