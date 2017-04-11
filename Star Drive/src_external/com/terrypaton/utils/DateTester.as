/**
 * // Date tester by Terry Paton Jan 2009
 */
package com.terrypaton.utils {
	public class DateTester {
		public static function testIfDatePassed(_day:int, _month:int, _year:int):Boolean {
			// january = 0
			var watchDate:Date = new Date (_year, _month, _day);
			var currentDate:Date = new Date ();
			var dateDifference:Number = (currentDate.valueOf() - watchDate.valueOf());
			trace(dateDifference)
			
			var daysDifference:Number = Math.floor (dateDifference / dayN);
			//var tempV:Number = dateDifference - (daysDifference * dayN);
			// var hoursDifference:Number = Math.floor (tempV / hr);
			//var tempV2:Number = dateDifference - (hoursDifference * hr + daysDifference * dayN);
			//var minsDifference:Number = Math.floor (tempV2 / min);
			trace("dayN ="+dayN)
			trace("daysDifference ="+daysDifference)
			if (dateDifference > 0) {
				return true
			}else{
				return false
			}
			return result;
		}
		public static function findDifferenece(_day:int, _month:int, _year:int):Array {
			var watchDate:Date = new Date (_year, _month, _day);
			var currentDate:Date = new Date ();
			var dateDifference:Number = (currentDate.valueOf() - watchDate.valueOf());
			trace(dateDifference)
			
			var daysDifference:Number = Math.floor (dateDifference / dayN);
			var tempV:Number = dateDifference - (daysDifference * dayN);
			var hoursDifference:Number = Math.floor (tempV / hr);
			var tempV2:Number = dateDifference - (hoursDifference * hr + daysDifference * dayN);
			var minsDifference:Number = Math.floor (tempV2 / min);
			return new Array(minsDifference,hoursDifference,daysDifference)
		}
		
		
		private static var min:int = 1000 * 60
		private static var hr:int = min * 60
		private static var dayN:int = hr * 24;
		private static var result:Boolean
	}
}