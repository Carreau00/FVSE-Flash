package Carreau.components {
	
	public class TrackerFader extends WidgetFaderControl{
		public var TrackerWidget_mc:TrackerDisplayWidget;
		
		public function TrackerFader() {
			// constructor code
			TrackerWidget_mc.fader = this;
		}

	}
	
}
