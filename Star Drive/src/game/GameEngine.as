package game {
	import data.CoreData;
	import data.GameSignals;
	import data.settings;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import game.managers.DataManager;
	import game.managers.PlayingLoopManager;
	import game.managers.QBox2DManager;
	import game.managers.RenderManager;

	[SWF(width="640", height="480", backgroundColor="#000000", frameRate="31")]
	public dynamic class GameEngine extends MovieClip {
		private var _cd:CoreData
		private var ref:MovieClip

		//
		public function GameEngine(_ref:MovieClip) {
			super();
			ref=_ref
			init()
		}
		private var helpKeyTimer:uint=0		private var helpKeyMonitor:Boolean=false

		public function keyDownHandler(event:KeyboardEvent):void {
			//	trace("keyDownHandler: " + event.keyCode);
			if (!helpKeyMonitor) {
				if (CoreData.Instance.helpActive) {
					if (helpKeyTimer == 0) {
						helpKeyTimer=getTimer()
					} else {
						var nowTime:uint=getTimer() - helpKeyTimer
						if (nowTime > 200) {
							//
							// check that a small amount of time has passed since help was last pressed
							helpKeyMonitor=true
							CoreData.Instance.waitingOnHelp=false;
							helpKeyTimer=getTimer()
						} else {
							//	trace("key pressed too soon")
						}
					}
				}
			}
			if (!CoreData.Instance.helpActive) {
				switch (event.keyCode) {
					case 71:
						//_cd.enableGhostCar=!_cd.enableGhostCar;
						//trace("GHOST CAR TOGGLED")
						break;
					case 88:
					case 39:
						_cd.tiltRightPressed=true;
						break;
					case 90:
					case 37:
						_cd.tiltLeftPressed=true;
						break;
					case 32:
						_cd.resetPressed=true;
						break;
					case 38:
						_cd.acceleratePressed=true;
						_cd.playHasStarted=true;
						break;
					case 40:
						_cd.reversePressed=true;
						break;
					case 84:
						//	PlayingLoopManager.Instance.gameState = settings.GS_LEVEL_COMPLETE
						break;
					case 80:
						// the key 'p'
						break
					case 192:
						// show the stats
						statSprite.visible=!statSprite.visible;
						break;
					case 220:
						// OUTPUT THE LEVEL DATA BY PRESSING THE ' \ ' key
						//				outputLevelData()
						break
				}
			}
		}
		private var statSprite:Sprite=new Sprite()

		//private var _holder : MovieClip 
		public function keyUpHandler(event:KeyboardEvent):void {
			helpKeyMonitor=false
			trace("keyUpHandler: " + event.keyCode);
			if (!CoreData.Instance.helpActive) {
				switch (event.keyCode) {
					case 88:
					case 39:
						_cd.tiltRightPressed=false;
						break;
					case 90:
					case 37:
						_cd.tiltLeftPressed=false;
						break;
					case 32:
						QBox2DManager.Instance.resetPlayer()
						_cd.resetPressed=false;
						break
					case 38:
						_cd.acceleratePressed=false;
						break;
					case 40:
						_cd.reversePressed=false;
						break;
				}
			}
		}

		public function dispose():void {
			// clean up!
			trace("dispose 1")
			QBox2DManager.Instance.dispose()
			trace("dispose 2")
			RenderManager.Instance.dispose()
			CoreData.Instance.KeyPressedSignal.remove(keyDownHandler)			CoreData.Instance.KeyReleasedSignal.remove(keyUpHandler)
			trace("dispose 3")
			DataManager.Instance.dispose()
			trace("dispose 4")
			PlayingLoopManager.Instance.dispose()
			trace("dispose 5")
			ref=null
			_cd=null
		}

		private function addedToStage(_event:Event):void {
			//trace("added!")
			ref.removeEventListener(Event.ADDED_TO_STAGE, addedToStage)
			QBox2DManager.Instance.setup(_quickBoxClip)
		}
		private var _quickBoxClip:MovieClip

		private function init():void {
			//c_carClip = new a_car()
			_quickBoxClip=new MovieClip()
			ref.addChild(new RenderManager())
			//ref.addChild(_quickBoxClip)
			new PlayingLoopManager()			new DataManager()
			new QBox2DManager()
			_cd=CoreData.Instance
			CoreData.Instance.resetGame()
			RenderManager.Instance.setupGraphics()
			ref.addEventListener(Event.ADDED_TO_STAGE, addedToStage)
			CoreData.Instance.KeyPressedSignal.add(keyDownHandler)
			CoreData.Instance.KeyReleasedSignal.add(keyUpHandler)
			CoreData.Instance.stageRef.focus=stage
			trace("help for level 1 is disabled here")
			if (CoreData.Instance.currentLevel == 1) {
				CoreData.Instance.helpActive=true
			} else {
				CoreData.Instance.helpActive=false
			}
			// setup for a new game
			PlayingLoopManager.Instance.gameState=settings.GS_INIT
			PlayingLoopManager.Instance.startLoop()
		}
	}
}