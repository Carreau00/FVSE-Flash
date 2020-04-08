package  {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import flash.events.*;
	import Shared.AS3.BSScrollingList;
	import flash.utils.Timer;
	
	public class PipboyVoreTab extends MovieClip {
		
		public var VoreTab_mc:VoreTab;
		public var PerkMenuButton: BSButtonHintData;
		public var PerkMenuButtonAlt: BSButtonHintData;
		public var SwallowItemButton: BSButtonHintData;
		public var PrevPredButton: BSButtonHintData;
		public var NextPredButton: BSButtonHintData;
		public var RootMenu:MovieClip;
		public var F4SECodeObj:Object;
		public var BGSCodeObj:Object;
		public var CurrentPage:int;
		public var CurrentTab:int;
		public var lastPage:int;
		public var PerksMenuCommand:String;
		
		private var _entryListStats:Array;
		private var _vorePerkPoints:int;
		private var _swallowChildIndex:int;
		private var _hasHadNukaAcid:int;
		private var _isController:Boolean;
		
		public function PipboyVoreTab() {
			// constructor code
			trace("[FVSE] Pipboy Vore function injected");
			PerksMenuCommand = "LShoulder";
			lastPage = 999;
			_swallowChildIndex = -1;
			_isController = false;
			_hasHadNukaAcid = 0;
			_vorePerkPoints = 0;
			_entryListStats = new Array();
			F4SECodeObj = new Object();
			BGSCodeObj = new Object();
			PerkMenuButton = new BSButtonHintData("$FVSE_OPEN_VORE_PERKS", "B", "PSN_L1", "Xenon_L1", 1, onPerkButtonPress);
			PerkMenuButtonAlt = new BSButtonHintData("$FVSE_OPEN_VORE_PERKS", "B", "PSN_X", "Xenon_X", 1, onPerkButtonPress);
			SwallowItemButton = new BSButtonHintData("$FVSE_SWALLOW_ITEM", "B", "PSN_L1", "Xenon_L1", 1, onSwallowItemButtonPress);
			PrevPredButton = new BSButtonHintData("$FVSE_PREVCHAR", "Ctrl","PSN_L1","Xenon_L1", 1, onPrevPred);
			NextPredButton = new BSButtonHintData("$FVSE_NEXTCHAR", "Alt","PSN_R1","Xenon_R1", 1, onNextPred);
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		}
		
		public function get HasHadNukaAcid() : int {
			return _hasHadNukaAcid;
		}
		
		public function set HasHadNukaAcid(value:int) : void {
			if(_hasHadNukaAcid != value){
				_hasHadNukaAcid = value;
			}
		}
		
		public function get VorePerkPoints() : int {
			return _vorePerkPoints;
		}
		
		public function set VorePerkPoints(value:int) : void {
			if(_vorePerkPoints != value){
				_vorePerkPoints = value;
			}
		}
		
		public function F4SECodeUpdate(ActorStats:Array, PlayerStats:Array, isGamePadEnabled:Boolean) : void {
			trace("[FVSE] VoreTab F4SECodeUpdate ActorStats.length: " + ActorStats.length + " PlayerStats.length: " + PlayerStats.length + " isGamePadEnabled: " + isGamePadEnabled);
			VoreTab_mc.actorStatsArray = ActorStats;
			VoreTab_mc.UpdateStats(0);
			HasHadNukaAcid = VoreTab_mc.PlayerPredLevel;
			_isController = isGamePadEnabled;
			VorePerkPoints = VoreTab_mc.PlayerPerkPoints;
			InvalidateVoreButton();
			_entryListStats = PlayerStats;
		}
		
		public function onAddedToStage() : void {
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			RootMenu = stage.getChildAt(0)["Menu_mc"];
			/*var children:Array = [];
			trace("numChildren: " + stage.numChildren + " RootMenu: " + RootMenu);
			for (var i:uint = 0; i <stage.numChildren; i++){
				children.push(stage.getChildAt(i));
				trace("child " + i + " object: " + stage.getChildAt(i));
			}*/
			PipboyChangeEvent.Register(stage, this.onPipBoyChangeEventInternal);
			if(stage.getChildAt(0)["FVSECodeObj"]){
				F4SECodeObj = stage.getChildAt(0)["FVSECodeObj"];
			}
			F4SECodeObj.UpdatePipboyValues();
		}
		
		public function onPrevPred(){
			VoreTab_mc.CurrSelectedActor -= 1;
			VoreTab_mc.UpdateStats(VoreTab_mc.CurrSelectedActor);
			InvalidateVoreButton();
		}
		
		public function onNextPred(){
			VoreTab_mc.CurrSelectedActor += 1;
			VoreTab_mc.UpdateStats(VoreTab_mc.CurrSelectedActor);
			InvalidateVoreButton();
		}
		
		public function ProcessUserInputVore(ControlEvent:String, IsDown:Boolean, keyCode:int) : Boolean{
			var ReturnValue:Boolean = false;
			//trace("ProcessUserEventVore ControlEvent: " + ControlEvent + "keyCode: " + keyCode);
			if(IsDown){
				
			} else {
				if (lastPage == 0){
					if(keyCode == 0x42 || ControlEvent == PerksMenuCommand){
						onPerkButtonPress();
					} else if(PrevPredButton.ButtonEnabled && (keyCode == 0xA2 || ControlEvent == "LShoulder")){
						onPrevPred()
					} else if(NextPredButton.ButtonEnabled && (keyCode == 0xA4 || ControlEvent == "RShoulder")){
						onNextPred()
					}
				} else if (lastPage == 1){
					if(SwallowItemButton.ButtonVisible && (keyCode == 0x42 || ControlEvent == "LShoulder")){
						onSwallowItemButtonPress()
					}
				}
			}
			return ReturnValue;
		}
		
		private function onPipBoyChangeEventInternal(param1:PipboyChangeEvent) : void{
			var _loc1_:BSButtonHintBar = RootMenu["ButtonHintBar_mc"];
			CurrentPage = param1.DataObj.CurrentPage;
			CurrentTab = param1.DataObj.CurrentTab
			var _loc2_:int = -1;
			var _loc3_:int = -1;
			var _loc4_:int = -1;
			for (var i:int = 0; i < RootMenu.numChildren; i++){
				if(RootMenu.getChildAt(i)["_buttonHintDataV"] && RootMenu.getChildAt(i)["StatusTab_mc"]){
					_loc2_ = i
				}
				if (RootMenu.getChildAt(i)["_buttonHintDataV"] && RootMenu.getChildAt(i)["PaperDoll_mc"]) {
					_loc3_ = i;
				}
				if (RootMenu.getChildAt(i)["StatsTab_mc"]) {
					_loc4_ = i;
				}
			}
			if(CurrentPage == 0 && CurrentPage != lastPage){
				if(_loc2_ > -1){
					RootMenu.getChildAt(_loc2_)["_TabNames"].push("$VORE");
					VoreTab_mc.TabIndex = RootMenu.getChildAt(_loc2_)["_TabNames"].length - 1;
					RootMenu.getChildAt(_loc2_)["_buttonHintDataV"].push(PrevPredButton);
					RootMenu.getChildAt(_loc2_)["_buttonHintDataV"].push(NextPredButton);
					RootMenu.getChildAt(_loc2_)["_buttonHintDataV"].push(PerkMenuButton);
					RootMenu.getChildAt(_loc2_)["_buttonHintDataV"].push(PerkMenuButtonAlt);
					_loc1_.SetButtonHintData(RootMenu.getChildAt(_loc2_)["_buttonHintDataV"]);
				}
			} else if(CurrentPage == 1 && CurrentPage != lastPage){
				if(_loc3_ > -1){
					RootMenu.getChildAt(_loc3_)["_buttonHintDataV"].push(SwallowItemButton);
					_loc1_.SetButtonHintData(RootMenu.getChildAt(_loc3_)["_buttonHintDataV"]);
					_swallowChildIndex = _loc3_;
				}
			} else if(CurrentPage == 2 && _loc4_ > -1){
				InjectVoreStats(_loc4_, param1.DataObj.GeneralStatsList, CurrentTab);
			}
			if (CurrentPage == 0 && _loc2_ > -1){
				if (CurrentTab == RootMenu.getChildAt(_loc2_)["PerksTab_mc"].TabIndex){
					PerkMenuButtonAlt.ButtonEnabled = true;
					PerkMenuButtonAlt.ButtonVisible = true;
					PerkMenuButton.ButtonEnabled = false;
					PerkMenuButton.ButtonVisible = false;
					PerksMenuCommand = "Accept"
				} else {
					PerkMenuButtonAlt.ButtonEnabled = false;
					PerkMenuButtonAlt.ButtonVisible = false;
					PerkMenuButton.ButtonEnabled = true;
					PerkMenuButton.ButtonVisible = true;
					PerksMenuCommand = "LShoulder"
				}
				InvalidateVoreButton();
			} else if (param1.DataObj.CurrentPage == 1 && _loc3_ > -1){
				if(HasHadNukaAcid >= 1){
					SwallowItemButton.ButtonVisible = !_isController || param1.DataObj.CurrentTab != 1;
				}
				else{
					SwallowItemButton.ButtonVisible = false;
				}
			}
			if (CurrentPage == 0 && CurrentTab == VoreTab_mc.TabIndex){
				VoreTab_mc.visible = true;
				VoreTab_mc.onPipboyChangeEvent_int(param1);
			} else {
				VoreTab_mc.visible = false;
			}
			lastPage = CurrentPage;
		}
		
		protected function InjectVoreStats(childIndex:int, arrayTest:Array, _CurrentTab:int):void{
			if(RootMenu.getChildAt(childIndex)["StatsTab_mc"].TabIndex == _CurrentTab){
				var _loc2_:BSScrollingList = RootMenu.getChildAt(childIndex)["StatsTab_mc"]["CategoryList_mc"];
				if (_loc2_){
					var _loc3_:Array = arrayTest;
					_loc3_.push(_entryListStats[0]);
					RootMenu.getChildAt(childIndex)["StatsTab_mc"]["CategoryList_mc"].entryList = _loc3_;
					RootMenu.getChildAt(childIndex)["StatsTab_mc"]["CategoryList_mc"].InvalidateData();
				} else {
					trace("[FVSE] Beep boop beep.  Scrolling List empty");
				}
			}
		}

		protected function InvalidateVoreButton():void{
			if (CurrentPage == 0 && CurrentTab == VoreTab_mc.TabIndex){
				PrevPredButton.ButtonVisible = true;
				PrevPredButton.ButtonEnabled = VoreTab_mc.CurrSelectedActor > 0;
				NextPredButton.ButtonVisible = true;
				NextPredButton.ButtonEnabled = VoreTab_mc.CurrSelectedActor < VoreTab_mc.actorStatsArray.length-1;
			} else {
				PrevPredButton.ButtonVisible = false;
				PrevPredButton.ButtonEnabled = false;
				NextPredButton.ButtonVisible = false;
				NextPredButton.ButtonEnabled = false;
			}
			if (PerkMenuButton.ButtonVisible){
				PerkMenuButton.ButtonText = VorePerkPoints > 0?"$$FVSE_LEVELUP (" + VorePerkPoints + ")":"$FVSE_OPEN_VORE_PERKS";
				PerkMenuButton.ButtonFlashing = VorePerkPoints > 0;
			}
			else if (PerkMenuButtonAlt.ButtonVisible){
				PerkMenuButtonAlt.ButtonText = VorePerkPoints > 0?"$$FVSE_LEVELUP (" + VorePerkPoints + ")":"$FVSE_OPEN_VORE_PERKS";
				PerkMenuButtonAlt.ButtonFlashing = VorePerkPoints > 0;
			}
		}
		
		private function onPerkButtonPress() : void{
			F4SECodeObj.OpenPerksMenu();
		}
		
		private function onSwallowItemButtonPress() : void {
			for(var i:uint = 0; i < RootMenu.numChildren; i++){
				if(RootMenu.getChildAt(i)["PaperDoll_mc"]){					
					var _loc1_:BSScrollingList = RootMenu.getChildAt(i)["List_mc"];
					if(_loc1_){
						for(var id:String in _loc1_.selectedEntry) {
							var value:Object = _loc1_.selectedEntry[id];
							trace(id + " = " + value);
						}
						var _loc2_:* = _loc1_.selectedEntry.formID;
						F4SECodeObj.SwallowItem(_loc2_);
						var myTimer:Timer = new Timer(500,1);
						myTimer.addEventListener(TimerEvent.TIMER, onTimerDropItem);
						myTimer.start();
						//RootMenu.getChildAt(i)["DropItem"]();
					}
				}
			}
		}
		
		private function onTimerDropItem(event:TimerEvent){
			RootMenu.getChildAt(_swallowChildIndex)["DropItem"]();
		}
	}
	
}
