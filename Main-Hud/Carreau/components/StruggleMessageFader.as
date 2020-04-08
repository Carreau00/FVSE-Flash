package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.DebugFunc;
	
	public class StruggleMessageFader extends WidgetFaderControl {
		
		public var StruggleMessage_mc:StruggleMessage;
		
		private var doFastFadeOut:int;
		
		public function StruggleMessageFader() {
			// constructor code
		}
		
		public function PushMessage(MessageString:String, bFastFadeOut:int):void{
			DebugFunc.debugTrace(MessageString + " " + bFastFadeOut);
			doFastFadeOut = bFastFadeOut;
			StruggleMessage_mc.UpdateMessage(MessageString);
			if(!FullyFadedIn){
				FadeIn();
			} else if(doFastFadeOut){
				gotoAndPlay("FastFadeOut");
			}
			else{
				gotoAndPlay("SlowFadeOut");
			}
		}
		
		override protected function OnFadeInComplete()
		{
			FullyFadedIn = true;
			//this._fadeInStarted = false;
			if(doFastFadeOut == 1){
				gotoAndPlay("FastFadeOut");
			}
		}
		override protected function OnFadeOutComplete()
        {
			DebugFunc.debugTrace("StruggleMessageFader OnFadeOutComplete");
			StruggleMessage_mc.UpdateMessage("");
            //visible = false;
			//this._fadeOutStarted = false;
            FullyFadedOut = true;
        }
	}
	
}
