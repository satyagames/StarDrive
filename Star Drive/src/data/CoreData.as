package data {
	import com.terrypaton.utils.SeededRandomNumber;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import game.objects.Player;
	import game.objects.RenderObject;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	public class CoreData {
		private static var _instance:CoreData;

		public static function get Instance():CoreData {
			return _instance;
		}

		public function CoreData():void {
			//	trace("new CoreData")
			//trace("Level data is stored in CoreData")
			include "levelData.xml"
			_instance=this;
		}
		//
		public var longDistanceYahoo:Boolean=false // used to make the player go yahoooo when doing a long jump, gets set to false when the player is on the ground
		//
		public var gameOverReason:int=0;
		public var rotateVelocity:Number=0;
		public var totalDistanceTraveled:Number=0;
		public var levelDistanceTraveled:Number=0;
		public var turboBoostCounter:Number=0;
		public var playerIsOnBack:Boolean=false
		public var playerIsUpsideDown:Boolean=false
		public var playerIsInTheAir:Boolean=false
		public var playerIsInTheAirCounter:int=0
		public var playersCollisionCounter:int=0;
		public var flip90:Boolean=false
		public var flip180:Boolean=false
		public var flip360:Boolean=false
		public var playerRotationChange:int=0; // used for determining if the player has done a flip
		public var playerLastX:Number=0;
		public var playerLastY:int=0;
		public var distanceTravelledInAir:Number=0;
		public var playerRotationAdd:int=0; // used for determining if the player has done a flip
		public var worldHeight:Number=10;
		public var worldWidth:Number=100;
		//
		public var renderingScale:Number=2;
		public var quickBoxObjectsData:Array;
		//
		public var ButtonSignal:Signal;
		public var DisplayScreenSignal:Signal;
		public var GameSignal:Signal;
//		public var ItemArray:Array
		public var KeyPressedSignal:NativeSignal;
		public var KeyReleasedSignal:NativeSignal;
		public var MAP_X_SIZE:int=1;
		public var MAP_Y_SIZE:int=1;
		public var itemsArray:Array
		public var returnToSurfaceMsgShown:Boolean;
		public var OverButtonSignal:Signal;
//		public var TileArray:Array
		public var WheelDistance:Number;
//		public var tempLevelCoins:int=0
		public var amountOfGameLosses:int=0
		public var amountOfGameWins:int=0
		public var amountOfGamesPlayed:int=0
		public var bonusPoints:int=0
		public var bonusTime:int=0
		public var bonusTimePoints:int=0
//		public var artifactsFoundArray:Array=[];
//		public var percentagesArray:Array=[];
		public var resetGameOnceCompleted:Boolean=false
		public var carAngle:Number=0;
		public var carType:int=1;
		public var currentGameTimeElapsed:int=0
		public var currentLevelTime:int;
		public var currentLevel:int=1;
//		public var currentRaceState:RACE_STATE;
		public var damageCountDown:Number;
//		public var depthPressure:Number=0;
		public var tiltLeftPressed:Boolean=false;
		//
		//
//		public var enableGhostCar:Boolean=true
		public var gameEndScore:int=0;
		public var gameTimePassed:int=0
		//		public var movementSpeed:Number = .3
		// timers
		public var gameTimeStart:int=0
		public var gameTimeStop:int=0
		public var gameWasQuit:Boolean=false
//		public var ghostData:Array=[];
		public var groundFriction:Number;
		public var heatMapCol:int=0;
		public var helpActive:Boolean;
		public var helpCountdown:int=0;
		public var helpPageNum:int;
//		public var lapCheckpointsCollected:int;
//		public var lapTimes:Array=[];
		public var lastCheckPoint:RenderObject;
		public var levelDataXML:XML
		//
		// NEW TO DRIVE
		public var levelName:String="";
		//	public var levelTime:int=0;
		//
		public var levelsUnlocked:int=1;
		//		public var backgroundType:int = 1;
		//		public var deckType:int = 1;
		// SKILL ADDICTION RELATED
		public var matchId:int=0;
		public var miniMapReal:BitmapData;
		public var minimapScale:Number;
		// MOCHI COINS RELATED
		public var mochiHighscoresEnabled:Boolean=true;
		public var highscoresSubmitEnabled:Boolean=true;
		public var moveSpeed:Number
//		public var nextCheckpoint:RenderObject;
		public var percentTimeLeft:Number
		public var playerx:Number=0;
		public var playery:Number=0;
//		public var playerCargoLevel:int=0
//		public var playerCargoMax:int=0;
//		public var playerCoins:int=0
//		public var playerEngineLevel:int=0
		public var playerHealth:Number;
//		public var playerHullLevel:int=0
		public var playerLaps:int;
//		public var playerLightSize:Number;
//		public var playerLightsLevel:int=0
//		public var playerMaxOxygen:int=0
		public var playerMaxSpeed:Number;
		public var playerMoveMentSpeed:Number;
		//
		public var playerX:Number;
		public var playerY:Number;
		public var playersMaxDepthPressure:Number=0;
		public var powerUpTimerColour:int;
		public var rotation:Number
		public var score:int;
		public var scoreUndoArray:Array=[];
		public var seeAheadScaling:Number;
		public var seededRandom:SeededRandomNumber
		public var shakeScreenCounter:int=0
		public var shakeScreenScreenAmount:Number=0
		public var shieldBallSpeed:Number
		public var skidScaling:Number;
		public var relicAlreadyCollected:Boolean=false
		public var sound_playMusic:Boolean=true
		public var sound_playSfx:Boolean=true
		public var speedAcceleration:Number;
		public var speedDeceleration:Number;
		public var speedMax:Number;
		public var speedMaxReverse:Number;
		public var stageComplete:Boolean;
		public var lowTimeMessageShown:Boolean;
		public var stageRef:Stage;
		public var tempLevelScore:int=0;
		public var timerColour:int;
		public var totalCheckpoints:int=0;
		public var totalDistance:Number;
		public var totalLaps:int=0;
		public var currentLevelMaxTime:Number
		public var totalLevels:int;
		public var totalScore:int=0
		public var lastLevelPlayed:int=1
		public var totalXMapDistance:Number
		public var totalYMapDistance:Number
		//
		public var playHasStarted:Boolean;
		//
		public var resetPressed:Boolean;
		public var reversePressed:Boolean=false;
		public var tiltRightPressed:Boolean=false;
		public var acceleratePressed:Boolean=false;
		public var waitingOnHelp:Boolean;

		//
		public function clearGameData():void {
		}

		public function resetGame():void {
			playHasStarted=false
			if (gameOverReason > 0) {
				// reset the players score 
				trace("*** reset the players score as they died in the last game ***")
				totalScore=0
				StuntRun.Instance.saveUserData()
			}
			gameOverReason=0
			levelDistanceTraveled=0
			quickBoxObjectsData=[]
			playersCollisionCounter=0
			playerIsOnBack=false
			playerIsInTheAir=false
			flip90=false
			flip180=false
			flip360=false
			trace("reset game")
			itemsArray=[]
//			playerLightSize=2
			tempLevelScore=0
//			tempLevelCoins=0
			returnToSurfaceMsgShown=false
			lowTimeMessageShown=false
//
			playerHealth=100
//			currentRaceState=RACE_STATE.WAITING_FOR_START
			timerColour=0x000000
			powerUpTimerColour=0x999900
			// set the level time
			//
			helpCountdown=60
			waitingOnHelp=false
			helpPageNum=0
			//totalLevelTime = 60 * 30 // (60 seconds)
			stageComplete=false
//			lapCheckpointsCollected=0
			playerLaps=0
			heatMapCol=0
			acceleratePressed=false;
			reversePressed=false;
			tiltRightPressed=false;
			resetPressed=false;
			//
//			ghostData=[];
//
			moveSpeed=0
			damageCountDown=0
			minimapScale=3
			shieldBallSpeed=.1
			skidScaling=.5
			WheelDistance=70
			seeAheadScaling=4
			shakeScreenCounter=0
			shakeScreenScreenAmount=0
			//totalLaps = 2
			var carSettting:int=1
			// setup the players submarine based in the oxygen, hull etc values
		}
		// special ending related
	}
}