package  {
	
	import Shared.AS3.BSUIComponent;
	import Shared.DebugFunc;
	
	public class WidgetFaderControl extends BSUIComponent {
		
		
		private var _fadeInStarted:Boolean;
		private var _fadeOutStarted:Boolean;
        private var _fullyFadedIn:Boolean;
        private var _hidden:Boolean;
        private var _fullyFadedOut:Boolean;
		
		public function WidgetFaderControl() {
			// constructor code
			this._fadeInStarted = false;
			this._fadeOutStarted = false;
			this._fullyFadedIn = false;
			this._hidden = false;
			this._fullyFadedOut = false;
		}
		
		public function FadeIn(){
			this.visible = true;
			this._fadeInStarted = true;
			this._fadeOutStarted = false;
			gotoAndPlay("StartFadeIn");
		}
		
		public function FastFadeOut(){
			if(_fullyFadedIn){
				this._fadeInStarted = false;
				this._fadeOutStarted = true;
				gotoAndPlay("FastFadeOut");
			}
		}
		
		public function SlowFadeOut(){
			if(_fullyFadedIn){
				this._fadeInStarted = false;
				this._fadeOutStarted = true;
				gotoAndPlay("SlowFadeOut");
			}
		}

		public function ShowWidget()
        {
			this.visible = true;
			//this._fadeInStarted = true;
			this._hidden = false;
			//gotoAndStop("Show");
        }
		
		public function HideWidget()
        {
            if (!this._hidden)
            {
				this._hidden = true;
				this.visible = false;
				//gotoAndStop("Hidden");
            };
        }

		public function get FadeInStarted():Boolean
        {
            return (this._fadeInStarted);
        }
		
		public function get FadeOutStarted():Boolean
        {
            return (this._fadeOutStarted);
        }
		
		public function get FullyFadedOut():Boolean
        {
            return (this._fullyFadedOut);
        }
		
		public function set FullyFadedOut(value:Boolean):void
        {
            if(this._fullyFadedOut != value){
				this._fullyFadedOut = value;
			}
        }
		
		public function get FullyFadedIn():Boolean
        {
            return (this._fullyFadedIn);
        }
		
		public function set FullyFadedIn(value:Boolean):void
        {
            if(this._fullyFadedIn != value){
				this._fullyFadedIn = value;
			}
        }
		
        public function get Hidden():Boolean
        {
            return (this._hidden);
        }
		
		public function set Hidden(state:Boolean):void
        {
			if(this._hidden != state){
				this._hidden = state;
			}
        }
		
		public function ResetFadeState(){
			//gotoAndPlay("Reset");
            visible = false;
            this._fadeInStarted = false;
			this._fadeOutStarted = false;
            this._fullyFadedIn = false;
			this._fullyFadedOut = false;
            this._hidden = false;
		}
		
		
		protected function OnFadeInComplete()
        {
            this._fullyFadedIn = true;
			//this._fadeInStarted = false;
        }

        protected function OnFadeOutComplete()
        {
			DebugFunc.debugTrace("WidgetFaderControl OnFadeOutComplete");
            //visible = false;
			//this._fadeOutStarted = false;
            this._fullyFadedOut = true;
        }
	}
	
}
