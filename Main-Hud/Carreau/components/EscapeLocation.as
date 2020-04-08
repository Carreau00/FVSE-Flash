package Carreau.components {
	
	import flash.display.MovieClip;
	
	
	public class EscapeLocation extends DevicePlay {
		
		//public var BlinkingMarker_mc:BlinkingMarker;
		
		private static var FIRST_FRAME:Number = 1;
		private static var LAST_FRAME:Number = 30;
		private var _percentToMove:Number;
				
		public function EscapeLocation() {
			// constructor code
			this.stop();
			this.FirstFrame = FIRST_FRAME;
			this.LastFrame = LAST_FRAME;
		}
		
		public function set PercentToMove(value:Number){
			_percentToMove = value;
		}
		
		public function get PercentToMove():Number{
			return _percentToMove;
		}
		
		public function MoveLocation(newPercentToMove:Number):void{
			//code to move the BlinkingMarker_mc marker object
			var targetFrame:Number = LAST_FRAME*newPercentToMove;
			trace("MoveLocation() targetFrame: " + targetFrame + " currentFrame: " + String(this.currentFrame));
			if(targetFrame > this.currentFrame){
				ForwardPlay(targetFrame);
			} else {
				ReversePlay(targetFrame);
			}
		}
	}
	
}
