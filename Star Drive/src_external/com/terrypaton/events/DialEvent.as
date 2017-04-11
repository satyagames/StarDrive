package com.terrypaton.events{
	import flash.events.*;
	public class DialEvent extends Event {
		public static const DIAL_UPDATED:String = "DialEvent.DIAL_UPDATED";
	
		public var data:*;
		public function DialEvent( controlType:String, bubbles:Boolean = true, data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}