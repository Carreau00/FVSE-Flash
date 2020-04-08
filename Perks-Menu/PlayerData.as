package  {
	
	import Shared.AS3.*;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.MovieClip;
	import Carreau.components.LevelUpButtons_List;
	import PerksWindow;
	
	public class PlayerData extends BSUIComponent {
		
		
		public var LevelPoint_tf:TextField;
		public var LevelPointLabel_tf:TextField;
		public var PredLevel_tf:TextField;
		public var PredLevelLabel:TextField;
		public var PreyLevel_tf:TextField;
		public var PerkPointsAvail_tf:TextField;
		public var LevelUpButtons_mc:LevelUpButtons_List;
		public var XPMeter_mc:XPMeter;
		public var CapacityMeter_mc:XPMeter;
		
		private var _savedEntryDisable:Boolean;
		private var _levelType:int;
		private var _voreLevelPoints:int;
		private var _predLevel:int;
		private var _preyLevel:int;
		private var _perkPointsAvilable:int;
		private var _currXP:Number;
		private var _maxXP:Number;
		private var _currCapPoints:Number;
		private var _maxCapPoints:Number;
		
		
		public function PlayerData() {
			// constructor code
			_levelType = -1;
			addEventListener(BSScrollingList.ITEM_PRESS, OnItemPress);
			addEventListener(BSScrollingList.SELECTION_CHANGE, OnSelectionChange);
			TogglePredLevelVisible(false);
			ToggleSpendLevelButton(false);
			
			_Set_LevelUpButton_mc_MenuObj_Prop();
			_Set_XPMeter_mc_MenuObj_Prop();
			_Set_CapacityMeter_mc_MenuObj_Prop();
		}
		
		public function InitializeData(PlayerDataArray:Array) : void {
			PerkPointsAvilable = PlayerDataArray[0];
			PreyLevel = PlayerDataArray[1];
			PredLevel = PlayerDataArray[2];
			VoreLevelPoints = PlayerDataArray[3];
			setXPMeter(PlayerDataArray[4], PlayerDataArray[5]);
			setCapacityMeter(PlayerDataArray[6], PlayerDataArray[7]);
		}
		
		public function get LevelType() : int {
			return _levelType;
		}
		
		public function set LevelType(value:int) : void {
			if(_levelType != value){
				_levelType = value;
			}
		}
		
		public function get VoreLevelPoints() : int {
			return _voreLevelPoints;
		}
		
		public function set VoreLevelPoints(value:int) : void {
			if(_voreLevelPoints != value){
				_voreLevelPoints = value;
				//LevelPoint_tf.text = String(_voreLevelPoints);
			}
			ToggleSpendLevelButton(_voreLevelPoints > 0);
		}
		
		public function get PredLevel() : int {
			return _predLevel;
		}
		
		public function set PredLevel(value:int) : void {
			if(_predLevel != value){
				_predLevel = value;
				PredLevel_tf.text = String(_predLevel);
			}
			TogglePredLevelVisible(_predLevel > 0);
		}
		
		public function get PreyLevel() : int {
			return _preyLevel;
		}
		
		public function set PreyLevel(value:int) : void {
			if(_preyLevel != value){
				_preyLevel = value;
				PreyLevel_tf.text = String(_preyLevel);
			}
		}
		
		public function get PerkPointsAvilable() : int {
			return _perkPointsAvilable;
		}
		
		public function set PerkPointsAvilable(value:int) : void {
			if(_perkPointsAvilable != value){
				_perkPointsAvilable = value;
			}
			PerkPointsAvail_tf.text = String(_perkPointsAvilable);
		}
		
		public function setXPMeter(CurrXP:Number, MaxXP:Number):*{
			_currXP = CurrXP;
			_maxXP = MaxXP;
			XPMeter_mc.SetMeter(_currXP, 0, _maxXP);
		}
		
		public function setCapacityMeter(CurrCapPoints:Number, MaxCapPoints:Number):*{
			_currCapPoints = CurrCapPoints;
			_maxCapPoints = MaxCapPoints;
			CapacityMeter_mc.SetMeter(_currCapPoints, 0, _maxCapPoints);
		}
		
		public function ToggleSpendLevelButton(toggle:Boolean) : void {
			if(toggle){
				LevelPoint_tf.text = String(_voreLevelPoints);
				LevelPointLabel_tf.text = "$FVSE_Lvl_Pnts_Avail";
				PopulateButtons();
			} else {
				LevelPoint_tf.text = "";
				LevelPointLabel_tf.text = "";
				LevelUpButtons_mc.ClearList();
				LevelUpButtons_mc.InvalidateData();
			}
		}
		
		public function TogglePredLevelVisible(toggle:Boolean) : void {
			PredLevel_tf.visible = toggle;
			if(toggle){
				PredLevelLabel.text = "$Pred_Level";
			} else {
				PredLevelLabel.text = "";
			}
		}
		
		public function ConfirmLevelPurchase():* {
			switch(_levelType){
				case 0:
					(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.AddPredLevel();
					break;
				case 1:
					(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.AddPreyLevel();
					break;
			}
			if(_levelType > -1){
				(stage.getChildAt(0) as MovieClip).f4se.SendExternalEvent("onPlayerLevelChoice");
			}
			_levelType = -1;
		}
		
		public function EnableDisableLevelButtonListEntry(value:Boolean):void {
			if(value){
				LevelUpButtons_mc.selectedEntry.disabled = _savedEntryDisable;
				LevelUpButtons_mc.UpdateList();
				LevelUpButtons_mc.disableInput = false;
				LevelUpButtons_mc.disableSelection = false;
			} else {
				_savedEntryDisable = LevelUpButtons_mc.selectedEntry.disabled;
				LevelUpButtons_mc.selectedEntry.disabled = true;
				LevelUpButtons_mc.UpdateList();
				LevelUpButtons_mc.disableInput = true;
				LevelUpButtons_mc.disableSelection = true;
			}
		}
		
		private function OnItemPress():*{
			_levelType = LevelUpButtons_mc.selectedIndex;
			if(_voreLevelPoints > 0 && _levelType > -1){
				(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuPopUpGeneric");
				EnableDisableLevelButtonListEntry(false);
				(Object(parent)).PerksWindow_mc.OnLearnLevelPressed(_levelType)
			}
		}
		private function OnSelectionChange():*{
			(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuFocus");
		}

		private function PopulateButtons():* {
			LevelUpButtons_mc.ClearList();
			var buttonListArray:Array = new Array();
			buttonListArray.push({"text":"$FVSE_Purchase_Pred", "disabled":false});
			buttonListArray.push({"text":"$FVSE_Purchase_Prey", "disabled":false});
			LevelUpButtons_mc.entryList = buttonListArray;
			LevelUpButtons_mc.InvalidateData();
			LevelUpButtons_mc.selectedIndex = -1;
		}
		
		function _Set_LevelUpButton_mc_MenuObj_Prop():* {
			try
			{
				this.LevelUpButtons_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			LevelUpButtons_mc.listEntryClass = "Carreau.components.LevelUpButton_ListEntry";
			LevelUpButtons_mc.numListItems = 2;
			LevelUpButtons_mc.restoreListIndex = false;
			LevelUpButtons_mc.textOption = "None";
			LevelUpButtons_mc.verticalSpacing = 0;
			try
			{
				this.LevelUpButtons_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function _Set_XPMeter_mc_MenuObj_Prop() : *
		{
			try
			{
				XPMeter_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			XPMeter_mc.bracketCornerLength = 0;	// originally 6
			XPMeter_mc.bracketLineWidth = 0;	//originally 1.5
			XPMeter_mc.bracketPaddingX = 0;
			XPMeter_mc.bracketPaddingY = 0;
			XPMeter_mc.BracketStyle = "horizontal";
			XPMeter_mc.bShowBrackets = false;	//originally true
			XPMeter_mc.bUseShadedBackground = true;
			XPMeter_mc.ShadedBackgroundMethod = "Flash";
			XPMeter_mc.ShadedBackgroundType = "normal";
			try
			{
				XPMeter_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}	
		}
		
		function _Set_CapacityMeter_mc_MenuObj_Prop() : *
		{
			try
			{
				CapacityMeter_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			CapacityMeter_mc.bracketCornerLength = 0;	// originally 6
			CapacityMeter_mc.bracketLineWidth = 0;	//originally 1.5
			CapacityMeter_mc.bracketPaddingX = 0;
			CapacityMeter_mc.bracketPaddingY = 0;
			CapacityMeter_mc.BracketStyle = "horizontal";
			CapacityMeter_mc.bShowBrackets = false;	//originally true
			CapacityMeter_mc.bUseShadedBackground = true;
			CapacityMeter_mc.ShadedBackgroundMethod = "Flash";
			CapacityMeter_mc.ShadedBackgroundType = "normal";
			try
			{
				CapacityMeter_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}	
		}
	}
	
}
