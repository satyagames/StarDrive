package gameshell.ui {
	import com.terrypaton.media.SoundManager;
	import flash.display.*;
	import flash.events.*;
	import data.CoreData;
	import org.osflash.signals.natives.NativeSignal;

	public class GraphicBtnClass extends MovieClip {
		public function GraphicBtnClass(_ref:MovieClip, _useRollOvers:Boolean=true) {
			//			trace("button name:" + _ref.name)
			ref=_ref
			ref.mouseChildren=false
			MouseSignal=new NativeSignal(ref, MouseEvent.MOUSE_DOWN, MouseEvent)
			MouseSignalOver=new NativeSignal(ref, MouseEvent.MOUSE_OVER, MouseEvent)
			MouseSignalOut=new NativeSignal(ref, MouseEvent.MOUSE_OUT, MouseEvent)
			MouseSignalUp=new NativeSignal(ref, MouseEvent.MOUSE_UP, MouseEvent)
			MouseSignal.add(mouseDownHandler)
			MouseSignalOver.add(mouseOverBTNHandler)
			MouseSignalOut.add(mouseOutBTNHandler)
			MouseSignalUp.add(mouseUpBTNHandler)
			useRollOvers=_useRollOvers
			ref.buttonMode=true
		}
		public var idNum:int
		//		private var data:Object = new Object()
		public var ref:MovieClip
		private var MouseSignal:NativeSignal;
		private var MouseSignalOut:NativeSignal;
		private var MouseSignalOver:NativeSignal;
		private var MouseSignalUp:NativeSignal;
		public var useRollOvers:Boolean=true;

		public function disable():void {
			ref.mouseEnabled=false
			useRollOvers=false
			ref.gotoAndStop(4)
		}

		public function dispose():void {
			MouseSignal.remove(mouseDownHandler)
			MouseSignalOver.remove(mouseOverBTNHandler)
			MouseSignalOut.remove(mouseOutBTNHandler)
			MouseSignalUp.remove(mouseUpBTNHandler)
			MouseSignal=null
			MouseSignalOver=null
			MouseSignalOut=null
			MouseSignalUp=null
			ref=null
		}

		public function enable():void {
			ref.mouseEnabled=true
			ref.gotoAndStop(1)
			useRollOvers=true
		}

		private function mouseDownHandler(e:MouseEvent):void {
			if (useRollOvers) {
				ref.gotoAndStop(3)
			}
		}

		private function mouseOutBTNHandler(e:MouseEvent):void {
			if (useRollOvers) {
				ref.gotoAndStop(1)
			}
		}

		private function mouseOverBTNHandler(e:MouseEvent):void {
			SoundManager.playSound("snd_menuOver")
			if (useRollOvers) {
				ref.gotoAndStop(2)
				CoreData.Instance.OverButtonSignal.dispatch(ref.name, ref)
			}
		}

		private function mouseUpBTNHandler(e:MouseEvent):void {
			SoundManager.playSound("snd_menuSelection")
			CoreData.Instance.ButtonSignal.dispatch(ref.name, ref)
		}
	}
}