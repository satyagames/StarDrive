package gameshell.events {
	import flash.display.MovieClip;
	import flash.events.*;

	public class ButtonEvent extends Event {
		public static const OVER : String = "ButtonEvent.over";
		public static const DOWN : String = "ButtonEvent.down";
		public static const OUT : String = "ButtonEvent.out";
		public static const GET_LANGUAGE : String = "ButtonEvent.getlanguage";
		public var name : String;
		public var btarget : MovieClip;

		public function ButtonEvent(controlType : String, bubbles : Boolean = true, _name : String = "", _btarget : MovieClip = null) {
			super(controlType, bubbles);
			this.name = _name;
			this.btarget = _btarget;
		}
	}
}