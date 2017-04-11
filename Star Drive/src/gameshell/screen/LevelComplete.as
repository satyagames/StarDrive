package gameshell.screen {
	import com.terrypaton.utils.commaNumber;
	import data.CopyBank;
	import data.CoreData;
	import data.StuntRunParticleSettings;
	import data.settings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import game.managers.SRParticleManager;
	import gameshell.ui.GameLogo;
	import gameshell.ui.GraphicBtnClass;
	import gameshell.ui.SponsorLogo;

	public class LevelComplete extends Screen {
		private var _ref:assets_level_complete
		private var _effect:MovieClip
		private var effectArray:Array
		//private var flag:WavingImage
		private var _particleSpriteSheet:BitmapData;

		// [Embed(source="../../../assets/particleSheet.png")]
		//private var particleSheet:Class;
		public function LevelComplete() {
			_ref=new assets_level_complete()
			addChild(DisplayObject(_ref))
			_particleManager=new SRParticleManager();
			_particleSpriteSheet=new a_particleSheet(10, 10);
			particleBitmapData=new BitmapData(640, 480, true, 0x00000000);
			_particleBitmap=new Bitmap(particleBitmapData);
			//			_particleBitmap.
			var _back:a_backgroundClip=new a_backgroundClip()
			_ref.specialEffectsLayer.addChild(_back);
			_ref.specialEffectsLayer.addChild(_particleBitmap);
			// add in a new waving flag
			//flag.setup(320, 240, 2, 0x006600, 0x003300);
			//	flag.scaleX = flag.scaleY = 2
			//
			//
			_startbtn=new GraphicBtnClass(_ref.startGameBtn)
			_btn=new GraphicBtnClass(_ref.mainMenuBtn)
			if (CoreData.Instance.mochiHighscoresEnabled || CoreData.Instance.highscoresSubmitEnabled) {
				submitScoreBtn=new GraphicBtnClass(_ref.submitScoresBtn)
				_ref.submitScoresBtn.visible=true
			} else {
				_ref.submitScoresBtn.visible=false
			}
			_ref.bonusSummaryField.text="Time Bonus:" + commaNumber.processNumber(CoreData.Instance.bonusTimePoints)
			if (CoreData.Instance.bonusPoints > 0) {
				_ref.bonusSummaryField.appendText("\nLow damage bonus:" + commaNumber.processNumber(CoreData.Instance.bonusPoints))
			}
			//
			//	_ref.bonusSummaryField.text=commaNumber.processNumber((CoreData.Instance.tempLevelScore - CoreData.Instance.bonusPoints)) + " + Time Bonus: " + commaNumber.processNumber(CoreData.Instance.bonusPoints)
			CopyBank.setText(TextField(_ref.trackScoreTitleField), "trackScoreTitle")			CopyBank.setText(TextField(_ref.totalScoreTitleField), "totalScoreTitle")
			_ref.trackScoreField.text=commaNumber.processNumber(CoreData.Instance.tempLevelScore)
			_ref.totalScoreField.text=commaNumber.processNumber(CoreData.Instance.totalScore)
			//
			CopyBank.setText(TextField(_ref.levelDistanceTitleField), "levelDistanceTitle")
			CopyBank.setText(TextField(_ref.totalDistanceTitleField), "totalDistanceTitle")
			_ref.levelDistanceField.text=String(CoreData.Instance.levelDistanceTraveled) + " metres"
			_ref.totalDistanceField.text=String(CoreData.Instance.totalDistanceTraveled) + " metres"
			//_ref.msgField.text = ""
			new SponsorLogo(_ref.sponsorLogo)
			CoreData.Instance.KeyPressedSignal.add(keyListener)
		new GameLogo(_ref.gamelogo)
			addEventListener(Event.ENTER_FRAME, loop)
		}
		public var _logo:GameLogo
		public var particleBitmapData:BitmapData
		public var _particleBitmap:Bitmap
		private var _btn:GraphicBtnClass
		private var submitScoreBtn:GraphicBtnClass
		private var _startbtn:GraphicBtnClass
		private var _particleManager:SRParticleManager

		public function loop(event:Event):void {
			//flag.manage()
			particleBitmapData.fillRect(particleBitmapData.rect, 0)
			var mx:Number=Math.random() * settings.SCREEN_WIDTH
			var my:Number=1
			var randomFactor:Number=.15;
			if (Math.random() < randomFactor) {
				_particleManager.createParticles(mx, my, 1, StuntRunParticleSettings.PARTICLE_LEVEL_COMPLETE, Math.random() * 360)
			}
			_particleManager.manageParticles(particleBitmapData, _particleSpriteSheet, 0, 0)
		}

		public function keyListener(event:KeyboardEvent):void {
			//trace("keyDownHandler: " + event.keyCode);
			switch (event.keyCode) {
				case 32:
					//trace("space pressed")
					// play game button was pressed
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_CHOOSER)
					break
			}
		}

		override public function dispose():void {
			//_logo.dispose()
		//	_logo=null
			_particleManager.dispose()
			_particleManager=null
			CoreData.Instance.KeyPressedSignal.removeAll()
			removeEventListener(Event.ENTER_FRAME, loop)
			_ref.specialEffectsLayer.removeChildAt(0);
			_ref.specialEffectsLayer.removeChildAt(0);
//			flag.dispose()
//			_ref.backgroundLayer.removeChild(flag)
//			flag=null
			_ref.dispose()
			_btn.dispose()
			submitScoreBtn.dispose()
			_ref=null			_btn=null
			submitScoreBtn=null
			_startbtn=null			_startbtn.dispose()
			submitScoreBtn=null
			_effect=null
			effectArray=[]
		}
	}
}