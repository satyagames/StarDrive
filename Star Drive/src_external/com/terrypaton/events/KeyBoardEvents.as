package com.terrypaton.events{
	import flash.events.*;
	public class KeyBoardEvents extends Event {
		public static const UP_PRESSED:String = "KeyBoardEventsUP_PRESSED";
		public static const UP_RELEASED:String = "KeyBoardEventsUP_RELEASED";
		
		public static const DOWN_PRESSED:String = "KeyBoardEventsDOWN_PRESSED";
		public static const DOWN_RELEASED:String = "KeyBoardEventsDOWN_RELEASED";
		
		public static const LEFT_PRESSED:String = "KeyBoardEventsLEFT_PRESSED";
		public static const LEFT_RELEASED:String = "KeyBoardEventsLEFT_RELEASED";
		
		public static const RIGHT_PRESSED:String = "KeyBoardEventsRIGHT_PRESSED";
		public static const RIGHT_RELEASED:String = "KeyBoardEventsRIGHT_RELEASED";
		
		public static const SPACE_PRESSED:String = "KeyBoardEventsSPACE_PRESSED";
		public static const SPACE_RELEASED:String = "KeyBoardEventsSPACE_RELEASED";
		
		public var data:*;
		public function KeyBoardEvents( controlType:String,bubbles:Boolean = true,data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}