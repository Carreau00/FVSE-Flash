package Carreau.components {

	import flash.display.MovieClip;


	public class ThiccStatusFader extends WidgetFaderControl {
		public var statusDisplay:ThiccDisplayWidget;

		public function ThiccStatusFader() {
			// constructor code
			statusDisplay.fader = this;
		}

	}

}