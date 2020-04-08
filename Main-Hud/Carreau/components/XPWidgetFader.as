package Carreau.components {

	import flash.display.MovieClip;


	public class XPWidgetFader extends WidgetFaderControl {
		
		public var XPWidget_mc:XPDisplayWidget;

		public function XPWidgetFader() {
			// constructor code
			XPWidget_mc.fader = this;
		}

	}

}