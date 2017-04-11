package com.terrypaton.events{
	import flash.events.*;
	public class EnemyEvents extends Event {
		public static const ENEMY_OFFSCREEN:String = "EnemyEvents.ENEMY_OFFSCREEN";
		public static const ENEMY_TOUCHED:String = "EnemyEvents.ENEMY_TOUCHED";
		
		public static const SHOW_PET_ROCK:String = "EnemyEvents.SHOW_PET_ROCK";
		public static const HIDE_PET_ROCK:String = "EnemyEvents.HIDE_PET_ROCK";
		public static const GET_PET_FRAME:String = "EnemyEvents.GET_PET_FRAME";
		
		public var data:*;
		public function EnemyEvents( controlType:String,bubbles:Boolean = true,data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}