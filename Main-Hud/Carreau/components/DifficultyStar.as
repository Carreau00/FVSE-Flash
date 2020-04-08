package Carreau.components {
	
	import flash.display.MovieClip;
	
	
	public class DifficultyStar extends MovieClip {
		
		public var StarOutline_mc:MovieClip;
		public var StarFill_mc:MovieClip;
		
		public function DifficultyStar() {
			// constructor code
			StarOutline_mc.visible = false;
			StarFill_mc.visible = false;
		}
		
		public function ToggleOutline(toggle:Boolean):void {
			StarOutline_mc.visible = toggle;
		}
		
		public function ToggleFill(toggle:Boolean):void {
			StarFill_mc.visible = toggle;
		}
		
	}
	
}
