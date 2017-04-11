package game.managers {
	import com.terrypaton.events.PlayingLoopEvent;
	import data.CoreData;
	import data.settings;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.getTimer;
	import mochi.as3.MochiEvents;

	//import com.terrypaton.utils.SharedObjectManager
	//import com.terrypaton.effect.particleManagerClass
	//import com.gameshell.GameShellEvents
	public class PlayingLoopManager extends MovieClip {
		private static var _CD:CoreData
		private static var _RM:RenderManager
		private static var _instance:PlayingLoopManager

		public static function get Instance():PlayingLoopManager {
			return _instance
		}

		public function PlayingLoopManager():void {
			_CD=CoreData.Instance
			if (!_instance) {
				_instance=this
			} else {
				trace("PlayingLoopManager already exists")
					//return _instance
			}
			CoreData.Instance.ButtonSignal.add(ButtonListener);
		}
		public var counter:int
		public var gameState:int

		public function dispose():void {
			_instance=null
			_RM=null
			_CD=null
			stopLoop()
		}

		public function gameLoop(event:Event):void {
			_RM=RenderManager.Instance
			switch (gameState) {
				case settings.GS_PLAYING:
					// run the game loop
					DataManager.Instance.manageData()
					RenderManager.Instance.render()
					//	trace("QB:"+QBox2DManager.Instance.canvas.stage)
					// display the help if neccesary
					break;
				case settings.GS_WAITING_ON_HELP:
					if (!CoreData.Instance.waitingOnHelp) {
						RenderManager.Instance.showHelp()
						CoreData.Instance.helpPageNum++
						CoreData.Instance.waitingOnHelp=true
						trace("CoreData.Instance.helpPageNum>" + CoreData.Instance.helpPageNum)
						if (CoreData.Instance.helpPageNum > settings.NUMBER_OF_HELP_PAGES) {
							RenderManager.Instance.hideHelp()
							CoreData.Instance.helpActive=false;
							gameState=settings.GS_PLAYING
						}
					} else {
						//
					}
					DataManager.Instance.manageData()
					RenderManager.Instance.render()
					break
				case settings.GS_INIT:
					// initialise everything
//					DataManager.Instance.generateMap()
					DataManager.Instance.init()
					DataManager.Instance.manageData()
					RenderManager.Instance.render()
					if (CoreData.Instance.helpActive) {
						CoreData.Instance.waitingOnHelp=false
						gameState=settings.GS_WAITING_ON_HELP;
					} else {
						gameState=settings.GS_PLAYING;
					}
					break;
				case settings.GS_LEVEL_COMPLETE:
					// save the users data ready for exiting
					DataManager.Instance.calculateFinalScore()
					DataManager.Instance.stopGameTimer()
					RenderManager.Instance.startDarkenScreen()
					counter=30
					gameState=settings.GS_LEVEL_COMPLETE_WAIT
					break
				case settings.GS_LEVEL_COMPLETE_WAIT:
					// darken the screen
					RenderManager.Instance.darkenScreen()
					counter--
					if (counter < 1) {
						gameState=settings.GS_LEVEL_COMPLETE_WAIT_2
//						CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_UPGRADE)
						if (CoreData.Instance.currentLevel >= CoreData.Instance.levelsUnlocked - 1) {
							CoreData.Instance.levelsUnlocked++
						}
						CoreData.Instance.amountOfGameWins++
						if (CoreData.Instance.currentLevel == CoreData.Instance.totalLevels) {
							CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME_COMPLETE)
						} else {
							CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_COMPLETE)
						}
					}
					break
				case settings.GS_LEVEL_COMPLETE_WAIT_2:
					break
				case settings.GS_GAME_COMPLETE:
					trace("game complete!")
					if (CoreData.Instance.mochiHighscoresEnabled) {
						mochi.as3.MochiEvents.trackEvent('game completed', CoreData.Instance.currentLevel);
					}
					counter=5
					StuntRun.Instance.gameCompleteTracking()
					DataManager.Instance.calculateFinalScore()
					DataManager.Instance.stopGameTimer()
					gameState=settings.GS_GAME_COMPLETE_WAIT
					break;
				case settings.GS_GAME_COMPLETE_WAIT:
					counter--
					if (counter < 1) {
						stopLoop()
						CoreData.Instance.amountOfGameWins++
						trace("go game over")
						CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME_COMPLETE)
//						CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_COMPLETE)
						//Broadcaster.dispatchEvent(new ShellEvents(ShellEvents.GO_STANDARD_GAME_COMPLETE))
						gameState=settings.GS_GAME_COMPLETE_WAIT_2
					}
				case settings.GS_PAUSED:
					break
				case settings.GS_GAME_OVER:
					StuntRun.Instance.gameCompleteTracking()
					DataManager.Instance.calculateFinalScore()
					DataManager.Instance.stopGameTimer()
					CoreData.Instance.amountOfGameLosses++
					gameState=settings.GS_GAME_OVER_WAIT
					counter=30
					break
				case settings.GS_GAME_OVER_WAIT:
					counter--
					if (counter < 1) {
						gameState=settings.GS_GAME_OVER_WAIT_2
						CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME_OVER)
							//Broadcaster.dispatchEvent(new ShellEvents(ShellEvents.GO_GAME_OVER))
					}
					break
				case settings.GS_GAME_COMPLETE_WAIT_2:
				case settings.GS_GAME_OVER_WAIT_2:
					break
			}
		}

		public function setupNewGame(e:PlayingLoopEvent):void {
			//			trace("SETUP NEW GAME")
			gameState=settings.GS_PLAYING
		}

		public function startCounter(_num:int):void {
			counter=_num
		}

		public function startLoop():void {
			//			trace("* startLoop")
			addEventListener(Event.ENTER_FRAME, gameLoop)
		}

		public function stopLoop():void {
			removeEventListener(Event.ENTER_FRAME, gameLoop)
		}

		private function ButtonListener(btnName:String, btarget:MovieClip):void {
			//trace("btnName:" + btnName)
			switch (btnName) {
				case "exitSubBtn":
					trace("exit the sub")
					gameState=settings.GS_LEVEL_COMPLETE
					break
			}
		}
	}
}