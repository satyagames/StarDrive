package game.managers {
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.b2ContactFilter;
	import com.actionsnippet.qbox.QuickBox2D;
	import com.actionsnippet.qbox.QuickContactFilter;
	import com.actionsnippet.qbox.QuickContacts;
	import com.actionsnippet.qbox.QuickObject;
	import com.terrypaton.media.SoundManager;
	import data.CoreData;
	import data.GameSignals;
//	import data.StuntRunParticleSettings;
	import data.settings;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.setTimeout;
	import game.objects.Item;
	import game.objects.OBJECT_TYPE;

	public class QBox2DManager {
		private static var _instance:QBox2DManager;

		public static function get Instance():QBox2DManager {
			return _instance;
		}

		public function QBox2DManager() {
			_instance=this
		}
		private var currentLevelXML:XML;
		//
		public var canvas:MovieClip;
		public var carDirectionRadian:Number
		public var carDirectionVelocity:b2Vec2
		public var playerDifferenceX:Number
		public var playerDifferenceY:Number
		private var _object:QuickObject
		private var _playersCurrentRotation:Number
		private var anchor:b2Vec2;
		private var backWheel:QuickObject;
		private var bikeScaling:Number=.3;
		private var carBody:QuickObject
		private var carCollisionGroup:int=99
		private var carXLocation:Number=3;
		private var carYLocation:Number=3;
		//
		private var chassis:QuickObject
		private var contacts:QuickContacts
		private var frontWheel:QuickObject;
		private var sim:QuickBox2D;
		private var solidObjectDensity:Number=0
		private var temporaryTravelledDistance:Number
		private var wheelSpeed:Number=0;

		public function dispose():void {
			canvas=null
			carDirectionVelocity
			sim.destroy()
			currentLevelXML=null
			//
			_instance=null
			contacts=null
			CoreData.Instance.itemsArray=[]
			canvas=null;
			carDirectionVelocity: b2Vec2
			_object=null
			anchor: b2Vec2;
			backWheel=null
			carBody=null
			chassis=null
			contacts=null
			frontWheel=null;
			sim=null
		}

		public function manage():void {
			// store the players last location
			var playerRotation:Number=carBody.angle * 180 / Math.PI
			if (playerRotation > 360) {
				playerRotation-=360
			}
			if (playerRotation < 0) {
				playerRotation+=360
				carBody.angle=playerRotation / 180 * Math.PI
			}
			carBody.angle=playerRotation / 180 * Math.PI
//			trace("playerRotation:" + playerRotation)
			if (playerRotation > 115 && playerRotation < 240) {
				//trace("player is on their back")
				CoreData.Instance.playerIsUpsideDown=true
					//	trace("CoreData.Instance.playerIsUpsideDown:" + CoreData.Instance.playerIsUpsideDown)
			} else {
				CoreData.Instance.playerIsOnBack=false
				CoreData.Instance.playerIsUpsideDown=false
			}
//			trace("*** players rotation:" + playerRotation)
			CoreData.Instance.playerLastX=carBody.x
			CoreData.Instance.playerLastY=carBody.y
			carDirectionRadian=carBody.angle
			carDirectionVelocity=carBody.body.GetLinearVelocity()
			sim.onRender()
			// how far has player travelled since last calculation?
			playerDifferenceX=CoreData.Instance.playerLastX - carBody.x;
			playerDifferenceY=CoreData.Instance.playerLastY - carBody.y;
			temporaryTravelledDistance=Math.abs(Math.sqrt(playerDifferenceX * playerDifferenceX + playerDifferenceY * playerDifferenceY));
			CoreData.Instance.levelDistanceTraveled+=temporaryTravelledDistance
			// manage how often the player can get damaged, not when the player is the right way up (not upside down, this will also be reset
			//	if (CoreData.Instance.playerIsOnBack) {
//				trace("playersCollisionCounter:" + CoreData.Instance.playersCollisionCounter)
			//if (CoreData.Instance.playersCollisionCounter < 120) {
			//	CoreData.Instance.playersCollisionCounter++
			//} else {
			//		resetPlayer() 
			//	trace("RESET")
			//}
			//}
			// check the rotation of the players car body, if it right's itself reset the damage counter
			var _playersCurrentRotation:Number=carBody.angle * 180 / Math.PI
			//trace("_playersCurrentRotation:_playersCurrentRotation" + _playersCurrentRotation)
			// find the difference in rotation the player has made
			// if the players wheels are off the ground
			if (!CoreData.Instance.helpActive) {
				if (CoreData.Instance.playerIsInTheAir && !CoreData.Instance.playerIsOnBack) {
					CoreData.Instance.distanceTravelledInAir+=temporaryTravelledDistance
					if (!CoreData.Instance.longDistanceYahoo) {
						if (CoreData.Instance.distanceTravelledInAir > 50) {
							testMakeYahoo()
						} else if (CoreData.Instance.distanceTravelledInAir > 40) {
							testMakeYahoo()
						} else if (CoreData.Instance.distanceTravelledInAir > 30) {
							testMakeYahoo()
						}
					}
					// how long has the player been in the air?
					CoreData.Instance.playerIsInTheAirCounter++
					if (CoreData.Instance.playerIsInTheAirCounter == 30) {
						trace("player has been in the air for 1 second")
					} else if (CoreData.Instance.playerIsInTheAirCounter == 45) {
						trace("player has been in the air for 1.5 seconds")
					} else if (CoreData.Instance.playerIsInTheAirCounter == 60) {
						trace("player has been in the air for 2 second")
					} else if (CoreData.Instance.playerIsInTheAirCounter == 75) {
						trace("player has been in the air for 2.5 seconds")
					} else if (CoreData.Instance.playerIsInTheAirCounter == 90) {
						trace("player has been in the air for 3 second")
					}
					var _item:Item
					var px:Number
					var py:Number
				} else {
					//
					CoreData.Instance.longDistanceYahoo=false
					CoreData.Instance.playerIsInTheAirCounter=0
					if (CoreData.Instance.distanceTravelledInAir > 5) {
						trace("CoreData.Instance.distanceTravelledInAir:" + CoreData.Instance.distanceTravelledInAir)
						px=carBody.x * settings.WORLD_SCALE * CoreData.Instance.renderingScale
						py=carBody.y * settings.WORLD_SCALE * CoreData.Instance.renderingScale
						// check if the player should be awarded anything for a long distance
						if (CoreData.Instance.distanceTravelledInAir > 50) {
							trace("HUGE jump")
							_item=new Item(px, py, OBJECT_TYPE.MESSAGE_HUGE_JUMP)
							CoreData.Instance.itemsArray.push(_item)
							DataManager.Instance.addPoints(1500)
						} else if (CoreData.Instance.distanceTravelledInAir > 40) {
							trace("long jump")
							_item=new Item(px, py, OBJECT_TYPE.MESSAGE_LONG_JUMP)
							CoreData.Instance.itemsArray.push(_item)
							DataManager.Instance.addPoints(750)
						} else if (CoreData.Instance.distanceTravelledInAir > 30) {
							_item=new Item(px, py, OBJECT_TYPE.MESSAGE_MEDIUM_JUMP)
							CoreData.Instance.itemsArray.push(_item)
							DataManager.Instance.addPoints(250)
							trace("medium jump")
						} else if (CoreData.Instance.distanceTravelledInAir > 20) {
							trace("small jump")
						}
					}
					CoreData.Instance.playerRotationAdd=0
					CoreData.Instance.distanceTravelledInAir=0
					CoreData.Instance.flip90=false;
					CoreData.Instance.flip180=false;
					CoreData.Instance.flip360=false
				}
				// check the rotation of the player
				if (CoreData.Instance.tiltRightPressed) {
					if (CoreData.Instance.rotateVelocity == 0) {
						CoreData.Instance.rotateVelocity=1
					} else {
						CoreData.Instance.rotateVelocity*=1.1
						if (CoreData.Instance.rotateVelocity > 6) {
							CoreData.Instance.rotateVelocity=6
						}
					}
					CoreData.Instance.playerRotationChange+=CoreData.Instance.rotateVelocity
					if (CoreData.Instance.playerRotationChange > 180) {
						CoreData.Instance.rotateVelocity=0
					}
						//trace(CoreData.Instance.rotateVelocity)
				} else if (CoreData.Instance.tiltLeftPressed) {
					if (CoreData.Instance.rotateVelocity == 0) {
						CoreData.Instance.rotateVelocity=-1
					} else {
						CoreData.Instance.rotateVelocity*=1.1
						if (CoreData.Instance.rotateVelocity < -6) {
							CoreData.Instance.rotateVelocity=-6
						}
					}
					if (CoreData.Instance.playerRotationChange < -180) {
						CoreData.Instance.rotateVelocity=0
					}
				} else {
					CoreData.Instance.playerRotationChange=0
					CoreData.Instance.rotateVelocity=0
						//	carBody.body.SetAngularVelocity(CoreData.Instance.rotateVelocity)
				}
				//	trace("CoreData.Instance.rotateVelocity:" + CoreData.Instance.rotateVelocity)
				carBody.body.SetAngularVelocity(CoreData.Instance.rotateVelocity)
				if (CoreData.Instance.turboBoostCounter > 0) {
					CoreData.Instance.turboBoostCounter--
					wheelSpeed+=settings.TURBO_BOOST_SPEED
				}
				if (CoreData.Instance.acceleratePressed) {
					wheelSpeed+=5
					if (wheelSpeed > 45) {
						wheelSpeed=45
					}
				} else {
					wheelSpeed*=.95
				}
				if (CoreData.Instance.reversePressed) {
					wheelSpeed-=2
					if (wheelSpeed < -20) {
						wheelSpeed=-20
					}
				}
				frontWheel.body.SetAngularVelocity(wheelSpeed);
				backWheel.body.SetAngularVelocity(wheelSpeed);
			}
			// manage camera 
			canvas.x=-carBody.x * CoreData.Instance.renderingScale * 30 + 320 - 160
			canvas.y=-carBody.y * CoreData.Instance.renderingScale * 30 + 240
			//
			CoreData.Instance.playerx=carBody.x
			CoreData.Instance.playery=carBody.y
		}

		public function resetPlayer():void {
			CoreData.Instance.playersCollisionCounter=0
			CoreData.Instance.playerIsOnBack=false
			wheelSpeed=0
			CoreData.Instance.playerIsInTheAirCounter=0
			CoreData.Instance.playerRotationChange=carBody.angle * 180 / Math.PI
			CoreData.Instance.playerRotationAdd=0
			// go through all objects and reset them all
			var i:int=CoreData.Instance.quickBoxObjectsData.length
			while (i--) {
				var _obj:QuickObject=CoreData.Instance.quickBoxObjectsData[i]
				switch (_obj.objID) {
					case OBJECT_TYPE.PLAYER_BACK_WHEEL:
					case OBJECT_TYPE.PLAYER_FRONT_WHEEL:
					case OBJECT_TYPE.PLAYER_CHASIS:
					case OBJECT_TYPE.PLAYER_CAR_BODY:
						CoreData.Instance.quickBoxObjectsData.splice(i, 1)
						_obj.destroy()
						break
				}
			}
			setTimeout(createCar, 100)
		}

		public function setup(_clip:MovieClip):void {
			var i:int=CoreData.Instance.levelDataXML.level.length();
			CoreData.Instance.totalLevels=CoreData.Instance.levelDataXML.level.length()
			while (i--) {
				//	trace(CoreData.Instance.levelDataXML.level[i].@number );
				if (CoreData.Instance.levelDataXML.level[i].@number == CoreData.Instance.currentLevel) {
					currentLevelXML=CoreData.Instance.levelDataXML.level[i];
				}
			}
			CoreData.Instance.currentLevelTime=CoreData.Instance.currentLevelMaxTime=int(currentLevelXML.totalLevelTime) * 31
			trace("currentLevelMaxTime:" + CoreData.Instance.currentLevelMaxTime)
			CoreData.Instance.worldWidth=currentLevelXML.worldWidth;
			CoreData.Instance.worldHeight=currentLevelXML.worldHeight;
			//
			CoreData.Instance.levelName=String(currentLevelXML.name)
			canvas=_clip;
			var gameBounds:Array=new Array(0, 0, CoreData.Instance.worldWidth * 2, CoreData.Instance.worldHeight * 2)
//			var gameBounds:Array=new Array(0, 0, CoreData.Instance.worldWidth, CoreData.Instance.worldHeight)
			//			sim=new QuickBox2D(canvas, {debug: false, gravityY: 20, renderJoints: true, bounds: gameBounds, frim: true, simpleRender: true});
			sim=new QuickBox2D(canvas, {debug: true, gravityY: 20, frim: true, bounds: gameBounds, simpleRender: false});
			sim.setDefault({fillColor: 0xaaaaaa, lineAlpha: 0});
			createWallsOfGame()
			createCar()
			//	
			createObjects()
			sim.start();
//			sim.mouseDrag();
			//
			trace("the stage is SCALED")
			canvas.scaleX=canvas.scaleY=CoreData.Instance.renderingScale
			//	canvas.scaleX=canvas.scaleY=.25
			//	addChild(new a_instructions())
			//
			contacts=sim.addContactListener();
			contacts.addEventListener(QuickContacts.ADD, onCollision);
			contacts.addEventListener(QuickContacts.PERSIST, onPersistantCollision);
			contacts.addEventListener(QuickContacts.REMOVE, onRemoveCollision);
//			collectableCollisionfilter=new QuickContactFilter();
//			QuickContactFilter(collectableCollisionfilter).addGroupIndexCallback(collectableCollision, carCollisionGroup);
//			sim.w.SetContactFilter(collectableCollisionfilter);
		}

		public function stopEngine():void {
			sim.stop()
		}

		private function connect(a:QuickObject, b:QuickObject, lower:Number, upper:Number, offX:Number=0, offY:Number=0):QuickObject {
			var min:Number=Math.min(a.y, b.y);
			var max:Number=Math.max(a.y, b.y);
			anchor.y=min + (max - min) * 0.5 + offY;
			min=Math.min(a.x, b.x);
			max=Math.max(a.x, b.x);
			anchor.x=min + (max - min) * 0.5 + offX;
			return sim.addJoint({type: "revolute", a: a.body, b: b.body, x1: anchor.x, y1: anchor.y, lowerAngle: lower, upperAngle: upper});
		}

		private function createCar():void {
			//
			// create the car
			//create the car parts
			chassis=sim.addBox({x: carXLocation + 3 * bikeScaling, y: carYLocation + 2.7 * bikeScaling, width: 1 * bikeScaling, height: 1 * bikeScaling, fillColor: 0x000000, groupIndex: carCollisionGroup, allowSleep: false});
			//	carBody=sim.addBox({x: carXLocation + 3 * bikeScaling, y: carYLocation + 1 * bikeScaling, width: 4 * bikeScaling, height: 1.5 * bikeScaling, fillColor: 0x000000, groupIndex: carCollisionGroup, allowSleep: false});
			//
			var vertices:Array=[]
			// normal
			var carWidth:Number=.6
			vertices.push(carWidth, 0);
			vertices.push(carWidth, 0.2);
			vertices.push(-carWidth, .2);
			vertices.push(-carWidth, 0);
			vertices.push(-carWidth * .5, -.2);
			vertices.push(0, -.3);
			vertices.push(carWidth * .5, -.2);
			//
			carBody=sim.addPoly({x: carXLocation + 3 * bikeScaling, y: carYLocation + 1 * bikeScaling, verts: [vertices], fillColor: 0x0000FF, groupIndex: carCollisionGroup, allowSleep: false});
			//
			backWheel=sim.addCircle({x: carXLocation + 1 * bikeScaling, y: carYLocation + 3.5 * bikeScaling, radius: 1.4 * bikeScaling, friction: 6, groupIndex: carCollisionGroup, allowSleep: false});
			frontWheel=sim.addCircle({x: carXLocation + 5 * bikeScaling, y: carYLocation + 3.5 * bikeScaling, radius: 1.4 * bikeScaling, friction: 1, groupIndex: carCollisionGroup, allowSleep: false});
			//create the car joints
			sim.addJoint({a: chassis.body, b: backWheel.body, x1: carXLocation + 2.5 * bikeScaling, y1: carYLocation + 3 * bikeScaling, frequencyHz: 0});
			sim.addJoint({a: chassis.body, b: frontWheel.body, x1: carXLocation + 3.5 * bikeScaling, y1: carYLocation + 3 * bikeScaling, frequencyHz: 0});
			//
			sim.addJoint({a: carBody.body, b: backWheel.body, x1: carXLocation + 1 * bikeScaling, y1: carXLocation + 2 * bikeScaling, frequencyHz: 8});
			sim.addJoint({a: carBody.body, b: frontWheel.body, x1: carYLocation + 5 * bikeScaling, y1: carYLocation + 2 * bikeScaling, frequencyHz: 8});
			//
			sim.addJoint({a: carBody.body, b: chassis.body, x2: carXLocation + 2.5 * bikeScaling, y2: carYLocation + 2.5 * bikeScaling, frequencyHz: 0});
			sim.addJoint({a: carBody.body, b: chassis.body, x2: carYLocation + 3.5 * bikeScaling, y2: carYLocation + 2.5 * bikeScaling, frequencyHz: 0});
			//
			sim.addJoint({a: carBody.body, b: chassis.body, x1: carXLocation + 5 * bikeScaling, y1: carXLocation + 2 * bikeScaling});
			sim.addJoint({a: carBody.body, b: chassis.body, x1: carYLocation + 1 * bikeScaling, y1: carYLocation + 2 * bikeScaling});
			//
			carBody.objID=OBJECT_TYPE.PLAYER_CAR_BODY;
			chassis.objID=OBJECT_TYPE.PLAYER_CHASIS;
			backWheel.objID=OBJECT_TYPE.PLAYER_BACK_WHEEL;
			frontWheel.objID=OBJECT_TYPE.PLAYER_FRONT_WHEEL;
			CoreData.Instance.quickBoxObjectsData.push(backWheel);
			CoreData.Instance.quickBoxObjectsData.push(frontWheel);
			CoreData.Instance.quickBoxObjectsData.push(carBody);
			CoreData.Instance.quickBoxObjectsData.push(chassis);
			// create a test car group
		}

		private function createCoin(_x:Number, _y:Number):void {
			var _item:Item=new Item(_x * settings.WORLD_SCALE * CoreData.Instance.renderingScale, _y * settings.WORLD_SCALE * CoreData.Instance.renderingScale, OBJECT_TYPE.COIN)
			CoreData.Instance.itemsArray.push(_item)
		}

		private function createCurvedRamp(_curvedRampType:OBJECT_TYPE, _x:Number, _y:Number, _rotation:Number=0):void {
			var r_width:Number=1
			var r_height:Number=1
			var _angle:Number=90
			var flipVertical:Boolean=false
			var flipHorizontal:Boolean=false
			// determin the size of the ramp
			switch (_curvedRampType) {
				case OBJECT_TYPE.CURVED_RAMP_1_NORMAL:
				case OBJECT_TYPE.CURVED_RAMP_1_FLIP_H:
					r_width=2
					r_height=1;
					_angle=45
					break
				case OBJECT_TYPE.CURVED_RAMP_2_NORMAL:
				case OBJECT_TYPE.CURVED_RAMP_2_FLIP_H:
					r_width=2
					r_height=2;
					_angle=60
					break
				case OBJECT_TYPE.CURVED_RAMP_3_NORMAL:
				case OBJECT_TYPE.CURVED_RAMP_3_FLIP_H:
					r_width=2
					r_height=1;
					_angle=80
					break
				case OBJECT_TYPE.CURVED_RAMP_4_NORMAL:
				case OBJECT_TYPE.CURVED_RAMP_4_FLIP_H:
					r_width=2
					r_height=2;
					_angle=90
					break
				default:
					trace("ALERT: CURVED RAMP DOES NOT EXIST")
					break
			}
			// determine if the ramp has to be fliped
			switch (_curvedRampType) {
				case OBJECT_TYPE.CURVED_RAMP_1_FLIP_H:
				case OBJECT_TYPE.CURVED_RAMP_2_FLIP_H:
				case OBJECT_TYPE.CURVED_RAMP_3_FLIP_H:
				case OBJECT_TYPE.CURVED_RAMP_4_FLIP_H:
					flipHorizontal=true
					break
				default:
					break
			}
			var _tempGroupArray:Array=[]
			var nodes:Number;
			var rotStep:Number;
			var i:Number;
			var _rot:Number;
			var _rad:Number;
			var dx:Number;
			var dy:Number;
			//
			nodes=7;
			rotStep=_angle / nodes;
			var lastNodeX:Number
			var lastNodeY:Number
//			var _rampSegment:QuickObject=sim.addBox({x: 0, y: 0, width: r_width, height: r_height, fillColor: 0xff0000, density: 0, friction: 1});
//			_tempGroupArray.push(_rampSegment)
			for (i=0; i < nodes + 1; i++) {
				_rot=i * rotStep;
				_rad=_rot / 180 * Math.PI;
				dx=-Math.sin(_rad) * (-r_width * .95);
				dy=Math.cos(_rad) * (r_height);
				// generate a segment of a ramp;
				var _nodeX:Number=-r_width * .5 + dx;
				var _nodeY:Number=dy;
				if (lastNodeX == 0) {
					lastNodeX=0;
					lastNodeY=r_height;
				}
				// create a shape based on current position
				lastNodeX=Math.floor(lastNodeX * 100) / 100
				lastNodeY=Math.floor(lastNodeY * 100) / 100
				_nodeX=Math.floor(_nodeX * 100) / 100
				_nodeY=Math.floor(_nodeY * 100) / 100
				var vertices:Array=[]
				if (!flipHorizontal && !flipVertical) {
					// normal
					vertices.push(_nodeX, _nodeY);
					vertices.push(_nodeX, r_height);
					vertices.push(lastNodeX, r_height);
					vertices.push(lastNodeX, lastNodeY);
					vertices.push(lastNodeX, lastNodeY);
				}
				if (flipHorizontal && !flipVertical) {
					vertices.push(-lastNodeX, lastNodeY);
					vertices.push(-lastNodeX, lastNodeY);
					vertices.push(-lastNodeX, r_height);
					vertices.push(-_nodeX, r_height);
					vertices.push(-_nodeX, _nodeY);
				}
				lastNodeX=_nodeX;
				lastNodeY=_nodeY;
				//		trace("vertices:" + vertices)
				if (i > 0) {
					var _rampSegment:QuickObject=sim.addPoly({x: 0, y: -r_height, verts: [vertices], fillColor: 0x0000FF, density: solidObjectDensity, friction: 1, isSleeping: true});
					_tempGroupArray.push(_rampSegment)
				}
			}
			// all the parts are passed into the objects array
			//trace("_tempGroupArray:" + _tempGroupArray)
			var curvedRampGroup:QuickObject=sim.addGroup({objects: _tempGroupArray, x: _x, y: _y, angle: _rotation / 180 * Math.PI, groupIndex: -1, isSleeping: true});
			curvedRampGroup.objID=_curvedRampType
			CoreData.Instance.quickBoxObjectsData.push(curvedRampGroup)
		}

		private function createFinishLine(_x:Number, _y:Number):void {
//			_object=sim.addBox({x: _x, y: _y, width: 1, height: 2, angle: 0, isSleeping: false, density: .1, groupIndex: carCollisionGroup})
//			_object.objID=OBJECT_TYPE.FINISH_LINE
//			CoreData.Instance.quickBoxObjectsData.push(_object)
			var _item:Item=new Item(_x * settings.WORLD_SCALE * CoreData.Instance.renderingScale, _y * settings.WORLD_SCALE * CoreData.Instance.renderingScale, OBJECT_TYPE.FINISH_LINE)
			CoreData.Instance.itemsArray.push(_item)
		}

		private function createObjects():void {
			CoreData.Instance.itemsArray=[]
			var i:int=currentLevelXML.objectData.object.length();
//			trace("i:" + i)
//			trace("XML START")
			while (i--) {
				var objXML:XML=currentLevelXML.objectData.object[i];
				var _xloc:Number=Number(objXML.@x)
				var _yloc:Number=CoreData.Instance.worldHeight - Number(objXML.@y)
				var _rotation:Number=Number(objXML.@rotation)
				if (objXML.@move == "false") {
					var _move:Boolean=false
				} else {
					_move=true
				}
				//
				switch (String(objXML.@id)) {
					case OBJECT_TYPE.RAMP_LEFT_1.stringVal:
						createSetRampLeft(OBJECT_TYPE.RAMP_LEFT_1, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.RAMP_LEFT_2.stringVal:
						createSetRampLeft(OBJECT_TYPE.RAMP_LEFT_2, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.PINBALL_FLICKER_1.stringVal:
						createPinballFlicker(OBJECT_TYPE.PINBALL_FLICKER_1, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.PINBALL_FLICKER_2.stringVal:
						createPinballFlicker(OBJECT_TYPE.PINBALL_FLICKER_2, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.PIVOT_PLATFORM_1.stringVal:
						createRotatingPlatform(OBJECT_TYPE.PIVOT_PLATFORM_1, _xloc + 1.01, _yloc, _rotation)
						break
					case OBJECT_TYPE.PIVOT_PLATFORM_2.stringVal:
						createRotatingPlatform(OBJECT_TYPE.PIVOT_PLATFORM_2, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.BOX_1.stringVal:
						createbox(OBJECT_TYPE.BOX_1, _xloc, _yloc, _move)
						break
					case OBJECT_TYPE.BOX_2.stringVal:
						createbox(OBJECT_TYPE.BOX_2, _xloc, _yloc, _move)
						break
					case OBJECT_TYPE.COIN.stringVal:
						createCoin(_xloc, _yloc)
						break
					case OBJECT_TYPE.PLANK_1.stringVal:
						createPlank(OBJECT_TYPE.PLANK_1, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.PLANK_2.stringVal:
						createPlank(OBJECT_TYPE.PLANK_2, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.PLANK_3.stringVal:
						createPlank(OBJECT_TYPE.PLANK_3, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.RAMP_LEFT_1.stringVal:
						createSetRampLeft(OBJECT_TYPE.RAMP_LEFT_1, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.RAMP_LEFT_2.stringVal:
						createSetRampLeft(OBJECT_TYPE.RAMP_LEFT_2, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.RAMP_RIGHT_1.stringVal:
						createSetRampRight(OBJECT_TYPE.RAMP_RIGHT_1, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.RAMP_RIGHT_2.stringVal:
						createSetRampRight(OBJECT_TYPE.RAMP_RIGHT_2, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_1_NORMAL.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_1_NORMAL, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_2_NORMAL.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_2_NORMAL, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_3_NORMAL.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_3_NORMAL, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_4_NORMAL.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_4_NORMAL, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_1_FLIP_H.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_1_FLIP_H, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_2_FLIP_H.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_2_FLIP_H, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_3_FLIP_H.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_3_FLIP_H, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RAMP_4_FLIP_H.stringVal:
						createCurvedRamp(OBJECT_TYPE.CURVED_RAMP_4_FLIP_H, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.TURBO_BOOST.stringVal:
						createTurboBoost(_xloc, _yloc)
						break
					case OBJECT_TYPE.FINISH_LINE.stringVal:
						createFinishLine(_xloc, _yloc)
						break
					case OBJECT_TYPE.CURVED_RISE_RAMP_1.stringVal:
						createRiseRamp(OBJECT_TYPE.CURVED_RISE_RAMP_1, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RISE_RAMP_2.stringVal:
						createRiseRamp(OBJECT_TYPE.CURVED_RISE_RAMP_2, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RISE_RAMP_3.stringVal:
						createRiseRamp(OBJECT_TYPE.CURVED_RISE_RAMP_3, _xloc, _yloc, _rotation)
						break
					case OBJECT_TYPE.CURVED_RISE_RAMP_4.stringVal:
						createRiseRamp(OBJECT_TYPE.CURVED_RISE_RAMP_4, _xloc, _yloc, _rotation)
						break
					default:
						trace("IINVALID OBJECT!!")
						break
				}
			}
		}

		private function createPinballFlicker(_flickerType:OBJECT_TYPE, _x:Number, _y:Number, _rotation:Number=0):void {
			// create a flicker object
			var _tempGroupArray:Array=[]
			var _circle1:QuickObject=sim.addCircle({x: 0, y: 0, radius: .5, allowSleep: false, groupIndex: -3, density: 1});
			_tempGroupArray.push(_circle1)
			var _circle2:QuickObject=sim.addCircle({x: 2, y: 0, radius: .3, allowSleep: false, groupIndex: -3, density: 1});
			_tempGroupArray.push(_circle2)
			// now create object for between the circles
			var vertices:Array=[]
			// normal
			vertices.push(0, 0);
			vertices.push(2, .2);
			vertices.push(2, .8);
			vertices.push(0, 1);
			//
			var _rampSegment:QuickObject=sim.addPoly({x: 0, y: -.5, verts: [vertices], fillColor: 0x0000FF, density: 1, friction: 1, isSleeping: true, groupIndex: -3});
			_tempGroupArray.push(_rampSegment)
			//
			//
			var pinballFlickerGroup:QuickObject=sim.addGroup({draggable: true, objects: _tempGroupArray, x: _x, y: _y, angle: 0, isSleeping: true});
			pinballFlickerGroup.objID=_flickerType
			CoreData.Instance.quickBoxObjectsData.push(pinballFlickerGroup)
			if (_flickerType == OBJECT_TYPE.PINBALL_FLICKER_2) {
				_rotation+=180
				pinballFlickerGroup.angle=(_rotation - 10) / 180 * Math.PI;
			} else {
				pinballFlickerGroup.angle=(_rotation + 10) / 180 * Math.PI;
			}
			//
			var _pivotCircle:QuickObject=sim.addCircle({x: _x, y: _y, radius: .1, allowSleep: true, groupIndex: -3, density: 0});
			//	_tempGroupArray.push(_pivotCircle)
			var jointsettings:Object={}
			jointsettings.type="revolute"
			jointsettings.a=_pivotCircle.body
			jointsettings.b=pinballFlickerGroup.body
			jointsettings.x1=_x
			jointsettings.y1=_y
			jointsettings.collideConnected=false
			jointsettings.enableLimit=true
			jointsettings.enableMotor=true
			if (_flickerType == OBJECT_TYPE.PINBALL_FLICKER_1) {
				jointsettings.upperAngle=(10 + _rotation) / 180 * Math.PI
				jointsettings.lowerAngle=(-40 + _rotation) / 180 * Math.PI
			} else {
				jointsettings.upperAngle=(_rotation + 40) / 180 * Math.PI
				jointsettings.lowerAngle=(_rotation - 10) / 180 * Math.PI
			}
//			var joint:QuickObject=sim.addJoint({type: "revolute", a: _pivotCircle.body, b: pinballFlickerGroup.body, x1: _x, y1: _y, collideConnected: false, enableLimit: true, enableMotor: true});
			var joint:QuickObject=sim.addJoint(jointsettings);
			_tempGroupArray.push(joint)
		}

		private function createPlank(_boxType:OBJECT_TYPE, _x:Number, _y:Number, _rot:Number=0):void {
			var _radians:Number=_rot / 180 * Math.PI
			var _width:Number=2
			var _height:Number=1
			switch (_boxType) {
				case OBJECT_TYPE.PLANK_1:
					_width=3
					_height=.25
					break
				case OBJECT_TYPE.PLANK_2:
					_width=1.5
					_height=.25
					break
				case OBJECT_TYPE.PLANK_3:
					_width=1
					_height=.25
					break
			}
			//trace("plank type:" + _boxType + " size should be ", (_width * 30 * CoreData.Instance.renderingScale), (_height * 30 * CoreData.Instance.renderingScale))
			_object=sim.addBox({angle: _radians, x: _x, y: _y, width: _width, height: _height, draggable: true, isSleeping: true, density: solidObjectDensity})
			_object.objID=_boxType
			CoreData.Instance.quickBoxObjectsData.push(_object)
		}

//		private function createRampLeft(_x:Number, _y:Number, _width:Number=2, _height:Number=1, _staticObject:Boolean=true, _rotation:Number=0):void {
//			// create a ramp
//			//trace("1")
//			var _radians:Number=_rot / 180 * Math.PI
//			var vertices:Array=[0, 0, _width, _height, 0, _height];
//			var _density:Number=1
//			if (_staticObject) {
//				_density=0
//			}
//			_object=sim.addPoly({angle: _radians, x: _x, y: _y - _height, verts: [vertices], fillColor: 0x0000FF, density: _density, friction: 1});
//			CoreData.Instance.quickBoxObjectsData.push(_object)
//		}
//
//		private function createRampRight(_x:Number, _y:Number, _width:Number=2, _height:Number=1, _staticObject:Boolean=true):void {
//			var _radians:Number=_rot / 180 * Math.PI
//			var vertices:Array=[0, 0, 0, _height, -_width, _height];
//			var _density:Number=1
//			if (_staticObject) {
//				_density=0
//			}
//			_object=sim.addPoly({angle: _radians, x: _x, y: _y - _height, verts: [vertices], fillColor: 0x0000FF, density: _density, friction: 1});
//			CoreData.Instance.quickBoxObjectsData.push(_object)
//		}
		private function createRiseRamp(_rampType:OBJECT_TYPE, _x:Number, _y:Number, _rotation:Number):void {
			trace("**** CURVED_RISE_RAMP")
			var _radians:Number=_rot / 180 * Math.PI
			var r_width:Number
			var r_height:Number
			var _angle:Number=360
			var flipVertical:Boolean=false
			var flipHorizontal:Boolean=false
			switch (_rampType) {
				case OBJECT_TYPE.CURVED_RISE_RAMP_1:
					r_width=1.5
					r_height=.5;
					break
				case OBJECT_TYPE.CURVED_RISE_RAMP_2:
					r_width=3
					r_height=.5;
					break
				case OBJECT_TYPE.CURVED_RISE_RAMP_3:
					r_width=5
					r_height=1;
					break
				case OBJECT_TYPE.CURVED_RISE_RAMP_4:
					r_width=4
					r_height=1.5;
					break
				default:
					trace("ALERT: RISE RAMP DOES NOT EXIST")
					break
			}
			var _tempGroupArray:Array=[]
			var nodes:Number;
			var rotStep:Number;
			var i:Number;
			var _rot:Number;
			var _rad:Number;
			var dx:Number;
			var dy:Number;
			//
			nodes=13;
			var xstepping:Number=r_width / nodes
			rotStep=_angle / nodes;
			var lastNodeX:Number
			var lastNodeY:Number
			//			var _rampSegment:QuickObject=sim.addBox({x: 0, y: 0, width: r_width, height: r_height, fillColor: 0xff0000, density: 0, friction: 1});
			//			_tempGroupArray.push(_rampSegment)
			for (i=0; i < nodes + 1; i++) {
				_rot=i * rotStep;
				_rad=_rot / 180 * Math.PI;
				dx=-Math.sin(_rad) * (-r_width * .95);
				dx=i * xstepping
				dy=Math.cos(_rad) * (r_height);
				// generate a segment of a ramp;
				var _nodeX:Number=-r_width * .5 + dx;
				var _nodeY:Number=dy;
				if (lastNodeX == 0) {
					lastNodeX=0;
					lastNodeY=r_height;
				}
				// create a shape based on current position
				lastNodeX=Math.floor(lastNodeX * 100) / 100
				lastNodeY=Math.floor(lastNodeY * 100) / 100
				_nodeX=Math.floor(_nodeX * 100) / 100
				_nodeY=Math.floor(_nodeY * 100) / 100
				var vertices:Array=[]
				if (!flipHorizontal && !flipVertical) {
					// normal
					vertices.push(_nodeX, _nodeY);
					vertices.push(_nodeX, r_height);
					vertices.push(lastNodeX, r_height);
					vertices.push(lastNodeX, lastNodeY);
					vertices.push(lastNodeX, lastNodeY);
				}
				if (flipHorizontal && !flipVertical) {
					vertices.push(-lastNodeX, lastNodeY);
					vertices.push(-lastNodeX, lastNodeY);
					vertices.push(-lastNodeX, r_height);
					vertices.push(-_nodeX, r_height);
					vertices.push(-_nodeX, _nodeY);
				}
				lastNodeX=_nodeX;
				lastNodeY=_nodeY;
				//		trace("vertices:" + vertices)
				if (i > 0) {
					var _rampSegment:QuickObject=sim.addPoly({x: 0, y: -r_height, verts: [vertices], fillColor: 0x0000FF, density: 0, friction: 1, isSleeping: true});
					_tempGroupArray.push(_rampSegment)
				}
			}
			// all the parts are passed into the objects array
			//trace("_tempGroupArray:" + _tempGroupArray)
			_radians=_rotation / 180 * Math.PI
			var curvedRampGroup:QuickObject=sim.addGroup({angle: _radians, objects: _tempGroupArray, x: _x, y: _y, groupIndex: -1, isSleeping: true, density: 0});
			curvedRampGroup.objID=_rampType
			CoreData.Instance.quickBoxObjectsData.push(curvedRampGroup)
		}

		private function createRotatingPlatform(_pivotType:OBJECT_TYPE, _x:Number, _y:Number, _angle:Number=0):void {
			var pivot:QuickObject
			var rad:Number=_angle / 180 * Math.PI
			var box:QuickObject
			var _width:Number
			var _height:Number
			switch (_pivotType) {
				case OBJECT_TYPE.PIVOT_PLATFORM_1:
					_width=2
					_height=.2
					box=sim.addBox({x: _x - _width * .5, y: _y - _height * .5, width: _width, height: _height, angle: _angle / 180 * Math.PI, draggable: true, fixedRotation: false, isSleeping: false, density: 1, friction: 1, groupIndex: -2})
					box.objID=OBJECT_TYPE.PIVOT_PLATFORM_1
					CoreData.Instance.quickBoxObjectsData.push(box)
					pivot=sim.addCircle({x: _x - _width * .5, y: _y - _height * .5, radius: _height * .5, allowSleep: false, groupIndex: -2, density: 0});
					pivot.objID=OBJECT_TYPE.PIVOT_POINT
					CoreData.Instance.quickBoxObjectsData.push(pivot)
					sim.addJoint({type: "revolute", a: box.body, b: pivot.body, x1: box.x, y1: box.y, collideConnected: false, dampingRatio: .5});
					break
				case OBJECT_TYPE.PIVOT_PLATFORM_2:
					_width=2
					_height=.2
					var boxXLoc:Number=_x + Math.cos(rad) * _width * .5
					var boxYLoc:Number=_y + Math.sin(rad) * _width * .5
					box=sim.addBox({x: boxXLoc, y: boxYLoc, width: _width, height: _height, angle: rad, draggable: true, isSleeping: true, density: 1, friction: 1})
					box.objID=OBJECT_TYPE.PIVOT_PLATFORM_1
					CoreData.Instance.quickBoxObjectsData.push(box)
					pivot=sim.addCircle({x: _x, y: _y, radius: _height * .5, allowSleep: false, density: 0, draggable: true});
					pivot.objID=OBJECT_TYPE.PIVOT_POINT
					CoreData.Instance.quickBoxObjectsData.push(pivot)
					var pivotX:Number=boxXLoc - Math.cos(rad) * _width * .5
					var pivotY:Number=boxYLoc - Math.sin(rad) * _width * .5
					var j:QuickObject=sim.addJoint({type: "revolute", a: pivot.body, b: box.body, x1: pivotX, y1: pivotY, collideConnected: false, dampingRatio: .5});
					break
			}
		}

		private function createSetRampLeft(_rampType:OBJECT_TYPE, _x:Number, _y:Number, _rotation:Number):void {
			var _radians:Number=_rotation / 180 * Math.PI
			var _width:Number=2
			var _height:Number=1
			switch (_rampType) {
				case OBJECT_TYPE.RAMP_LEFT_1:
					_width=2
					_height=1
					break
				case OBJECT_TYPE.RAMP_LEFT_2:
					_width=3
					_height=2.5
					break
			}
			//trace("ramp type:" + _rampType + " size should be ", (_width * 30 * CoreData.Instance.renderingScale), (_height * 30 * CoreData.Instance.renderingScale))
			// create a ramp
			var vertices:Array=[_width * .5, -_height * .5, _width * .5, _height * .5, -_width * .5, _height * .5];
			var _density:Number=0
			_object=sim.addPoly({angle: _radians, x: _x, y: _y, verts: [vertices], fillColor: 0x0000FF, density: _density, friction: 1});
			_object.objID=_rampType
			CoreData.Instance.quickBoxObjectsData.push(_object)
		}

		private function createSetRampRight(_rampType:OBJECT_TYPE, _x:Number, _y:Number, _rotation:Number):void {
			var _radians:Number=_rotation / 180 * Math.PI
			var _width:Number=2
			var _height:Number=1
			switch (_rampType) {
				case OBJECT_TYPE.RAMP_RIGHT_1:
					_width=2
					_height=1
					break
				case OBJECT_TYPE.RAMP_RIGHT_2:
					_width=3
					_height=2.5
					break
			}
//			trace("ramp type:" + _rampType + " size should be ", (_width * 30 * CoreData.Instance.renderingScale), (_height * 30 * CoreData.Instance.renderingScale))
			// create a ramp
			var vertices:Array=[-_width * .5, -_height * .5, _width * .5, _height * .5, -_width * .5, _height * .5];
			var _density:Number=0
			_object=sim.addPoly({angle: _radians, x: _x, y: _y, verts: [vertices], fillColor: 0x0000FF, density: _density, friction: 1, isSleeping: true});
			_object.objID=_rampType
			CoreData.Instance.quickBoxObjectsData.push(_object)
		}

		private function createTurboBoost(_x:Number, _y:Number):void {
			var _item:Item=new Item(_x * settings.WORLD_SCALE * CoreData.Instance.renderingScale, _y * settings.WORLD_SCALE * CoreData.Instance.renderingScale, OBJECT_TYPE.TURBO_BOOST)
			CoreData.Instance.itemsArray.push(_item)
		}

		private function createWallsOfGame():void {
			//  top
			_object=sim.addBox({x: CoreData.Instance.worldWidth * .5, y: -.5, width: CoreData.Instance.worldWidth, height: 2, angle: 0, fixedRotation: true, isSleeping: true, density: 0})
			_object.objID=OBJECT_TYPE.WALL_CEILING
			CoreData.Instance.quickBoxObjectsData.push(_object)
			// bottom
			_object=sim.addBox({x: CoreData.Instance.worldWidth * .5, y: CoreData.Instance.worldHeight + 1, width: CoreData.Instance.worldWidth, height: 2, angle: 0, fixedRotation: true, isSleeping: true, density: 0})
			_object.objID=OBJECT_TYPE.WALL_GROUND
			CoreData.Instance.quickBoxObjectsData.push(_object)
			// left 
			_object=sim.addBox({x: 0, y: CoreData.Instance.worldHeight * .5, width: 2, height: CoreData.Instance.worldHeight, angle: 0, fixedRotation: true, isSleeping: true, density: 0})
			_object.objID=OBJECT_TYPE.WALL_LEFT
			CoreData.Instance.quickBoxObjectsData.push(_object)
//			right
			_object=sim.addBox({x: CoreData.Instance.worldWidth, y: CoreData.Instance.worldHeight * .5, width: 2, height: CoreData.Instance.worldHeight, angle: 0, fixedRotation: true, isSleeping: true, density: 0})
			_object.objID=OBJECT_TYPE.WALL_RIGHT
			CoreData.Instance.quickBoxObjectsData.push(_object)
		}

		private function createbox(_boxType:OBJECT_TYPE, _x:Number, _y:Number, _allowMovement:Boolean=true):void {
			var _width:Number=2
			var _height:Number=1
			switch (_boxType) {
				case OBJECT_TYPE.BOX_1:
					_width=1
					_height=1
					break
				case OBJECT_TYPE.BOX_2:
					_width=1.5
					_height=1.5
					break
			}
			if (_allowMovement) {
				var _density:Number=.1
			} else {
				_density=0
			}
			_object=sim.addBox({x: _x, y: _y, width: _width, height: _height, angle: 0, isSleeping: false, density: _density})
			_object.objID=_boxType
			CoreData.Instance.quickBoxObjectsData.push(_object)
		}

		private function onCollision(evt:Event):void {
			// go through all objects and test if the they are touching the players body
			var i:int=CoreData.Instance.quickBoxObjectsData.length
			while (i--) {
				var _obj:QuickObject=CoreData.Instance.quickBoxObjectsData[i]
				// check for dmaging collisions
				if (contacts.isCurrentContact(frontWheel, _obj) || contacts.isCurrentContact(backWheel, _obj) || contacts.isCurrentContact(carBody, _obj)) {
					switch (_obj.objID) {
						case OBJECT_TYPE.PINBALL_FLICKER_1:
						case OBJECT_TYPE.PINBALL_FLICKER_2:
							triggerFlicker(_obj)
							break
						default:
							SoundManager.playSound("snd_touch_" + int(Math.random() * 4 + 1), .5)
							break
					}
				}
				if (contacts.isCurrentContact(carBody, _obj)) {
					//	var loc:b2Vec2=contacts.currentPoint.position;
					// you cannot create new QuickObjects inside this listener function
					// what has the player collided with?
					switch (_obj.objID) {
						case OBJECT_TYPE.PINBALL_FLICKER_1:
						case OBJECT_TYPE.PINBALL_FLICKER_2:
							triggerFlicker(_obj)
							break
						case OBJECT_TYPE.WALL_CEILING:
						case OBJECT_TYPE.WALL_GROUND:
						case OBJECT_TYPE.WALL_LEFT:
						case OBJECT_TYPE.WALL_RIGHT:
							trace("player is touching a wall")
							CoreData.Instance.GameSignal.dispatch(GameSignals.PLAYER_DAMAGED)
							break
						case OBJECT_TYPE.PLAYER_BACK_WHEEL:
						case OBJECT_TYPE.PLAYER_FRONT_WHEEL:
						case OBJECT_TYPE.PLAYER_CHASIS:
							// player collides with own objects
							break
						default:
							if (!CoreData.Instance.playerIsOnBack) {
								trace("found collision", "playerIsUpsideDown:" + CoreData.Instance.playerIsUpsideDown)
								CoreData.Instance.GameSignal.dispatch(GameSignals.PLAYER_DAMAGED)
								if (CoreData.Instance.playerIsUpsideDown) {
									CoreData.Instance.playerIsOnBack=true
								}
							}
							break
					}
				}
			}
		}

//		private function collectableCollision(a:b2Shape, b:b2Shape):void {
//			// find the object
//			var i:int=CoreData.Instance.quickBoxObjectsData.length
//			while (i--) {
//				var _obj:QuickObject=CoreData.Instance.quickBoxObjectsData[i]
//				if (b == _obj.shape) {
//					switch (_obj.objID) {
//						case OBJECT_TYPE.FINISH_LINE:
//							// get the location of the collision in world space
////							trace("player touches finish line")
////							PlayingLoopManager.Instance.gameState=settings.GS_LEVEL_COMPLETE
////							stopEngine()
////							CoreData.Instance.quickBoxObjectsData.splice(i, 1)
//							break
//					}
//				}
//			}
//		}
		private function onPersistantCollision(evt:Event):void {
			var wheelCollision:Boolean=false
			var i:int=CoreData.Instance.quickBoxObjectsData.length
			while (i--) {
				var _obj:QuickObject=CoreData.Instance.quickBoxObjectsData[i]
				if (contacts.isCurrentContact(carBody, _obj)) {
					// check if the player is resting on their back
					//trace("player is on their back")
					if (CoreData.Instance.playerIsUpsideDown) {
						if (!CoreData.Instance.playerIsOnBack) {
							CoreData.Instance.playerIsOnBack=true
							CoreData.Instance.playersCollisionCounter=0
						}
					}
				}
				// make sure if objects is not part of the car
				if (contacts.isCurrentContact(backWheel, _obj)) {
					// check if the player is on a surface
					wheelCollision=true
				} else if (contacts.isCurrentContact(frontWheel, _obj)) {
					// check if the player is on a surface
					wheelCollision=true
				}
			}
			if (wheelCollision) {
				CoreData.Instance.playerIsInTheAir=false
			}
		}

		private function onRemoveCollision(evt:Event):void {
			var wheelCollision:Boolean=false
			var i:int=CoreData.Instance.quickBoxObjectsData.length
			while (i--) {
				var _obj:QuickObject=CoreData.Instance.quickBoxObjectsData[i]
				if (contacts.isCurrentContact(carBody, _obj)) {
					// check if the player is resting on their back
					//	CoreData.Instance.playerIsOnBack=false
				}
				// make sure if objects is not part of the car
				if (contacts.isCurrentContact(backWheel, _obj)) {
					wheelCollision=false
				} else if (contacts.isCurrentContact(frontWheel, _obj)) {
					wheelCollision=false
				}
			}
			if (!wheelCollision) {
				CoreData.Instance.playerIsInTheAir=true
			}
		}

		private function testMakeYahoo():void {
			if (Math.random() < .5) {
				SoundManager.playSound("snd_yahoo")
				trace("YAHHHHHHOOOOOOOO!!!")
				trace("CoreData.Instance.distanceTravelledInAir" + CoreData.Instance.distanceTravelledInAir)
			}
			CoreData.Instance.longDistanceYahoo=true
		}

		private function triggerFlicker(_object:QuickObject):void {
			switch (_object.objID) {
				case OBJECT_TYPE.PINBALL_FLICKER_1:
					// flick the object
					_object.body.SetAngularVelocity(-settings.PINBALL_FLICK_FORCE)
					break
				case OBJECT_TYPE.PINBALL_FLICKER_2:
					// flick the object
					_object.body.SetAngularVelocity(settings.PINBALL_FLICK_FORCE)
					break
			}
		}
	}
}