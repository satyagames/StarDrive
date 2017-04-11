package com.terrypaton.events{
	import flash.events.*;
	public class ScrollBarEvent extends Event {
		public static const SCROLLBAR_UPDATED:String = "ScrollBarEvent.SCROLLBAR_UPDATED";
		
		public var data:*;
		public function ScrollBarEvent( controlType:String, bubbles:Boolean = true, data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}