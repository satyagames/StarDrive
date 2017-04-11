package game.managers {
	import data.StuntRunParticleSettings;
	import flash.display.*;
	import flash.geom.*;
	import game.objects.StuntRunParticle;

	public class SRParticleManager {
		private static var _instance:SRParticleManager;

		public static function getInstance():SRParticleManager {
			return _instance;
		}

		public function SRParticleManager() {
			//			trace("particle manager init")
			particleSize=10
			//gravitySpeed = 1
			//gravityAngle = 90
			particleCounter=0
			particleArray=[]
		}
		private var _particleBitmapLoc:Point=new Point()
		private var _particleSize:Point=new Point()
		private var _particleXSize:int
		private var _particleYSize:int
		private var alphaBitmap:BitmapData
		private var cTransform:ColorTransform=new ColorTransform();
		private var copyRect:Rectangle=new Rectangle(0, 0, 10, 10)
		private var newParticle:StuntRunParticle
		private var pCount:int
		private var particleArray:Array
		private var particleCounter:Number
		private var particleHolder:BitmapData
		private var particleScale:Number
		private var particleSize:Number
		private var particleSpriteSheet:BitmapData
		private var renderMatrix:Matrix=new Matrix()
		private var tempLoc:Point=new Point()
		private var trot:Number
		private var zeroPoint:Point=new Point()
		private var particle:StuntRunParticle

		public function createParticles(x:Number, y:Number, _amount:int, _type:int, _rot:Number):void {
			while (_amount--) {
				generateParticle(x, y, _type, _rot)
			}
		}

		public function dispose():void {
			trace("dispose of the particle manager")
			killAllParticles()
			if (newParticle) {
				newParticle=null
			}
			if (particle) {
				particle=null
			}
			particleArray=[]
			particleHolder=null
			newParticle=null
			cTransform=null
			alphaBitmap=null
			particleSpriteSheet=null
			_instance=null
		}

		public function killAllParticles():void {
			trace("kill all particles")
			var p:int=particleArray.length
			while (p--) {
				particle=particleArray[p]
				particle=null
				particleArray.splice(p, 1)
			}
			particleArray=[]
		}

		public function manageParticles(particleHolder:BitmapData, particleSpriteSheet:BitmapData, _xoffset:Number, _yoffset:Number):void {
			particleHolder.lock()
			pCount=0
			var p:int=particleArray.length
			while (p--) {
				particle=particleArray[p]
				pCount++
				if (!particle.alive) {
					//trace ("delete particle")
					particleArray.splice(p, 1)
				} else {
					particle.moveit();
					_particleSize=particle.getSize()
					_particleBitmapLoc=particle.getSheetloc()
					particleScale=particle.getScale()
					//trace("_particleSize = "+_particleSize)
					var pxSize:int=_particleSize.x * particleScale
					var pySize:int=_particleSize.y * particleScale
					if (pxSize < 1) {
						pxSize=1
					}
					if (pySize < 1) {
						pySize=1
					}
					var particleBitmap:BitmapData=new BitmapData(_particleSize.x, _particleSize.y, true, 0x00000000);
					copyRect.x=_particleBitmapLoc.x
					copyRect.y=_particleBitmapLoc.y
					copyRect.width=_particleSize.x
					copyRect.height=_particleSize.y
					particleBitmap.copyPixels(particleSpriteSheet, copyRect, zeroPoint, null, null, true)
					tempLoc=particle.getLoc()
					cTransform.alphaMultiplier=particle.getAlpha()
					renderMatrix.identity()
					renderMatrix.scale(particleScale, particleScale)
					trot=particle.getRot()
					renderMatrix.rotate(trot);
					var tx:Number=copyRect.width / 2 * particleScale
					var ty:Number=copyRect.height / 2 * particleScale
					var cosr:Number=Math.cos(trot)
					var sinr:Number=Math.sin(trot)
					var xv:Number=cosr * tx
					var xv2:Number=sinr * tx
					var yv:Number=sinr * ty
					var yv2:Number=cosr * ty
					var renderX:Number=tempLoc.x - (xv - xv2) + tx					var renderY:Number=tempLoc.y - (yv + yv2) + ty
					renderX+=_xoffset
					renderY+=_yoffset
//					trace("renderX:" + renderX, "renderY:" + renderY)
					renderMatrix.translate(renderX, renderY);
					particleHolder.draw(particleBitmap, renderMatrix, cTransform)
				}
			}
			particleHolder.unlock()
			//return (pCount)
		}

		private function generateParticle(x:Number, y:Number, _typeOfParticle:int, _rot:Number):void {
			//	trace("generate particle")
			//trace("_typeOfParticle:" + _typeOfParticle)
			// setup defaults
			_particleBitmapLoc.x=0
			_particleBitmapLoc.y=0
			_particleYSize=_particleXSize=20
			var xoffset:Number=0
			var yoffset:Number=0
			switch (_typeOfParticle) {
				case StuntRunParticleSettings.PARTICLE_LEVEL_COMPLETE:
					var r:int=Math.random() * 3
					_particleBitmapLoc.x=20 + r * 20
					_particleBitmapLoc.y=0
					_particleYSize=_particleXSize=20
					break				case StuntRunParticleSettings.PARTICLE_COLLECT:
					_particleBitmapLoc.x=0
					_particleBitmapLoc.y=0
					_particleYSize=_particleXSize=6
					//xoffset = Math.random() * 30 - 15
					//yoffset = Math.random() * 30 - 15
					break
				case StuntRunParticleSettings.PARTICLE_COIN:
					_particleBitmapLoc.x=12
					_particleBitmapLoc.y=0
					_particleYSize=_particleXSize=20
					break
				case StuntRunParticleSettings.PARTICLE_FIRE:
					_particleBitmapLoc.x=20 + int(Math.random() * 4) * 20;
					//_particleBitmapLoc.x=20
					_particleBitmapLoc.y=20;
					_particleYSize=_particleXSize=20
					break
				case StuntRunParticleSettings.PARTICLE_PLAYER_HURT:
					_particleBitmapLoc.x=0
					_particleBitmapLoc.y=20
					_particleYSize=_particleXSize=3
					break
				case StuntRunParticleSettings.PARTICLE_COLLECT_POINTS:
					_particleBitmapLoc.x=20
					_particleBitmapLoc.y=20;
					_particleYSize=_particleXSize=4;
					break
				case StuntRunParticleSettings.PARTICLE_COLLECT_POWERUP:
					_particleBitmapLoc.x=20
					_particleBitmapLoc.y=9
					_particleYSize=_particleXSize=4;
					break
				case StuntRunParticleSettings.PARTICLE_GUN_FIRING:
					_particleBitmapLoc.x=40;
					_particleBitmapLoc.y=0;
					_particleYSize=_particleXSize=20
					break
				case StuntRunParticleSettings.PARTICLE_EXHAUST_SMOKE:
					_particleBitmapLoc.x=20 + int(Math.random() * 4) * 20;
					_particleBitmapLoc.y=0;
					_particleYSize=_particleXSize=20
					break
			}
			newParticle=new StuntRunParticle(x + xoffset, y + yoffset, _typeOfParticle, _particleXSize, _particleYSize, _particleBitmapLoc.x, _particleBitmapLoc.y, _rot);
			//trace(newParticle)
			//particleDict [newParticle] = newParticle
			particleArray.push(newParticle)
			particleCounter++
			if (particleArray.length > 50) {
				particle=particleArray[0]
				particle.alive=false
			}
			//trace(particleCounter)
		}
	}
}