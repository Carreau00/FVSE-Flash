package  {
	
	import Shared.BGSExternalInterface;
	import Shared.AS3.*;
	import Shared.GlobalFunc;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import Carreau.components.PerkList;
	import Carreau.components.ConfirmWindow;
	import Carreau.components.PerkRankStar;
	import flash.text.TextField;
	import flash.display.Loader;
	
	public class PerksWindow extends BSUIComponent {
		
		public var PerkList_mc:PerkList;
		public var ConfirmWindow_mc:ConfirmWindow;
		public var Description_tf:TextField;
		public var SPECIALType_tf:TextField;
		public var SPECIALValue_tf:TextField;
		public var VoreType_tf:TextField;
		public var VoreReq_tf:TextField;
		public var StarHolder_mc:MovieClip;
		public var VBHolder_mc:MovieClip;
		
		private var BGSCodeObj:Object;
		private var strPerkName:String;
		private var _DescText:String;
		private var _SPECIALNameText:String;
		private var _SPECIALValInt:uint;
		private var _VoreTypeText:String;
		private var _VoreValInt:uint;
		private var _CurrSelectedRank:uint;
		private var _MaxSelectedRank:uint;
		private var _ViewingRankOffset:int;
		private var _ViewingRanks:Boolean;
		private var _CurrSpecialEnough:Boolean;
		private var _VoreLevelEnough:Boolean;
		private var ORIG_STAR_X:Number;
		private var _VBLoader:Loader;
		private var _VBClipID:uint;
		private var _VBFileName:String;
		private var _FilterMode:uint;
		private var _savedEntryDisable:Boolean;
		
		private const STRENGTH_ID:int = 706;
		private const PERCEPTION_ID:int = 707;
		private const ENDURANCE_ID:int = 708;
		private const CHARISMA_ID:int = 709;
		private const INTELLIGENCE_ID:int = 710;
		private const AGILITY_ID:int = 711;
		private const LUCK_ID:int = 712;
		
		private const PREDTYPE_ID:int = 4;
		private const PREYTYPE_ID:int = 8;
		
		private const DEFAULT_VORE_UI_SOUND = "UIPerkMenuDefault_Vore_FV_";
		
		public function PerksWindow() {
			// constructor code
			BGSCodeObj = new Object();
			VBHolder_mc.scaleX = 0.8;
			VBHolder_mc.scaleY = 0.8;
			_DescText = "";
			_SPECIALNameText = "";
			_VoreTypeText = "";
			_CurrSelectedRank = 0;
			_MaxSelectedRank = 0;
			_ViewingRankOffset = 0;
			_FilterMode = 0;
			_ViewingRanks = false;
			_CurrSpecialEnough = true;
			_VoreLevelEnough = true;
			_VBClipID = 0;
			_VBFileName = "";
			_VBLoader = new Loader();
			addEventListener(BSScrollingList.ITEM_PRESS, OnItemPress);
			addEventListener(BSScrollingList.SELECTION_CHANGE, OnSelectionChange);
			ORIG_STAR_X = StarHolder_mc.x;
			_setProp_Perk_List_mc();
			_setProp_ConfirmWindow_mc_();
		}
		
		public function PopulateEntryList(PerksListArray:Array) : void {
			var lastIndex = PerkList_mc.selectedIndex;
			PerkList_mc.entryList = PerksListArray;
			PerkList_mc.entryList.sortOn("text");
			PerkList_mc.filterer.itemFilter = int(0xFEFFFFFF);		//dec 4293918719  4278190079‬ filters out ineligible perks
			PerkList_mc.InvalidateData();
			
			if (lastIndex < 0){
				PerkList_mc.selectedIndex = 0;
			} else {
				OnSelectionChange();
			}
			
			//Populate the confirm purchase window
			var ConfirmWindowArray:Array = new Array();
			ConfirmWindowArray.push({"text":"$YES"});
			ConfirmWindowArray.push({"text":"$NO"});
			ConfirmWindow_mc.ActionButtons_mc.entryList = ConfirmWindowArray;
			ConfirmWindow_mc.ActionButtons_mc.InvalidateData();
			ConfirmWindow_mc.ActionButtons_mc.selectedIndex = 0
			//(Object(parent)).SetContextMenu();
			SetIsDirty();
		}
		
		public function get CurrSelectedRank(): uint {
			return _CurrSelectedRank;
		}
		
		public function get MaxSelectedRank(): uint {
			return _MaxSelectedRank;
		}
		
		public function set PerkName(StringName:String) : * {
			strPerkName = StringName;
		}
		
		public function get codeObj(): Object {
			return BGSCodeObj;
		}
		
		public function set codeObj(param1:Object) : * {
			BGSCodeObj = param1;
		}
		
		public function get FilterMode() : uint{
			return _FilterMode;
		}
		
		public function SetPerkWindowFocus() : void {
			stage.focus = PerkList_mc;
		}
		
		public function IsPerkListFocus() : Boolean {
			if(stage.focus == PerkList_mc){
				return true;
			}
			return false;
		}
		
		public function IsConfirmFocus() : Boolean {
			if(stage.focus == ConfirmWindow_mc.ActionButtons_mc){
				return true;
			}
			return false;
		}
		
		public function IsConfirmWindowOpened() : Boolean{
			return ConfirmWindow_mc.IsOpened;
		}
		
		public function CloseConfirmWindow() : void {
			ConfirmWindow_mc.Close();
		}
		
		public function GetConfirmLastIndex() : int {
			return (ConfirmWindow_mc.ActionButtons_mc.entryList.length - 1);
		}
		public function OnLearnPerkButtonPressed() : Boolean {
			//if (PerkList_mc.entryList[PerkList_mc.selectedIndex].isEligible)
				//Let player know WHY they can't purchase
				//return true;
			//else{
			OnLearnPerkPressed(PerkList_mc.entryList[PerkList_mc.selectedIndex]);
			return false;
			//}
		}
		
		public function onPrevPerk() : *
		{
			_ViewingRankOffset--;
			_ViewingRanks = true;
			nextPrevPerk_Helper();
			SetIsDirty();
		}
      
		public function onNextPerk() : *
		{
			_ViewingRankOffset++;
			_ViewingRanks = true;
			nextPrevPerk_Helper();
			SetIsDirty();
		}
		
		public function onFilterPerk() : * {
			_FilterMode += 1;
			if(_FilterMode > 2){
				_FilterMode = 0;
			}
			var _loc1_:int;
			switch (_FilterMode){
				case 0:
					_loc1_ = int(0xF);
					break;
				case 1:
					_loc1_ = PREDTYPE_ID;
					break;
				case 2:
					_loc1_ = PREYTYPE_ID;
					break;
			}
			
			PerkList_mc.filterer.itemFilter = _loc1_;
			PerkList_mc.InvalidateData();
			PerkList_mc.selectedIndex = PerkList_mc.GetEntryFromClipIndex(0);
			(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuOK");
			(Object(parent)).SetContextMenu();			
		}

		private function OnSelectionChange():*{
			if(PerkList_mc.selectedIndex != -1){
				//set the description
				_DescText = PerkList_mc.selectedEntry.descriptions[PerkList_mc.selectedEntry.rank - 1];
				_SPECIALValInt = PerkList_mc.selectedEntry.specialReq;
				var _loc1_:int = PerkList_mc.selectedEntry.specialType;
				if(_loc1_ == STRENGTH_ID){
					_CurrSpecialEnough = (Object(parent)).SpecialWindow_mc.StrengthValue >= _SPECIALValInt;
					_SPECIALNameText = "$FVSE_Str";
				}
				else if(_loc1_ == PERCEPTION_ID){
					_CurrSpecialEnough = (Object(parent)).SpecialWindow_mc.PerceptionValue >= _SPECIALValInt;
					_SPECIALNameText = "$FVSE_Per";
				}
				else if(_loc1_ == ENDURANCE_ID){
					_CurrSpecialEnough = (Object(parent)).SpecialWindow_mc.EnduranceValue >= _SPECIALValInt;
					_SPECIALNameText = "$FVSE_End";
				}
				else if(_loc1_ == CHARISMA_ID){
					_CurrSpecialEnough = (Object(parent)).SpecialWindow_mc.CharismaValue >= _SPECIALValInt;
					_SPECIALNameText = "$FVSE_Cha";
				}
				else if(_loc1_ == INTELLIGENCE_ID){
					_CurrSpecialEnough = (Object(parent)).SpecialWindow_mc.IntelligenceValue >= _SPECIALValInt;
					_SPECIALNameText = "$FVSE_Int";
				}
				else if(_loc1_ == AGILITY_ID){
					_CurrSpecialEnough = (Object(parent)).SpecialWindow_mc.AgilityValue >= _SPECIALValInt;
					_SPECIALNameText = "$FVSE_Agi";
				}
				else if(_loc1_ == LUCK_ID){
					_CurrSpecialEnough = (Object(parent)).SpecialWindow_mc.LuckValue >= _SPECIALValInt;
					_SPECIALNameText = "$FVSE_Lck";
				}
				
				_VoreValInt = PerkList_mc.selectedEntry.voreReqValues[PerkList_mc.selectedEntry.rank - 1];
				var _loc2_:int = PerkList_mc.selectedEntry.voreType;
				
				if(_VoreValInt == 1){
					_VoreTypeText = "";
				}
				else if(_loc2_ == PREDTYPE_ID){
					_VoreLevelEnough = (Object(parent)).PlayerData_mc.PredLevel >= _VoreValInt;
					_VoreTypeText = "$Pred_Level";
				} else if(_loc2_ == PREYTYPE_ID){
					_VoreLevelEnough = (Object(parent)).PlayerData_mc.PreyLevel >= _VoreValInt;
					_VoreTypeText = "$Prey_Level";
				}
				
				_VBClipID = PerkList_mc.selectedEntry.formID;
				if(PerkList_mc.selectedEntry.SWFFile != undefined && PerkList_mc.selectedEntry.SWFFile.length > 0)
				{
					_VBFileName = PerkList_mc.selectedEntry.SWFFile;
				}
				else if (_loc2_ == PREDTYPE_ID)
				{
					_VBFileName = "Components/VaultBoys/Perks/PerkClip_defaultvore.swf";
				} else {
					_VBFileName = "Components/VaultBoys/Perks/PerkClip_default.swf";
				}
				_CurrSelectedRank = PerkList_mc.selectedEntry.rank;
				_MaxSelectedRank = PerkList_mc.selectedEntry.maxRank;
				(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuFocus");
			}
			else {
				_DescText = " ";
				//_VBFileName = "";
				_VBClipID = 0;
				_CurrSelectedRank = 0;
				_MaxSelectedRank = 0;
			}
			_ViewingRankOffset = 0;
			_ViewingRanks = false;
			SetIsDirty();
		}
		
		public function OnButtonBarPressed() : void {
			if(stage.focus == PerkList_mc){
				
			} else if (stage.focus == ConfirmWindow_mc.ActionButtons_mc){
				if (ConfirmWindow_mc.ConfirmMode == ConfirmWindow.MODE_LEARN_PERK){
					OnLearnPerkConfirm();
				} else if(ConfirmWindow_mc.ConfirmMode == ConfirmWindow.MODE_CANT_LEARN){
					onAcceptCancelCannotLearn();
				} else if(ConfirmWindow_mc.ConfirmMode == ConfirmWindow.MODE_LEARN_LEVEL){
					OnLevelConfirm()
				}
			}
		}
		
		public function OnLearnLevelPressed(levelType:int = -1):void{
			ConfirmWindow_mc.ConfirmMode = ConfirmWindow.MODE_LEARN_LEVEL;
			var ConfirmWindowArray:Array = new Array();
			ConfirmWindowArray.push({"text":"$YES"});
			ConfirmWindowArray.push({"text":"$NO"});
			ConfirmWindow_mc.ActionButtons_mc.entryList = ConfirmWindowArray;
			ConfirmWindow_mc.ActionButtons_mc.InvalidateData();
			ConfirmWindow_mc.ActionButtons_mc.selectedIndex = 0
			var _loc1_:String;
			if(levelType == 0){
				_loc1_ = "$FVSE_Increase_Pred";
			} else if (levelType == 1){
				_loc1_ = "$FVSE_Increase_Prey";
			}
			ConfirmWindow_mc.Open(stage.focus, _loc1_);
			stage.focus = ConfirmWindow_mc.ActionButtons_mc;
			(Object(parent)).SetContextMenu();
		}
		
		private function OnItemPress(param1:Object) : *{
			switch(param1.target.name){
				case "PerkList_mc" :
					(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuPopUpGeneric");
					if((Object(parent)).PlayerData_mc.PerkPointsAvilable > 0 && (param1.target.selectedEntry.filterFlag & (2<<4)) == 0){
						OnLearnPerkPressed(param1.target.selectedEntry);
					} else if((Object(parent)).PlayerData_mc.PerkPointsAvilable > 0) {
						OnIneligibleToPurchase(param1.target.selectedEntry);
					}
					break;
				case "ActionButtons_mc" :
					if (ConfirmWindow_mc.ConfirmMode == ConfirmWindow.MODE_LEARN_PERK){
						OnLearnPerkConfirm();
					} else if(ConfirmWindow_mc.ConfirmMode == ConfirmWindow.MODE_CANT_LEARN){
						onAcceptCancelCannotLearn();
					} else if(ConfirmWindow_mc.ConfirmMode == ConfirmWindow.MODE_LEARN_LEVEL){
						OnLevelConfirm();
					}
					break;
			}	
		}
		
		private function OnLearnPerkPressed(param1:Object) : *
		{

			ConfirmWindow_mc.ConfirmMode = ConfirmWindow.MODE_LEARN_PERK;
			var ConfirmWindowArray:Array = new Array();
			ConfirmWindowArray.push({"text":"$YES"});
			ConfirmWindowArray.push({"text":"$NO"});
			ConfirmWindow_mc.ActionButtons_mc.entryList = ConfirmWindowArray;
			ConfirmWindow_mc.ActionButtons_mc.InvalidateData();
			ConfirmWindow_mc.ActionButtons_mc.selectedIndex = 0
			ConfirmWindow_mc.Open(stage.focus, "$FVSE_LEARN_PERK_WIN", param1);
			stage.focus = ConfirmWindow_mc.ActionButtons_mc;
			EnableDisablePerkListEntry(false);
			(Object(parent)).SetContextMenu();
		}
		
		private function OnIneligibleToPurchase(param1:Object):*
		{
			ConfirmWindow_mc.ConfirmMode = ConfirmWindow.MODE_CANT_LEARN;
			var ConfirmWindowArray:Array = new Array();
			ConfirmWindowArray.push({"text":"$OK"});
			ConfirmWindow_mc.ActionButtons_mc.entryList = ConfirmWindowArray;
			ConfirmWindow_mc.ActionButtons_mc.InvalidateData();
			ConfirmWindow_mc.ActionButtons_mc.selectedIndex = 0
			var _loc1_:String = "$FVSE_Cannot_learn " + param1.text + ".";
			if((Object(parent)).PlayerData_mc.PerkPointsAvilable == 0){
				_loc1_ = "$FVSE_Lack_Perk_Points";
			}
			ConfirmWindow_mc.Open(stage.focus, _loc1_);
			stage.focus = ConfirmWindow_mc.ActionButtons_mc;
			EnableDisablePerkListEntry(false);
			//PerkList_mc.disableInput = true;
			//PerkList_mc.disableSelection = true;
			(Object(parent)).SetContextMenu();
		}
		
		private function OnPerkListItemPress(param1:Event){
			OnLearnPerkPressed(PerkList_mc.entryList[PerkList_mc.selectedIndex]);
		}
		
		private function OnLevelConfirm() : void 
		{
			stage.focus = ConfirmWindow_mc.prevFocus;
			var learn:Boolean = ConfirmWindow_mc.ActionButtons_mc.selectedIndex == 0;
			ConfirmWindow_mc.Close();
			(Object(parent)).PlayerData_mc.EnableDisableLevelButtonListEntry(true)
			EnableDisablePerkListEntry(true);
			if(learn){
				(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuOK");
				(Object(parent)).PlayerData_mc.ConfirmLevelPurchase();
			} else {
				(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuCancel");
			}
			(Object(parent)).SetContextMenu();
		}
		
		public function EnableDisablePerkListEntry(value:Boolean):void {
			if(value){
				PerkList_mc.selectedEntry.disabled = _savedEntryDisable;
				PerkList_mc.UpdateList();
				PerkList_mc.disableInput = false;
				PerkList_mc.disableSelection = false;
			} else {
				_savedEntryDisable = PerkList_mc.selectedEntry.disabled;
				PerkList_mc.selectedEntry.disabled = true;
				PerkList_mc.UpdateList();
				PerkList_mc.disableInput = true;
				PerkList_mc.disableSelection = true;
			}
		}

		public function OnLearnPerkConfirm() : void
		{
			var formID:uint = uint(ConfirmWindow_mc.MessageTarget.formID);
			stage.focus = ConfirmWindow_mc.prevFocus;
			var learn:Boolean = ConfirmWindow_mc.ActionButtons_mc.selectedIndex == 0;
			ConfirmWindow_mc.Close();
			EnableDisablePerkListEntry(true);
			if(learn)
			{
				(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuOK");
				try
				{
					(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.AddPerk(formID);
				}
				catch(e:Error)
				{
					trace("[FVSE:Perks] Failed to call root.f4se.plugins.FVSE.AddPerk() " + e);
				}
			}
			else
			{
				(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuCancel");
				
			}
		}
	  
		public function onAcceptCancelCannotLearn():*{
			stage.focus = ConfirmWindow_mc.prevFocus;
			ConfirmWindow_mc.Close();
			EnableDisablePerkListEntry(true);
			(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuOK");
			//PerkList_mc.disableInput = false;
			//PerkList_mc.disableSelection = false;
		}

		public function SetFilterType(filterType:int):void{
			
		}

		/*
		private function SetListFocus(param1:Boolean) : *{
			var _loc2_:Array = null;
			if(param1)
			{
				ConfirmWindow_mc.visible = false;
				//PerkList_mc.disableInput = false;
				EnableDisablePerkListEntry(true);
				stage.focus = PerkList_mc;
			}
			else
			{
				this.ConfirmWindow_mc.visible = true;
				EnableDisablePerkListEntry(false);
				//this.PerkList_mc.disableInput = true;
				stage.focus = null;
			}
		}*/
		
		private function nextPrevPerk_Helper() : *
		{
			_DescText = PerkList_mc.selectedEntry.descriptions[PerkList_mc.selectedEntry.rank + _ViewingRankOffset - 1];
			_CurrSelectedRank = PerkList_mc.selectedEntry.rank + _ViewingRankOffset;
			_VoreValInt = PerkList_mc.selectedEntry.voreReqValues[PerkList_mc.selectedEntry.rank + _ViewingRankOffset - 1];
			var _loc2_:int = PerkList_mc.selectedEntry.voreType;
			if(_VoreValInt == 1){
					_VoreTypeText = "";
			}
			else if(_loc2_ == PREDTYPE_ID){
				_VoreLevelEnough = (Object(parent)).PlayerData_mc.PredLevel >= _VoreValInt;
				_VoreTypeText = "$Pred_Level";
			} else if(_loc2_ == PREYTYPE_ID){
				_VoreLevelEnough = (Object(parent)).PlayerData_mc.PreyLevel >= _VoreValInt;
				_VoreTypeText = "$Prey_Level";
				}
			(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound("UIMenuPrevNext");
		}
	  
		override public function redrawUIComponent() : void{
			var _loc1_:URLRequest = null;
			var _loc2_:LoaderContext = null;			
			var _loc3_:uint = 0;
			var _loc4_:MovieClip = null;
			
			super.redrawUIComponent();
			
			if(!_ViewingRanks)
			{
				//if(_VBFileName != "")
				if(_VBClipID != 0)
				{
					_loc1_ = new URLRequest(this._VBFileName);
					_loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain);
					_VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
					_VBLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onVBLoadFail);
					_VBLoader.load(_loc1_,_loc2_);
					if(_VBClipID == 0){// && _VBFileName == "Components/VaultBoys/Perks/PerkClip_defaultvore.swf"){
						//(stage.getChildAt(0) as MovieClip).f4se.plugins.FVSE.PlayUISound(DEFAULT_VORE_UI_SOUND);
					} else if (_VBClipID != 0){
						//BGSExternalInterface.call(this.codeObj,"PlayPerkSound",this._VBClipID);
					}
				}
				else
				{
					if(VBHolder_mc.numChildren > 0)
					{
						VBHolder_mc.removeChildAt(0);
					}
					//BGSExternalInterface.call(codeObj,"StopPerkSound");
				}
			}
			
			GlobalFunc.SetText(Description_tf, _DescText, false);
			GlobalFunc.SetText(SPECIALType_tf, _SPECIALNameText, false);
			GlobalFunc.SetText(SPECIALValue_tf, String(_SPECIALValInt), false);
			GlobalFunc.SetText(VoreType_tf, _VoreTypeText, false);
			if(_VoreValInt > 1){
				GlobalFunc.SetText(VoreReq_tf, String(_VoreValInt), false);
			}
			else{
				GlobalFunc.SetText(VoreReq_tf, "", false);
			}
			SPECIALType_tf.textColor = _CurrSpecialEnough?uint(16777215‬):uint(10066329);
			SPECIALValue_tf.textColor = _CurrSpecialEnough?uint(16777215‬):uint(10066329);
			
			VoreType_tf.textColor = _VoreLevelEnough?uint(16777215‬):uint(10066329);
			VoreReq_tf.textColor = _VoreLevelEnough?uint(16777215‬):uint(10066329);
			
			//update rank view
			while(StarHolder_mc.numChildren > 0)
			{
				StarHolder_mc.removeChildAt(0);
			}
			if(this._MaxSelectedRank >= 1)
			{
				_loc3_ = 0;
				while(_loc3_ < this._MaxSelectedRank)
				{
					_loc4_ = new PerkRankStar();
					this.StarHolder_mc.addChild(_loc4_);
					_loc4_.x = 37.5 * _loc3_;
					if(_loc3_ < _CurrSelectedRank)
					{
						_loc4_.gotoAndStop("Full");
					}
					_loc3_++;
				}
				StarHolder_mc.x = ORIG_STAR_X - StarHolder_mc.width / 2;
			}
			(Object(parent)).SetContextMenu();
		}
		
		private function onVBLoadComplete(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,onVBLoadComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onVBLoadFail);
			if(VBHolder_mc.numChildren > 0)
			{
				param1.target.content.removeEventListener(Event.ENTER_FRAME,onPerkSelectionAnimUpdate);
				VBHolder_mc.removeChildAt(0);
			}
			VBHolder_mc.addChild(param1.target.content);
			param1.target.content.addEventListener(Event.ENTER_FRAME,onPerkSelectionAnimUpdate);
		}
      
		private function onVBLoadFail(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,onVBLoadComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onVBLoadFail);
			if(VBHolder_mc.numChildren > 0)
			{
				VBHolder_mc.removeChildAt(0);
			}
		}
		
		protected function onPerkSelectionAnimUpdate(param1:Event) : *
		{
			if(param1.target.currentFrame == 1 && _VBClipID != 0)
			{
				//BGSExternalInterface.call(codeObj,"PlayPerkSound", _VBClipID);
			}
		}
		
		function _setProp_Perk_List_mc() : *{
			try
			{
				this.PerkList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			PerkList_mc.listEntryClass = "Carreau.components.Perk_ListEntry";
			PerkList_mc.numListItems = 16;
			PerkList_mc.restoreListIndex = false;
			PerkList_mc.textOption = "None";
			PerkList_mc.verticalSpacing = 0;
			try
			{
				this.PerkList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function _setProp_ConfirmWindow_mc_() : *{
			try
			{
				ConfirmWindow_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			ConfirmWindow_mc.bracketCornerLength = 6;
			ConfirmWindow_mc.bracketLineWidth = 1.5;
			ConfirmWindow_mc.bracketPaddingX = 0;
			ConfirmWindow_mc.bracketPaddingY = 0;
			ConfirmWindow_mc.BracketStyle = "vertical";
			ConfirmWindow_mc.bShowBrackets = true;
			ConfirmWindow_mc.bUseShadedBackground = true;
			ConfirmWindow_mc.ShadedBackgroundMethod = "Flash";
			ConfirmWindow_mc.ShadedBackgroundType = "normal";
			try
			{
				ConfirmWindow_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
	
}
