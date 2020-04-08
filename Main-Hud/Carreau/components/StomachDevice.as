package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSUIComponent;
	import flash.events.Event;
	import flash.globalization.NumberFormatter;
	
	public class StomachDevice extends BSUIComponent {
		
		private var moveForward:Boolean;
		private var _framesToMove:Number;
		private var _gender:Number;
		
		private static var FRAME_OFFSET_MALE:Number = 5;
		private static var FRAME_OFFSET_FEMALE:Number = 119;
		
		public function StomachDevice() {
			// constructor code
			moveForward = true;
			_framesToMove = 0;
			_gender = 0;
		}
		
		public function ForwardPlay(EndFrame:int){
			ResetDisplayZero();
			if (!moveForward){
				this._framesToMove = 0;
			}			
			moveForward = true;
			var frame_offset:Number;
			if (this._gender == 0){
				frame_offset = FRAME_OFFSET_MALE;
			} else {
				frame_offset = FRAME_OFFSET_FEMALE;
			}
			var moveFrames:int = EndFrame - this.currentFrame + frame_offset;
			this._framesToMove += moveFrames;
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.play();
		}
		private function get FramesToMove():Number{
			return _framesToMove;
		}
		
		private function set FramesToMove(val:Number):void{
			if(_framesToMove != val){
				_framesToMove = val;
			}
		}
		
		public function ResetDisplayZero(){
			if (this._gender == 0 && currentFrame < FRAME_OFFSET_MALE){
				this.gotoAndStop("0_percentM");
			} else if (this._gender == 1 && currentFrame < FRAME_OFFSET_FEMALE){
				this.gotoAndStop("0_percentF");
			}
		}
		
		public function ReversePlay(EndFrame:int){
			//this.gotoAndStop("100_percent")
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (moveForward){
				this._framesToMove = 0;
			}
			moveForward = false;
			var frame_offset:Number;
			if (this._gender == 0){
				frame_offset = FRAME_OFFSET_MALE;
			} else {
				frame_offset = FRAME_OFFSET_FEMALE;
			}
			var moveFrames:int = this.currentFrame - EndFrame - frame_offset;		
			this._framesToMove += moveFrames;
			this.prevFrame();
		}
		
		public function get Gender():Number{
			return (this._gender);
		}
		
		public function set Gender(val:Number):void{
			if (_gender != val){
				_gender = val;
			}
			
		}
		private function enterFrameHandler(e:Event):void {
			Update();
		}
		
		private function Update():void{
			//trace("OnEvent _framesToMove:", _framesToMove);
			var stopFrame:Number = 0;
			if (moveForward){
				if (_gender == 0){
					stopFrame = 101 + FRAME_OFFSET_MALE;
				} else {
					stopFrame = 101 + FRAME_OFFSET_FEMALE;
				}
			}
			
			if (!moveForward){
				if (_gender == 0){
					stopFrame = 1 + FRAME_OFFSET_MALE;
				} else {
					stopFrame = 1 + FRAME_OFFSET_FEMALE;
				}
				if (this.currentFrame > stopFrame && this._framesToMove > 0){
					this.prevFrame();
				}
			}
			this._framesToMove -= 1;
			if (this._framesToMove <= 0){
				this.stop();
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
	}
	
}
