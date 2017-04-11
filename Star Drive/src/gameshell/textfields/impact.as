package gameshell.textfields {
	import flash.text.Font;

	/**
	 * This code embeds the font from the resource folder
	 */
	[Embed(source='impact.ttf',fontName='impact',mimeType='application/x-font')]
	/**
	 * This is the nobel bold font.
	 *
	 * <p>
	 * This is an external ttf file which is loaded in when the swf is compiled.
	 * <br/>
	 * Source file is /FlashSolution/resources/fonts/Nobel_Bold.ttf
	 * </p>
	 *
	 */
	public class impact extends Font {
		/**
		 * This is the embedded font name of the font
		 *
		 * <p>
		 * This should be exactly the same as the embedded fontName
		 * </p>
		 *
		 */
		public static const FONT_NAME : String = "impact";

		/**
		 * Constructor
		 *
		 */
		public function impact() {
			super();
		}
	}
}