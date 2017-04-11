package game.objects {
	import com.terrypaton.media.SoundManager;
	import flash.geom.Rectangle;
	import flashx.textLayout.events.DamageEvent;
	import data.CoreData;
	import data.RACE_STATE;
	import data.settings;
	import game.managers.DataManager;
	import game.managers.RenderManager;
	import game.objects.RenderObject;

	public class Player extends RenderObject {
		public function Player(_x:Number, _y:Number, _type:OBJECT_TYPE) {
			playersExtraSpeed=0
			powerUpType=null
			collisionRect=new Rectangle(-settings.PLAYER_COLLISION_LENGTH * .5, -settings.PLAYER_COLLISION_HEIGHT * .5, settings.PLAYER_COLLISION_LENGTH, settings.PLAYER_COLLISION_HEIGHT)
			super(_x, _y, _type, null);
		}
		public var _pressurePercent:Number
		public var addit:Number
		public var dx:Number;
		//	private var hitrect : Rectangle;
		//	private var tRotDiff : Number;
		public var dy:Number;
		public var gridLocX:int
		public var gridLocY:int
		public var lastGridLocY:int
		public var lastMiniTimeSegment:int=-1
		public var lastRadians:Number;
		public var lastSafeX:Number;
		public var lastSafeY:Number;
		public var lastY:Number
		//
		public var lastxVelocity:Number=0;
		public var lastyVelocity:Number=0;
		public var miniTimeSegment:int
		public var moveAngle:Number
		public var movementRadians:Number
		public var powerUpCounter:int
		public var powerUpCounterReset:int=30 * 8 // you get 8 seconds worth of speed up
		public var powerUpType:OBJECT_TYPE
		public var renderFrame:int;
		//
		public var tRadian:Number
		//	private var rotTarDiff : Number 		public var targetRot:Number=0
		//
		public var testX1:Number
		public var testX2:Number
		//	public var xVelocity:Number=0;
//		public var yVelocity:Number=0;
		public var tireRad:Number;
		private var collisionRect:Rectangle
		private var onOil:Boolean;
		//	private var lastRotation : Number 
		//	private var lastRot : Number		private var playerFacingDirection:int
		private var playersExtraSpeed:Number

		override public function manage():void {
			super.manage()
		}
	}
}