package com.terrypaton.events{
	import flash.events.*;
	public class GalleryEvents extends Event {
		public static const TRACK_SELECTED:String = "GalleryEvents.TRACK_SELECTED";
		public static const TRACK_LOADED:String = "GalleryEvents.TRACK_LOADED";
		public static const CLOSER_TRACK_LOADER:String = "GalleryEvents.CLOSER_TRACK_LOADER";
		
		public var data:*;
		public function GalleryEvents( controlType:String,bubbles:Boolean = true,data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}