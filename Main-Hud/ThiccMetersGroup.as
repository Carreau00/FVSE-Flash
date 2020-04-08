package  {
	
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import flash.display.MovieClip;
	import Carreau.components.*;
	import flash.events.Event;
	import Shared.DebugFunc;
	
	public class ThiccMetersGroup extends MovieClip {
		
		private var ActorIDStorage:Dictionary = new Dictionary(true);
		private var ActorStatusList:Vector.<ThiccStatusFader> = new Vector.<ThiccStatusFader>();
		private var DisplayedActorStats:Vector.<int> = new Vector.<int>();
		private static var Y_SPACING:Number = 6;
		private static var Y_OFFSET:Number = 50;
		
		public function ThiccMetersGroup() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function ProcessStats(ActorID:int, sated:Number, thiccness:Number, hunger:int, isPlayer:int):void{
			ShowActor(ActorID, isPlayer);
			UpdateStats(ActorID, sated, thiccness, hunger);
		}

		public function UpdateName(MessageString:String):void {
			var MessageArray:Array = MessageString.split("?");	//message must be formatted "Index|ActorName" no spaces
			var index:int = int(MessageArray[0]);
			var ActorName:String = String(MessageArray[1]);
			DebugFunc.debugTrace("index: " + String(index) + " UpdateName " + String(ActorName));
			if (index && ActorName){
				var actorFader:ThiccStatusFader = ActorIDStorage[index];
				if (!actorFader){
					AddActor(index);
					actorFader = ActorIDStorage[index];
				}
				actorFader.statusDisplay.data.name = ActorName;
				setDirty(index);
			}
		}
		
		public function ShowActor(ActorID:int, IsPlayer:int = 0){
			DebugFunc.debugTrace("ShowActor " + String(ActorID) + " " + String(IsPlayer));
			var fader:ThiccStatusFader = ActorIDStorage[ActorID];
			if (!fader){
				AddActor(ActorID);
				fader = ActorIDStorage[ActorID];
			}
			if (!fader.FadeInStarted || fader.FadeOutStarted) {
				fader.ResetFadeState();
				if (IsPlayer == 1){
					fader.y = 0;
					DisplayedActorStats.splice(0, 0, ActorStatusList.indexOf(fader));
				} else if (DisplayedActorStats.length > 0) {
					fader.y = GetTotalY(DisplayedActorStats.length) - Y_OFFSET;
				}
				//debugTrace("fader.y " + String(fader.y));
				fader.FadeIn();
				if (IsPlayer == 0){
					DisplayedActorStats.push(ActorStatusList.indexOf(fader));	
				}
				//debugTrace("ShowActor finished");
			}
		}
		
		public function UpdateStats(ActorID:int, sated:Number, thiccness:Number, hunger:int):void {
			//debugTrace("UpdateStats " + String(ActorID) + " " +  String(sated) + " " + String(thiccness) + " " + String(hunger));
			var fader:ThiccStatusFader = ActorIDStorage[ActorID];
			if (!fader){
				AddActor(ActorID);
				fader = ActorIDStorage[ActorID];
			}
			
			var statusDisplay:ThiccDisplayWidget = fader.statusDisplay;
			if (statusDisplay) {
				//trace(statusDisplay);
				if (sated > 1) sated = 1;
				if (sated < 0) sated = 0;
				if (thiccness > 1) thiccness = 1;
				if (thiccness < 0) thiccness = 0;
				statusDisplay.data.sated = sated;
				statusDisplay.data.thiccness = thiccness;
				statusDisplay.data.hunger = hunger;
				//statusDisplay.SetIsDirty();
				setDirty(ActorID);
			}
			//debugTrace("UpdateStats finished");
		}
		
		public function AddActor(ActorID:int, ActorName:String = " "):void {
			DebugFunc.debugTrace("AddActor " + String(ActorID) + " " + String(ActorName));
			var actorFader:ThiccStatusFader;
			actorFader = ActorIDStorage[ActorID];
			if (!actorFader){
				actorFader = new ThiccStatusFader();
				actorFader.statusDisplay.data = new ActorData(ActorID, ActorName);
				ActorIDStorage[ActorID] = actorFader;
				ActorStatusList.push(actorFader);
				addChild(actorFader);
			}
			//actorFader.statusDisplay.data.id = ActorID;
			//actorFader.statusDisplay.data.name = ActorName;
			
			setDirty(ActorID);
			//debugTrace("AddActor finished");
		}
		
		public function HideActor(ActorID:int){
			var fader:ThiccStatusFader = ActorIDStorage[ActorID];
			
			if (fader) {
				DebugFunc.debugTrace("hiding actor ID: " + String(ActorID));
				fader.FastFadeOut();
				}
		}
		
		public function setDirty(ActorID:int){
			var fader:ThiccStatusFader = ActorIDStorage[ActorID];
			if(fader){
				var statusDisplay:ThiccDisplayWidget = fader.statusDisplay;
				statusDisplay.SetIsDirty();
			}

		}
		
		
		
		// Private event handlers
		private function addedToStageHandler(e:Event):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
					
		}
		
		private function enterFrameHandler(e:Event):void {
			Update();
		}
		
		
		// Private functions
		private function Update():void {
			
			var index:int = DisplayedActorStats.length;
			while(index--){
				var TotalY:Number = this.GetTotalY(index);
				var ActorFader:ThiccStatusFader = ActorStatusList[DisplayedActorStats[index]];
				var ModY = TotalY - ActorFader.y;
				
				if (ModY != 0){
					if(ModY > 0){
						ActorFader.y += 1.5;
					}
					if(ModY < 0){
						ActorFader.y -= 1.5;
					}
					if (ModY > -1 && ModY < 1){
						ActorFader.y = TotalY;
					}
				}
				if (ActorFader.FadeOutStarted){
					DisplayedActorStats.splice(index, 1);
				}
				
			}
		}
		
		private function GetTotalY(index:int): Number {
			var TotalY:Number = 0;
			for(var i:int = 0; i < index; i ++){
				TotalY += this.ActorStatusList[DisplayedActorStats[i]].height;
			}
			
			return TotalY
		}
	}
	
}
