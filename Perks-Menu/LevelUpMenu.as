package  {
	
	import Carreau.components.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import Shared.AS3.*;
	import Shared.IMenu;
	import Shared.PlatformChangeEvent;
	import scaleform.gfx.Extensions;
	import Shared.BGSExternalInterface;
	
	public class LevelUpMenu extends IMenu {
		
		public var bgholder_mc:BGHolder;
		
		public var PerksWindow_mc:PerksWindow;
		public var InfoWindow_mc:InfoWindow;
		public var SpecialWindow_mc:SpecialWindow;
		public var PlayerData_mc:PlayerData;
		//public var loaded:uint = 0;
		
		//vars for Contextual Menu Holder
		public var ContextualMenuHolder_mc:BSButtonHintBar;
		private var AcceptButton:BSButtonHintData;
		private var LearnPerkButton:BSButtonHintData;
		private var PrevPerkButton:BSButtonHintData;
		private var NextPerkButton:BSButtonHintData;
		private var FilterPerkButton:BSButtonHintData;
		private var CancelButton:BSButtonHintData;
		private var CancelConfirmButton:BSButtonHintData;
		private var SpendLevelButton:BSButtonHintData;
		
		public var AllowClose:Boolean;
		
		//internal vars
		private var _BGSCodeObj:Object;
		private var _perkPoints:uint;
		private var _canCloseMenu:Boolean = true;
		
		public function LevelUpMenu() {
			// constructor code
			_BGSCodeObj = new Object();
			Extensions.enabled = true;
			this.AcceptButton = new BSButtonHintData("ACCEPT", "Enter", "PSN_A", "Xenon_A", 1, OnAcceptPressed);
			this.LearnPerkButton = new BSButtonHintData("$FVSE_LEARN_PERK","Enter","PSN_A","Xenon_A",1,OnLearnPerkButtonPressed);
			this.SpendLevelButton = new BSButtonHintData("$FVSE_PURCHASE_LEVEL","Enter","PSN_A","Xenon_A",1,OnPurchaseLevelButtonPressed);
			this.PrevPerkButton = new BSButtonHintData("$PREV PERK","Ctrl","PSN_L1","Xenon_L1",1,PerksWindow_mc.onPrevPerk);
			this.NextPerkButton = new BSButtonHintData("$NEXT PERK","Alt","PSN_R1","Xenon_R1",1,PerksWindow_mc.onNextPerk);
			this.FilterPerkButton = new BSButtonHintData("TEST FILTER","F","PSN_Y","Xenon_Y",1,PerksWindow_mc.onFilterPerk);
			this.CancelConfirmButton = new BSButtonHintData("$CANCEL","Tab","PSN_B","Xenon_B",1,OnConfirmCancelButtonPressed);
			this.CancelButton = new BSButtonHintData("$CLOSE", "Tab", "PSN_B", "Xenon_B", 1, OnCancelPressed);
			PerksWindow_mc.PerkList_mc.addEventListener(MouseEvent.ROLL_OVER, onPerkListRollOver);
			PlayerData_mc.LevelUpButtons_mc.addEventListener(MouseEvent.ROLL_OVER, onLevelUpButtonsRollOver);
			PopulateButtonBar();
			//SetContextMenu();
			_setProp_BGHolder();
			_setProp_ContextualMenuHolder_mc();
			CallDeviceUpdate(); //call this last to ensure the constructor has finished before F4SE starts to monkey with IMenu
		}
		
		public function RegisterCodeObj(param1:Object){
			_BGSCodeObj = param1;
			PerksWindow_mc.codeObj = _BGSCodeObj;
		}
		
		function CallDeviceUpdate() : * {
			var isGamePadEnabled:Boolean = false;
			try {
				isGamePadEnabled = (stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.RegisterInputDevice();
			}
			catch(e:Error){
				trace("[FVSE:Perks] RegisterInputDevice failed to call.  Defaulting to PC control scheme");
			}
			
			if(isGamePadEnabled && uiPlatform != PlatformChangeEvent.PLATFORM_XB1){
				SetPlatform(PlatformChangeEvent.PLATFORM_XB1, false)
			} else if (uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE){
				SetPlatform(PlatformChangeEvent.PLATFORM_PC_KB_MOUSE, false)				
			}

		}
		
		//F4SE Invoked Commands
		public function BeginMenu(PerksListArray:Array, PlayerDataArray:Array, isGamePadEnabled:Boolean) : * {
			PerksWindow_mc.PopulateEntryList(PerksListArray);
			PlayerDataArray = SpecialWindow_mc.SetSpecialValues(PlayerDataArray);
			PlayerData_mc.InitializeData(PlayerDataArray);
			PerksWindow_mc.SetPerkWindowFocus();
			SetContextMenu();
			
		}
		
		public function UpdateInputDeviceType(isGamePadEnabled:Boolean) : * {
			if(isGamePadEnabled && uiPlatform != PlatformChangeEvent.PLATFORM_XB1){
				SetPlatform(PlatformChangeEvent.PLATFORM_XB1, false)
			} else if (uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE){
				SetPlatform(PlatformChangeEvent.PLATFORM_PC_KB_MOUSE, false)				
			}
		}
		
		public function PopulatePlayerData(playerDataArray:Array) : * {
			//send up the array.  All special values are in the first 7 places in order S P E C I A L
			//returned array will have special values removed
			playerDataArray = SpecialWindow_mc.SetSpecialValues(playerDataArray);
		}
		
		public function ProcessUserInput(ControlEvent:String, IsDown:Boolean, keyCode:int) : Boolean{
			//Mask for down press events.  Finalize input command on the up lift side of the keypress
			var ReturnValue:Boolean = false;
			if(IsDown){
				if (stage.focus == PerksWindow_mc.PerkList_mc && PlayerData_mc.LevelUpButtons_mc.entryList.length > 0 && (ControlEvent == "Right" || ControlEvent == "StrafeRight")){
					(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuOK");
					onLevelUpButtonsFocus();
				} else if (stage.focus == PlayerData_mc.LevelUpButtons_mc  && (ControlEvent == "Left" || ControlEvent == "StrafeLeft")) {
					(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuOK");
					onPerkListFocus();
				}
			} else {
				if (ControlEvent == "Activate" || ControlEvent == "Accept" || ControlEvent == "XButton") {
					/*if(PerksWindow_mc.IsConfirmFocus()) {
						OnConfirmPressed();
					} 
					else if (PerksWindow_mc.IsPerkListFocus()){
						OnLearnPerkButtonPressed();
					}
					ReturnValue = true;*/
				} else if (PrevPerkButton.ButtonEnabled && stage.focus == PerksWindow_mc.PerkList_mc && (keyCode == 0xA2 || ControlEvent == "LShoulder")){
					PerksWindow_mc.onPrevPerk();
				} else if (NextPerkButton.ButtonEnabled && stage.focus == PerksWindow_mc.PerkList_mc && (keyCode == 0xA4 || ControlEvent == "RShoulder")){
					PerksWindow_mc.onNextPerk();
				} else if (keyCode == 0x46 || ControlEvent == "YButton"){
					PerksWindow_mc.onFilterPerk();
				}
				else if (ControlEvent == "Cancel"){
					if(PerksWindow_mc.IsConfirmFocus()) {
						OnConfirmCancelButtonPressed();
						CanCloseMenu = true;
					}
					else if (CanCloseMenu && !PerksWindow_mc.IsConfirmFocus()) {
						OnCancelPressed();
					}
					ReturnValue = true;
				}
			}
			SetContextMenu();
			return ReturnValue;
		}
		
		public function UpdateInputDevice(IsGamepadEnabled:Boolean) : Boolean{
			var ReturnValue:Boolean = false;
			if(IsGamepadEnabled && uiPlatform != PlatformChangeEvent.PLATFORM_XB1){
				SetPlatform(PlatformChangeEvent.PLATFORM_XB1, false)
				ReturnValue = true;
			} else if (uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE){
				SetPlatform(PlatformChangeEvent.PLATFORM_PC_KB_MOUSE, false)				
				ReturnValue = true;
			}
			return ReturnValue;
		}
		
		public function onPerkListRollOver(param1:MouseEvent):*{
			onPerkListFocus();
		}
		
		public function onPerkListFocus():*{
			if(stage.focus == PlayerData_mc.LevelUpButtons_mc){
				PlayerData_mc.LevelUpButtons_mc.selectedIndex = -1;
				stage.focus = PerksWindow_mc.PerkList_mc;
				PerksWindow_mc.EnableDisablePerkListEntry(true);
				SetContextMenu();
			}
		}
		
		public function onLevelUpButtonsRollOver(param1:MouseEvent):*{
			onLevelUpButtonsFocus();
		}

		public function onLevelUpButtonsFocus():*{
			if(PlayerData_mc.LevelUpButtons_mc.entryList.length > 0 && stage.focus == PerksWindow_mc.PerkList_mc){
				if(PlayerData_mc.LevelUpButtons_mc.selectedIndex == -1){
					PlayerData_mc.LevelUpButtons_mc.selectedIndex = 0;
				}
				stage.focus = PlayerData_mc.LevelUpButtons_mc;
				PerksWindow_mc.EnableDisablePerkListEntry(false);
				SetContextMenu();
			}
		}
		
		// Get and Set functions
		public function get PerkPoints() : uint {
			return _perkPoints;
		}
		
		public function set PerkPoints(value:uint) {
			if(_perkPoints != value){
				_perkPoints = value;
			}
		}
		
		public function get CanCloseMenu() : Boolean {
			return _canCloseMenu;
		}
		
		public function set CanCloseMenu(value:Boolean) {
			if(_canCloseMenu != value){
				_canCloseMenu = value;
			}
		}
		
		private function PopulateButtonBar() : void {
			var ContextMenuHolder:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			ContextMenuHolder.push(AcceptButton);
			ContextMenuHolder.push(this.LearnPerkButton);
			ContextMenuHolder.push(SpendLevelButton);
			ContextMenuHolder.push(PrevPerkButton);
			ContextMenuHolder.push(NextPerkButton);
			ContextMenuHolder.push(FilterPerkButton);
			ContextMenuHolder.push(CancelButton);
			ContextualMenuHolder_mc.SetButtonHintData(ContextMenuHolder);
		}
	  
		private function OnAcceptPressed() : void {
			if(!CanCloseMenu && PerkPoints > 0) {
				return;
			}
			try {
				(stage.getChildAt(0) as MovieClip).f4se.AllowTextInput(false);
			}
			catch(e:Error){
				trace("[FVSE:Perks] Failed to disable text input " + e);
			}
			
		}
		
		private function OnPurchaseLevelButtonPressed() : void {
			PlayerData_mc.LevelType = PlayerData_mc.LevelUpButtons_mc.selectedIndex;
			if(PlayerData_mc.VoreLevelPoints > 0 && PlayerData_mc.LevelType > -1){
				PerksWindow_mc.OnLearnLevelPressed(PlayerData_mc.LevelType)
			}
		}

		private function OnCancelPressed() : * {
			try {
			(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.CloseLevelVoreMenu();
			}
			catch(e:Error){
				trace("[FVSE:Perks] Close Menu failed " + e);
			}
		}
		
		private function OnConfirmCancelButtonPressed() : * {
			var _loc1_:int = PerksWindow_mc.GetConfirmLastIndex();
			OnConfirmPressed(_loc1_);
		}
		
		private function OnConfirmPressed(indexVal:int =  -1) : * {
			if(indexVal != -1){
				PerksWindow_mc.ConfirmWindow_mc.ActionButtons_mc.selectedIndex = indexVal;
			}
			PerksWindow_mc.OnButtonBarPressed();
					
		}

		private function OnLearnPerkButtonPressed() : * {
			CanCloseMenu = PerksWindow_mc.OnLearnPerkButtonPressed();
		}
		
		public function SetContextMenu() : void {
			LearnPerkButton.ButtonEnabled = PlayerData_mc.PerkPointsAvilable > 0;
			LearnPerkButton.ButtonVisible = stage.focus == PerksWindow_mc.PerkList_mc;
			SpendLevelButton.ButtonEnabled = PlayerData_mc.VoreLevelPoints > 0;
			SpendLevelButton.ButtonVisible = stage.focus == PlayerData_mc.LevelUpButtons_mc;
			AcceptButton.ButtonEnabled = PerksWindow_mc.IsConfirmFocus() && !LearnPerkButton.ButtonVisible;
			AcceptButton.ButtonVisible = AcceptButton.ButtonEnabled;
			PrevPerkButton.ButtonVisible = stage.focus == PerksWindow_mc.PerkList_mc;
			PrevPerkButton.ButtonEnabled = PerksWindow_mc.CurrSelectedRank > 1;
			NextPerkButton.ButtonVisible = stage.focus == PerksWindow_mc.PerkList_mc;
			NextPerkButton.ButtonEnabled = PerksWindow_mc.CurrSelectedRank < PerksWindow_mc.MaxSelectedRank;
			var _loc1_:String;
			switch(PerksWindow_mc.FilterMode){
				case 0:
					_loc1_ = "$FVSE_SHOW_PRED_PERKS";
					break;
				case 1:
					_loc1_ = "$FVSE_SHOW_PREY_PERKS";
					break;
				case 2:
					_loc1_ = "$FVSE_SHOW_ALL_PERKS";
					break;
			}
			FilterPerkButton.ButtonText = _loc1_;
			FilterPerkButton.ButtonEnabled = !PerksWindow_mc.IsConfirmFocus();
			FilterPerkButton.ButtonVisible = FilterPerkButton.ButtonEnabled;
            CancelConfirmButton.ButtonEnabled = PerksWindow_mc.IsConfirmFocus();
            CancelConfirmButton.ButtonVisible = CancelConfirmButton.ButtonEnabled;
            CancelButton.ButtonEnabled = !PerksWindow_mc.IsConfirmFocus();
            CancelButton.ButtonVisible = CancelButton.ButtonEnabled;
		}
		
		
		function _setProp_BGHolder() : * {
			try {
				this.bgholder_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error){
			}
			bgholder_mc.bracketCornerLength = 6;
			bgholder_mc.bracketLineWidth = 1.5;
			bgholder_mc.bracketPaddingX = 0;
			bgholder_mc.bracketPaddingY = 0;
			bgholder_mc.BracketStyle = "vertical";
			bgholder_mc.bShowBrackets = true;
			bgholder_mc.bUseShadedBackground = true;
			bgholder_mc.ShadedBackgroundMethod = "Flash";
			bgholder_mc.ShadedBackgroundType = "normal";
			try {
				bgholder_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error) {
				return;
			}
		}
		
		function _setProp_ContextualMenuHolder_mc() : *{
			try
			{
				this.ContextualMenuHolder_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ContextualMenuHolder_mc.BackgroundAlpha = 0.7;
			this.ContextualMenuHolder_mc.BackgroundColor = 3355443;
			this.ContextualMenuHolder_mc.bracketCornerLength = 6;
			this.ContextualMenuHolder_mc.bracketLineWidth = 1.5;
			this.ContextualMenuHolder_mc.BracketStyle = "horizontal";
			this.ContextualMenuHolder_mc.bRedirectToButtonBarMenu = false;
			this.ContextualMenuHolder_mc.bShowBrackets = true;
			this.ContextualMenuHolder_mc.bUseShadedBackground = true;
			this.ContextualMenuHolder_mc.ShadedBackgroundMethod = "Flash";
			this.ContextualMenuHolder_mc.ShadedBackgroundType = "normal";
			try
			{
				this.ContextualMenuHolder_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
	}
	
}
