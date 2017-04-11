package com.coj {
	import flash.display.*
	import flash.events.*
	
	public class SmokeParticle extends MovieClip {
		public function SmokeParticle():void {
			kill = false
			rot = 0
			yVel = .5
			life = int (Math.random() * 30 + 40)
			alphaReduce = 1/life
			wander = Math.random() 
			this.gotoAndStop(int((Math.random() * 4) + 1))
		
		}
		
		public function manage():void 
		{
			rot += 10
			this.rotation = rot*.25
			var rad:Number = (rot / 180) * Math.PI
			this.x += Math.sin(rad)*wander
			this.alpha -=alphaReduce
			this.y -= yVel
			yVel *= 1.03
			
			life --
			if (life < 1) {
				kill = true
			}
		}
		
		private var _clip:MovieClip
		private var xVel:Number
		private var yVel:Number
		private var life:int
		private var rot:Number
		public var kill:Boolean
		public var wander:Number
		public var alphaReduce:Number
		
	}
	
}