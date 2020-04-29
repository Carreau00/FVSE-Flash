package Carreau.components {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import Shared.AS3.BSUIComponent;
	
	public dynamic class HPMeterBar extends MeterBarControl {
		
		
		public function HPMeterBar() {
			// constructor code
		}
		
		override protected function enterFrameHandler(e:Event):void {
			var FillPercent:Number

			if (this.TargetPercent < this.MeterPercent){
				//trace("this.TargetPercent", this.TargetPercent, "this.MeterPercent", this.MeterPercent, "scaleX", scaleX);
				MeterFilled = false;
				this.MeterPercent -= 0.01;
				FillPercent = this.MeterPercent;
			}
			else{
				this.MeterPercent = this.TargetPercent;
				FillPercent = this.TargetPercent;
			}
			var deltaX:Number = FillPercent - scaleX;
			//trace("this", this, "FillPercent ", FillPercent, "MeterPercent ", this.MeterPercent, " TargetPercent ", this.TargetPercent, " deltaX ", deltaX);
			if (Math.abs(deltaX) < 0.01) {
				//trace("Math.abs(deltaX) < 0.01 scaleX", scaleX, " FillPercent ", FillPercent);
				scaleX = FillPercent;
			} else if (deltaX > 0) {
				//trace("deltaX > 0");
				scaleX += 0.01;
			} else {
				//trace("else deltaX ", deltaX, " FillPercent ", FillPercent);
				scaleX = FillPercent;

			}
		}
	}
	
}
