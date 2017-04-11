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
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.text.TextField;
	
	import game.managers.SRParticleManager;
	
	import gameshell.ui.GameLogo;
	import gameshell.ui.GraphicBtnClass;
	import gameshell.ui.SponsorLogo;

	public class GameComplete extends Screen {
		private var _particleManager:SRParticleManager
		private var _ref:assets_screen_game_complete
		private var _standardEndingNumber:int
		public var particleBitmapData:BitmapData
		public var _particleBitmap:Bitmap
		private var _effect:MovieClip
		private var effectArray:Array
		private var submitScoreBtn:GraphicBtnClass
		// [Embed(source="../../../assets/particleSheet.png")]
		//private var particleSheet : Class;
		private var _particleSpriteSheet:BitmapData;
		private var _btn:GraphicBtnClass
		private var _menubtn:GraphicBtnClass

		public function GameComplete() {
			_ref=new assets_screen_game_complete()
			addChild(DisplayObject(_ref))
			//
			// = new TButton("mainMenuBtn", 110, 42, 0x000000, 0xfebf0f)
			//			addChild(_btn)
			//			_btn.x = settings.SCREEN_WIDTH - _btn.width - 30
			//			_btn.y = 418
			//
			//			_particleBitmap.
			// add in a new waving flag
			_menubtn=new GraphicBtnClass(_ref.mainMenuBtn)
			submitScoreBtn=new GraphicBtnClass(_ref.submitScoresBtn)
			if (CoreData.Instance.mochiHighscoresEnabled || CoreData.Instance.highscoresSubmitEnabled) {
				_ref.submitScoresBtn.visible=true
			} else {
				_ref.submitScoresBtn.visible=false
			}
			_ref.bonusSummaryField.text=commaNumber.processNumber((CoreData.Instance.tempLevelScore - CoreData.Instance.bonusPoints)) + " + Time Bonus: " + commaNumber.processNumber(CoreData.Instance.bonusPoints)
			CopyBank.setText(TextField(_ref.trackScoreTitleField), "trackScoreTitle")
			CopyBank.setText(TextField(_ref.totalScoreTitleField), "finalScoreTitle")
			_ref.trackScoreField.text=commaNumber.processNumber(CoreData.Instance.tempLevelScore)
			_ref.totalScoreField.text=commaNumber.processNumber(CoreData.Instance.totalScore)
			//_ref.msgField.text = ""
			_sponsorLogo=new SponsorLogo(_ref.sponsorLogo)
			_particleManager=new SRParticleManager()
			_particleSpriteSheet=new a_particleSheet(10, 10)
			particleBitmapData=new BitmapData(160, 120, true, 0x00000000)
			_particleBitmap=new Bitmap(particleBitmapData,PixelSnapping.AUTO,true)
			_particleBitmap.y = 50
			//			_particleBitmap.
			_ref.specialEffectsLayer.addChild(_particleBitmap)
//			_ref.specialEffectsLayer.addChild(_particleBitmap)
			_particleBitmap.scaleX=_particleBitmap.scaleY=4
			_standardEndingNumber=int(Math.random() * 10)
			//			_standardEndingNumber = STANDARD_ENDING_4
			// now reset the game
			CoreData.Instance.resetGameOnceCompleted=true
			new GameLogo(_ref.gamelogo)
			addEventListener(Event.ENTER_FRAME, loop)
		}
		private var _sponsorLogo:SponsorLogo

		public function loop(event:Event):void {
//			trace("game complete screen")
			
			particleBitmapData.fillRect(particleBitmapData.rect, 0)
				var n:int =2
					while (n--){
			var mx:Number=Math.random() * (particleBitmapData.width - 20) + 10
			var my:Number=particleBitmapData.height - 2
			_particleManager.createParticles(mx, my, 1, StuntRunParticleSettings.PARTICLE_FIRE, Math.random() * 360)
					}
			_particleManager.manageParticles(particleBitmapData, _particleSpriteSheet, 0, 0)
				
		}

		override public function dispose():void {
			_sponsorLogo.dispose()
			_sponsorLogo=null
			trace("&&&&&&&& DISPOSE")
			removeEventListener(Event.ENTER_FRAME, loop)
			_particleManager.dispose()
			_particleManager=null
			particleBitmapData=null
			_particleBitmap=null
			_ref.specialEffectsLayer.addChild(_particleBitmap)
			if (_btn) {
				_btn.dispose()
				_btn=null
			}
			_menubtn.dispose()
			_menubtn=null
			_ref=null
			submitScoreBtn.dispose()
			submitScoreBtn=null
			_effect=null
			effectArray=[]
			super.dispose()
		}
	}
}