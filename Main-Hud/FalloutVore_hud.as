package  {
	
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain
	import flash.utils.getDefinitionByName;	
	
	import hudframework.IHUDWidget;
	import Carreau.components.*	

	import Shared.AS3.BSUIComponent;
	import flash.events.Event;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import Shared.DebugFunc;
	
	public class FalloutVore_hud extends BSUIComponent implements IHUDWidget {
		
		
		public var VoreNotificationsGroup_mc:VoreNotificationsGroup;
		public var ThiccMetersGroup_mc:ThiccMetersGroup;
		public var StruggleDisplayGroup_mc:StruggleDisplayGroup;
		
		private var KeyPressCounter:Number = 0;
		private var HealthCounter:Number = 1;
		
		private static const Command_ThiccUpdateStats:Number				= 100;
		private static const Command_ThiccUpdateName:Number					= 110;
		private static const Command_ThiccHideActor:Number					= 120;

		private static const Command_UpdatePlayerXP:Number					= 200;
		private static const Command_TrackerUpdateProperties:Number			= 210;
		
		private static const Command_StruggleInitialize:Number				= 300;
		private static const Command_StruggleKeyPress:Number				= 310;
		private static const Command_StrugglePushMessage:Number				= 320;
		private static const Command_StruggleResult:Number					= 330;
		private static const Command_StruggleChangeStage:Number				= 340;
		private static const Command_UpdateControlType:Number				= 350;
		
		private static const Command_UpdateHealthBar:Number					= 400;
		private static const Command_RemoveHealthBar:Number					= 410;
		private static const Command_ClearAllHealthBars:Number				= 420;

		private static const Command_DebugToggle:Number						= 1000;
		
		public function FalloutVore_hud() {
			// constructor code
			//getHUDFramework();
			
			//this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		public function getHUDFramework():void {
			var hud:Object;
			if (ApplicationDomain.currentDomain.hasDefinition("hudframework.HUDFramework")) {
				hud = getDefinitionByName("hudframework.HUDFramework")["getInstance"]();
			}
		}
		
		public function processMessage(command:String, params:Array):void {
			DebugFunc.debugTrace("processMessage() command: " + command + " params: " + params);
			switch(command) {
				case String(Command_UpdatePlayerXP):
				case "UpdatePlayerXP":
					DebugFunc.debugTrace("Received UpdatePlayerXP");
					processXPWidget(Number(params[0]), Number(params[1]), int(params[2]), int(params[3]));
					break;
				case String(Command_ThiccUpdateStats):
				case "ThiccUpdateStats":
					processThiccStats(int(params[0]), Number(params[1]), Number(params[2]), int(params[3]), int(params[4]));
					break;
				case String(Command_ThiccUpdateName):
				case "ThiccUpdateName":
					processThiccName(String(params[0]));
					break;
				case String(Command_ThiccHideActor):
				case "ThiccHideActor":
					processThiccHideActor(int(params[0]));
					break;
				case String(Command_TrackerUpdateProperties):
				case "TrackerUpdateProperties":
					processPreyTracker(Number(params[0]), Number(params[1]), Number(params[2]));
					break;
				case String(Command_StruggleInitialize):
				case "StruggleInitialize":
					processInitializeStage(String(params[0]))
					break;
				case String(Command_StruggleKeyPress):
				case "StruggleKeyPress":
					processKeyPress(int(params[0]), int(params[1]));
					break;
				case String(Command_StrugglePushMessage):
				case "StrugglePushMessage":
					processStruggleMessage(String(params[0]));
					break;
				case String(Command_StruggleResult):
				case "StruggleResult":
					//processPreyTracker(Number(params[0]), Number(params[1]), Number(params[2]));
					processStruggleResults(int(params[0]), Number(params[1]));
					break;
				case String(Command_StruggleChangeStage):
				case "StruggleChangeStage":
					processStruggleChangeStage(Number(params[0]));
					break;
				case String(Command_UpdateControlType):
				case "UpdateControlType":
					processUpdateControlType(Number(params[0]));
					break;
				case String(Command_UpdateHealthBar):
				case "UpdateHealthBar":
					processHealthBar(String(params[0]))
					break;
				case String(Command_RemoveHealthBar):
				case "RemoveHealthBar":
					removeHealthBar(int(params[0]))
					break;
				case String(Command_ClearAllHealthBars):
				case "ClearAllHealthBars":
					ClearAllHealthBars()
					break;
				case String(Command_DebugToggle):
				case "DebugToggle":
					processDebugToggle(int(params[0]));
					break;
				
			}
			
		}
		
		public function processXPWidget(startPercent:Number, endPercent:Number, addedXP:int, levelUp:int):void{
			VoreNotificationsGroup_mc.ProcessVoreXP(startPercent, endPercent, addedXP, levelUp)
		}
		
		public function processThiccStats(ActorID:int, sated:Number, thiccness:Number, hunger:int, isPlayer:int):void{
			ThiccMetersGroup_mc.ProcessStats(ActorID, sated, thiccness, hunger, isPlayer);
		}
		
		public function processThiccName(MessageString:String):void{
			ThiccMetersGroup_mc.UpdateName(MessageString);
		}
		
		public function processThiccHideActor(ActorID:int):void{
			ThiccMetersGroup_mc.HideActor(ActorID);
		}
		
		public function processPreyTracker(current:Number, maximumCapacity:Number, newGender:Number = -1):void{
			VoreNotificationsGroup_mc.ProcessTrackerProperties(current, maximumCapacity, newGender);
		}
		
		public function processInitializeStage(MessageString:String):void{
			StruggleDisplayGroup_mc.InitializeStage(MessageString);
		}
		
		/*public function processDifficulty(Difficulty:Number):void {
			StruggleDisplayGroup_mc.PopulateDifficulty(Difficulty);
		}*/
		
		public function processKeyPress(KeyCode:int, SequenceNumber:int):void{
			//var MessageArray:Array = MessageString.split("?");
			StruggleDisplayGroup_mc.KeyPress(KeyCode, SequenceNumber);
		}
		
		public function processNewLocation(LocationPercent:Number):void{
			StruggleDisplayGroup_mc.UpdateLocation(LocationPercent);
		}
		
		public function processStruggleMessage(MessageString:String):void{
			//var MessageArray:Array = MessageString.split("?");
			StruggleDisplayGroup_mc.UpdateNotification(MessageString);
		}
		
		public function processStruggleChangeStage(StageID:Number):void{
			StruggleDisplayGroup_mc.ChangeStage(StageID);
		}
		
		public function processUpdateControlType(UseAlternate:Number):void{
			if(UseAlternate == 0){
				StruggleDisplayGroup_mc.UseAlternateControl = false;
			} else {
				StruggleDisplayGroup_mc.UseAlternateControl = true;
			}
			
		}
		
		public function processStruggleResults(StageID:int, LocationPercent:Number):void {
			StruggleDisplayGroup_mc.StruggleResults(StageID, LocationPercent);
		}
		
		public function processHealthBar(MessageString:String):void{
			VoreNotificationsGroup_mc.processHealthbar(MessageString);
		}
		
		public function removeHealthBar(Index:int):void{
			VoreNotificationsGroup_mc.processRemoveHealthbar(Index);
		}
		
		public function ClearAllHealthBars():void{
			VoreNotificationsGroup_mc.clearAllHealthBars();
		}
		
		public function processDebugToggle(bEnabled:int):void{
			DebugFunc.SetDebugEnabled(bEnabled);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.ENTER:
					DebugFunc.debugTrace("Enter");
					//processXPWidget(0.5, 0.51, 1, 0);
					//var SendMessage = "Back?".concat(KeyPressCounter);
					//processKeyPress(0, KeyPressCounter);
					var messageString = String(0) + "?" + "Test Name" + "?" + String(HealthCounter);
					processHealthBar(messageString);
					HealthCounter -= 0.05;
					KeyPressCounter += 1.0;
					break;
				case Keyboard.HOME:
					DebugFunc.debugTrace("Home");
					processThiccStats(1, 1.0, 0.2, 0, 0);
					processThiccName("1?Bria");
					//StruggleDisplayGroup_mc.HidePressedKeyList(true);
					//processStruggleChangeStage(1);
					break;
				case Keyboard.PAGE_UP:
					DebugFunc.debugTrace("PgUp");
					processThiccStats(2, 0.80, 0.35, 2, 1);
					processThiccName("2?Carreau");
					break;
				case Keyboard.END:
					DebugFunc.debugTrace("End");
					processThiccHideActor(1);
					break;
				case Keyboard.PAGE_DOWN:
					DebugFunc.debugTrace("PgDn");
					//processXPWidget(0.9, 0.2, 25, 1);
					removeHealthBar(1);
					break;
				case Keyboard.DELETE:
					DebugFunc.debugTrace("Delete");
					processPreyTracker(4, 10, 0);
					//processNewLocation(0.5);
					break;
				case Keyboard.INSERT:
					DebugFunc.debugTrace("Insert");
					processNewLocation (0.1);
					break;
				case Keyboard.NUMPAD_ADD:
					DebugFunc.debugTrace("+");
					//processPreyTracker(4, 10, 0);
					processInitializeStage("2.5?Forward?Back?StrafeLeft?StrafeRight?Jump");
					processStruggleMessage("0/Do you remember the way you came in");
					break;				
			}
		}
		
	}
	
}
