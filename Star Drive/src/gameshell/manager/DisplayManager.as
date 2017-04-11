package gameshell.manager {
	import com.terrypaton.media.SoundManager;
	import data.CopyBank;
	import data.CoreData;
	import data.settings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import game.GameEngine;
	import game.managers.PlayingLoopManager;
	import gameshell.screen.GameComplete;
	import gameshell.screen.GameOver;
	import gameshell.screen.Highscores;
	import gameshell.screen.Intro;
	import gameshell.screen.LevelChooser;
	import gameshell.screen.LevelComplete;
	import gameshell.screen.MainMenu;
	import gameshell.screen.Screen;
//	import gameshell.screen.Upgrade;
	import gameshell.ui.Drive2Button;
	import gameshell.ui.GraphicBtnClass;
	import mochi.as3.*;

	public dynamic class DisplayManager extends MovieClip {
		private static var _instance:DisplayManager

		public static function get Instance():DisplayManager {
			return _instance;
		}

		public function DisplayManager() {
			super();
			// trace("DisplayManager")
			setupGraphics()
			setupListeners()
			_instance=this
		}
		public var currentSceneName:String=""
		// screens vars
		private var _gameEngine:GameEngine
		private var _gameHolder:Sprite
		//
		//
		//assets_screen_challenge
		private var _menuHolder:Sprite
		private var _pauseScreen:assets_pauseOverlay
		private var _soundControls:assets_soundControls
		private var _transitionManager:TransitionManager
		private var levelCompleteRef:GameComplete

		public function cleanupMenus():void {
			//trace("cleanup menus")
			positionSoundControls()
			var n:int=_menuHolder.numChildren
			while (n--) {
				try {
					var _screen:Screen=Screen(_menuHolder.getChildAt(0))
					//	trace("dispose the screen")
					_screen.dispose()
				} catch (e:Error) {
				}
				_menuHolder.removeChildAt(0)
			}
			if (_screen) {
				_screen=null
			}
			//			
			if (_gameEngine) {
				_gameEngine.dispose()
				_gameEngine=null
			}
			if (levelCompleteRef) {
				levelCompleteRef.dispose()
				levelCompleteRef=null
			}
			//			_mainMenu = null
			//			_highscores = null
			// clean up the game too
			n=_gameHolder.numChildren
			while (n--) {
				_gameHolder.removeChildAt(0)
			}
			//_gameEngine = null
			CoreData.Instance.stageRef.focus=stage
		}

		public function getGameOverComment():String {
			// evaluate the player based on how the game went
			var _string:String=""
			return _string
		}

		public function getMenuBackground():Bitmap {
			var menuBitmapData:BitmapData=new BitmapData(640, 480, false, 0x000000)
			return new Bitmap(menuBitmapData)
		}

		public function hidePauseScreen():void {
			removeChild(_pauseScreen)
			CoreData.Instance.stageRef.focus=stage
		}

		public function positionSoundControls(_inGame:Boolean=false):void {
			if (_inGame) {
				_soundControls.x=566
				_soundControls.y=7
			} else {
				_soundControls.x=566
				_soundControls.y=7
			}
		}

		public function setupListeners():void {
			CoreData.Instance.DisplayScreenSignal.add(displayListener)
			//CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS)
			//
			CoreData.Instance.ButtonSignal.add(ButtonListener)
		}

		public function showPauseScreen():void {
			addChild(_pauseScreen)
		}

		private function ButtonListener(btnName:String, btarget:MovieClip):void {
			//trace("btnName:" + btnName)
			var _testLvlBtn:int=btnName.indexOf("level_", 0)
			if (_testLvlBtn > -1) {
				var levelNum:int=int(btnName.slice(6))
				//				Debug.log("ButtonListener " + levelNum)
				CoreData.Instance.currentLevel=levelNum
				CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME)
			}
			switch (btnName) {
				case "quitGameButton":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_MAIN_MENU)
					break
				case "resumeBtn":
					PlayingLoopManager.Instance.gameState=settings.GS_PLAYING
					SoundManager.playSound("snd_resumeGame")
					// remove the pause screen overlay
					trace(" hide the pause screen overlay")
					hidePauseScreen()
					break
				case "submitScoresBtn":
					StuntRun.Instance.submitScores(CoreData.Instance.totalScore)
					var o:Object = { n: [13, 6, 0, 15, 11, 14, 3, 0, 2, 15, 11, 13, 12, 9, 10, 14], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
					var boardID:String = o.f(0,"7c2ddc876db057e8");
					MochiScores.showLeaderboard({boardID: boardID, score: CoreData.Instance.totalScore});
					// hide the clip that sent this event
					//var _btn:GraphicBtnClass=GraphicBtnClass(btarget)
					btarget.visible=false
					break
				case "pauseButton":
					//trace("pauseButton")
					if (PlayingLoopManager.Instance.gameState == settings.GS_PLAYING) {
						PlayingLoopManager.Instance.gameState=settings.GS_PAUSED
						// display the pause screen overlay
						trace(" display the pause screen overlay")
						showPauseScreen()
					}
					break
				case "muteMusicButton":
					// change the appearance of the music button
					SoundManager.toggleMusic()
					evalDisplaySoundButtons()
					StuntRun.Instance._sharedOBJ.setData("sound_playMusic", CoreData.Instance.sound_playMusic)
					trace("muteButton")
					break
				case "muteButton":
					trace("muteButton")
					if (CoreData.Instance.sound_playSfx) {
						CoreData.Instance.sound_playSfx=false
					} else {
						CoreData.Instance.sound_playSfx=true
					}
					evalDisplaySoundButtons()
					StuntRun.Instance.saveUserData()
					break
				case "nextGameBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_CHOOSER)
					break;
				case "startGameBtn":
					//					trace("GO!")
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_CHOOSER)
					break;
				case "goGameBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_CHOOSER)
					break;
				case "mainMenuBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_MAIN_MENU)
					break;
				case "helpBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_HELP)
					break;
				case "highscoresGameWinsBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME_WINS)
					break;
				case "highscoresBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_HIGH_SCORES)
					break;
				case "sponsorLogo":
				case "moreGamesBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_SPONSOR_URL)
					break
				case "upgradeScreenBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_UPGRADE);
					break
				case "medalsBtn":
					CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_MEDALS)
					break;
			}
		}

		public function displayListener(_task:String):void {
			//trace("DISPLAY LISTENER!:", _task)
			switch (_task) {
//				case settings.GO_UPGRADE:
//					goUpgrade(_task)
//					break
				case settings.GO_LEVEL_COMPLETE:
					goLevelComplete(_task)
					break
				case settings.GO_GAME_COMPLETE:
					goGameComplete(_task)
					break
				case settings.CLEAN_UP_MENUS:
					cleanupMenus()
					break
				case settings.GO_GAME:
					goGame(_task);
					break;
				case settings.GO_LEVEL_CHOOSER:
					goLevelChooser(_task);
					break;
				case settings.GO_HIGH_SCORES:
					goHighscores(_task);
					break;
				case settings.GO_MAIN_MENU:
					goMainMenu(_task);
					break;
				case settings.GO_HIGH_SCORES:
					goHighscores(_task)
					break;
				case settings.GO_GAME_OVER:
					goGameOver(_task);
					break;
				case settings.GO_INTRO:
					goIntro(_task);
					break;
			}
		}

		public function evalDisplaySoundButtons():void {
			trace("eval sound sound_playMusic", CoreData.Instance.sound_playMusic)
			trace("eval sound sound_playSfx", CoreData.Instance.sound_playSfx)
			if (CoreData.Instance.sound_playMusic) {
				_soundControls.muteMusicButton.gotoAndStop(1)
			} else {
				_soundControls.muteMusicButton.gotoAndStop(2)
			}
			if (CoreData.Instance.sound_playSfx) {
				_soundControls.muteButton.gotoAndStop(1)
			} else {
				_soundControls.muteButton.gotoAndStop(2)
			}
		}

		private function goGame(scene:String):void {
			CoreData.Instance.amountOfGamesPlayed++
			currentSceneName=scene
			//	trace("go game")
			//				CoreData.Instance.stageRef.stageFocusRect = false
			//			.focusRect = false
			_transitionManager.startTransition(this)
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS)
			positionSoundControls(true)
			var _clip:MovieClip=new MovieClip()
			_clip.focusRect=false
			// add a cover over the game so it fades out
			//_menuHolder.addChild(new ScreenCover());
			_gameEngine=new GameEngine(_clip)
			_gameHolder.addChild(_clip)
			//CoreData.Instance.stageRef.focus = _gameHolder
			//SoundManager.playMusic("music_inGame")
			//SoundManager.playMusic("music_inGame")
			playMainMenuMusic()
			StuntRun.Instance.trackGameStart()
		}

		private function goGameOver(scene:String):void {
			mochi.as3.MochiEvents.trackEvent('Game over', CoreData.Instance.currentLevel);
			StuntRun.Instance.trackGameStop()
			StuntRun.Instance.saveUserData()
			currentSceneName=scene
			//trace("goGameOver")
			//			_transitionManager.startTransition(this)
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS);
			_menuHolder.addChild(new GameOver())
			SoundManager.playMusic("snd_gameOver")
			SoundManager.playMusic("music_gameOver")
		}

		private function goHighscores(scene:String):void {
			//			Solitaire.Instance.hideMochiLogin()
			currentSceneName=scene
			//trace("goHighscores")
			//			_transitionManager.startTransition(this);
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS);
			_menuHolder.addChild(new Highscores());
		}

		private function goIntro(scene:String):void {
			//			Solitaire.Instance.hideMochiLogin()
			currentSceneName=scene
			//			_transitionManager.startTransition(this)
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS)
			_menuHolder.addChild(new Intro())
		}

		private function goLevelChooser(scene:String):void {
			if (CoreData.Instance.resetGameOnceCompleted) {
				CoreData.Instance.resetGameOnceCompleted=false;
				StuntRun.Instance.resetGameData()
			}
			trace("GO TO THE LEVEL CHOOSER")
			currentSceneName=scene
			_soundControls.visible=true
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS);
			//trace(111)
			//			_mainMenu =
			_menuHolder.addChild(new LevelChooser())
			SoundManager.playMusic("music_MainMenu")
			//CoreData.Instance.stageRef.focus = _menuHolder
			//trace(112)
		}

		private function goMainMenu(scene:String):void {
			//trace("MAIN MENU")
			StuntRun.Instance.trackGameStop()
			currentSceneName=scene
			_soundControls.visible=true
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS);
			//			_mainMenu =
			_menuHolder.addChild(new MainMenu())
			setTimeout(playMainMenuMusic, 100)
		}

		private function goGameComplete(scene:String):void {
			StuntRun.Instance.saveUserData()
			currentSceneName=scene
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS)
			_menuHolder.addChild(new GameComplete())
			SoundManager.playSound("snd_gameComplete")
			SoundManager.playMusic("music_levelComplete")
		}

		private function goLevelComplete(scene:String):void {
			StuntRun.Instance.saveUserData()
			currentSceneName=scene
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS)
			_menuHolder.addChild(new LevelComplete())
			SoundManager.playSound("snd_levelComplete")
			SoundManager.playMusic("music_levelComplete")
		}

//		private function goUpgrade(scene:String):void {
//			currentSceneName=scene
//			CoreData.Instance.DisplayScreenSignal.dispatch(settings.CLEAN_UP_MENUS)
//			_menuHolder.addChild(new Upgrade())
//		}
		private function playMainMenuMusic():void {
			SoundManager.playMusic("music_MainMenu")
		}

		private function setupGraphics():void {
			_gameHolder=new Sprite()
			addChild(_gameHolder)
			_menuHolder=new Sprite()
			addChild(_menuHolder)
			_soundControls=new assets_soundControls()
			new GraphicBtnClass(_soundControls.muteButton, false)
			new GraphicBtnClass(_soundControls.muteMusicButton, false)
			addChild(_soundControls)
			_soundControls.visible=false
			_transitionManager=new TransitionManager()
			addChild(_transitionManager)
			_pauseScreen=new assets_pauseOverlay()
			//	CopyBank.setText(_pauseScreen.pauseTitle, "pauseTitle")
			_pauseBtn=new GraphicBtnClass(_pauseScreen.resumeBtn)
			_menuHolder.focusRect=false
			_menuHolder.focusRect=false
			_soundControls.focusRect=false
		}
		private var _pauseBtn:GraphicBtnClass
	}
}