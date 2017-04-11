package com.terrypaton.utils
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	// USE: new DelayedCall(delayedFunction, [], 60, true)
	public class DelayedCall
	{
		private static var FRAME_DISPATCHER:Shape;
		
		public function get pending():Boolean{
			return _pending;
		}
		
		public function get remainingDelay(): Number
		{
			var r: Number = 0;
			if (this._pending)
			{
				if (this.milliseconds)
				{
					r = this.timer.currentCount;
				}
				else
				{
					r += this.count;
				}
			}
			return r;
		}
		
		private var func:Function;
		private var delay:Number;
		private var count:Number;
		private var timer:Timer;
		private var parameters:Array;
		private var loop:Boolean = false;
		private var milliseconds:Boolean = false;
		private var _pending:Boolean = false;
		
		public function DelayedCall(func:Function, parameters:Array, delay:Number, milliseconds:Boolean = true){
			count = 0;
			this.func = func;
			this.delay = delay;
			this.parameters = parameters;
			this.milliseconds = milliseconds;
			begin();
		}
		public function begin():void{
			if(_pending)clear()
			_pending = true;
			if(milliseconds){
				timer = new Timer(delay, 1);
				timer.addEventListener(TimerEvent.TIMER,tick);
				timer.start();
			}else {
				if(!FRAME_DISPATCHER)FRAME_DISPATCHER = new Shape();
				FRAME_DISPATCHER.addEventListener(Event.ENTER_FRAME,frameTick);
			}
		}
		public function clear():void{
			_pending = false;
			if(timer){
				timer.removeEventListener(TimerEvent.TIMER,tick);
				timer = null;
			}
			if(!milliseconds){
				FRAME_DISPATCHER.removeEventListener(Event.ENTER_FRAME,frameTick);
			}
		}
		private function frameTick(e:Event = null):void{
			count++;
			if(count>=delay)tick();
		}
		private function tick(e:Event = null):void{
			_pending = false;
			if(!loop){
				clear();
				delete(this);
			}else{
				begin();
			}
			func.apply(null,parameters);
		}
		
	}
}