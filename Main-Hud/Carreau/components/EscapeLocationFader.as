package Carreau.components {
	
	import flash.display.MovieClip;
	
	import Shared.DebugFunc;
	
	public class EscapeLocationFader extends WidgetFaderControl {
		
		public var EscapeLocation_mc:EscapeLocation;
		public var PercentLevelChange:Number;
		
		public function EscapeLocationFader() {
			// constructor code
		}
		
		public function UpdateLocation(PercentLevel:Number){
			PercentLevelChange = PercentLevel;
			if(!this.FadeOutStarted){
				DebugFunc.debugTrace("EscapeLocationFader_mc FadeIn");
				this.FadeIn();
			} else if(this.FadeOutStarted){
				DebugFunc.debugTrace("EscapeLocationFader_mc FadeOut");
				EscapeLocation_mc.MoveLocation(PercentLevelChange);
				this.stop();
				this.SlowFadeOut();
			}
		}
		
		public function SetToBeginning():void{
			EscapeLocation_mc.ResetPlayhead();
		}
		override protected function OnFadeInComplete(){
			DebugFunc.debugTrace("EscapeLocationFader_mc FadeInComplete");
			this.FullyFadedIn = true;
			EscapeLocation_mc.MoveLocation(PercentLevelChange);
			this.SlowFadeOut();
		}
	}
	
}
