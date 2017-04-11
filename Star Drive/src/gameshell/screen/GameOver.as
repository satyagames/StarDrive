package gameshell.screen {
//	import com.terrypaton.effect.WavingImage;
	import com.terrypaton.events.SaveEvents;
	import com.terrypaton.utils.commaNumber;
	import data.CopyBank;
	import data.CoreData;
	import data.settings;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import gameshell.manager.DisplayManager;
	import gameshell.ui.GameLogo;
	import gameshell.ui.GraphicBtnClass;
	import gameshell.ui.SponsorLogo;

	public dynamic class GameOver extends Screen {
		public function GameOver() {
			//trace("GAME OVER!")
			_clip=new assets_screen_gameover()
			addChild(_clip)
			_logo=new GameLogo(_clip.gamelogo)
			//_clip.backgroundLayer.addChild(DisplayManager.Instance.getMenuBackground())
			//
			_startbtn=new GraphicBtnClass(_clip.startGameBtn)
			_btn=new GraphicBtnClass(_clip.mainMenuBtn)
			//
			submitScoreBtn=new GraphicBtnClass(_clip.submitScoresBtn)
			_clip.submitScoresBtn.visible=false
			if (CoreData.Instance.totalScore > 0) {
				if (CoreData.Instance.mochiHighscoresEnabled || CoreData.Instance.highscoresSubmitEnabled) {
					_clip.submitScoresBtn.visible=true
				}
			}
			//
			CopyBank.setText(_clip.scoreTitleField, "finalScoreTitle")
			_clip.scoreField.text=commaNumber.processNumber(CoreData.Instance.totalScore)
			new SponsorLogo(_clip.sponsorLogo)
//			flag=new WavingImage()
//			_clip.backgroundLayer.addChild(flag)
//			flag.setup(320, 240, 2, 0x753e00, 0x301900)
//			addEventListener(Event.ENTER_FRAME, loop)
			CoreData.Instance.KeyPressedSignal.add(keyListener)
			// display the reason for game over
			switch (CoreData.Instance.gameOverReason) {
				case settings.GAME_OVER_REASION_TIME_RAN_OUT:
					CopyBank.setText(_clip.gameOverMesssage, "GameOverMessage_timeUp")
					break
				case settings.GAME_OVER_REASION_PLAYER_DIED:
					CopyBank.setText(_clip.gameOverMesssage, "GameOverMessage_playerDied")
					break
				default:
					_clip.gameOverMesssage.text=""
					break
			}
		}
		private var _logo:GameLogo
		private var _btn:GraphicBtnClass
		private var _clip:assets_screen_gameover
		private var _startbtn:GraphicBtnClass
//		private var flag:WavingImage
		private var submitScoreBtn:GraphicBtnClass

		override public function dispose():void {
			_logo.dispose()
			_logo=null
//			if (flag) {
//				flag.dispose()
//				_clip.backgroundLayer.removeChild(flag)
//				flag=null
//			}
			_clip=null
			_startbtn.dispose()
			_startbtn=null
			if (_btn) {
				_btn.dispose()
			}
			submitScoreBtn.dispose()
//			removeEventListener(Event.ENTER_FRAME, loop)
			submitScoreBtn=null
			_btn=null
			CoreData.Instance.KeyPressedSignal.remove(keyListener)
			super.dispose()
		}

		public function keyListener(event:KeyboardEvent):void {
			//trace("keyDownHandler: " + event.keyCode);
			switch (event.keyCode) {
				case 32:
					// trace("space pressed in game over")
					// play game button was pressed
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_CHOOSER)
					break
			}
		}
//		public function loop(event:Event):void {
		//	trace("game over screen")
//			flag.manage()
//		}
	}
}