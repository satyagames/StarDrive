package com.terrypaton.utils {

	public class commaNumber {
		// USAGE - commaNumber.processNumber(12000) - Returns "12,000"
		public static function processNumber(_num : Number) : String {
			if (_num < 1000) {
				outputString = _num.toString();
			} else {
				outputString = "";
				var sourceString : String = _num.toString();
				var tn : Number = sourceString.length;
				//var split : Number = (tn / 3);
				var flatSplit : int = Math.floor(tn / 3);
				var diff : Number = tn - (flatSplit * 3);
				var currentNum : int = 0;

				if (diff > 0) {
					outputString += sourceString.slice(currentNum, diff) + ",";
					sourceString = sourceString.slice(diff, tn);
				}

				for (var i : int = 0; i < flatSplit; i++) {
					var p1 : Number = i * 3;
					var p2 : Number = p1 + 3;

					if (i > 0) {
						outputString += ",";
					}
					outputString += sourceString.slice(p1, p2);
				}
			}
			return outputString;
		}
		private static var outputString : String
	}
}