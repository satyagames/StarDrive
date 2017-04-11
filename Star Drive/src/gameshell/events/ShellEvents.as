package gameshell.events {
	import flash.events.*;
	public class ShellEvents extends Event {
		public static const GO_INTRO:String = "ShellEvents.GO_INTRO";
		public static const GO_MAIN_MENU:String = "ShellEvents.GO_MAIN_MENU";
		public static const GO_MISSION_CHOOSER:String = "ShellEvents.GO_MISSION_CHOOSER";
		public static const GO_GAME_OVER:String = "ShellEvents.GO_GAME_OVER";
		public static const GO_CHALLENGE:String = "ShellEvents.GO_CHALLENGE";
		public static const GO_HIGH_SCORES:String = "ShellEvents.GO_HIGH_SCORES";
		public static const GO_STF:String = "ShellEvents.GO_STF";
		public static const GO_MEDALS:String = "ShellEvents.GO_MEDALS";
		public static const GO_HELP:String = "ShellEvents.GO_HELP";
		public static const GO_GAME:String = "ShellEvents.GO_GAME";
		public static const GO_STANDARD_GAME_COMPLETE:String = "ShellEvents.GO_STANDARD_GAME_COMPLETE";
		public static const GO_SPECIAL_GAME_COMPLETE:String = "ShellEvents.GO_SPECIAL_GAME_COMPLETE";
		public static const CLEAN_UP_MENUS:String = "ShellEvents.CLEAN_UP_MENUS";
		public static const GO_SPONSOR_URL:String = "ShellEvents.GO_SPONSOR_URL";
		public static const GO_CHANGE_THEME:String = "ShellEvents.GO_CHANGE_THEME";
		public static const MOCHI_PLAYER_LOGGED_IN:String = "ShellEvents.MOCHI_PLAYER_LOGGED_IN";
		public static const SUBMIT_SKILL_ADDICTION_SCORE:String = "ShellEvents.SUBMIT_SKILL_ADDICTION_SCORE";
		public static const STOP_SKILL_ADDICTION_SUBMIT:String = "ShellEvents.STOP_SKILL_ADDICTION_SUBMIT";
		public static const GO_GAME_WINS:String = "ShellEvents.GO_GAME_WINS";
		public var data:*;

		public function ShellEvents(controlType:String, bubbles:Boolean = true, data:Object = null) {
			super(controlType, bubbles);
			this.data = data;
		}
	}
}