package com.terrypaton.events{
	import flash.events.*;
	public class SliderEvent extends Event {
		public static const CHANNEL_VOLUME_SLIDER_UPDATED:String = "SliderEvent.CHANNEL_VOLUME_SLIDER_UPDATED";
		public static const CHANNEL_PAN_SLIDER_UPDATED:String = "SliderEvent.CHANNEL_PAN_SLIDER_UPDATED";
	
		public static const MASTER_VOLUME_SLIDER_UPDATED:String = "SliderEvent.MASTER_VOLUME_SLIDER_UPDATED";
		public static const VISUALISER_SLIDER_UPDATED:String = "SliderEvent.VISUALISER_SLIDER_UPDATED";
		public static const ZOOM_SLIDER_UPDATED:String = "SliderEvent.ZOOM_SLIDER_UPDATED";
		
		public var data:*;
		public function SliderEvent( controlType:String, bubbles:Boolean = true, data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}