package com.terrypaton.graphics {
	import flash.display.BlendMode;
	import com.gs.TweenMax;
	import com.gs.TweenLite;
	import flash.display.GradientType;
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

	public class DialogBox extends Sprite {
		public function DialogBox() {
			_speechBubbleMask=new Sprite()
			_speechBubbleSprite=new Sprite();
			_speechBubbleSprite.blendMode=BlendMode.LAYER
			_boxShape=new Shape();
			_arrowShape=new Shape();
			_gradientShape=new Shape()
			textF2=new TextField();
			textF=new TextField();
			super();
		}

		public function showMessage(p_text:String, p_xsize:Number, p_ysize:Number, p_screenConstraints:Rectangle, _isInteractive:Boolean=false, _callback:Function=null, _timeToStay:Number=1):void {
			TweenMax.killTweensOf(_speechBubbleSprite)
			showArrow=false // this makes the arrow go away ;)
			// _timeToStay = seconds - ONLY USED IF _isInteractive=false
			timer=_timeToStay * 30
			// pass in a variable if it needs user interaction
			// pass in the amount of time the speech bubble should last before putting itself away
			// build dispose functions
			allText=p_text
			_speechBubbleWidth=p_xsize;
			_speechBubbleHeight=p_ysize;
			screenConstraints=p_screenConstraints // a rectangle containing the screen cords
			isInteractive=_isInteractive // this determines if the speech bubble needs clicking to progress and then disapear
			callback=_callback // set to null if not used
			format=new TextFormat();
			format.font="Verdana";
			format.color=0x222222;
			format.size=20;
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
		private var showArrow:Boolean=true
		private var isInteractive:Boolean
		private var _speechBubbleSprite:Sprite;
		private var _speechBubbleMask:Sprite;
		protected var _boxShape:Shape
		protected var _arrowShape:Shape
		protected var _gradientShape:Shape
		protected var _clickArea:Sprite
		//
		protected var _speechBubbleWidth:Number;
		protected var _speechBubbleHeight:Number;
		protected var _totalPages:int
		protected var _currentPage:int=0;
		//
		protected var textF:TextField;
		protected var textArray:Array
		protected var xArrowOffset:Number=0;
		protected var yArrowOffset:Number=0;
		protected var dif:Number=0;
		protected var callback:Function

		//
		protected function init():void {
			// DRAW THE SPEECH BUBBLE
			//_speechBubbleSprite.x = xpos;
			//_speechBubbleSprite.y = ypos;
			//
			addChild(_speechBubbleSprite);
			addChild(_speechBubbleMask)
			if (!showArrow) {
				ARROW_HEIGHT=0
			}
			_gradientShape.graphics.clear()
			_arrowShape.graphics.clear()
			_boxShape.graphics.clear()
			var fillType:String=GradientType.LINEAR;
			var colors:Array=[0xFFFFFF, 0xaaaaaa];
			var alphas:Array=[.7, .8];
			var ratios:Array=[0x00, 0xFF];
			var matr:Matrix=new Matrix();
			matr.rotate(90 / 180 * Math.PI)
			_gradientShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr)
			_gradientShape.graphics.drawRect(0, 0, _speechBubbleWidth, _speechBubbleHeight + ARROW_HEIGHT)
			_gradientShape.graphics.endFill()
			_speechBubbleMask.addChild(_boxShape);
			_speechBubbleMask.addChild(_arrowShape);
			_speechBubbleSprite.addChild(_gradientShape)
			drawSpeechBubble()
			positionSpeechBubble()
			//
			_speechBubbleSprite.mask=_speechBubbleMask
			_speechBubbleSprite.alpha=0
			TweenLite.to(_speechBubbleSprite, .25, {alpha: 1})
			removeEventListener(Event.ENTER_FRAME, loop)
			addEventListener(Event.ENTER_FRAME, loop)
			//
			// write in the text for the speech bubble
			// if there are multiple pages of text, put a next arrow
			// if the bubble is on the last page of it's text and it's a mission chat one, put a close button - with call back handler
			// if a mission bubble, put a interaction blocker behind the speech bubble to stop mouse clicks
			// animate the bubble in
			// consider positioning for the arrow pointer of the speech bubble
		}

		protected function drawSpeechBubble():void {
			/**/
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
			// create the text field
			textF.width=_speechBubbleWidth - 20;
			textF.height=_speechBubbleHeight - 20;
			//textF.border = true	;
			textF.x=10;
			textF.y=10;
			textF.selectable=false;
			textF.multiline=true;
			textF.wordWrap=true;
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
			//
			_clickArea=new Sprite();
			//
			_boxShape.graphics.clear()
			_boxShape.graphics.beginFill(0xff0000, 1);
			//
			_boxShape.graphics.moveTo(CORNER_RADIUS, 0);
			_boxShape.graphics.lineTo(_speechBubbleWidth - CORNER_RADIUS, 0);
			_boxShape.graphics.curveTo(_speechBubbleWidth, 0, _speechBubbleWidth, CORNER_RADIUS);
			_boxShape.graphics.lineTo(_speechBubbleWidth, _speechBubbleHeight - CORNER_RADIUS);
			_boxShape.graphics.curveTo(_speechBubbleWidth, _speechBubbleHeight, _speechBubbleWidth - CORNER_RADIUS, _speechBubbleHeight);
			_boxShape.graphics.lineTo(CORNER_RADIUS, _speechBubbleHeight);
			_boxShape.graphics.curveTo(0, _speechBubbleHeight, 0, _speechBubbleHeight - CORNER_RADIUS);
			_boxShape.graphics.lineTo(0, CORNER_RADIUS);
			_boxShape.graphics.curveTo(0, 0, CORNER_RADIUS, 0);
			_boxShape.graphics.endFill()
			// draw arrow
			if (showArrow) {
				_arrowShape.graphics.clear()
				_arrowShape.graphics.beginFill(0xff0ff0, 1);
				_arrowShape.graphics.moveTo(-ARROW_WIDTH * .5, -ARROW_HEIGHT)
				_arrowShape.graphics.lineTo(ARROW_WIDTH * .5, -ARROW_HEIGHT)
				_arrowShape.graphics.lineTo(CORNER_RADIUS * .75, -CORNER_RADIUS)
				_arrowShape.graphics.curveTo(0, 0, -CORNER_RADIUS * .75, -CORNER_RADIUS)
				_arrowShape.graphics.endFill()
				_arrowShape.y=-OFFSET_BUBBLE_Y
			}
			_speechBubbleSprite.y=-(_speechBubbleHeight + ARROW_HEIGHT + OFFSET_BUBBLE_Y)
			//
			textF.alpha=0;
			TweenLite.to(textF, .5, {alpha: 1, delay: .5})
			displayText()
			// add click functions to the speech bubble
			if (isInteractive) {
				_speechBubbleSprite.addEventListener(MouseEvent.CLICK, mouseClick)
			}
		}

		protected function displayText():void {
			textF.text=textArray[_currentPage]
			textF.alpha=0
			TweenLite.to(textF, .5, {alpha: 1})
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

		public function positionSpeechBubble():void {
			// check to see how close to the edge of the screen the box is, move the speech box if it is too close
			xOffset=-(_speechBubbleWidth * .5);
			yOffset=-(_speechBubbleHeight + ARROW_HEIGHT + OFFSET_BUBBLE_Y);
			xArrowOffset=0
			yArrowOffset=-OFFSET_BUBBLE_Y
			var leftDist:Number=x - (_speechBubbleWidth * .5 + 4)
			var rightEdgeMax:Number=screenConstraints.width - (4 + _speechBubbleWidth * .5)
			var rightDist:Number=rightEdgeMax - x
			if (leftDist < 0) {
				xOffset-=leftDist
			} else if (rightDist < 0) {
				xOffset+=rightDist
			}
			_boxShape.x=xOffset;
			_boxShape.y=yOffset;
			// stop the arrow from going out of bounds
			var minX:Number=4 + CORNER_RADIUS + ARROW_WIDTH * .5
			if (x < minX) {
				dif=x - minX;
				xArrowOffset-=dif;
			}
			var maxX:Number=screenConstraints.width - 4 - CORNER_RADIUS - ARROW_WIDTH * .5
			if (x > maxX) {
				dif=x - maxX;
				xArrowOffset-=dif;
			}
			//
			var minY:Number=(_speechBubbleHeight + 4 + ARROW_HEIGHT + OFFSET_BUBBLE_Y)
			if (y < minY) {
				dif=y - minY
				yOffset-=dif
				yArrowOffset-=dif
			}
			_boxShape.x=xOffset;
			_boxShape.y=yOffset;
			//
			_arrowShape.x=xArrowOffset;
			_arrowShape.y=yArrowOffset;
			//
			_speechBubbleSprite.x=xOffset
			_speechBubbleSprite.y=yOffset
			// make sure the arrow doesn't go off screen
			// 
		}

		private function loop(event:Event):void {
			positionSpeechBubble()
			if (!isInteractive) {
				timer--
				if (timer < 1) {
					//dispose()
					// make in active
					makeInactive()
				}
			}
		}

		private function makeInactive():void {
			removeEventListener(Event.ENTER_FRAME, loop)
			TweenLite.to(_speechBubbleSprite, .5, {alpha: 0})
			if (callback != null)
				callback.call();
			callback=null;
		}

		public function dispose():void {
			removeEventListener(Event.ENTER_FRAME, loop)
			if (isInteractive) {
				_speechBubbleSprite.removeEventListener(MouseEvent.CLICK, mouseClick)
			}
			removeChild(_speechBubbleSprite)
			removeChild(_speechBubbleMask)
			_speechBubbleSprite.removeChild(textF)
			_boxShape.graphics.clear();
			_arrowShape.graphics.clear();
			_gradientShape.graphics.clear();
			_speechBubbleSprite=null;
			_speechBubbleMask=null;
			_boxShape=null;
			_arrowShape=null;
			_gradientShape=null;
			_clickArea=null;
			textF=null;
			if (callback != null)
				callback.call();
			callback=null;
		}
	}
}