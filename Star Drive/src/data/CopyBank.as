package data {
	// possible commands - sans='true' fontSize='30' setLines='200' yoffset='-10' setLeading='-5'
	import com.terrypaton.utils.Debug
	//import flash.//trace.//trace;

	import flash.text.*;
	public class CopyBank {
		public function CopyBank() : void {
			// setup the language
			////trace ("CopyBank");
			if (_instance) {
				//trace("HEY CopyBank already exists!")
			} else {
				_instance = this;
			}

			include "languageData.xml"
			sansFormat = new TextFormat();
			sansFormat.font = "Verdana";
			sansFormat.size = 10;
		}

		private static var sansFormat : TextFormat

		public static function outputAlltext() : void {
			var n : int = languageDataXML.item.length()
			//trace("copybank n:" + n)
			//trace("COPYBANK ALL TEXT -------------------------------------------------")
			while (n--) {
				trace(languageDataXML.item[n].@name + "^" + languageDataXML.item[n].en)
			}

			//trace("-------------------------------------------------")
		}

		public static function setText(_textField : TextField,_string : String,_htmlText : Boolean = false) : void {

			var result : String = languageDataXML.item.(@name == _string).child(currentLanguage);
			if (result == "") {
				trace("COPYBANK NEEDS TEXT FOR:" + _string)
				result = languageDataXML.item.(@name == _string).child("en");
			}

			if (_htmlText) {
				_textField.htmlText = result
			} else {
				try {
					_textField.text = result
				} catch (e : Error) {
				}
			}
			//
			var isSans : String = languageDataXML.item.(@name == _string).child(currentLanguage).@sans
			var checkStandardCharacters : RegExp = /^[a-z0-9 \/\\_'"!?,.;:-]+$/i;
			//trace(checkStandardCharacters.test(result))
			if (isSans != "" || !checkStandardCharacters.test(result)) {
				//trace("turn into sans")
				try {
					sansFormat = _textField.getTextFormat()
					sansFormat.font = "_sans"
					_textField.embedFonts = false
					_textField.setTextFormat(sansFormat)
					_textField.multiline = true
				}catch(e : Error) {
				}
			}
			var fontSize : String = languageDataXML.item.(@name == _string).child(currentLanguage).@fontSize
			////trace(result,"fontSize = "+fontSize)
			if (fontSize != "") {
				////trace("change the font size")
				sansFormat = _textField.getTextFormat()
				sansFormat.size = Number(fontSize)
				_textField.setTextFormat(sansFormat)
			}
			// test if the text is too big to fit in
			//var _textBoxWidth:Number = _textField.width
			//var _textBoxHeight:Number = _textField.height

			//var _textWidth:Number = _textField.textWidth
			//var _textHeight:Number = _textField.textHeight
			var setLines : String = languageDataXML.item.(@name == _string).child(currentLanguage).@setLines
			if (setLines != "") {
				////trace("make the text box have multilines")
				_textField.height = Number(setLines)
				_textField.multiline = true
				_textField.wordWrap = true
			}
			//			trace("----")
			//			trace("_textBoxWidth:" + _textBoxWidth)
			//			trace("_textField.textWidth:" + _textWidth)
			//			trace("_textHeight:" + _textBoxHeight)
			//			trace("_textField.textHeight:" + _textHeight)
			var count : int = 0
			while (!testSize(_textField)) {
				//if (!testSize(_textField)){
				sansFormat = _textField.getTextFormat()
				trace(sansFormat.size)
				var newNum : Number = Number(sansFormat.size)
				//var newNum:Number = 10
				sansFormat.size = Number(newNum - 1)
				_textField.setTextFormat(sansFormat)
				count++
				if (count > 200) {
					break
				}
			}

			var setLeading : String = languageDataXML.item.(@name == _string).child(currentLanguage).@setLeading
			if (setLeading != "") {
				sansFormat = _textField.getTextFormat()
				sansFormat.leading = Number(setLeading)
				_textField.setTextFormat(sansFormat)

					//_textField.height = setLines
			}
			var yoffset : String = languageDataXML.item.(@name == _string).child(currentLanguage).@yoffset

			if (yoffset != "") {
				_textField.y += Number(yoffset)
			}
		}

		private static function testSize(_textField : TextField) : Boolean {
			var _textBoxWidth : Number = _textField.width
			var _textBoxHeight : Number = _textField.height

			var _textWidth : Number = _textField.textWidth
			var _textHeight : Number = _textField.textHeight

			if (_textField.maxScrollV > 1) {
				return false
			}
			if (_textWidth > _textBoxWidth || _textHeight > _textBoxHeight) {
				return false
			}
			//if (_textWidth > _textBoxWidth && _textHeight >_textBoxHeight) {
			//return false
			//}
			return true
		}

		public static function getErrorText(_string : String) : String {
			var _nstring : String = "error_" + _string
			Debug.log("error string: " + _nstring)
			var result : String = languageDataXML.item.(@name == _nstring).child(currentLanguage);
			if (result == "") {
				//trace("NEED:" + _string)
				result = languageDataXML.item.(@name == _nstring).child("en");
			}

			if (result == "" || result == null) {
				trace("NEED:" + _nstring)
				result = ""
			}
			return result;
		}

		public static function getText(_string : String) : String {
			var result : String = languageDataXML.item.(@name == _string).child(currentLanguage);
			if (result == "") {
				//trace("NEED:" + _string)
				result = languageDataXML.item.(@name == _string).child("en");
			}

			if (result == "" || result == null) {
				//trace("NEED:" + _string)
				result = ""
			}
			return result;
		}

		public static function get Instance() : CopyBank {
			return _instance;
		}

		public static function changeLanguage(_newLanguage : String) : void {
			//trace ("_newLanguage:"+_newLanguage);
			currentLanguage = _newLanguage;
		}

		private static var _instance : CopyBank;
		private static var languageDataXML : XML;
		public static var currentLanguage : String = "en";
	}
}