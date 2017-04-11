package com.terrypaton.events{
	import flash.events.*;
	public class TerrysSoundEvent extends Event {
		public static const PLAY_SOUND:String = "TerrysSoundEvent.play sound";
		public static const STOP_ALL_SOUNDS:String = "TerrysSoundEvent.stop all sounds";
		public static const DRAGGING:String = "TerrysSoundEvent.dragging";
		public static const STRETCHING_STARTED:String = "TerrysSoundEvent.stretching started";
		public static const STRETCHING_STOPPED:String = "TerrysSoundEvent.stretching stopped";
		public static const CREATE_NEW_SAMPLE_INSTANCE:String = "TerrysSoundEvent.create_new_sample_instance";
		public static const DUPLICATE_SAMPLE:String = "TerrysSoundEvent.DUPLICATE_SAMPLE";
		public static const PICK_UP_SAMPLE_CLIP:String = "TerrysSoundEvent.pick_up_sample_clip";
		public static const DROP_SAMPLE_CLIP:String = "TerrysSoundEvent.drop_sample_clip";
		public static const REMOVE_MOVIECLIP:String = "TerrysSoundEvent.remove_movieclip";
		public static const PLAY_LIBRARY_PREVIEW:String = "TerrysSoundEvent.play_library_preview";
		public static const UPDATE_SCROLL_BAR:String = "TerrysSoundEvent.UPDATE_SCROLL_BAR";
		public static const MUTE_CHANNEL:String = "TerrysSoundEvent.MUTE_CHANNEL";
		public static const DISPOSE_SAMPLE:String = "TerrysSoundEvent.DISPOSE_SAMPLE";
		public static const SOLO_CHANNEL:String = "TerrysSoundEvent.SOLO_CHANNEL";
		public static const VOLUME_EDIT_CHANNEL:String = "TerrysSoundEvent.VOLUME_EDIT_CHANNEL";
		public static const UNSOLO_ALL:String = "TerrysSoundEvent.UNSOLO_ALL";
		public var data:*;
		public function TerrysSoundEvent( controlType:String, bubbles:Boolean = true, data:Object = null ) {
			super( controlType,bubbles);
			this.data = data;
		}
	}
}
