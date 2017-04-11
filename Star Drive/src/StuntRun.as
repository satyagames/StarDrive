package {
	import com.newgrounds.NewgroundsAPI;
	import com.terrypaton.media.SoundManager;
	import com.terrypaton.utils.SeededRandomNumber;
	import com.terrypaton.utils.SharedObjectManager;
	import com.terrypaton.utils.Stats;
	import data.CopyBank;
	import data.CoreData;
	import data.gameRunningFromURL;
	import data.settings;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	import flash.utils.setTimeout;
	import gameshell.manager.DisplayManager;
	import mochi.as3.*;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	[SWF(width="640", height="480", backgroundColor="#333333", frameRate="31")]
	public dynamic class StuntRun extends MovieClip {
		private var soundArray:Array=[music_MainMenu, music_gameOver, snd_gameComplete, snd_gameOver];

		public function StuntRun() {
			soundArray.push(music_levelComplete, snd_changeSelection, snd_levelComplete)
			soundArray.push(snd_startGame, snd_menuOver, snd_menuSelection, snd_gameOver)
			soundArray.push(snd_playerDies)
			soundArray.push(snd_coin_1, snd_coin_2, snd_coin_3, snd_coin_4)
			soundArray.push(snd_playerCrash_1, snd_playerCrash_2, snd_playerCrash_3, snd_playerCrash_4)
			soundArray.push(snd_touch_1, snd_touch_2, snd_touch_3, snd_touch_4)
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			//	trace("_mochiads_game_id:" + _mochiads_game_id)
			soundArray
			_instance=this;
			_sharedOBJ=new SharedObjectManager();
			_sharedOBJ.setupSharedObject("StuntRun_1_r2");
			new CopyBank();
			new CoreData();
			CoreData.Instance.stageRef=stage;
			//	CoreData.Instance.sound_playSfx=true;
			CoreData.Instance.mochiHighscoresEnabled=false;
			CoreData.Instance.highscoresSubmitEnabled=true;
			Security.allowDomain("*");
			addEventListener(Event.ADDED_TO_STAGE, delayedStart);
			CoreData.Instance.seededRandom=new SeededRandomNumber()
		}

		private function delayedStart(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, delayedStart);
			setTimeout(addedToStage, 100)
		}

		public function getMainLoaderInfo():LoaderInfo {
			var loaderInfo:LoaderInfo=root.loaderInfo;
			if (loaderInfo.loader != null) {
				loaderInfo=root.loaderInfo;
			}
			return loaderInfo;
		}

		public function trackGameStop():void {
			// code removed
		}

		public function trackGameStart():void {
			// code removed
		}

		public function goSponsorURL(_task:String):void {
			//			trace("task:" + _task)
			if (_task == settings.GO_SPONSOR_URL) {
				trace("sponsor clicked")
				if (gameRunningFrom == gameRunningFromURL.NEWGROUNDS) {
					NewgroundsAPI.loadCustomLink('SponsorLink');
				} else {
					if (CoreData.Instance.mochiHighscoresEnabled) {
						mochi.as3.MochiEvents.trackEvent('sponsor url', 1);
					}
					//			MochiBot.track(this, "");
					navigateToURL(new URLRequest(settings.URL_SPONSOR))
				}
			}
		}

		private function menuItemSelectHandler(event:ContextMenuEvent):void {
			var request:URLRequest;
			switch (event.target.caption) {
				case MENU_ITEM_0:
					request=new URLRequest("http://playcoolonlinegames.com/");
					navigateToURL(request, "_blank");
					break;
				case MENU_ITEM_2:
					//change quality to low
					stage.quality="LOW";
					break;
				case MENU_ITEM_3:
					//change quality to high
					stage.quality="HIGH";
					break;
			}
		}
		private var gameRunningFrom:String
		public var MindJoltAPI:Object;

		private function postMindJoltAPIConnect(success:Boolean):void {
			trace("[MindJoltAPI] service successfully loaded");
		}

		private function loadFinished(e:Event):void {
			trace(e.toString())
			trace(e.currentTarget)
			//if (MindJoltAPI != null) {
			// MindJoltAPI.service.connect(postMindJoltAPIConnect);
			MindJoltAPI=e.currentTarget.content;
			MindJoltAPI.service.connect();
		}

		private function addedToStage():void {
			var _shape:Shape=new Shape()
			addChild(_shape)
			_shape.graphics.drawRect(0, 0, settings.SCREEN_WIDTH, settings.SCREEN_HEIGHT)
			// find which url the game is running from ...
			//			MochiServices.connect("", this._mochiservicesLoadingPanel);
			var loaderInfo:LoaderInfo=stage.root.loaderInfo
			if (loaderInfo == null) {
				gameRunningFrom="file"
			} else {
				gameRunningFrom=String(loaderInfo.loaderURL).toLowerCase();
			}
			//trace("gameRunningFrom:"+gameRunningFrom)
			CoreData.Instance.KeyPressedSignal=new NativeSignal(stage, KeyboardEvent.KEY_DOWN, KeyboardEvent)
			CoreData.Instance.KeyReleasedSignal=new NativeSignal(stage, KeyboardEvent.KEY_UP, KeyboardEvent)
			CoreData.Instance.DisplayScreenSignal=new Signal(String)
			CoreData.Instance.GameSignal=new Signal(String)
			CoreData.Instance.ButtonSignal=new Signal(String, MovieClip)
			CoreData.Instance.DisplayScreenSignal.add(goSponsorURL)
			//Broadcaster.addEventListener(ShellEvents.GO_SPONSOR_URL, goSponsorURL);
			_DM=new DisplayManager();
			addChild(_DM);
			// filter out the different domains
			
			//			test1=-1
			//test2=1
			//			test3=-1
			//			test4=-1
			//			test5=-1
		
				gameRunningFrom=gameRunningFromURL.FILE;
			
		
		
			CoreData.Instance.mochiHighscoresEnabled=false;
			//trace("gameRunningFrom:"+gameRunningFrom)
			CoreData.Instance.KeyPressedSignal=new NativeSignal(stage, KeyboardEvent.KEY_DOWN, KeyboardEvent)
			CoreData.Instance.KeyReleasedSignal=new NativeSignal(stage, KeyboardEvent.KEY_UP, KeyboardEvent)
			CoreData.Instance.DisplayScreenSignal=new Signal(String)
			CoreData.Instance.ButtonSignal=new Signal(String, MovieClip)
			CoreData.Instance.OverButtonSignal=new Signal(String, MovieClip)
			CoreData.Instance.DisplayScreenSignal.add(goSponsorURL)
			//Broadcaster.addEventListener(ShellEvents.GO_SPONSOR_URL, goSponsorURL);
			_DM=new DisplayManager();
			addChild(_DM);
			// filter out the different domains
			//			trace("game loaded from :" + root.loaderInfo.url);
			//gameSetup
			if (_sharedOBJ.getData("levelsUnlocked") != null) {
				CoreData.Instance.levelsUnlocked=_sharedOBJ.getData("levelsUnlocked");
				trace("CoreData.Instance.levelsUnlocked:" + CoreData.Instance.levelsUnlocked);
			} else {
				trace("setting up default for levels unlocked");
				_sharedOBJ.setData("levels_unlocked", 2);
				CoreData.Instance.levelsUnlocked=2;
			}
			if (_sharedOBJ.getData("totalDistanceTraveled") != null) {
				CoreData.Instance.totalDistanceTraveled=_sharedOBJ.getData("totalDistanceTraveled")
			} else {
				_sharedOBJ.setData("totalDistanceTraveled", 0)
				CoreData.Instance.totalDistanceTraveled=0
			}
			if (_sharedOBJ.getData("sound_playSfx") != null) {
				CoreData.Instance.sound_playSfx=_sharedOBJ.getData("sound_playSfx");
			} else {
				_sharedOBJ.setData("sound_playSfx", true);
				CoreData.Instance.sound_playSfx=true;
			}
			if (_sharedOBJ.getData("sound_playMusic") != null) {
				CoreData.Instance.sound_playMusic=_sharedOBJ.getData("sound_playMusic");
			} else {
				_sharedOBJ.setData("sound_playMusic", false);
				CoreData.Instance.sound_playMusic=false;
			}
			resetGameData()
//			trace("		CoreData.Instance.artifactsFoundArray:" + CoreData.Instance.artifactsFoundArray)
			_sharedOBJ.setData("finalScore", CoreData.Instance.totalScore);
//			_sharedOBJ.setData("artifactsFoundArray", CoreData.Instance.artifactsFoundArray)
			trace("**** DEBUG VALUES CODED NEXT ****")
			//CoreData.Instance.sound_playMusic = false
			//CoreData.Instance.levelsUnlocked=2
			saveUserData()
			// sound manager
			CoreData.Instance.stageRef=stage
			new SoundManager();
			//Broadcaster.dispatchEvent(new ShellEvents(ShellEvents.GO_MAIN_MENU))
			_DM.evalDisplaySoundButtons();
			var myContextMenu:ContextMenu;
			myContextMenu=new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var defaultItems:ContextMenuBuiltInItems=myContextMenu.builtInItems;
			defaultItems.print=false;
			var item0:ContextMenuItem=new ContextMenuItem(MENU_ITEM_0);
			myContextMenu.customItems.push(item0);
			var item1:ContextMenuItem=new ContextMenuItem(MENU_ITEM_1);
			myContextMenu.customItems.push(item1);
			var item2:ContextMenuItem=new ContextMenuItem(MENU_ITEM_2);
			myContextMenu.customItems.push(item2);
			var item3:ContextMenuItem=new ContextMenuItem(MENU_ITEM_3);
			myContextMenu.customItems.push(item3);
			item0.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
			item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
			contextMenu=myContextMenu;
			/// load the users play data
			//			if (!CoreData.Instance.mochiCoinsEnabled){
			//			trace("_storeDataObject.amountOfGamesPlayed:"+_storeDataObject.amountOfGamesPlayed)
			//			}
			//
			//			if (CoreData.Instance.mochiCoinsEnabled || CoreData.Instance.mochiHighscoresEnabled) {
			//CoreData.Instance.playerCoins=600
			//saveUserData()
			
				waitForMochiItems()
			
		}

		public function waitForMochiItems():void {
		
			//MochiServices.connect("63586ccf1920a693", root);
			//MochiAd.showPreGameAd({clip:root, id:"63586ccf1920a693", res:"640x480",ad_finished:startGame});
			
			//_stats.x=settings.GAME_PLAY_WIDTH - 70
			//_stats.scaleX=_stats.scaleY=1
			//addChild(_stats)
			//this.tabChildren = false
			stage.stageFocusRect=false
			goIntro()
		}
		private function startGame() : void {
			
			goIntro()
		}
		private var _loadingMochiClip:a_mochiLoader


		public function gameCompleteTracking():void {
			//			MochiBot.track(this, ""); 
		}
		

		public function submitStat(_string:String, _value:int):void {
			switch (gameRunningFrom) {
				//				case gameRunningFromURL.FILE:
				//					CoreData.Instance.mochiHighscoresEnabled=true;
				//					break
				case gameRunningFromURL.MINDJOLT:
					break
				case gameRunningFromURL.KONGREGATE:
				
					break
			}
		}

		public function submitScores(_score:Number):void {
			// code removed
		}

		public function displayHighscores():void {
			// code removed
		}

		public function goMainMenu():void {
			//Broadcaster.dispatchEvent(new ShellEvents(ShellEvents.GO_MAIN_MENU));
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_MAIN_MENU)
		}

		public static function get Instance():StuntRun {
			return _instance;
		}
		private var MENU_ITEM_0:String="www.playcoolonlinegames.com";
		private var MENU_ITEM_1:String="PLAY COOL ONLINE GAMES";
		private var MENU_ITEM_2:String="LOW Quality";8
		private var MENU_ITEM_3:String="HIGH Quality";
		private static var _instance:StuntRun;
		private var _DM:DisplayManager;
		public var _sharedOBJ:SharedObjectManager;

		public function resetGameData():void {
			CoreData.Instance.totalScore=0;
			CoreData.Instance.lastLevelPlayed=1
			saveUserData()
		}

		public function goIntro():void {
			if (!introPlayed) {
				
				//CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_MAIN_MENU)
				CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_INTRO)
				//import flash.events.MouseEvent;
				/*MochiServices.connect("657c43c98b85eab0", root);
				MochiAd.showPreGameAd({clip:root, id:"657c43c98b85eab0", res:"640x480"});*/
				//setTimeout(addedToStage, 100)
				//introPlayed=true;
				//CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME_OVER)
				//	CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_COMPLETE)
				//	CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_LEVEL_CHOOSER)
				//	CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_UPGRADE);
//				CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME)
					//	CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME_COMPLETE)
			}
		}
		private var introPlayed:Boolean=false;

		public function saveUserData():void {
			//	trace("saving user data", CoreData.Instance.levelsUnlocked)
			_sharedOBJ.setData("sound_playMusic", CoreData.Instance.sound_playMusic);
			_sharedOBJ.setData("sound_playSfx", CoreData.Instance.sound_playSfx);
			_sharedOBJ.setData("levelsUnlocked", CoreData.Instance.levelsUnlocked);
//			_sharedOBJ.setData("artifactsFoundArray", CoreData.Instance.artifactsFoundArray)
			_sharedOBJ.setData("lastLevelPlayed", CoreData.Instance.lastLevelPlayed)
			_sharedOBJ.setData("totalDistanceTraveled", CoreData.Instance.totalDistanceTraveled)
		}
		//private var param : URLVariables
	}
}