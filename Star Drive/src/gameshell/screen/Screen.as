package gameshell.screen {
	import flash.display.MovieClip;

	public class Screen extends MovieClip {
		public function Screen() {
			super();
		}

		public function dispose() : void {
//			trace("dispose")
			var n : int = this.numChildren

			while (n--) {
				this.removeChildAt(0)
			}
		}
	}
}