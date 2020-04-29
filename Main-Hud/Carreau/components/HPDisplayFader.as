package Carreau.components {
	
	import flash.display.MovieClip;
	
	
	public class HPDisplayFader extends WidgetFaderControl {
		
		public var HPDisplayWidget_mc:HPDisplayWidget;
		public var isDisplayed:Boolean;
		public var Index:int;
		
		public function HPDisplayFader() {
			// constructor code
			//HPDisplayWidget_mc.fader = this;
			isDisplayed = false;
		}
		
		public function SetPreyName(val:String):void {
			HPDisplayWidget_mc.PreyName = val;
		}
		
		public function SetHealthPercent(val:Number):void {
			HPDisplayWidget_mc.HealthPercent = val;
		}
		
		override protected function OnFadeOutComplete()
        {
            super.OnFadeOutComplete();
			(Object(parent)).RemoveHealthBar(Index);
        }
	}
	
}
