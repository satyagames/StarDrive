package gameshell.ui {
	import org.osflash.signals.natives.NativeSignal;
	import data.CoreData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class SponsorLogo extends MovieClip {
		public function SponsorLogo(_clip:MovieClip) {
			super();
			// attach the relevant assets basesd on the sponsor
			var realLogo:MovieClip
			realLogo=new assets_sponsorLogo()
			ref=_clip
			ref.addChild(realLogo)
			ref.mouseChildren=false
			//dispatchEvent(new ButtonEvent(ButtonEvent.GET_LANGUAGE, true));
			ref.buttonMode=true
			MouseSignal=new NativeSignal(ref, MouseEvent.MOUSE_DOWN, MouseEvent)
			MouseSignal.add(mouseDownBTNHandler)
		}

		private function mouseDownBTNHandler(e:MouseEvent):void {
			//Broadcaster.dispatchEvent(new ButtonEvent(ButtonEvent.DOWN, true, ref.name, ref));
			CoreData.Instance.ButtonSignal.dispatch(ref.name, this)
		}
		private var MouseSignal:NativeSignal;

		public function dispose():void {
			MouseSignal.removeAll()
			MouseSignal=null
			ref=null
		}
		public var ref:MovieClip
	}
}