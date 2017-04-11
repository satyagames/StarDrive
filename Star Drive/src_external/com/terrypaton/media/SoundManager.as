package com.terrypaton.media {
	import com.gs.TweenLite;
	import data.CoreData;
	import flash.media.*;
	import flash.utils.*;

	public class SoundManager {
		public function SoundManager() {
			// trace("## Sound Manager init")
			trans=new SoundTransform(1, 0);
			musicTrans=new SoundTransform(1, 0);
			musicChannel=new SoundChannel()
			_instance=this;
		}
		private static var _instance:SoundManager;

		public static function get Instance():SoundManager {
			return _instance;
		}

		public static function toggleMusic():void {
			//trace("toggle music")
			if (CoreData.Instance.sound_playMusic) {
				trace("music off")
				TweenLite.to(musicChannel, 2, {volume: 0});
				CoreData.Instance.sound_playMusic=false
			} else {
				trace("music on")
				TweenLite.to(musicChannel, .5, {volume: 1});
				CoreData.Instance.sound_playMusic=true
			}
		}

		public static function adjustVolume(_newVolume:Number):void {
			//			trace(_newVolume)
			//			trace(" trans = " + trans)
			trans.volume=_newVolume
		}
		public static var currentPlayingMusic:String="";

		public static function playMusic(_soundLinkageRef:String, _volume:Number=1):void {
			//			trace("PLAY SOUND: " + _soundLinkageRef);
			if (currentPlayingMusic != _soundLinkageRef) {
				currentPlayingMusic=_soundLinkageRef
				if (!CoreData.Instance.sound_playMusic) {
					musicTrans.volume=0
				}
				musicChannel.stop()
				try {
					var ClassReference:Class=getDefinitionByName(_soundLinkageRef) as Class;
					musicobj=new ClassReference();
					musicChannel=musicobj.play(0, 9999, musicTrans)
					if (CoreData.Instance.sound_playMusic) {
						TweenLite.to(musicChannel, 2, {volume: _volume});
					}
				} catch (e:Error) {
				}
			}
		}

		public static function playSound(_soundLinkageRef:String, _volume:Number=1):void {
			//			trace("PLAY SOUND: " + _soundLinkageRef);
			if (CoreData.Instance.sound_playSfx) {
				trans.volume=_volume
				try {
					var ClassReference:Class=getDefinitionByName(_soundLinkageRef) as Class;
					mysoundobj=new ClassReference();
					mysoundobj.play(0, 0, trans)
				} catch (e:Error) {
					trace("** NEED THE SOUND :" + _soundLinkageRef)
				}
			}
		}
		private static var musicChannel:SoundChannel;
		private static var musicobj:Sound;
		private static var mysoundobj:Sound;
		public static var trans:SoundTransform
		public static var musicTrans:SoundTransform
	}
}