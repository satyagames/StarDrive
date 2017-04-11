/*
VERSION: 1.0
DATE: 3/7/2009
ACTIONSCRIPT VERSION: 3.0 (AS2 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
DESCRIPTION:
	If you'd like to tween something to a destination value that may change at any time,
	DynamicPropsPlugin allows you to simply associate a function with a property so that
	every time the tween is updated, it calls that function to get the value for the
	associated property. For example, if you want a MovieClip to tween to wherever the
	mouse happens to be, you could do:
		
		TweenLite.to(mc, 3, {dynamicProps:{x:getMouseX, y:getMouseY}}); 
		function getMouseX():Number {
			return this.mouseX;
		}
		function getMouseY():Number {
			return this.mouseY;
		}
		
	Of course you can get as complex as you want inside your custom function, as long as
	it returns the destination value, TweenLite/Max will take care of adjusting things 
	on the fly.
	
	DynamicPropsPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
	without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.
	
USAGE:
	import gs.*;
	import gs.plugins.*;
	TweenPlugin.activate([DynamicPropsPlugin]); //only do this once in your SWF to activate the plugin
	
	TweenLite.to(my_mc, 3, {dynamicProps:{x:getMouseX, y:getMouseY}}); 
	
	function getMouseX():Number {
		return this.mouseX;
	}
	function getMouseY():Number {
		return this.mouseY;
	}
	
	
BYTES ADDED TO SWF: 345 bytes (not including dependencies)

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/

package gs.plugins {
	import gs.*;
	
	public class DynamicPropsPlugin extends TweenPlugin {
		public static const VERSION:Number = 1.0;
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		protected var _target:Object;
		protected var _props:Array;
		protected var _lastFactor:Number;
		
		public function DynamicPropsPlugin() {
			super();
			this.propName = "dynamicProps"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = []; //will be populated in init()
			_props = [];
		}
		
		override public function onInitTween($target:Object, $value:*, $tween:TweenLite):Boolean {
			_target = $tween.target;
			_lastFactor = 0;
			for (var p:String in $value) {
				_props[_props.length] = new DynamicProperty(p, $value[p] as Function);
				this.overwriteProps[this.overwriteProps.length] = p;
			}
			return true;
		}
		
		override public function killProps($lookup:Object):void {
			for (var i:int = _props.length - 1; i > -1; i--) {
				if (_props[i].name in $lookup) {
					_props.splice(i, 1);
				}
			}
			super.killProps($lookup);
		}	
		
		override public function set changeFactor($n:Number):void {
			if ($n != _lastFactor) {
				var i:int, prop:DynamicProperty, end:Number;
				var ratio:Number = ($n == 1 || _lastFactor == 1) ? 0 : 1 - (($n - _lastFactor) / (1 - _lastFactor));
				for (i = _props.length - 1; i > -1; i--) {
					prop = _props[i];
					end = prop.getter();
					_target[prop.name] = end - ((end - _target[prop.name]) * ratio);
				}
				_lastFactor = $n;
			}
		}
		
	}
}

internal class DynamicProperty {
	public var name:String;
	public var getter:Function;
	
	public function DynamicProperty($name:String, $getter:Function) {
		this.name = $name;
		this.getter = $getter;
	}
}