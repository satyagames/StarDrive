package gameshell.ui {
	import com.gs.TweenLite;
	import com.gs.TweenMax;
	import data.settings;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class DialogBox extends Sprite {
		public function DialogBox() {
//			_speechBubbleMask=new Sprite()
			_speechBubbleSprite=new Sprite();
			_speechBubbleSprite.blendMode=BlendMode.LAYER
			textF2=new TextField();
			textF=new TextField();
			super();
		}

		public function showMessage(p_text:String, p_xsize:Number, p_ysize:Number, p_screenConstraints:Rectangle, _isInteractive:Boolean=false, _callback:Function=null, _timeToStay:Number=1):void {
			TweenMax.killTweensOf(_speechBubbleSprite)
			// _timeToStay = seconds - ONLY USED IF _isInteractive=false
			timer=_timeToStay * 30
			// pass in a variable if it needs user interaction
			// pass in the amount of time the speech bubble should last before putting itself away
			// build dispose functions
			allText=p_text
			_speechBubbleWidth=p_xsize;
			_speechBubbleHeight=p_ysize;
			screenConstraints=p_screenConstraints // a rectangle containing the screen cords
			callback=_callback // set to null if not used
			format=new TextFormat();
			format.font="Verdana";
			format.color=0x222222;
			format.size=20;
			format.align=TextFormatAlign.CENTER
			format.bold=true;
			//create temporary text box		
			//trace(allText.length)
			// find how many characters can fit into the box
			init();
		}
		protected var format:TextFormat
		protected var textF2:TextField
		protected var allText:String;
		//
		public var timer:Number=0;
		protected var xpos:Number;
		protected var ypos:Number;
		protected var screenConstraints:Rectangle;
		protected var xOffset:Number;
		protected var yOffset:Number;
		//
		protected var OFFSET_BUBBLE_Y:Number=5;
		protected var CORNER_RADIUS:Number=5;
		protected var ARROW_HEIGHT:Number=30;
		protected var ARROW_WIDTH:Number=18;
		protected var MAXIMUM_WIDTH:Number=500;
		protected var MAXIMUM_HEIGHT:Number=300;
		//
		private var _speechBubbleSprite:Sprite;
		//
		protected var _speechBubbleWidth:Number;
		protected var _speechBubbleHeight:Number;
		protected var _totalPages:int
		protected var _currentPage:int=0;
		//
		protected var textF:TextField;
		protected var textArray:Array
//		protected var xArrowOffset:Number=0;
//		protected var yArrowOffset:Number=0;
		protected var dif:Number=0;
		protected var callback:Function

		//
		protected function init():void {
			addChild(_speechBubbleSprite);
			drawSpeechBubble()
			_speechBubbleSprite.alpha=0
//			TweenLite.to(_speechBubbleSprite, .25, {alpha: 1})
			removeEventListener(Event.ENTER_FRAME, loop)
			addEventListener(Event.ENTER_FRAME, loop)
		}
		private var _msB:MovieClip

		protected function drawSpeechBubble():void {
			/**/
			if (!_msB) {
				_msB=new a_msgBacking()
			}
			_speechBubbleSprite.addChild(_msB)
			trace("_speechBubbleWidth:" + _speechBubbleWidth)
			textF2.width=_speechBubbleWidth - 20;
			textF2.x=10;
			textF2.y=10;
			textF2.selectable=false;
			textF2.multiline=true;
			textF2.wordWrap=true;
			textF2.defaultTextFormat=format;
			textF2.autoSize=TextFieldAutoSize.LEFT
			textF2.text=allText;
			//
			if (textF2.height < _speechBubbleHeight) {
				_speechBubbleHeight=textF2.height + 20
				// now test if the speech bubble should be less wide
				if (textF2.textWidth < _speechBubbleWidth) {
					_speechBubbleWidth=textF2.textWidth + 25
				}
			}
			_msB.width=_speechBubbleWidth + 30;
			_msB.height=_speechBubbleHeight + 30;
			_msB.cacheAsBitmap=true;
			// create the text field
			// create the text field
			textF.width=_speechBubbleWidth - 20;
			textF.height=_speechBubbleHeight - 20;
			//textF.border = true	;
			textF.x=-textF2.width * .25;
			textF.y=-textF2.height * .5;
			textF.selectable=false;
			textF.multiline=true;
			textF.wordWrap=true;
			textF.textColor=0x000000
//			textF.embedFonts=true;
			textF.antiAliasType=AntiAliasType.NORMAL
			textF.defaultTextFormat=format;
			_speechBubbleSprite.addChild(textF)
			//
			var howManysetsOfLines:Number=textF2.height / textF.height
			var startLine:int=0
			var totalLines:int=textF2.numLines
			var pageLinesAmount:int=Math.floor(totalLines / howManysetsOfLines)
			_totalPages=Math.ceil(totalLines / pageLinesAmount)
			textArray=new Array()
			for (var j:int=0; j < _totalPages; j++) {
				startLine=j * pageLinesAmount
				// now get the last character in line lastLine
				var totalChars:int=0
				var nextLineStep:int=startLine + pageLinesAmount
				if (nextLineStep > totalLines) {
					nextLineStep=totalLines
				}
				for (var i:int=startLine; i < nextLineStep; i++) {
					totalChars+=textF2.getLineLength(i)
				}
				textArray[j]=String(allText.substr(textF2.getLineOffset(startLine), totalChars))
			}
			displayText()
			textF.x=-textF.width * .5
		}

		protected function displayText():void {
			textF.text=textArray[_currentPage]
//			textF.alpha=0
			y=-20
			TweenLite.to(_speechBubbleSprite, .5, {y: 15 + _speechBubbleHeight * .25, alpha: 1})
		}

		protected function mouseClick(event:MouseEvent):void {
			//trace("mouse click")
			if (_currentPage < _totalPages - 1) {
				_currentPage++
				displayText()
			} else {
				//	trace("CLOSE THE PANEL")
				dispose()
			}
		}

		private function loop(event:Event):void {
			timer--
			if (timer < 1) {
				//dispose()
				// make in active
				makeInactive()
			}
		}

		private function makeInactive():void {
			removeEventListener(Event.ENTER_FRAME, loop)
//			TweenLite.to(_speechBubbleSprite, .5, {alpha: 0})
			TweenLite.to(_speechBubbleSprite, .5, {y: -60, alpha: 0})
			if (callback != null)
				callback.call();
			callback=null;
		}

		public function dispose():void {
			removeEventListener(Event.ENTER_FRAME, loop)
			try {
				_msB=null
				removeChild(_speechBubbleSprite)
//				removeChild(_speechBubbleMask)
				_speechBubbleSprite.removeChild(textF)
			} catch (e:Error) {
			}
			_speechBubbleSprite=null;
			textF=null;
			if (callback != null)
				callback.call();
			callback=null;
		}
	}
}