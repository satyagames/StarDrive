package com.terrypaton.utils {
	public class ProcessNumber {
	
	// USAGE - ProcessNumber.pad(12,3) - Returns "012"
	// USAGE - ProcessNumber.pad(24,5) - Returns "00012"
	
	public static function pad(_num:Number,_spaces:int):String {
		outputString = String(_num)
		while (outputString.length < _spaces) {
			outputString = "0"+outputString;
		}
		return outputString;
	}
	private static var outputString:String
}
}