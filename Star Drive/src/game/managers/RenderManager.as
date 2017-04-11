package game.managers {
	import com.actionsnippet.qbox.QuickObject;
	import com.gs.TweenMax;
	import com.terrypaton.graphics.DrawPieChart;
	import com.terrypaton.media.SoundManager;
	import com.terrypaton.utils.commaNumber;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import data.CopyBank;
	import data.CoreData;
	import data.RACE_STATE;
	import data.StuntRunParticleSettings;
	import data.settings;
	import game.objects.Checkpoint;
	import game.objects.Item;
	import game.objects.OBJECT_TYPE;
	import game.objects.Points;
	import game.objects.RenderObject;
	import game.objects.Scenery;
	import game.objects.bullets.*;
	import game.objects.enemy.*;
	import gameshell.ui.DialogBox;
	import gameshell.ui.GraphicBtnClass;
	import org.as3lib.math.getNumberAsHexString;

	public class RenderManager extends Sprite {
		private static var _instance:RenderManager

		public static function get Instance():RenderManager {
			return _instance;
		}

		public function RenderManager() {
			//addChild(ref)_hel
			if (_instance) {
				trace("HEY RenderManager already exists!")
			} else {
				_instance=this;
			}
		}
		public var _dialogBox:DialogBox
		public var _gameBitmap:Bitmap
		public var _gameBitmapData:BitmapData
		public var _hud:a_gameClip
		public var _particleManager:SRParticleManager
		public var _particleSpriteSheet:BitmapData
		public var ref:Sprite
		public var renderPoint:Point=new Point()
		public var renderRect:Rectangle=new Rectangle()
		public var xOffset:Number
		public var yOffset:Number
		private var _CD:CoreData
		private var c_ceilingClip:MovieClip
		private var _clip:MovieClip
		//private var _exitBtn:GraphicBtnClass
		private var c_groundClip:MovieClip
		private var _helpClip:MovieClip
		private var _item:Item
		private var c_leftWall:MovieClip
		private var _object:RenderObject
		private var _pauseButton:GraphicBtnClass
		private var _quickObj:QuickObject
		private var _quitGameButton:GraphicBtnClass
		private var _renderPoint:Point=new Point()
		private var c_rightWall:MovieClip
		private var _screenConstraints:Rectangle=new Rectangle(0, 0, 640, 480)
		private var _tempPoint1:Point=new Point()
		private var backgroundFrame:int
		private var blackenScreenClip:MovieClip
		private var c_background:MovieClip
		private var c_box:MovieClip
		private var c_car_frame:MovieClip
		private var c_chasis:MovieClip
		private var c_curvedRamps:MovieClip
		private var c_finishLine:MovieClip
		private var c_flicker:MovieClip
		private var c_message:MovieClip
		private var c_misc:MovieClip
		private var c_parralax1:MovieClip
		private var c_parralax2:MovieClip
		private var c_pickups:MovieClip
		private var c_pivotPoint:MovieClip
		private var c_pivot_platform:MovieClip
		private var c_plank:MovieClip
		private var c_ramps:MovieClip
		private var c_wheel:MovieClip
		private var colTrans:ColorTransform=new ColorTransform()
		private var collisions:Boolean
		private var copyRect:Rectangle
		private var dist:Number
		private var distx:Number;
		private var disty:Number;
		private var fadeColorTransform:ColorTransform
		private var playerRect:Rectangle
		private var redLevel:Number=0;
		private var renderClip:MovieClip
		private var renderMatrix:Matrix
		private var renderWobble:Boolean;
		private var renderit:Boolean;
		private var scaleFactor:Number=1
		private var scaling:Number
		private var segment:int
		private var spriteRad:Number=0
		private var spriteRotation:Number=0
		private var tempRot:Number
		private var testRect:Rectangle
		private var timeShape:Shape
		private var xLoc:Number
		private var yLoc:Number
		private var zeroPoint:Point=new Point()

		public function addParticles(x:Number, y:Number, _type:int, _amount:int=1, _rot:Number=0):void {
			var mx:Number=x
			var my:Number=y
			_particleManager.createParticles(mx, my, _amount, _type, _rot)
		}

		public function darkenScreen():void {
			if (blackenScreenClip.alpha < 1) {
				blackenScreenClip.alpha+=.05
			}
		}

		public function displayMessage(_message:String):void {
			var _text:String
			_text=_message
			//_text ="Hi there!"
			_dialogBox.showMessage(_text, 310, 100, _screenConstraints, false, null, 4)
			_dialogBox.x=settings.GAME_PLAY_WIDTH * .5
			_dialogBox.y=50;
		}

		public function dispose():void {
			//
			if (_item) {
				_item=null
			}
			if (_quickObj) {
				_quickObj=null;
			}
			_pauseButton.dispose();
			_quitGameButton.dispose();
			_dialogBox.dispose()
			_instance=null
			CoreData.Instance.DisplayScreenSignal.remove(updateHUD)
			//Broadcaster.removeEventListener(GameEvents.UPDATE_HUD, updateHUD)
			_dialogBox=null
			_gameBitmap=null
			_gameBitmapData=null;
			_hud=null
			_particleManager.dispose()
			_particleManager=null
			_particleSpriteSheet=null;
			ref=null
			_CD=null
			c_ceilingClip=null
			_clip=null
			c_groundClip=null
			_helpClip=null
			c_leftWall=null
			_object=null
			_pauseButton=null
			_quickObj=null
			_quitGameButton=null
			c_rightWall=null
			blackenScreenClip=null
			//
			c_background=null
			c_box=null
			c_car_frame=null
			c_chasis=null
			c_curvedRamps=null
			c_finishLine=null
			c_flicker=null
			c_message=null
			c_misc=null
			c_parralax1=null
			c_parralax2=null
			c_pickups=null
			c_pivotPoint=null
			c_pivot_platform=null
			c_plank=null
			c_ramps=null
			c_wheel=null
			renderClip=null
			timeShape=null
		}

		public function hideHelp():void {
			_helpClip.alpha=1
			_helpClip.scaleX=1
			_helpClip.scaleY=1
			TweenMax.to(_helpClip, .5, {alpha: 0, onComplete: removeHelp})
		}

		public function isDialogInactive():Boolean {
			if (_dialogBox.timer < 1) {
				return true
			}
			return false
		}

		public function removeDialogBox():void {
			//ref.removeChild(_speechBubble)
			trace("removing the dialog box")
		}

		public function removeHelp():void {
			try {
				_hud.removeChild(_helpClip)
			} catch (e:Error) {
			}
			_helpClip=null
		}

		public function render():void {
			// find the offset location
			xOffset=int(settings.SCREEN_X_MIDDLE - (CoreData.Instance.playerx * settings.WORLD_SCALE * CoreData.Instance.renderingScale)) - 160;
			yOffset=int(settings.SCREEN_Y_MIDDLE - (CoreData.Instance.playery * settings.WORLD_SCALE * CoreData.Instance.renderingScale));
			//
			_gameBitmapData.lock();
			_gameBitmapData.fillRect(_gameBitmapData.rect, 0x00000099)
			renderbackground()
			renderWalls()
			renderQuickBoxObjects()
			_particleManager.manageParticles(_gameBitmapData, _particleSpriteSheet, xOffset, yOffset);
			// render the darkness over everything
			//
			_gameBitmapData.unlock()
			manageShakeScreen()
			// render the time display
			if (renderWobble) {
				//	renderPowerUpTime()
				renderTime()
			}
			renderWobble=!renderWobble
			//var endTime : int = getTimer()
//			_hud.locationField.text=String(CoreData.Instance.playerx)
			renderItems()
		}

		//
		public function renderWalls():void {
			/**/ // render the ceiling if it's in range
			yLoc=(yOffset)
			if (yLoc < settings.SCREEN_HEIGHT) {
				renderMatrix.identity()
				// find which segment the player is above
				var segment:int=(CoreData.Instance.playerx * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / 640
				xLoc=(segment * 640 + xOffset)
				renderMatrix.translate(xLoc, yLoc)
				_gameBitmapData.draw(c_ceilingClip, renderMatrix, null, null, null, true)
				//
				if (xLoc > 0) {
					renderMatrix.translate(-640, 0)
				} else {
					renderMatrix.translate(640, 0)
				}
				_gameBitmapData.draw(c_ceilingClip, renderMatrix, null, null, null, true)
			}
			// render the left wall if it's in 
			xLoc=xOffset
			if (xLoc > -settings.SCREEN_WIDTH * .25 + 10) {
				//	trace("render left wall")
				yLoc=(CoreData.Instance.worldHeight * CoreData.Instance.renderingScale * settings.WORLD_SCALE + yOffset)
				// render 2 ground segments
				renderMatrix.identity()
				// find which segment the player is above
				xLoc=xOffset
				segment=(CoreData.Instance.playery * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / 480
				yLoc=(segment * 480 + yOffset)
				renderMatrix.translate(xLoc, yLoc)
				_gameBitmapData.draw(c_leftWall, renderMatrix, null, null, null, true)
				//
				if (yLoc > 0) {
					renderMatrix.translate(0, -480)
				} else {
					renderMatrix.translate(0, 480)
				}
				_gameBitmapData.draw(c_leftWall, renderMatrix, null, null, null, true)
			}
			// render the right wall if it's in range
			xLoc=(CoreData.Instance.worldWidth * CoreData.Instance.renderingScale * settings.WORLD_SCALE) + xOffset
			//- xOffset)
			if (xLoc < settings.SCREEN_WIDTH + 90) {
				//				trace("render left wall")
				yLoc=(CoreData.Instance.worldHeight * CoreData.Instance.renderingScale * settings.WORLD_SCALE + yOffset)
				// render 2 ground segments
				renderMatrix.identity()
				// find which segment the player is above
				segment=(CoreData.Instance.playery * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / 480
				yLoc=(segment * 480 + yOffset)
				renderMatrix.translate(xLoc, yLoc)
				_gameBitmapData.draw(c_rightWall, renderMatrix, null, null, null, true)
				//
				if (yLoc > 0) {
					renderMatrix.translate(0, -480)
				} else {
					renderMatrix.translate(0, 480)
				}
				_gameBitmapData.draw(c_rightWall, renderMatrix, null, null, null, true)
			}
			// render the ground if it is in range
			yLoc=(CoreData.Instance.worldHeight * CoreData.Instance.renderingScale * settings.WORLD_SCALE + yOffset)
			if (yLoc < settings.SCREEN_HEIGHT + 90) {
				// render 2 ground segments
				renderMatrix.identity()
				// find which segment the player is above
				segment=(CoreData.Instance.playerx * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / 640
				xLoc=(segment * 640 + xOffset)
				renderMatrix.translate(xLoc, yLoc)
				_gameBitmapData.draw(c_groundClip, renderMatrix, null, null, null, true)
				//
				if (xLoc > 0) {
					renderMatrix.translate(-640, 0)
				} else {
					renderMatrix.translate(640, 0)
				}
				_gameBitmapData.draw(c_groundClip, renderMatrix, null, null, null, true)
			}
		}

		public function renderbackground():void {
			var xsegment:int=((CoreData.Instance.playerx / 6) * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / 480 - 1
			var ysegment:int=((CoreData.Instance.playery / 6) * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / settings.SCREEN_HEIGHT
			xLoc=int(xsegment * 480 + xOffset / 6)
			yLoc=int(ysegment * 480 + yOffset / 6)
			//
			renderMatrix.identity()
			renderMatrix.translate(xLoc, yLoc)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			renderMatrix.translate(480, 0)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			renderMatrix.translate(480, 0)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			renderMatrix.translate(480, 0)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			//trace("ysegment:" + ysegment)
			if (yLoc > 0) {
				yLoc-=480
			} else {
				yLoc+=480
			}
			renderMatrix.identity()
			renderMatrix.translate(xLoc, yLoc)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			renderMatrix.translate(480, 0)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			renderMatrix.translate(480, 0)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			renderMatrix.translate(480, 0)
			_gameBitmapData.draw(c_background, renderMatrix, null, null, null, true)
			if (CoreData.Instance.playery > CoreData.Instance.worldHeight - 10) {
				// render parralax 1
				xsegment=((CoreData.Instance.playerx / 3) * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / 640 - 1
				renderMatrix.identity()
				xLoc=int(xsegment * 640 + xOffset / 3)
				yLoc=int(CoreData.Instance.worldHeight * CoreData.Instance.renderingScale * settings.WORLD_SCALE + (yOffset * .8) - 100)
				renderMatrix.translate(xLoc, yLoc)
				_gameBitmapData.draw(c_parralax1, renderMatrix, null, null, null, true)
				renderMatrix.translate(640, 0)
				_gameBitmapData.draw(c_parralax1, renderMatrix, null, null, null, true)
				renderMatrix.translate(640, 0)
				_gameBitmapData.draw(c_parralax1, renderMatrix, null, null, null, true)
				// render parralax 2
				xsegment=((CoreData.Instance.playerx / 2) * settings.WORLD_SCALE * CoreData.Instance.renderingScale) / 640 - 1
				renderMatrix.identity()
				xLoc=int(xsegment * 640 + xOffset / 2)
				yLoc=int(CoreData.Instance.worldHeight * CoreData.Instance.renderingScale * settings.WORLD_SCALE + (yOffset))
				renderMatrix.translate(xLoc, yLoc)
				_gameBitmapData.draw(c_parralax2, renderMatrix, null, null, null, true)
				renderMatrix.translate(640, 0)
				_gameBitmapData.draw(c_parralax2, renderMatrix, null, null, null, true)
				renderMatrix.translate(640, 0)
				_gameBitmapData.draw(c_parralax2, renderMatrix, null, null, null, true)
			}
		}

		public function setupGraphics():void {
			c_message=new a_messageClip()
			c_chasis=new a_chasis()
			c_flicker=new a_flicker()
			c_car_frame=new a_bike_frame()
			c_wheel=new a_wheel()
			c_misc=new a_miscObject()
			c_box=new a_box()
			c_curvedRamps=new a_curvedRamps()
			c_pickups=new a_pickups()
			c_background=new a_background()
			c_parralax1=new a_parralaxTile1()
			c_parralax2=new a_parralaxTile2()
			c_pivotPoint=new a_pivotPoint()
			c_ramps=new a_ramps_left()
			c_plank=new a_plank()
			c_finishLine=new a_finishLine()
			c_pivot_platform=new a_pivot_platform()
			//
			backgroundFrame=CoreData.Instance.currentLevel
			c_background.gotoAndStop(backgroundFrame)
			c_parralax1.gotoAndStop(backgroundFrame)
			c_parralax2.gotoAndStop(backgroundFrame)
			//
			testRect=new Rectangle(0, 0, settings.TILE_SIZE, settings.TILE_SIZE)
			playerRect=new Rectangle(0, 0, settings.PLAYER_SIZE, settings.PLAYER_SIZE)
			ref=new Sprite()
			_hud=new a_gameClip()
			c_leftWall=new a_leftWall()
			c_rightWall=new a_rightWall()
			c_groundClip=new a_ground()
			c_ceilingClip=new a_ceiling()
			this.addChild(_hud)
			this.addChild(ref)
			_tempPoint1=new Point()
			renderMatrix=new Matrix()
			_particleSpriteSheet=new a_particleSheet(10, 10)
			_particleManager=new SRParticleManager()
			copyRect=new Rectangle(0, 0, settings.GAME_PLAY_WIDTH, settings.GAME_PLAY_HEIGHT)
			//c_tile = new a_mTile()
			colTrans=new ColorTransform()
			fadeColorTransform=new ColorTransform()
			fadeColorTransform.alphaMultiplier=.99999999999
			//
			_gameBitmapData=new BitmapData(settings.GAME_PLAY_WIDTH, settings.GAME_PLAY_HEIGHT, true, 0xff000000)
			_gameBitmap=new Bitmap(_gameBitmapData)
			_gameBitmap.scaleX=_gameBitmap.scaleY=scaleFactor
			_hud.GameHolder.addChild(_gameBitmap)
			//
			_helpClip=new a_helpPanel()
			//
			timeShape=new Shape()
			timeShape.alpha=.5
			_hud.timeHolder.addChild(timeShape)
			//
			_dialogBox=new DialogBox()
			ref.addChild(_dialogBox)
			_pauseButton=new GraphicBtnClass(_hud.pauseButton)
			_quitGameButton=new GraphicBtnClass(_hud.quitGameButton)
			CoreData.Instance.DisplayScreenSignal.add(updateHUD)
			renderWobble=true
			//Broadcaster.addEventListener(GameEvents.UPDATE_HUD, updateHUD, false, 0, true)
			CoreData.Instance.DisplayScreenSignal.dispatch(settings.UPDATE_HUD)
			if (CoreData.Instance.currentLevel > 1) {
				_hud.howToControlMessage.visible=false
			}
		}

		public function showHelp():void {
			// attach a help bubble
			_helpClip.gotoAndStop(int(CoreData.Instance.helpPageNum + 1))
			_hud.addChild(_helpClip)
			_helpClip.x=settings.SCREEN_X_MIDDLE
			_helpClip.y=settings.SCREEN_Y_MIDDLE
			_helpClip.alpha=.1
			TweenMax.to(_helpClip, .45, {alpha: 1})
		}

		public function startDarkenScreen():void {
			blackenScreenClip=new a_blackenScreenClip()
			ref.addChild(blackenScreenClip)
			blackenScreenClip.alpha=0
		}

		public function updateHUD(_task:String):void {
			if (_task == settings.UPDATE_HUD) {
				var _percent:Number=CoreData.Instance.playerHealth / 100
				_hud.healthMeter.clip.scaleY=_percent
				//	_hud.tempLevelScoreField.text=commaNumber.processNumber(CoreData.Instance.tempLevelScore)
//				_hud.tempLevelCoinsField.text=commaNumber.processNumber(CoreData.Instance.tempLevelCoins)
				_hud.scoreField.text=commaNumber.processNumber((CoreData.Instance.totalScore + CoreData.Instance.tempLevelScore))
//				_hud.coinsField.text=commaNumber.processNumber(CoreData.Instance.playerCoins)
//				trace("UPDATE THE HUD")
			}
		}

		private function blitClip(_clip:MovieClip):BitmapData {
			var _bmpd:BitmapData=new BitmapData(_clip.width, _clip.height, true, 0)
			renderMatrix.identity()
			renderMatrix.translate(_clip.width * .5, _clip.height * .5)
			_bmpd.draw(_clip, renderMatrix)
			return _bmpd
		}

		private function manageShakeScreen():void {
			// shake the screen
			if (CoreData.Instance.shakeScreenCounter > 0) {
				if (CoreData.Instance.shakeScreenCounter > 30) {
					CoreData.Instance.shakeScreenCounter=30
				}
				CoreData.Instance.shakeScreenCounter--
				CoreData.Instance.shakeScreenScreenAmount*=.7
				if (CoreData.Instance.shakeScreenCounter < 1 || CoreData.Instance.shakeScreenScreenAmount < .2) {
					CoreData.Instance.shakeScreenScreenAmount=0
					CoreData.Instance.shakeScreenScreenAmount=0
				}
				_gameBitmap.x=Math.random() * CoreData.Instance.shakeScreenScreenAmount - CoreData.Instance.shakeScreenScreenAmount * .5
				_gameBitmap.y=Math.random() * CoreData.Instance.shakeScreenScreenAmount - CoreData.Instance.shakeScreenScreenAmount * .5
			} else {
			}
		}

		private function renderItems():void {
			var playerX:Number=(CoreData.Instance.playerx * CoreData.Instance.renderingScale * settings.WORLD_SCALE)
			var playerY:Number=(CoreData.Instance.playery * CoreData.Instance.renderingScale * settings.WORLD_SCALE)
			var isCollected:Boolean
			var n:int=CoreData.Instance.itemsArray.length
			while (n--) {
				_item=CoreData.Instance.itemsArray[n]
				var xLoc:Number=(_item.x + xOffset)
				var yLoc:Number=(_item.y + yOffset)
				// only render if in view
				if (xLoc > -100 && xLoc < settings.SCREEN_WIDTH + 100 && yLoc > -100 && yLoc < settings.SCREEN_HEIGHT + 100 || _item.type.value >= OBJECT_TYPE.MESSAGE_TURBO_BOOST.value) {
					//
					isCollected=false
					_item.manage()
					if (_item.kill) {
						CoreData.Instance.itemsArray.splice(n, 1)
					} else {
						// check if the player is colliding with the item
						distx=playerX - _item.x
						disty=playerY - _item.y
						dist=Math.floor(Math.sqrt(distx * distx + disty * disty));
						//
						if (dist < 90 && _item.active) {
							// item is collected
							isCollected=true
						}
						renderMatrix.identity()
						//	renderMatrix.scale(.667, .667)
						renderMatrix.rotate(_item.radians)
						switch (_item.type) {
							case OBJECT_TYPE.FINISH_LINE:
								renderMatrix.translate(xLoc, yLoc)
								_gameBitmapData.draw(c_finishLine, renderMatrix, null, null, null, true)
								if (isCollected) {
									trace("player touches finish line")
									PlayingLoopManager.Instance.gameState=settings.GS_LEVEL_COMPLETE
									QBox2DManager.Instance.stopEngine()
								}
								break
							case OBJECT_TYPE.COIN:
								renderMatrix.translate(xLoc, yLoc)
								c_pickups.gotoAndStop(1)
								colTrans.alphaMultiplier=_item.alpha
								_gameBitmapData.draw(c_pickups, renderMatrix, colTrans, null, null, true)
								if (isCollected) {
									trace(" player collected a coin")
									_item.collected()
									//	trace("player collects a coin")
									//	DataManager.Instance.givePlayerCoins(_item.coinValue)
									DataManager.Instance.addPoints(_item.pointsValue)
									// create particles where player collected coin
									RenderManager.Instance.addParticles(_item.x, _item.y, StuntRunParticleSettings.PARTICLE_COLLECT, 25);
									_item=new Item(xLoc - 20, yLoc + 10, OBJECT_TYPE.MESSAGE_COIN_COLLECTED)
									CoreData.Instance.itemsArray.push(_item)
									SoundManager.playSound(("snd_coin_" + int(Math.random() * 4 + 1)), .25)
								}
								break
							case OBJECT_TYPE.TURBO_BOOST:
								renderMatrix.translate(xLoc, yLoc)
								c_pickups.gotoAndStop(2)
								colTrans.alphaMultiplier=_item.alpha
								_gameBitmapData.draw(c_pickups, renderMatrix, colTrans, null, null, true)
								if (isCollected) {
									_item.collected()
									//	trace("player collects a coin")
									trace("activate turbo boost")
									CoreData.Instance.turboBoostCounter=60
									DataManager.Instance.addPoints(_item.pointsValue)
									// create particles where player collected coin
									RenderManager.Instance.addParticles(_item.x, _item.y, StuntRunParticleSettings.PARTICLE_COLLECT, 25);
									// create a 'turbo boost' message
									_item=new Item(xLoc - 20, yLoc + 10, OBJECT_TYPE.MESSAGE_TURBO_BOOST)
									CoreData.Instance.itemsArray.push(_item)
								}
								break
							case OBJECT_TYPE.MESSAGE_360:
								renderMatrix.translate(_item.x, _item.y)
								c_message.gotoAndStop(4)
								colTrans.alphaMultiplier=_item.alpha
								_gameBitmapData.draw(c_message, renderMatrix, colTrans, null, null, true)
								break
							case OBJECT_TYPE.MESSAGE_180:
								renderMatrix.translate(_item.x, _item.y)
								c_message.gotoAndStop(3)
								colTrans.alphaMultiplier=_item.alpha
								_gameBitmapData.draw(c_message, renderMatrix, colTrans, null, null, true)
								break
							case OBJECT_TYPE.MESSAGE_COIN_COLLECTED:
								renderMatrix.translate(_item.x, _item.y)
//								trace(_item.x, _item.y)
								c_message.gotoAndStop(2)
								colTrans.alphaMultiplier=_item.alpha
								_gameBitmapData.draw(c_message, renderMatrix, colTrans, null, null, true)
								break
							case OBJECT_TYPE.MESSAGE_TURBO_BOOST:
								renderMatrix.translate(_item.x, _item.y)
								colTrans.alphaMultiplier=_item.alpha
								c_message.gotoAndStop(1)
								_gameBitmapData.draw(c_message, renderMatrix, colTrans, null, null, true)
								break
							case OBJECT_TYPE.MESSAGE_HUGE_JUMP:
								renderMatrix.translate(_item.x, _item.y)
								colTrans.alphaMultiplier=_item.alpha
								c_message.gotoAndStop(5)
								_gameBitmapData.draw(c_message, renderMatrix, colTrans, null, null, true)
								break
							case OBJECT_TYPE.MESSAGE_LONG_JUMP:
								renderMatrix.translate(_item.x, _item.y)
								colTrans.alphaMultiplier=_item.alpha
								c_message.gotoAndStop(6)
								_gameBitmapData.draw(c_message, renderMatrix, colTrans, null, null, true)
								break
							case OBJECT_TYPE.MESSAGE_MEDIUM_JUMP:
								renderMatrix.translate(_item.x, _item.y)
								colTrans.alphaMultiplier=_item.alpha
								c_message.gotoAndStop(7)
								_gameBitmapData.draw(c_message, renderMatrix, colTrans, null, null, true)
								break
						}
					}
				}
			}
		}

		private function renderQuickBoxObjects():void {
			var renderCount:int=0
			var n:int=CoreData.Instance.quickBoxObjectsData.length
			while (n--) {
				// go through all quick box 2d objects and render them to the screen
				_quickObj=CoreData.Instance.quickBoxObjectsData[n]
				//
				if (_quickObj.body) {
					var xLoc:Number=(_quickObj.x * CoreData.Instance.renderingScale * settings.WORLD_SCALE + xOffset)
					var yLoc:Number=(_quickObj.y * CoreData.Instance.renderingScale * settings.WORLD_SCALE + yOffset)
//				trace("normal obj", _quickObj.objID)
					// only render if in view
					var objectWidth:Number=_quickObj.userData.width * CoreData.Instance.renderingScale
					if (xLoc > -objectWidth && xLoc < settings.SCREEN_WIDTH + objectWidth) {
						var objectHeight:Number=_quickObj.userData.height * CoreData.Instance.renderingScale
						if (yLoc > -200 && yLoc < settings.SCREEN_HEIGHT + 200) {
							//trace("xLoc:" + xLoc, yLoc)
							//	trace(_quickObj.x)
							renderMatrix.identity()
							//	renderMatrix.scale(.667, .667)
							renderMatrix.rotate(_quickObj.angle)
							renderMatrix.translate(xLoc, yLoc)
							renderCount++
							//renderMatrix.translate(settings.SCREEN_X_MIDDLE, settings.SCREEN_Y_MIDDLE)
							switch (_quickObj.objID) {
								case game.objects.OBJECT_TYPE.PLAYER_CHASIS:
									_gameBitmapData.draw(c_chasis, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PLAYER_CAR_BODY:
									// based on the damage of the car, display the right frame
									var _carBodyFrame:int=5 - ((CoreData.Instance.playerHealth / 100) * 4)
									c_car_frame.gotoAndStop(_carBodyFrame)
									_gameBitmapData.draw(c_car_frame, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PLAYER_BACK_WHEEL:
								case game.objects.OBJECT_TYPE.PLAYER_FRONT_WHEEL:
									_gameBitmapData.draw(c_wheel, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PINBALL_FLICKER_1:
								case game.objects.OBJECT_TYPE.PINBALL_FLICKER_2:
									c_flicker.gotoAndStop(1)
									_gameBitmapData.draw(c_flicker, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PIVOT_POINT:
									_gameBitmapData.draw(c_pivotPoint, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PIVOT_PLATFORM_1:
									_gameBitmapData.draw(c_pivot_platform, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.RAMP_LEFT_1:
									c_ramps.gotoAndStop(1)
									_gameBitmapData.draw(c_ramps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.RAMP_LEFT_2:
									c_ramps.gotoAndStop(2)
									_gameBitmapData.draw(c_ramps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.RAMP_RIGHT_1:
									c_ramps.gotoAndStop(10)
									_gameBitmapData.draw(c_ramps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.RAMP_RIGHT_2:
									c_ramps.gotoAndStop(11)
									_gameBitmapData.draw(c_ramps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.BOX_1:
									c_box.gotoAndStop(1)
									_gameBitmapData.draw(c_box, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.BOX_2:
									c_box.gotoAndStop(2)
									_gameBitmapData.draw(c_box, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PLANK_1:
									c_plank.gotoAndStop(1)
									_gameBitmapData.draw(c_plank, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PLANK_2:
									c_plank.gotoAndStop(2)
									_gameBitmapData.draw(c_plank, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.PLANK_3:
									c_plank.gotoAndStop(3)
									_gameBitmapData.draw(c_plank, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_1_NORMAL:
									c_curvedRamps.gotoAndStop(1)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_1_FLIP_H:
									c_curvedRamps.gotoAndStop(2)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_2_NORMAL:
									c_curvedRamps.gotoAndStop(3)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_2_FLIP_H:
									c_curvedRamps.gotoAndStop(4)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_3_NORMAL:
									c_curvedRamps.gotoAndStop(5)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_3_FLIP_H:
									c_curvedRamps.gotoAndStop(6)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_4_NORMAL:
									c_curvedRamps.gotoAndStop(7)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RAMP_4_FLIP_H:
									c_curvedRamps.gotoAndStop(8)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RISE_RAMP_1:
									c_curvedRamps.gotoAndStop(9)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RISE_RAMP_2:
									c_curvedRamps.gotoAndStop(10)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RISE_RAMP_3:
									c_curvedRamps.gotoAndStop(11)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.CURVED_RISE_RAMP_4:
									c_curvedRamps.gotoAndStop(12)
									_gameBitmapData.draw(c_curvedRamps, renderMatrix, null, null, null, true)
									break
								case game.objects.OBJECT_TYPE.WALL_GROUND:
								case game.objects.OBJECT_TYPE.WALL_RIGHT:
								case game.objects.OBJECT_TYPE.WALL_LEFT:
								case game.objects.OBJECT_TYPE.WALL_CEILING:
									// LEFT INTENTIONALLY EMPTY, rendering is performed elsewhere
									break
								default:
									renderMatrix.identity()
									var _widthScale:Number=(_quickObj.userData.width / settings.WORLD_SCALE) * CoreData.Instance.renderingScale
									//var _widthScale:Number=2000
									var _heightScale:Number=(_quickObj.userData.height / settings.WORLD_SCALE) * CoreData.Instance.renderingScale
									if (_widthScale < 20 && _heightScale < 20) {
										renderMatrix.scale(_widthScale, _heightScale)
										renderMatrix.rotate(_quickObj.angle)
										renderMatrix.translate(xLoc, yLoc)
										_gameBitmapData.draw(c_misc, renderMatrix, null, null, null, true)
									}
									break
							}
						}
					}
				}
			}
//			_hud.locationField.text="Render count " + String(renderCount)
		}

		private function renderTime():void {
			// find the percent of time left
			var timePercent:Number=(CoreData.Instance.currentLevelTime / CoreData.Instance.currentLevelMaxTime)
//			trace("timePercent:" + timePercent)
			if (timePercent < .15) {
				if (!CoreData.Instance.lowTimeMessageShown) {
					CoreData.Instance.lowTimeMessageShown=true
					RenderManager.Instance.displayMessage(CopyBank.getText("lowTime"))
				}
				CoreData.Instance.timerColour=settings.TIME_COLOUR_VERY_LOW
			} else if (timePercent < .3) {
				CoreData.Instance.timerColour=settings.TIME_COLOUR_LOW
			}
			DrawPieChart.drawChart(timeShape, 25, timePercent, CoreData.Instance.timerColour, -90)
			//
		}
	}
}