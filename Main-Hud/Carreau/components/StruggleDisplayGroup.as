package Carreau.components {
	
	import Shared.AS3.BSButtonHintData;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.net.FileFilter;
	import Shared.DebugFunc;
	
	public class StruggleDisplayGroup extends MovieClip {
		
		public var Notification_mc:TextField;
		public var EscapeLocationFader_mc:EscapeLocationFader;
		
		private var KeyPressList:Vector.<KeyPressFader> = new Vector.<KeyPressFader>();
		private var PressedKeyList:Vector.<KeyPressFader> = new Vector.<KeyPressFader>();
		private var DifficultyStarList:Vector.<DifficultyControl> = new Vector.<DifficultyControl>();
		private var X_SPACING_ODD_OFFSET:Number = 10;
		private var X_SPACING:Number = 50;
		//private var DIFFICULTY_X_SPACING:Number = 38.6;
		private var KEYPRESS_Y_SPACING:Number = 150;
		private var KEYPRESS_Y_OFFSET:Number = 50;
		
		public function StruggleDisplayGroup() {
			// constructor code
			this.Notification_mc.text = "";
			//PopulateKeyPressList("Forward?Back?StrafeLeft?StrafeRight?Jump?Forward?Back?StrafeLeft?StrafeRight?Jump");
			//PopulateDifficulty(7);
		}
		
		public function InitializeStage(MessageString:String):void{
			//clear arrays if they are still populated
			if(KeyPressList.length > 0){
				RemoveKeyPressList();
			}
			var MessageArray:Array = MessageString.split("?");
			var Difficulty:Number = Number(MessageArray.splice(0,1));
			//var KeyPressArray:Array = MessageArray[1:end];
			if(Difficulty != DifficultyStarList.length){
				PopulateDifficulty(Difficulty);
			}
			PopulateKeyPressList(MessageArray);
		}
		
		public function PopulateDifficulty(Difficulty:Number): void{
			var lastOutlineControl:DifficultyControl = new DifficultyControl();
			var DIFFICULTY_X_SPACING = lastOutlineControl.width;
			var x_pos:Number = 0;
			x_pos = 0 - (Math.round(Difficulty/2)-1)*DIFFICULTY_X_SPACING/2;
			DebugFunc.debugTrace("Difficulty " + Difficulty);
			for(var i:int = 1; i <= Difficulty; i++){
				if(i%2 == 0){
					lastOutlineControl.FadeInCompleteStar();
					x_pos += DIFFICULTY_X_SPACING;
				} else {
					var temp:DifficultyControl = new DifficultyControl();
					temp.x = x_pos;
					
					temp.y = -200;
				
					temp.FadeInOutlineStar();
					addChild(temp);
					lastOutlineControl = temp;
				}
			}
		}
		
		public function PopulateKeyPressList(MessageArray:Array):void {
		
			//var MessageArray:Array = MessageString.split("?");
			var x_pos:Number = 0-(MessageArray.length-1)*X_SPACING/2;
			DebugFunc.debugTrace("x_pos " + x_pos);
			for(var i:int = 0; i < MessageArray.length; i ++){
				var temp:KeyPressFader = new KeyPressFader();
				//temp.UpdateKeyInfo(MessageString(i));
				temp.y = KEYPRESS_Y_SPACING;
				temp.x = x_pos;
				x_pos += X_SPACING;
				temp.SetIndex(i);
				temp.TurnOnMessage(MessageArray[i]);
				KeyPressList.push(temp);
				addChild(temp);
				temp.FadeIn();
				
			}
		}
		
		public function KeyPress(MessageString:String, KeyNumber:int):void {
			if(KeyNumber < KeyPressList.length){
				DebugFunc.debugTrace(MessageString + KeyNumber);
				var temp:KeyPressFader = new KeyPressFader();
				temp.y = KEYPRESS_Y_SPACING + KEYPRESS_Y_OFFSET;
				temp.x = KeyPressList[KeyNumber].x;
				temp.TurnOnMessage(MessageString, MessageString==KeyPressList[KeyNumber].DisplayedMessage);
				PressedKeyList.push(temp);
				addChild(temp);
				temp.FadeIn();
			}
		}
		
		public function UpdateLocation(LocationPercent:Number):void {
			EscapeLocationFader_mc.UpdateLocation(LocationPercent);
		}
		
		public function UpdateNotification(MessageString:String):void{
			this.Notification_mc.text = MessageString;
		}
		
		public function StruggleBegins():void {
			if(!DebugFunc.GetDebugEnabled()){
				//block hiding this list if debug mode enabled
				HideKeyPressList();
			}
			this.Notification_mc.text = "";
		}
		
		public function ShutDown(){
			HideKeyPressList(true);
			HidePressedKeyList(true);
			HideDifficulty(true);
			this.Notification_mc.text = ""
		}
		
		public function HideKeyPressList(MarkForDelete:Boolean = false):void {
			//call this function when it's time to hide the KeyPress list
			for(var i:int = 0; i < KeyPressList.length; i++) {
				KeyPressList[i].HideDisplay(MarkForDelete);
			}
		}
		
		public function HidePressedKeyList(MarkForDelete:Boolean = false):void {
			for(var i:int = 0; i < PressedKeyList.length; i++) {
				PressedKeyList[i].HideDisplay(MarkForDelete);
			}
		}
		
		public function HideDifficulty(MarkForDelete:Boolean = false):void{
			for(var i:int = 0; i < DifficultyStarList.length; i++) {
				DifficultyStarList[i].HideDisplay(MarkForDelete);
			}
		}

		public function RemoveFlaggedKeyPressChild(ChildFader:KeyPressFader):void{
			var ChildIndex:int = KeyPressList.indexOf(ChildFader);
			var temp:KeyPressFader;
			if(ChildIndex >= 0){
				temp = KeyPressList[ChildIndex];
				KeyPressList.splice(ChildIndex, 1);
				removeChild(temp);
			} else {
				//Gotta run the check again in case the passed fader is from the pressed key list
				ChildIndex = PressedKeyList.indexOf(ChildFader);
				if(ChildIndex >= 0){
					temp = PressedKeyList[ChildIndex];
					PressedKeyList.splice(ChildIndex, 1);
					removeChild(temp);
				}
			}
		}
		
		public function RemoveFlaggedStarChild(ChildFader:DifficultyControl):void{
			var ChildIndex:int = DifficultyStarList.indexOf(ChildFader);
			var temp:DifficultyControl;
			if(ChildIndex >= 0){
				temp = DifficultyStarList[ChildIndex];
				DifficultyStarList.splice(ChildIndex, 1);
				removeChild(temp);
			}
		}
		
		
		public function RemoveKeyPressList():void {
			for(var i:int = KeyPressList.length-1; i >= 0; i--) {
				var temp:KeyPressFader = KeyPressList.pop();
				removeChild(temp);
			}
		}
	}
	
}
