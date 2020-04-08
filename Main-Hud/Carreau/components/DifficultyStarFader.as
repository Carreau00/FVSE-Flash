package Carreau.components {
	
	import flash.display.MovieClip;
	
	
	public class DifficultyStarFader extends WidgetFaderControl {
		
		public var DifficultyStar_mc:DifficultyStar;
		public var MarkForDelete:Boolean = false;
		
		public function DifficultyStarFader() {
			// constructor code
		}
		
		public function FadeInOutlineStar(): void{
			//DifficultyStarOutline_mc.visible=true;
			DifficultyStar_mc.ToggleOutline(true);
			if(!FullyFadedIn){
				FadeIn();
			}
		}
		
		public function FadeInCompleteStar(): void{
			//DifficultyStarFill_mc.visible = true;
			DifficultyStar_mc.ToggleFill(true);
			if(!FullyFadedIn){
				FadeIn();
			}
		}
		
		public function HideStar(MarkForDeletion:Boolean = false) {
			if(!this.FullyFadedIn && MarkForDeletion){
				(Object(parent)).RemoveFlaggedStarChild(this);
			} else{
				MarkForDelete = MarkForDeletion;
				this.FastFadeOut();
			}
		}
		
		
		
		override protected function OnFadeOutComplete(){
			this.FullyFadedOut = true;
			if(MarkForDelete){
				(Object(parent)).RemoveFlaggedStarChild(this);
			}
		}
	}
	
}
