package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSUIComponent;
	import flash.events.Event;
	import Shared.DebugFunc;
	
	public class DevicePlay extends BSUIComponent {
		
		private var _framesToMove:Number;
		private var _moveForward:Boolean;
		private var _firstFrame:Number;
		private var _lastFrame:Number;
		
		public function ForwardPlay(EndFrame:int, frame_offset:Number = 0){
			//ResetDisplayZero();
			if (!_moveForward){
				this._framesToMove = 0;
			}			
			_moveForward = true;
			//following code would be implemented in calling function
			/*
			if (this._gender == 0){
				frame_offset = FRAME_OFFSET_MALE;
			} else {
				frame_offset = FRAME_OFFSET_FEMALE;
			}*/
			var moveFrames:int = EndFrame - this.currentFrame + frame_offset;
			this._framesToMove += moveFrames;
			DebugFunc.debugTrace("DevicePlay ForwardPlay _moveForward: " + _moveForward + " currentFrame: " + this.currentFrame + " _framesToMove: " + _framesToMove + " EndFrame: " + EndFrame + " moveFrames: " +moveFrames);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.play();
		}
		
		public function ReversePlay(EndFrame:int, frame_offset:Number = 0){
			//this.gotoAndStop("100_percent")
			if (_moveForward){
				this._framesToMove = 0;
			}
			_moveForward = false;
			/*
			var frame_offset:Number;
			if (this._gender == 0){
				frame_offset = FRAME_OFFSET_MALE;
			} else {
				frame_offset = FRAME_OFFSET_FEMALE;
			}*/
			_lastFrame = EndFrame;
			var moveFrames:int = this.currentFrame - EndFrame - frame_offset;		
			this._framesToMove += moveFrames;
			DebugFunc.debugTrace("DevicePlay ReversePlay _moveForward: " + _moveForward + " currentFrame: " + this.currentFrame + " _framesToMove: " + _framesToMove + " EndFrame: " + EndFrame + " moveFrames: " +moveFrames);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);			
			this.prevFrame();
		}
		
		public function ResetPlayhead(){
			gotoAndStop(_firstFrame);
		}
		public function get FirstFrame():Number{
			return _firstFrame;
		}
		
		public function set FirstFrame(val:Number):void{
			if(_firstFrame != val){
				_firstFrame = val;
			}
		}
		
		public function get LastFrame():Number{
			return _lastFrame;
		}
		
		public function set LastFrame(val:Number):void{
			if(_lastFrame != val){
				_lastFrame = val;
			}
		}
		
		public function get FramesToMove():Number{
			return _framesToMove;
		}
		
		public function set FramesToMove(val:Number):void{
			if(_framesToMove != val){
				_framesToMove = val;
			}
		}
		
		public function get MoveForward():Boolean{
			return _moveForward;
		}
		
		public function set MoveForward(val:Boolean):void{
			if(_moveForward != val){
				_moveForward = val;
			}
		}
		
		private function enterFrameHandler(e:Event):void {
			Update();
		}
		
		private function Update():void{
			//trace("OnEvent _framesToMove:", _framesToMove);
			//svar stopFrame:Number = 0;
			if (_moveForward){/*
				if (_gender == 0){
					stopFrame = 101 + FRAME_OFFSET_MALE;
				} else {
					stopFrame = 101 + FRAME_OFFSET_FEMALE;
				}*/
			}
			
			if (!_moveForward){
				/*
				if (_gender == 0){
					stopFrame = 1 + FRAME_OFFSET_MALE;
				} else {
					stopFrame = 1 + FRAME_OFFSET_FEMALE;
				}*/
				if (this.currentFrame > _lastFrame && this._framesToMove > 0){
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