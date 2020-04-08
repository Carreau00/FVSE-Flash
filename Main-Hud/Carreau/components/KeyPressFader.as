package Carreau.components {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class KeyPressFader extends WidgetFaderControl {
		
		public var KeyPressDisplay_mc:KeyPressDisplay;
		public var Control_Wrong_mc:MovieClip;
		public var Index:int;
		public var DisplayedMessage;String;
		public var MarkForDelete:Boolean = false;
		public var MarkForWrongFade:Boolean = false;
		
		public function KeyPressFader() {
			// constructor code
			KeyPressDisplay_mc.fader = this;
			Control_Wrong_mc.visible = false;
		}
		
		public function SetIndex(value:int):void{
			Index = value;
		}
		public function TurnOnMessage(keyToShow:String, isCorrect:Boolean = true):void {
			DisplayedMessage = keyToShow;
			KeyPressDisplay_mc.ShowMessage(keyToShow);
			if(!isCorrect){
				Control_Wrong_mc.visible = true;
				MarkForWrongFade = true;
			}
		}
		
		public function HideDisplay(MarkForDeletion:Boolean = false) {
			if(this.FullyFadedOut && MarkForDeletion){
				(Object(parent)).RemoveFlaggedKeyPressChild(this);
			} else{
				MarkForDelete = MarkForDeletion;
				this.FastFadeOut();
			}
		}
		
		public function SetAlternate(value:Boolean):void{
			KeyPressDisplay_mc.UseAlternateControl = value;
		}
		
		private function enterFrameHandler(e:Event):void {

			if(KeyPressDisplay_mc.alpha > 0){
				KeyPressDisplay_mc.alpha -= 0.02;
			}else if (KeyPressDisplay_mc.alpha <= 0){
				KeyPressDisplay_mc.visible = false;
				KeyPressDisplay_mc.alpha = 0;
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}	

		}
		
		override protected function OnFadeInComplete(){
			this.FullyFadedIn = true;
			if(MarkForWrongFade){
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		override protected function OnFadeOutComplete(){
			this.FullyFadedOut = true;
			if(MarkForDelete){
				(Object(parent)).RemoveFlaggedKeyPressChild(this);
			}
		}
	}
	
}
