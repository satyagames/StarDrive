package com.terrypaton.events{
	import flash.events.*;
	public class PlayingLoopEvent extends Event {
		public static const SETUP_NEW_GAME:String = "PlayingLoopEvent.SETUP_NEW_GAME";
		
		public static const GO_GAME_SCREEN:String = "PlayingLoopEvent.GO_GAME_SCREEN";
		public static const GO_HELP_SCREEN:String = "PlayingLoopEvent.GO_HELP_SCREEN";
		public static const GO_MAIN_MENU:String = "PlayingLoopEvent.GO_MAIN_MENU";
		public static const GO_DOWNLOAD_SCREEN:String = "PlayingLoopEvent.GO_DOWNLOAD_SCREEN";
		public static const GO_GAME_COMPLETE:String = "PlayingLoopEvent.GO_SPECIAL_GAME_COMPLETE";
		public static const GO_LEVEL_COMPLETE:String = "PlayingLoopEvent.GO_LEVEL_COMPLETE";
		public static const GO_NEXT_LEVEL:String = "PlayingLoopEvent.GO_NEXT_LEVEL";
			
		public static const INIT:String = "PlayingLoopEvent.INIT";
		
		public static const EXECUTE_PLAYING_FUNCTIONS:String = "PlayingLoopEvent.EXECUTE_PLAYING_FUNCTIONS";
		
		public static const RENDER_SCREEN:String = "PlayingLoopEvent.RENDER_SCREEN";
		
		public static const MANAGE_ENEMY:String = "PlayingLoopEvent.MANAGE_ENEMY";
		public static const MANAGE_DINO:String = "PlayingLoopEvent.MANAGE_DINO";
		public static const MANAGE_PLAYER:String = "PlayingLoopEvent.MANAGE_PLAYER";
		public static const MANAGE_ITEMS:String = "PlayingLoopEvent.MANAGE_ITEMS";
		public static const PLAYER_LOSES_LIFE:String = "PlayingLoopEvent.PLAYER_LOSES_LIFE";
		public static const SHOW_INTRO_MOVIE:String = "PlayingLoopEvent.SHOW_INTRO_MOVIE";
		public static const INTRO_MOVIE_OVER:String = "PlayingLoopEvent.INTRO_MOVIE_OVER";
		public static const DISPLAY_LEVEL_COMPLETE:String = "PlayingLoopEvent.DISPLAY_LEVEL_COMPLETE";
		public static const DISPLAY_GAME_COMPLETE:String = "PlayingLoopEvent.DISPLAY_GAME_COMPLETE";
	
		
		public static const TOGGLE_STATS:String = "PlayingLoopEvent.TOGGLE_STATS";
		public var data:*;
		public function PlayingLoopEvent( controlType:String, bubbles:Boolean = true, data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}