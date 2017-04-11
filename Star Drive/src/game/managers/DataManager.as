package game.managers {
	import com.terrypaton.media.SoundManager;
	import data.CopyBank;
	import data.CoreData;
	import data.GameSignals;
	import data.RACE_STATE;
	import data.StuntRunParticleSettings;
	import data.settings;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import game.objects.Checkpoint;
	import game.objects.Item;
	import game.objects.OBJECT_TYPE;
	import game.objects.Player;
	import game.objects.Points;
	import game.objects.RenderObject;
	import game.objects.Scenery;
	import game.objects.enemy.EnemyBase;
	import game.objects.enemy.Enemy_1;

	public class DataManager {
		private static var _instance:DataManager;

		public static function get Instance():DataManager {
			return _instance;
		}

		public function DataManager() {
			_instance=this
		}
		public var generateMapCounter:int=0;
		public var generateMapTotal:int=0;
		private var _CD:CoreData
		private var _object:RenderObject
		private var _renderXloc:Number;
		private var _renderYloc:Number;
		private var _xloc:int;
		private var _yloc:int;
		private var i:int;
		private var objectType:OBJECT_TYPE;
		private var playedTimeWarningSound:Boolean=false;

		public function addPoints(_points:int):void {
			CoreData.Instance.tempLevelScore+=_points;
			if (CoreData.Instance.tempLevelScore < 0) {
				CoreData.Instance.tempLevelScore=0;
			}
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.UPDATE_HUD)
		}

		public function calculateFinalScore():void {
			// if the player hasn't taken any damage, then give them bonus points
			CoreData.Instance.bonusPoints=0
			if (CoreData.Instance.playerHealth > 89) {
				trace("player gets bonus points for making it through the level with greater than 90% health")
				CoreData.Instance.bonusPoints=CoreData.Instance.currentLevel * 2500
			}
			// give the player points based on how much time they have left after finishing the level
			var timePercent:Number=1 - (CoreData.Instance.currentLevelTime / CoreData.Instance.currentLevelMaxTime)
			CoreData.Instance.bonusTimePoints=timePercent * 10000
			//
			CoreData.Instance.tempLevelScore+=CoreData.Instance.bonusPoints
			CoreData.Instance.tempLevelScore+=CoreData.Instance.bonusTimePoints
			//
			if (CoreData.Instance.tempLevelScore > 0) {
				SoundManager.playSound("snd_permanentPoints")
				CoreData.Instance.totalScore+=CoreData.Instance.tempLevelScore;
				//trace("CoreData.Instance.trackScore :" + CoreData.Instance.trackScore)
				CoreData.Instance.DisplayScreenSignal.dispatch(settings.UPDATE_HUD)
				//
				StuntRun.Instance.saveUserData()
			}
			CoreData.Instance.totalDistanceTraveled+=CoreData.Instance.levelDistanceTraveled
			CoreData.Instance.totalDistanceTraveled=Math.floor(CoreData.Instance.totalDistanceTraveled * 100) / 100
			CoreData.Instance.levelDistanceTraveled=Math.floor(CoreData.Instance.levelDistanceTraveled * 100) / 100
			trace("FINAL SCORE = " + CoreData.Instance.totalScore)
		}

		public function dispose():void {
			CoreData.Instance.GameSignal.remove(gameSignalListener)
			objectType=null
			if (_object) {
				_object.dispose()
				_object=null
			}
			_instance=null
			_CD=null
		}

		public function gameSignalListener(_task:String):void {
			//			trace("GAME SIGNAL LISTENER!:", _task)
			switch (_task) {
				case GameSignals.PLAYER_DAMAGED:
					// go ahead and damage the player
					hurtPlayer(2, CoreData.Instance.playerx, CoreData.Instance.playery + .5)
					break
			}
		}

//		public function givePlayerCoins(coinValue:int):void {
//			CoreData.Instance.tempLevelCoins+=coinValue
//			CoreData.Instance.DisplayScreenSignal.dispatch(settings.UPDATE_HUD)
//		}
		public function hurtPlayer(damage:Number, x:int, y:int):void {
			CoreData.Instance.damageCountDown=15
			CoreData.Instance.playerHealth-=damage
			SoundManager.playSound(("snd_playerCrash_" + int(Math.random() * 4 + 1)), .5)
			//			CoreData.Instance.shakeScreenCounter+=20
			//			CoreData.Instance.shakeScreenScreenAmount+=10
			//	trace(CoreData.Instance.playerOxygen)
			if (CoreData.Instance.playerHealth < 1) {
				CoreData.Instance.playerHealth=0
				//trace("PLAYER DIES!")
				RenderManager.Instance.displayMessage(CopyBank.getText("outOfOxygen"))
				CoreData.Instance.gameOverReason=settings.GAME_OVER_REASION_PLAYER_DIED
				PlayingLoopManager.Instance.gameState=settings.GS_GAME_OVER
				QBox2DManager.Instance.stopEngine()
				SoundManager.playSound("snd_playerDies")
					// stop the physic engine
			}
			RenderManager.Instance.addParticles(x * settings.WORLD_SCALE * CoreData.Instance.renderingScale + 50, y * settings.WORLD_SCALE * CoreData.Instance.renderingScale + 30, StuntRunParticleSettings.PARTICLE_PLAYER_HURT, 6);
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.UPDATE_HUD)
		}

		public function init():void {
			// display the progress meter
			//			_instance=this
			CoreData.Instance.GameSignal.add(gameSignalListener)
			//			trace("init")
			playedTimeWarningSound=false
			_CD=CoreData.Instance;
			//			trace("initComplete")
			//CoreData.Instance.levelName=String(currentLevelXML.name)
			CoreData.Instance.seededRandom.seed=CoreData.Instance.currentLevel
			CoreData.Instance.seededRandom.nextInt();
			//
		}

		public function initComplete():void {
		}

		public function manageData():void {
			if (CoreData.Instance.playHasStarted) {
				CoreData.Instance.currentLevelTime--
			}
			if (CoreData.Instance.currentLevelTime <= 1) {
				//	trace("time up")
				RenderManager.Instance.displayMessage(CopyBank.getText("timeUp"))
				CoreData.Instance.gameOverReason=settings.GAME_OVER_REASION_TIME_RAN_OUT
				PlayingLoopManager.Instance.gameState=settings.GS_GAME_OVER
			}
			// create an exhaust particle
			if (Math.random() < .2) {
				var smokeX:Number=CoreData.Instance.playerx - Math.cos(QBox2DManager.Instance.carDirectionRadian) * 1.1
				var smokeY:Number=CoreData.Instance.playery - Math.sin(QBox2DManager.Instance.carDirectionRadian) * .1
				RenderManager.Instance.addParticles(smokeX * settings.WORLD_SCALE * CoreData.Instance.renderingScale, smokeY * settings.WORLD_SCALE * CoreData.Instance.renderingScale, StuntRunParticleSettings.PARTICLE_EXHAUST_SMOKE, 1);
			}
			if (!CoreData.Instance.helpActive) {
				if (CoreData.Instance.damageCountDown > 0) {
					CoreData.Instance.damageCountDown--
				}
				// work out how much time has passed
				var currentSubTime:uint=CoreData.Instance.gameTimePassed + (getTimer() - CoreData.Instance.gameTimeStart);
				CoreData.Instance.currentGameTimeElapsed=currentSubTime;
					//	trace(testMapArrayCollision(_CD.player.x, _CD.player.y))
					// check if the game is over
			}
			QBox2DManager.Instance.manage()
			// find the distance the player has travelled
			//	CoreData.Instance.levelDistanceTraveled +=
		}

		public function stageComplete():void {
			trace(" START THE LEVEL COMPLETE SEQUENCE HERE")
		}

		public function startGameTimer():void {
			CoreData.Instance.gameTimeStart=getTimer()
		}

		public function stopGameTimer():void {
			CoreData.Instance.gameTimeStop=getTimer()
		}
	}
}