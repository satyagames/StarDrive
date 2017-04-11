package gameshell.ui {
	import data.CoreData;

	import org.osflash.signals.natives.NativeSignal;

	import flash.display.*;
	import flash.events.*;
	public class BtnClass extends MovieClip {
		private var MouseSignal : NativeSignal;

		public function BtnClass(_ref : MovieClip ) {
			//trace("button name:" + _ref.name)
			ref = _ref
			ref.mouseChildren = false
			//ref.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBTNHandler);
			//ref.addEventListener(MouseEvent.MOUSE_OVER, mouseOverBTNHandler);
			//ref.addEventListener(MouseEvent.MOUSE_OUT, mouseOutBTNHandler);
			MouseSignal = new NativeSignal(ref, MouseEvent.MOUSE_DOWN, MouseEvent)			MouseSignal.add(mouseDownBTNHandler) 
			
			//dispatchEvent(new ButtonEvent(ButtonEvent.GET_LANGUAGE, true));
			ref.buttonMode = true
			if (_ref) {
								
				
					//CopyBank.setText(_ref.textBox, _ref.name)
			}
		}

		public function mouseDownBTNHandler(e : MouseEvent) : void {
			//trace(e)
			
			//Broadcaster.dispatchEvent(new ButtonEvent(ButtonEvent.DOWN, true, ref.name));
			CoreData.Instance.ButtonSignal.dispatch(ref.name, ref)
		}

		public function mouseOutBTNHandler(e : MouseEvent) : void {
			//Broadcaster.dispatchEvent(new ButtonEvent(ButtonEvent.OUT, true, ref.name));
		}

		public function mouseOverBTNHandler(e : MouseEvent) : void {
			//Broadcaster.dispatchEvent(new ButtonEvent(ButtonEvent.OVER, true, ref.name));
		}

		public function dispose() : void {
			//	ref.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownBTNHandler);
			//ref.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverBTNHandler);
			//ref.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutBTNHandler);
			MouseSignal.removeAll()
			MouseSignal = null
			ref = null
		}

		//		private var data:Object = new Object()
		public var ref : MovieClip
	}
}