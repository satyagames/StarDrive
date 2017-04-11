package gameshell.textfields {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * This is the base text field class which holds reference to the text format
	 *
	 * <p>
	 * Always use this class when using a text format so that the text field will always have the correct text format when it's updated
	 * </p>
	 */
	public class TextBase extends TextField {
		/**
		 * @private
		 */
		private var m_format : TextFormat;

		/**
		 * This is the text format which is set on the text field everytime htmlText is called
		 */
		public function get format() : TextFormat {
			return m_format;
		}

		/**
		 * @private
		 */
		public function set format(a_format : TextFormat) : void {
			m_format = a_format;
		}

		/**
		 * @inheritDoc
		 */
		public override function set htmlText(value : String) : void {
			super.htmlText = value;
			this.setTextFormat(this.format);
		}

		/**
		 * Constructor
		 *
		 */
		public function TextBase() {
			super();
			m_format = new TextFormat();
			this.embedFonts = true;
			this.selectable = true;
			this.autoSize = TextFieldAutoSize.LEFT;
		}
	}
}