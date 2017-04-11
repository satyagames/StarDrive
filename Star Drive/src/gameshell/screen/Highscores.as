package gameshell.screen {
	import gameshell.ui.GraphicBtnClass;
	import gameshell.manager.DisplayManager;
	public dynamic class Highscores extends Screen {
		public function Highscores() {
			var ref : assets_screen_highscores = new assets_screen_highscores()
			addChild(ref)
		//	ref.backgroundLayer.addChild(DisplayManager.Instance.getMenuBackground())
			_btn = new GraphicBtnClass(ref.mainMenuBtn)
			
			StuntRun.Instance.displayHighscores()
		}

		private var _btn : GraphicBtnClass 

		override public function dispose() : void {
			_btn.dispose()
			super.dispose()
		}
	}
}