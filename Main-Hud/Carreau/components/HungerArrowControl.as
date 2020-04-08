package  Carreau.components{
		
	import Shared.AS3.BSUIComponent;
    import flash.display.MovieClip;
    import fl.motion.easing.Bounce;
	import flash.events.Event;
	
	public class HungerArrowControl extends BSUIComponent{
		
		private var _fadeInStarted:Boolean = false;
		private var _fadeOutStarted:Boolean = false;
		private var _fullyFadedIn:Boolean = false;
		private var _fullyFadedOut:Boolean = false;
		
		public function HungerArrowControl() {
			// constructor code
			this._fadeInStarted = false;
			this._fullyFadedIn = false;
			this._fadeOutStarted = false;
			this._fullyFadedOut = false;
		}
		
		public function ArrowFadeIn(){
			
			if (!this._fadeInStarted)
            {
                visible = true;
                this._fadeInStarted = true;
            };
			
		}
		
		public function ArrowFadeOut(){

			if (!this._fadeOutStarted)
            {
                visible = true;
                this._fadeOutStarted = true;
            };
		}
		
		public function get FadeInStarted():Boolean{
			return _fadeInStarted;
		}
		
		public function set FadeInStarted(val:Boolean){
			_fadeInStarted = val;
		}
		
		public function get FullyFadedIn():Boolean{
			return _fullyFadedIn;
		}
		
		public function set FullyFadedIn(val:Boolean){
			_fullyFadedIn = val;
		}
		public function get FadeOutStarted():Boolean{
			return _fadeOutStarted;
		}
		
		public function set FadeOutStarted(val:Boolean){
			_fadeOutStarted = val;
		}
		
		public function get FullyFadedOut():Boolean{
			return _fullyFadedOut;
		}
		
		public function set FullyFadedOut(val:Boolean){
			_fullyFadedOut = val;
		}
		
		public function ResetArrowState(){
			visible = false;
            this._fadeInStarted = false;
            this._fullyFadedIn = false;

            this._fadeOutStarted = false;
            this._fullyFadedOut = false;
		}
		
		override public function onAddedToStage():void
        {
            super.onAddedToStage();
            this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
		
		private function enterFrameHandler(e:Event):void {
			/*var targetAlpha:Number
			if(_fadeOutStarted){
				targetAlpha = 0;
			} else if(_fadeInStarted){
				targetAlpha = 1;
			}
			var deltaAlpha:Number = targetAlpha - alpha;*/
			if(this._fadeOutStarted && alpha > 0){
				alpha -= 0.05;
			}else if (this._fadeOutStarted && alpha <= 0){
				visible = false;
				alpha = 0;
				this._fadeOutStarted = false;
				this._fullyFadedOut = true;
			} else if(this._fadeInStarted && alpha <= 1){			
				alpha += 0.05;
			} else if(this._fadeInStarted && alpha > 1){
				alpha = 1;
				this._fadeInStarted = false;
				this._fullyFadedIn = true;
			}
			
		}
	}
	
}
