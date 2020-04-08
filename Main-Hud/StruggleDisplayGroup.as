package {
	
	import Shared.AS3.BSButtonHintData;
	
	import Carreau.components.*;
	
	import flash.display.MovieClip;
	import flash.net.FileFilter;
	import Shared.DebugFunc;
	import flash.display3D.IndexBuffer3D;
	
	public class StruggleDisplayGroup extends MovieClip {
		
		public var StruggleMessageFader_mc:StruggleMessageFader;
		public var EscapeLocationFader_mc:EscapeLocationFader;
		public var DifficultyTitleFader_mc:TitleFader;
		public var DifficultyFader_mc:DifficultyControl;
		
		private var KeyPressList:Vector.<KeyPressFader> 			= new Vector.<KeyPressFader>();
		private var PressedKeyList:Vector.<KeyPressFader> 			= new Vector.<KeyPressFader>();
		//private var DifficultyStarList:Vector.<DifficultyControl> 	= new Vector.<DifficultyControl>();
		private var X_SPACING_ODD_OFFSET:Number 					= 10;
		private var X_SPACING:Number 								= 50;
		//private var DIFFICULTY_X_SPACING:Number 					= 38.6;
		private var KEYPRESS_Y_SPACING:Number 						= 150;
		private var KEYPRESS_Y_OFFSET:Number 						= 50;
		
		//These values are keyed to FV_PlayerStruggleScript
		private var iStruggleStageBegin:Number 						= 0;
		private var iStruggleStageFinished:Number					= 1;
		private var iStruggleStageCleanUp:Number 					= 2;
		private var iStruggleStageDisplaySequence:Number			= 3;
		private var _useAlternateControl:Boolean					= false;
		public function StruggleDisplayGroup() {
			// constructor code
		}
		
		public function InitializeStage(MessageString:String):void{
			//clear arrays if they are still populated
			//DebugFunc.debugTrace("InitializeStage() DifficultyStarList.length: " + DifficultyStarList.length);
			//if(KeyPressList.length > 0){
			//	//RemoveKeyPressList();
			//}
			//if(PressedKeyList.length > 0){
			//	//HidePressedKeyList(true);
			//}
			var MessageArray:Array = MessageString.split("?");
			var Difficulty:Number = Number(MessageArray.splice(0,1));
			//var KeyPressArray:Array = MessageArray[1:end];
			//if(DifficultyStarList.length == 0){
				DifficultyFader_mc.PopulateDifficulty(Difficulty);
			//}
			PopulateKeyPressList(MessageArray);
		}
		
		public function get UseAlternateControl():Boolean{
			return _useAlternateControl;
		}
		
		public function set UseAlternateControl(value:Boolean):void{
			if(_useAlternateControl != value){
				_useAlternateControl = value;
			}
		}
		
		//public function PopulateDifficulty(Difficulty:Number): void{
		//	var lastOutlineControl:DifficultyControl = new DifficultyControl();
		//	var DIFFICULTY_X_SPACING = lastOutlineControl.width;
		//	var x_pos:Number = 0;
		//	x_pos = 0 - (Math.round(Difficulty)-1)*DIFFICULTY_X_SPACING/2;
		//	DebugFunc.debugTrace("Difficulty " + Difficulty);
		//	for(var i:int = 1; i <= Difficulty*2; i++){
		//		if(i%2 == 0){
					//lastOutlineControl.FadeInCompleteStar();
		//			x_pos += DIFFICULTY_X_SPACING;
		//		} else {
		//			var temp:DifficultyControl = new DifficultyControl();
		//			temp.x = x_pos;
					
		//			temp.y = -200;
				
					//temp.FadeInOutlineStar();
		//			DifficultyStarList.push(temp)
		//			addChild(temp);
		//			lastOutlineControl = temp;
		//		}
		//	}
		//}
		
		public function PopulateKeyPressList(MessageArray:Array):void {
		
			//var MessageArray:Array = MessageString.split("?");
			var x_pos:Number = 0-(MessageArray.length-1)*X_SPACING/2;
			DebugFunc.debugTrace("x_pos " + x_pos);
			for(var i:int = 0; i < MessageArray.length; i ++){
				var temp:KeyPressFader = new KeyPressFader();
				temp.SetAlternate(_useAlternateControl);
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
		
		public function ChangeStage(StageID:Number):void{
			DebugFunc.debugTrace("processChangeStage() StageID: " + StageID);
			if(StageID == iStruggleStageBegin){
				StruggleBegins();
			} else if(StageID == iStruggleStageCleanUp){
				HideKeyPressList(true);
				HidePressedKeyList(true);
			} else if(StageID == iStruggleStageFinished){
				ShutDown(true, true, true);
			} else if(StageID == iStruggleStageDisplaySequence){
				ShowKeyPressList();
			}
		}
		
		public function KeyPress(KeyCode:int, SequenceNumber:int):void {
			if(SequenceNumber < KeyPressList.length){
				var KeyString:String = GetKeyName(KeyCode);
				DebugFunc.debugTrace("KeyPress() KeyCode: " + KeyCode + " SequenceNumber: " + SequenceNumber + " KeyString: " + KeyString);
				var temp:KeyPressFader = new KeyPressFader();
				temp.SetAlternate(_useAlternateControl);
				temp.y = KEYPRESS_Y_SPACING + KEYPRESS_Y_OFFSET;
				temp.x = KeyPressList[SequenceNumber].x;
				temp.TurnOnMessage(KeyString, KeyString==KeyPressList[SequenceNumber].DisplayedMessage);
				PressedKeyList.push(temp);
				addChild(temp);
				temp.FadeIn();
			}
		}
		
		public function UpdateLocation(LocationPercent:Number):void {
			EscapeLocationFader_mc.UpdateLocation(LocationPercent);
		}
		
		public function UpdateNotification(MessageString:String):void{
			var MessageArray:Array = MessageString.split("/");
			StruggleMessageFader_mc.PushMessage(String(MessageArray[1]), int(MessageArray[0]));
		}
		
		public function StruggleBegins():void {
			if(!DebugFunc.GetDebugEnabled()){
				//block hiding this list if debug mode enabled
				HideKeyPressList();
			}
			UpdateNotification("1/Begin!");
		}
		
		public function StruggleResults(StageID:int, LocationPercent:Number):void{
			//will call location change form here.  Also hide the PressedKeyList
			EscapeLocationFader_mc.UpdateLocation(LocationPercent);
		}
		public function ShutDown(bHideKeyPressList:Boolean = false, bHidePressedKeyList:Boolean = false, bHideDifficulty:Boolean = false){
			DebugFunc.debugTrace("ShutDown() bHideKeyPressList: " + bHideKeyPressList + " bHidePressedKeyList: " + bHidePressedKeyList + " bHideDifficulty: " + bHideDifficulty);
			HideKeyPressList(bHideKeyPressList);
			HidePressedKeyList(bHidePressedKeyList);
			DifficultyFader_mc.HideDisplay(bHideDifficulty);
		}
		
		public function ShowKeyPressList():void{
			DebugFunc.debugTrace("ShowKeyPressList()");
			for(var i:int = 0; i < KeyPressList.length; i++) {
				KeyPressList[i].FadeIn();
			}
		}
		
		public function HideKeyPressList(MarkForDelete:Boolean = false):void {
			//call this function when it's time to hide the KeyPress list
			DebugFunc.debugTrace("HideKeyPressList() MarkForDelete: " + MarkForDelete);
			for(var i:int = 0; i < KeyPressList.length; i++) {
				KeyPressList[i].HideDisplay(MarkForDelete);
			}
		}
		
		public function HidePressedKeyList(MarkForDelete:Boolean = false):void {
			DebugFunc.debugTrace("HidePressedKeyList() MarkForDelete: " + MarkForDelete);
			for(var i:int = 0; i < PressedKeyList.length; i++) {
				PressedKeyList[i].HideDisplay(MarkForDelete);
			}
		}
		
		//public function HideDifficulty(MarkForDelete:Boolean = false):void{
		//	DebugFunc.debugTrace("HideDifficulty() MarkForDelete: " + MarkForDelete);
		//	for(var i:int = 0; i < DifficultyStarList.length; i++) {
		//		DifficultyStarList[i].HideDisplay(MarkForDelete);
		//	}
		//}

		public function RemoveFlaggedKeyPressChild(ChildFader:KeyPressFader):void{
			var ChildIndex:int = KeyPressList.indexOf(ChildFader);
			var temp:KeyPressFader;
			if(ChildIndex >= 0){
				if(ChildIndex == KeyPressList.length-1){
					DebugFunc.debugTrace("RemoveFlaggedKeyPressChild() ChildIndex: " + ChildIndex + " KeyPressList.length-1: " + String(KeyPressList.length-1));
					for(var i:int = KeyPressList.length - 1; KeyPressList.length > 0; i--){
						temp = KeyPressList.pop();
						//KeyPressList.splice(i, 1);
						DebugFunc.debugTrace("RemoveFlaggedKeyPressChild() temp: " + temp + " index: " + i);
						removeChild(temp);
					}
				}
			} else {
				//Gotta run the check again in case the passed fader is from the pressed key list
				ChildIndex = PressedKeyList.indexOf(ChildFader);
				if(ChildIndex == PressedKeyList.length-1){
					DebugFunc.debugTrace("RemoveFlaggedKeyPressChild() ChildIndex: " + ChildIndex + " PressedKeyList.length-1: " + String(PressedKeyList.length-1));
					for(var j:int = PressedKeyList.length-1; PressedKeyList.length > 0; j--){
						temp = PressedKeyList.pop();;
						//PressedKeyList.splice(i, 1);
						DebugFunc.debugTrace("RemoveFlaggedKeyPressChild() temp: " + temp + " index: " + j);
						removeChild(temp);
					}
				}
			}
		}
		
		/*public function RemoveFlaggedStarChild(ChildFader:DifficultyControl):void{
			var ChildIndex:int = DifficultyStarList.indexOf(ChildFader);
			var temp:DifficultyControl;
			if(ChildIndex >= 0){
				temp = DifficultyStarList[ChildIndex];
				DifficultyStarList.splice(ChildIndex, 1);
				DebugFunc.debugTrace("RemoveFlaggedStarChild() temp: " + temp + " ChildIndex: " + ChildIndex);
				removeChild(temp);
			}
		}*/
		
		
		public function RemoveKeyPressList():void {
			for(var i:int = KeyPressList.length-1; i >= 0; i--) {
				var temp:KeyPressFader = KeyPressList.pop();
				removeChild(temp);
			}
		}
		
		private function GetKeyName(KeyCode:int):String{
			//These HAVE to match the key code sequencing entered in FV_PlayerStruggleScript
			if(KeyCode == 0){
				return "Back";
			} else if(KeyCode == 1){
				return "Forward";
			} else if(KeyCode == 2){
				return "StrafeLeft";
			} else if(KeyCode == 3){
				return "StrafeRight";
			} else if(KeyCode == 4){
				return "Jump";
			} else if(KeyCode == 5){
				return "Sneak";
			} else if(KeyCode == 6){
				return "QuickkeyDown";
			} else if(KeyCode == 7){
				return "QuickkeyUp";
			} else if(KeyCode == 8){
				return "QuickkeyLeft";
			} else if(KeyCode == 9){
				return "QuickkeyRight";
			}
				
			return " ";
		}
	}
	
}
