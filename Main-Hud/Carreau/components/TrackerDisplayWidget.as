package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSUIComponent;
	import flash.text.TextField;
	import Carreau.components.StomachDevice;
	
	public class TrackerDisplayWidget extends BSUIComponent {
		
		public var StomachDevice_mc:StomachDevice;
		public var Max_Capacity_tf:TextField;
		public var Current_Prey_tf:TextField;
		
		private var _fader:TrackerFader;
		
		public function TrackerDisplayWidget() {
			// constructor code
		}
		
		public function get fader():TrackerFader {
			return _fader;
		}
		public function set fader(val:TrackerFader):void {
			_fader = val;
		}
	}
	
}
