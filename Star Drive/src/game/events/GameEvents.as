package game.events {
	import flash.events.*;
	public class GameEvents extends Event {
		public static const UPDATE_HUD:String = "GameEvents.UPDATE_HUD";
		public var data:*;

		public function GameEvents(controlType:String, bubbles:Boolean = true, data:Object = null) {
			super(controlType, bubbles);
			this.data = data;
		}
	}
}