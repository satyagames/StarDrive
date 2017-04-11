package game.objects {
	import data.StuntRunParticleSettings;
	import flash.display.*;
	import flash.geom.Point;
	import game.managers.DataManager;

	public class StuntRunParticle {
		public var lastX:Number;
		public var lastY:Number;
		public var x:Number;
		public var y:Number;
		private var bx:Number;
		private var by:Number;
		//private var gravity:Number;
		public var alive:Boolean;
		public var moving:Boolean;
		public var life:int;
		public var alphaVal:Number;
		public var dx:Number;
		public var dy:Number;
		public var gx:Number;
		public var gy:Number;
		public var reduceAlpha:Number;
		public var scale:Number;
		public var _speed:Number;
		private var rot:Number;
		private var radians:Number;
		private var angle:Number;
		private var sheetX:Number;
		private var sheetY:Number;
		private var xSize:Number;
		private var ySize:Number;
		//private var spriteRef:Sprite;
		public var bitmapRef:Bitmap;
		public var particleType:int;
		public var baseAlpha:Number;
		public var xpos:int // position in the bitmap to copy from

		public function StuntRunParticle(_x:int, _y:int, _particleType:int, _xSize:Number, _ySize:Number, _sheetX:int, _sheetY:int, _angle:Number=0) {
			particleType=_particleType
			lastX=x=_x
			lastY=y=_y
			alive=true
			xSize=_xSize
			ySize=_ySize
			life=20
			sheetX=_sheetX
			sheetY=_sheetY
			sheetLoc.x=sheetX
			sheetLoc.y=sheetY
			alphaVal=1
			rot=(Math.random() * 360) / 180 * Math.PI
			baseAlpha=1
			moving=true
			// setup defaults
			// var _startRotation:Number = Math.random() * 360
			var _gravitySpeed:Number=0
			var _gravityAngle:Number=90
			reduceAlpha=0
			_speed=2
			//angle = Math.random() * 360
			// now change the defaults depending on the particle
			angle=_angle
			//angle = Math.random() * 360
			scale=Math.random() * .8 + .5
			_speed=Math.random() * 2 + 1
			life=70
			var canFade:Boolean=true
			radians=(_gravityAngle) * Math.PI / 180;
			switch (particleType) {
				case StuntRunParticleSettings.PARTICLE_LEVEL_COMPLETE:
					_speed=3 + Math.random()
					angle=-90 + Math.random() * 10 - 5
					life=160 + Math.random() * 60
					alphaVal=1
					scale=Math.random() * .8 + .2
					//alphaVal = Math.random() * .8 + .2;
					_gravitySpeed=0
					canFade=false
					break
				case StuntRunParticleSettings.PARTICLE_PLAYER_HURT:
					_speed=2 + Math.random() * 2
					angle=Math.random() * 360
					life=30 + Math.random() * 20
					alphaVal=1
					x+=Math.random() * 20 - 10
					y+=Math.random() * 20 - 10
					canFade=true
					break
				case StuntRunParticleSettings.PARTICLE_COLLECT:
					rot=0
					//_speed = Math.random() * .5 + 2
					_speed=1 + Math.random() * 2
					angle=Math.random() * 360
					life=30 + Math.random() * 20
					alphaVal=1
					x+=Math.random() * 6 - 3
					y+=Math.random() * 6 - 3
					canFade=true
					break
				case StuntRunParticleSettings.PARTICLE_COIN:
					rot=0
					//_speed = Math.random() * .5 + 2
					_speed=2
					angle=-90 + Math.random() * 180 - 90
					life=30 + Math.random() * 20
					alphaVal=1
					_gravitySpeed=6
					scale=1
					canFade=true
					break
				case StuntRunParticleSettings.PARTICLE_FIRE:
					rot=Math.random() * 360
					//_speed = Math.random() * .5 + 2
					_speed=1
					angle=-90 + Math.random() * 30 - 15
					life=40 + Math.random() * 30
					alphaVal=1
					_gravitySpeed=0
					scale=1
					canFade=true
					break
				case StuntRunParticleSettings.PARTICLE_EXHAUST_SMOKE:
				//	rot=Math.random() * 360
					//_speed = Math.random() * .5 + 2
					_speed=2
					angle=-90 + Math.random() * 30 - 15
					life=30 + Math.random() * 20
					alphaVal=1
					_gravitySpeed=0
					scale=Math.random() * .5 + .5
					canFade=true
					break
			}
			if (canFade) {
				reduceAlpha=1 / life
			} else {
				reduceAlpha=0
			}
			gx=0
			gy=_gravitySpeed
			// movement
			radians=angle * Math.PI / 180;
			bx=(_speed * Math.cos(radians));
			by=(_speed * Math.sin(radians))
		}
		private var returnPoint:Point=new Point()

		public function getParticleType():int {
			return particleType
		}

		public function getSheetloc():Point {
			return sheetLoc
		}
		private var sheetLoc:Point=new Point()

		public function getScale():Number {
			return scale
		}

		public function getSize():Point {
			//trace("getSize = "+xSize)
			returnPoint.x=xSize
			returnPoint.y=ySize
			return returnPoint
		}

		public function getAlpha():Number {
			return alphaVal
		}

		public function getRot():Number {
			return rot
		}

		public function getLoc():Point {
			returnPoint.x=x - xSize / 2
			returnPoint.y=y - ySize / 2
			return returnPoint
		}

		public function effectParticle(_vx:Number, _vy:Number):void {
			x+=_vx
			y+=_vy
		}

		public function moveit():void {
			if (alive) {
				life--
				if (life < 1) {
					alive=false
				}
				dx=x - lastX
				dy=y - lastY
				radians=Math.atan2(dy, dx)
				switch (particleType) {
					case StuntRunParticleSettings.PARTICLE_LEVEL_COMPLETE:
						angle+=Math.random() * 10 - 5
						radians=angle * Math.PI / 180;
						bx=(_speed * Math.cos(radians));
						by=(_speed * Math.sin(radians))
						break
					case StuntRunParticleSettings.PARTICLE_COLLECT:
						angle+=Math.random() * 10 - 5
						radians=angle * Math.PI / 180;
						bx=(_speed * Math.cos(radians));
						by=(_speed * Math.sin(radians))
						if (y < 0) {
							//	trace("kill particle")
							//	alive=false
						}
						break
					case StuntRunParticleSettings.PARTICLE_COIN:
						angle+=2
						radians=angle * Math.PI / 180;
						bx=(_speed * Math.cos(radians));
						by=(_speed * Math.sin(radians))
						if (y < 0) {
							//	trace("kill particle")
							//	alive=false
						}
						by+=gx
						by+=gy
						break
					case StuntRunParticleSettings.PARTICLE_FIRE:
					angle+=Math.random()*5 - 2.5
						radians=angle * Math.PI / 180;
						bx=(_speed * Math.cos(radians));
						by=(_speed * Math.sin(radians))
						if (y < 0) {
							//	trace("kill particle")
							alive=false
						}
						by+=gx
						by+=gy
						break
					case StuntRunParticleSettings.PARTICLE_EXHAUST_SMOKE:
						angle+=Math.random() * 4 - 2
						radians=angle * Math.PI / 180;
						bx=(_speed * Math.cos(radians));
						by=(_speed * Math.sin(radians))
						break
				}
				lastX=x
				lastY=y
				//				trace(x)
				x+=bx
				y+=by
				bx+=gx
				by+=gy
				//spriteRef.x = x
				//spriteRef.y = y
				//spriteRef.rotation = rot
				if (Math.abs(bx) < .1 && Math.abs(by) < .1) {
					moving=false
				}
				if (reduceAlpha != 0) {
					alphaVal-=reduceAlpha
					if (alphaVal < .02) {
						alive=false
					}
				}
			}
		}
	}
}