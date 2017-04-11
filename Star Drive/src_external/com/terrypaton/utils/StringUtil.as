package com.terrypaton.utils {
	public class StringUtil {
	
	// USAGE checks if an email address is valid - StringUtil.checkEmail("terry@terrypaton.com") - return true
	
	public static function checkEmail(_email:String):Boolean {
		//trace("checking : "+_email)
		var passCheck:Boolean = false
		var atLoc:int = _email.indexOf("@")
		var dotLoc:int = _email.indexOf(".")
		if (atLoc > 0 && dotLoc >0) {
			passCheck =true
		}
		return passCheck
	}
	public static function isValidEmail(email:String):Boolean {
		var EMAIL_REGEX : RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		return Boolean(email.match(EMAIL_REGEX));

	}
}
}