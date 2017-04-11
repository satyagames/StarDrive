package com.terrypaton.events{
	import flash.events.*;
	public class GeneralEvents extends Event {
		public static const CANCEL:String = "GeneralEvents.CANCEL";
		public static const CLOSE_QUICK_HELP:String = "GeneralEvents.CLOSE_QUICK_HELP";
		public static const CLOSE_RENAMER:String = "GeneralEvents.CLOSE_RENAMER";
		public static const PLAY_HEAD_START_DRAG:String = "GeneralEvents.PLAY_HEAD_START_DRAG";
		public static const PLAY_HEAD_STOP_DRAG:String = "GeneralEvents.PLAY_HEAD_STOP_DRAG";
		public static const CLOSE_ABOUT:String = "GeneralEvents.CLOSE_ABOUT";
		public static const CLOSE_SHARE:String = "GeneralEvents.CLOSE_SHARE";
		public static const CLOSE_INTRO:String = "GeneralEvents.CLOSE_INTRO";
		public static const DEMO_FINISHED:String = "GeneralEvents.DEMO_FINISHED";
		public static const SHOW_HELP:String = "GeneralEvents.SHOW_HELP";
		public static const UPDATE_ENEMY_CLIPS:String = "GeneralEvents.UPDATE_ENEMY_CLIPS";
		public static const UPDATE_HEALTHBAR:String = "GeneralEvents.UPDATE_HEALTHBAR";
		public static const UPDATE_LIVES:String = "GeneralEvents.UPDATE_LIVES";
		public static const UPDATE_SCORE:String = "GeneralEvents.UPDATE_SCORE";
		public static const UPDATE_SCORE_SPECIAL:String = "GeneralEvents.UPDATE_SCORE_SPECIAL";
		public static const UPDATE_PLAYERS_OFFSET:String = "GeneralEvents.UPDATE_PLAYERS_OFFSET";
		public static const REVEAL_GAME_HUD:String = "GeneralEvents.REVEAL_GAME_HUD";
		public static const REVEAL_MAIN_MENU:String = "GeneralEvents.REVEAL_MAIN_MENU";
		public static const HIDE_MAIN_MENU:String = "GeneralEvents.HIDE_MAIN_MENU";
		public static const HIDE_SCREENS:String = "GeneralEvents.HIDE_SCREENS";
		public static const QUIT_GAME:String = "GeneralEvents.QUIT_GAME";
		public static const CANCEL_QUIT_GAME:String = "GeneralEvents.CANCEL_QUIT_GAME";
		public static const CONFIRM_QUIT_GAME:String = "GeneralEvents.CONFIRM_QUIT_GAME";
		public static const HIDE_HUD:String = "GeneralEvents.HIDE_HUD";
		public static const SHOW_SCREEN_TRANSITION:String = "GeneralEvents.SHOW_SCREEN_TRANSITION";
		public static const HIDE_SCREEN_TRANSITION:String = "GeneralEvents.HIDE_SCREEN_TRANSITION";
		public static const REMOVE_MOVIECLIP:String = "GeneralEvents.REMOVE_MOVIECLIP";
		public static const RESET_STAGE_FOCUS:String = "GeneralEvents.RESET_STAGE_FOCUS";
		public static const KILL:String = "GeneralEvents.KILL";
		
		public var data:*;
		public function GeneralEvents( custom_type:String,custom_bubbles:Boolean = true,custom_data:Object = null ) {
			super( custom_type,custom_bubbles);
			this.data = custom_data;
		}
		public override function clone():Event {
			return new GeneralEvents(type,bubbles,data );
		}
	}
}