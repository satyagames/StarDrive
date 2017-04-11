package com.terrypaton.events{
	import flash.events.*;
	public class SaveEvents extends Event {
		public static const CANCEL:String = "SaveEvents.CANCEL";
		
		public var data:*;
		public function SaveEvents( controlType:String,bubbles:Boolean = true,data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}