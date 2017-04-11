package gameshell.textfields {
	//import flash.text.AntiAliasType;
	//import flash.text.Font;
	public class ButtonText extends TextBase {
		public function ButtonText(_fontSize : Number = 20, _BoxWidth : Number = 100, _textColour : uint = 0xFFFFFF) {
			super();
			this.textColor = _textColour
			this.selectable = false
			//
			this.embedFonts = true
			trace(_fontSize, _BoxWidth)
			//			this.format.font = impact.FONT_NAME
			/*
			var _font : Font = new font_apex()
			trace(_font.fontName)
			this.format.font = _font.fontName
			this.format.size = _fontSize;
			this.width = _BoxWidth
			this.antiAliasType = AntiAliasType.ADVANCED'
			 * 
			 */
		}
//		private var font1 : Class;
	}
}