package gameshell.ui {
	import com.terrypaton.media.SoundManager;

	import flash.text.TextField;

	import org.osflash.signals.natives.NativeSignal;

	import data.CoreData;

	import com.gs.TweenLite;

	import data.CopyBank;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import gameshell.textfields.ButtonText;
	public class Drive2Button extends BtnClass {
		private var textBox : TextField;
		private var MouseSignalOver : NativeSignal;
		private var MouseSignalOut : NativeSignal;

		public function Drive2Button(_name : String, _buttonWidth : Number = 100, _buttonHeight : Number = 30, _textColour : uint = 0xFFFFFF, _colour1 : uint = 0x40b001, _twoLines : Boolean = false) {
			
			this.name = _name
			buttonWidth = _buttonWidth
			buttonHeight = _buttonHeight
			_col1 = _colour1
			textColour = _textColour
			twoLines = _twoLines
			init()
			ref = this
			super(this)
		}

		private var twoLines : Boolean

		override public function dispose() : void {
			//this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownBTNHandler);
			//this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverBTNHandler);
			//this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutBTNHandler);
			MouseSignal.removeAll()			MouseSignalOver.removeAll()			MouseSignalOut.removeAll()
			MouseSignal = null			MouseSignalOver = null			MouseSignalOut = null
		}

		private function init() : void {
			var _shape : Shape = new Shape()
			addChild(_shape)
			_shape.graphics.beginFill(_col1, 1)
			_shape.graphics.endFill()
			//
			// draw end shape
			_shape = new Shape()
			addChild(_shape)
			_shape.graphics.beginFill(0x000000, .5)
			_shape.graphics.lineStyle(4, _col1, .5, true)
			_shape.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, 25, 25)
			_shape.graphics.endFill()
			//
			//			var _shape2:Shape = new Shape()
			//			_shape2.graphics.beginFill(0xcccccc, 1)
			//			_shape2.graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa, 0xaaaaaa], [1, 0], [0, 255])
			//			_shape2.graphics.lineStyle(0, 0, 0)
			//			_shape2.graphics.drawCircle(buttonWidth * .5, buttonHeight * .5, buttonHeight * .41)
			//			_shape.graphics.endFill()
			//			addChild(_shape2)
			//			_shape2.width = buttonWidth * .1
			//			_shape2.rotation = 90
			//			_shape2.x = buttonWidth - 10 - _shape2.width
			//			_shape2.y = buttonHeight * .05
			//create the roll over effect
			rollOverEffect = new Sprite();
			addChild(rollOverEffect)
			_shape = new Shape()
			rollOverEffect.addChild(_shape)
			_shape.graphics.beginFill(_col1, .5)
			_shape.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, 25, 25)
			_shape.graphics.endFill()
			rollOverEffect.alpha = 0
			//			rollOverEffect.blendMode = BlendMode.INVERT
			//
			var dx : Number = buttonWidth
			var dy : Number = buttonHeight
			var dist : Number = Math.floor(Math.sqrt(dx * dx + dy * dy));
			twoLines = false
			if (!twoLines) {
				var _textSize : Number = dist * .18
				//				trace(CopyBank.getText(this.name), "_textSize:" + _textSize)
				//				if (_textSize > 30) {
				//					_textSize = 30
				//				}
				var _text : ButtonText = new ButtonText(_textSize, buttonWidth, textColour)
				_text.y = buttonHeight * .18
				addChild(_text)
				CopyBank.setText(_text, this.name, true)
			} else {
				var originalString : String = CopyBank.getText(this.name)
				var spaceLoc : int = originalString.indexOf(" ")
				//				trace("spaceLoc:" + spaceLoc)
				var _string1 : String = originalString.slice(0, spaceLoc)
				var _string2 : String = originalString.substr(spaceLoc)
				_textSize = dist * .13
				_text = new ButtonText(_textSize * .9, buttonWidth, 0xFFFFFF)
				var _text2 : ButtonText = new ButtonText(_textSize, buttonWidth, textColour)
				_text.y = buttonHeight * .15
				_text2.y = buttonHeight * .45
				_text.alpha = .85
				_text.htmlText = _string1
				_text2.htmlText = _string2
				addChild(_text2)
				addChild(_text)
				_text2.x = buttonWidth * .5 - _text2.width * .5
			}
			//trace("_text.text:"+_text.text)
			_text.x = buttonWidth * .5 - _text.width * .5
			_text.width = buttonWidth
			this.textBox = _text
			this.buttonMode = true
			this.mouseChildren = false
			//this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBTNHandler);
			//this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverBTNHandler);
			//this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutBTNHandler);
			MouseSignal = new NativeSignal(this, MouseEvent.MOUSE_DOWN, MouseEvent)			MouseSignalOver = new NativeSignal(this, MouseEvent.MOUSE_OVER, MouseEvent)			MouseSignalOut= new NativeSignal(this, MouseEvent.MOUSE_OUT, MouseEvent)
			MouseSignal.add(mouseDownBTNHandler) 			MouseSignalOver.add(mouseOverBTNHandler) 			MouseSignalOut.add(mouseOutBTNHandler) 
		}

		private var MouseSignal : NativeSignal;

		override public function mouseDownBTNHandler(e : MouseEvent) : void {
			//trace(e)
			//Broadcaster.dispatchEvent(new ButtonEvent(ButtonEvent.DOWN, true, this.name, this));
			CoreData.Instance.ButtonSignal.dispatch(this.name, this)
			SoundManager.playSound("snd_menuSelection", 1);
		}

		override public function mouseOutBTNHandler(e : MouseEvent) : void {
			//			Broadcaster.dispatchEvent(new ButtonEvent(ButtonEvent.OUT, true, this.name));
			TweenLite.to(rollOverEffect, .25, {alpha: 0})
//			TweenLite.to(this, .25, {scaleX: 1, scaleY: 1})
		}

		override public function mouseOverBTNHandler(e : MouseEvent) : void {
			//Broadcaster.dispatchEvent(new ButtonEvent(ButtonEvent.OVER, true, this.name));
			TweenLite.to(rollOverEffect, .25, {alpha: 1})
			//			TweenLite.to(this, .25, {scaleX: 1.025, scaleY: 1.025})
			SoundManager.playSound("snd_menuOver", 1);
		}

		public var _name : String
		public var buttonHeight : Number
		public var buttonWidth : Number
		public var rollOverEffect : Sprite
		private var _col1 : uint
		private var textColour : uint = 0x000000
	}
}