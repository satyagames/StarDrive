package com.terrypaton.events{
	import flash.events.*;
	public class TabEvent extends Event {
		public static const SWITCH_TAB:String = "TabEvent.switchtab";
	
		public var data:*;
		public function TabEvent( controlType:String, bubbles:Boolean = true, data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}