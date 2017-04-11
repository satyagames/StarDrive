package com.terrypaton.items{
	public class CameraClass {
		public var cx:Number;
		public var cy:Number;
		public var cz:Number;
		public var crotation:Number;
		public var cangle:Number;
		public function CameraClass(_newx:Number,_newy:Number,_newz:Number,_newRotation:Number,_newAngle:Number):void {
				trace("new CameraClass")
				cx = _newx;
				cy = _newy;
				cz = _newz;
				crotation = _newRotation;
				cangle = _newAngle;
		}

		
	}
}