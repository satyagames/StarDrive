package com.terrypaton.utils {
	public class swearWordTester {
		
		// USAGE - swearWordTester.testWordForErrors("shit") - returns false
		
		public static function testWordForErrors(testWord:String):Boolean {
			
			// is word longer than zero characters long
			if (testWord.length < 1) {
				trace("word not long enough")
				return false
			}
			// test for a swear word
			for (si=0; si<swearwordList.length; si++) {
				swearWord = swearwordList[si];
				testWordLC = testWord.toLowerCase();
				isBadword = testWordLC.indexOf(swearWord);
				if (isBadword != -1) {
					return false
				}
			}
			return true
		}
		private static var si:int
		private static var isBadword:int
		private static var swearWord:String
		private static var testWordLC:String
		private static var swearwordList :Array = new Array("co ck","c unt","cu nt","fu ck","f uck","fuk", "fuc", "cnt", "knt", "ass", "dic","fag", "d1k", "4q", "cun", "pis", "nig", "fu", "as5", "a55", "p1s", "fu2", "BJ", "BJU", "bum", "cok", "cum", "tit", "t1t","coc", "koc", "f4g", "c0k", "c0c", "twt","pus", "dyk", "tlt", "sac", "sak", "s4c", "s4k","arse", "fuck", "shit","cunt");
	}
	
}