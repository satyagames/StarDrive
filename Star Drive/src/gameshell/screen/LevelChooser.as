package gameshell.screen {
	import com.gs.TweenLite;
	import com.gs.TweenMax;
//	import com.terrypaton.effect.WavingImage;
	import com.terrypaton.media.SoundManager;
	import com.terrypaton.utils.commaNumber;
	import data.CoreData;
	import data.settings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import gameshell.ui.GameLogo;
	import gameshell.ui.GraphicBtnClass;

	public dynamic class LevelChooser extends Screen {
		public function LevelChooser() {
			super();
			setupLevelChooser();
		}
		private var _btn:GraphicBtnClass;
		private var _btn1:GraphicBtnClass;
		private var _btn2:GraphicBtnClass;
		private var _focusClip:MovieClip;
		private var _screenConstraints:Rectangle=new Rectangle(0, 0, settings.SCREEN_WIDTH, settings.SCREEN_HEIGHT);
		private var _selector:Sprite;
		private var currentLevelNum:int=1;
//		private var flag:WavingImage;
		private var iconWidth:Number;
		private var levelIconsArray:Array;
		private var mapPreviewScale:Number=1.75;
		private var ref:assets_screen_level_chooser;
		private var totalLevels:int;

		override public function dispose():void {
			for (var i:int=1; i < 11; i++) {
				if (i <= totalLevels) {
					_btn=levelIconsArray[i];
					_btn.dispose()
				}
			}
			levelIconsArray=[];
			levelIconsArray=null
			//	if (_btn)
			//	_btn.dispose()
			if (_btn1)
				_btn1.dispose()
			if (_btn2)
				_btn2.dispose()
			_btn=null
			_btn1=null
			_btn2=null
			_logo.dispose()
			_logo=null
			_focusClip=null
//			if (flag) {
//				flag.dispose();
//				ref.backgroundHolder.removeChild(flag)
////			ref.backgroundHolder.removeChild(flag);
//				flag=null;
//			}
			levelIconsArray=null
			//		CoreData.Instance.KeyPressedSignal.removeAll();
			//	
			CoreData.Instance.OverButtonSignal.remove(OverButtonListener);
			CoreData.Instance.ButtonSignal.remove(ButtonListener);
			CoreData.Instance.KeyPressedSignal.remove(keyListener);
			//
			TweenLite.killTweensOf(ref.levelchooser_slider);
//			
			_selector=null;
			ref=null;
//			removeEventListener(Event.ENTER_FRAME, loop);
			super.dispose();
		}

		public function goSelectedLevel():void {
			// is the current selected level unlocked?
			if (currentLevelNum <= CoreData.Instance.levelsUnlocked) {
				CoreData.Instance.currentLevel=currentLevelNum;
				SoundManager.playSound("snd_startGame")
				CoreData.Instance.lastLevelPlayed=currentLevelNum
				CoreData.Instance.DisplayScreenSignal.dispatch(settings.GO_GAME);
			} else {
				//SoundManager.playSound("snd_menuError");
				trace("tell the player there is an error and they can't play that level yet");
			}
		}

		public function keyListener(event:KeyboardEvent):void {
			//trace("keyDownHandler: " + event.keyCode);
			switch (event.keyCode) {
				case 39:
					if (currentLevelNum < CoreData.Instance.levelsUnlocked) {
						currentLevelNum++;
						markCurrentLevel();
					}
					break;
				case 37:
					if (currentLevelNum > 1) {
						currentLevelNum--
						markCurrentLevel();
					}					break;
				case 32:
					//	trace("space pressed")
					goSelectedLevel();
					break;
			}
		}

//		public function loop(event:Event):void {
			//trace("level chooser")
//			if (flag)
//				flag.manage();
//		}
		private var _logo:GameLogo

		public function markCurrentLevel():void {
			//currentLevelNum=10
			var _clip:MovieClip=MovieClip(ref.getChildByName("pin" + currentLevelNum));
			if (_clip) {
				TweenLite.to(_focusClip, .25, {x: _clip.x, y: _clip.y});
			}
		}

		//[Embed(source="../../../assets/levelPeices.png")]
		//	private var tileSheet : Class;
		public function setupLevelChooser():void {
			ref=new assets_screen_level_chooser();
			addChild(ref);
			_logo=new GameLogo(ref.gamelogo)
			if (CoreData.Instance.gameOverReason > 0 || CoreData.Instance.totalScore == 0) {
				ref.currentScoreClip.visible=false;
			} else {
				ref.currentScoreClip.visible=true;
				ref.currentScoreClip.scoreField.text=commaNumber.processNumber(CoreData.Instance.totalScore)
			}
			_btn1=new GraphicBtnClass(ref.mainMenuBtn);
			//	_btn2=new GraphicBtnClass(ref.upgradeScreenBtn);
//			flag=new WavingImage();
//			ref.backgroundHolder.addChild(flag);
//			flag.setup(320, 240, 2);
			totalLevels=CoreData.Instance.levelDataXML.level.length();
			var renderMatrix:Matrix=new Matrix();
			levelIconsArray=[];
			//CoreData.Instance.levelsUnlocked=8
			// setup all the actions for level chooser buttons
//			trace("totalLevels:" + totalLevels)
			for (var i:int=1; i < 11; i++) {
				var _clip:MovieClip=MovieClip(ref.getChildByName("pin" + i));
				_btn=new GraphicBtnClass(_clip);
				_btn.ref.idNum=i;
//					trace("CoreData.Instance.levelsUnlocked:" + CoreData.Instance.levelsUnlocked, i)
				if (i <= CoreData.Instance.levelsUnlocked) {
				} else {
					_btn.disable();
				}
				_clip.textF.text="S " + i
				levelIconsArray[i]=_btn;
					//trace(CoreData.Instance.artifactsFoundArray[i - 1])
			}
			_focusClip=ref.focusClip
//			trace(_focusClip)
			currentLevelNum=CoreData.Instance.lastLevelPlayed;
			markCurrentLevel();
			// add in controls for moving the selector clip around
			CoreData.Instance.OverButtonSignal.add(OverButtonListener);
			CoreData.Instance.ButtonSignal.add(ButtonListener);
			CoreData.Instance.KeyPressedSignal.add(keyListener);//			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function ButtonListener(btnName:String, btarget:MovieClip):void {
			var testLoc:int=btnName.indexOf("pin");
			if (testLoc == 0) {
//				trace("found a pin")
				currentLevelNum=btarget.idNum;
				goSelectedLevel();
			}
		}

		private function OverButtonListener(btnName:String, btarget:MovieClip):void {
			var testLoc:int=btnName.indexOf("pin")
			if (testLoc == 0) {
//				trace("found a pin")
				currentLevelNum=btarget.idNum;
				markCurrentLevel();
			}
		}
	}
}