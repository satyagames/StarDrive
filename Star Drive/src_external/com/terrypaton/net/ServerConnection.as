package com.terrypaton.net{
	
	import flash.net.*
	import flash.events.*;
	
	public class ServerConnection{
		public function ServerConnection() {
			//trace("ServerConnection")
			_instance  =this
		}
		
		public function sendData(_serverURL:String, variables:URLVariables, _callingObject:Object = null, _completeCallback:Function = null):void {
			if (inUse) {
				trace("*** SORRY LOADER IS IN USE, ignoring your request")
			}else{
				inUse = true
				callingObject = _callingObject
				completeCallback = _completeCallback
				
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
				loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				
				var request:URLRequest = new URLRequest(_serverURL);
				
				request.data = variables;
				request.method = URLRequestMethod.POST;
				loader.load(request);
			}
		}
		
		private function loadCompleteHandler(e:Event):void {
			inUse = false
			var loader:URLLoader = URLLoader(e.target);
			if (completeCallback != null) {
				completeCallback.call(callingObject,loader.data)
			}
		}
	
	
		
		
		private function progressHandler(e:ProgressEvent):void {
			//trace(e)
			if (progressCallback != null) {
				progressCallback.call(callingObject,e)
			}
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void{
			trace(e)
			inUse = false
			if (securityErrorCallback != null) {
				securityErrorCallback.call(callingObject,e)
			}
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void {
			//trace(e)
			if (httpStatusCallback != null) {
				httpStatusCallback.call(callingObject,e)
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			trace(e)
			
			inUse = false
			if (ioErrorCallback != null) {
				ioErrorCallback.call(callingObject,e)
			}
		}
		public static function getInstance ():ServerConnection {
			return _instance;
		}
		private static  var _instance:ServerConnection;
		public static var inUse:Boolean = false
		private var callingObject:Object
		private var progressCallback:Function
		private var completeCallback:Function
		private var ioErrorCallback:Function
		private var errorCallback:Function
		private var httpStatusCallback:Function
		private var securityErrorCallback:Function
	}
}