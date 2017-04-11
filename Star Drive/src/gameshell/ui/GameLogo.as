package gameshell.ui {
	import data.CoreData;
	import data.StuntRunParticleSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.managers.SRParticleManager;
	import org.osflash.signals.natives.NativeSignal;

	public class GameLogo extends MovieClip {
		private var _particleSpriteSheet:BitmapData
		private var _fireBitmapData:BitmapData
		private var _fireBitmap:Bitmap

		public function GameLogo(_clip:MovieClip) {
			super();
			// attach the relevant assets basesd on the sponsor
			ref=_clip
			//
			// check that the logo has a effectHolderClip
			if (ref.effectHolder) {
				_particleSpriteSheet=new a_particleSheet(10, 10)
				_particleManager=new SRParticleManager()
				_fireBitmapData=new BitmapData(240, 120, true, 0x00000000)
				_fireBitmap=new Bitmap(_fireBitmapData)
				ref.effectHolder.addChild(_fireBitmap)
				_fireBitmap.x=-_fireBitmap.width * .5
				_fireBitmap.y=-_fireBitmap.height - 50
				// create a loop that generates fire effect
				addEventListener(Event.ENTER_FRAME, loop)
			} else {
				trace("THE GAME LOGO NEEDS A CLIP CALLED 'effectHolder")
			}
		}
		private var _particleManager:SRParticleManager

		public function loop(event:Event):void {
			_fireBitmapData.fillRect(_fireBitmapData.rect, 0x00000000)
			var mx:Number=Math.random() * (_fireBitmapData.width - 40) + 20
			var my:Number=_fireBitmapData.height - 3
			_particleManager.createParticles(mx, my, 2, StuntRunParticleSettings.PARTICLE_FIRE, 0)
			_particleManager.manageParticles(_fireBitmapData, _particleSpriteSheet, 0, 0);
		}

		public function dispose():void {
			_particleManager.dispose()
			_particleManager=null
			removeEventListener(Event.ENTER_FRAME, loop)
			ref=null
			_particleSpriteSheet=null
		}
		public var ref:MovieClip
	}
}