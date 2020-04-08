package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.DebugFunc;
	
	public class DifficultyControl extends WidgetFaderControl {
		
		public var DifficultyTitle_mc:MovieClip;

		private var DifficultyStarList:Vector.<DifficultyStarFader> = new Vector.<DifficultyStarFader>();
		private var X_SPACING_ODD_OFFSET:Number 					= 10;
		private var X_SPACING:Number 								= 50;
		
		public function DifficultyControl() {
			// constructor code
		}
		
		public function PopulateDifficulty(Difficulty:Number): void{
			this.FadeIn();
			var lastOutlineControl:DifficultyStarFader = new DifficultyStarFader();
			var DIFFICULTY_X_SPACING = lastOutlineControl.width;
			var x_pos:Number = 0;
			x_pos = 0 - (Math.round(Difficulty)-1)*DIFFICULTY_X_SPACING/2;
			for(var i:int = 1; i <= Difficulty*2; i++){
				if(i%2 == 0){
					lastOutlineControl.FadeInCompleteStar();
					x_pos += DIFFICULTY_X_SPACING;
				} else {
					var temp:DifficultyStarFader = new DifficultyStarFader();
					temp.x = x_pos;
					
					temp.y = 50;
				
					temp.FadeInOutlineStar();
					DifficultyStarList.push(temp)
					DebugFunc.debugTrace(String(DifficultyStarList));
					addChild(temp);
					lastOutlineControl = temp;
				}
			}
			
		}
		
		public function HideDisplay(MarkForDeletion:Boolean = false) {
			this.FastFadeOut();
			DebugFunc.debugTrace("HideDifficulty() MarkForDeletion: " + MarkForDeletion);
			for(var i:int = 0; i < DifficultyStarList.length; i++) {
				DifficultyStarList[i].HideStar(MarkForDeletion);
			}
		}
		
		public function RemoveFlaggedStarChild(ChildFader:DifficultyStarFader):void{
			var ChildIndex:int = DifficultyStarList.indexOf(ChildFader);
			var temp:DifficultyStarFader;
			if(ChildIndex >= 0){
				temp = DifficultyStarList[ChildIndex];
				DifficultyStarList.splice(ChildIndex, 1);
				DebugFunc.debugTrace("RemoveFlaggedStarChild() temp: " + temp + " ChildIndex: " + ChildIndex);
				removeChild(temp);
			}
		}
	}
	
}
