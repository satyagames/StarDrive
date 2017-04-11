package com.terrypaton.utils {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	public class goURL {

		public function launchURLinBrowser(_url : String) : void {
			var request : URLRequest = new URLRequest(_url);
			navigateToURL(request, "_blank");
		}
	}
}