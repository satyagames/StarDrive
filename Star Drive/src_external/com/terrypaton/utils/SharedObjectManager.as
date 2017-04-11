package com.terrypaton.utils {
	import flash.net.SharedObject;

	public class SharedObjectManager {
		private static var _instance:SharedObjectManager;

		private var so:SharedObject;

		public function SharedObjectManager():void {
			// Debug.log("SharedObjectManager")
			_instance=this;
		}

		public function setupSharedObject(_string:String):void {
			// Debug.log("setupSharedObject: " + _string)
			// setup the shared object if it doesn't exist already
//			dictionary = new Dictionary();
			so=SharedObject.getLocal(_string, "/");
			//so.clear();
			// Debug.log("so.size = " + so.size)
//			// Debug.log("dictionary = " + dictionary)
		}

		public function getData(_string:String):* {
			try {
				var _data:Object=so.data[_string];
				// Debug.log(_data)
				//	Debug.log("getting data," + _string + "," + _data)
				return _data;
			} catch (e:Error) {
				trace("DATA NOT FOUND!");
			}
			return null;
		}

		public static function getInstance():SharedObjectManager {
			return _instance;
		}

		public function setData(_key:String, _val:*):void {
			// Debug.log("setting data," + _key + "," + _val)
			so.data[_key]=_val;
			//save()
		}

		public function save():void {
			// save the shared object
			so.flush();
		}
		//public static var _instance:SharedObjectManager

//		public var dictionary:Dictionary
	}
}