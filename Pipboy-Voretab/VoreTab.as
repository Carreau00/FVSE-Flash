package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import Shared.AS3.BSScrollingListEx;
	import Shared.GlobalFunc;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class VoreTab extends PipboyTab {
		
		public var List_mc:BSScrollingListEx;
		public var Description_tf:TextField;
		public var Name_tf:TextField;
		public var PreyLevel_tf:TextField;
		public var PredLevel_tf:TextField;
		public var PreyLevelLabel_tf:TextField;
		public var PredLevelLabel_tf:TextField;
		public var CapacityLabel_tf:TextField;
		public var Capacity_tf:TextField;
		public var XPMeter_mc:XPMeter;
		public var CurrSelectedActor:int;
		
		private var _actorStatsArray:Array;
		private var _DescText:String;
		private var _name:String;
		private var _predLevel:int;
		private var _preyLevel:int;
		private var _playerPredLevel:int;
		private var _playerPerkPoints:int;
		private var _currentXP:Number;
		private var _reqXP:Number;
		private var _currentPreyCount:uint;
		private var _maxCapacity:Number;
		
		public function VoreTab() {
			// constructor code
			super();
			CurrSelectedActor = 0;
			_actorStatsArray = new Array();
			Extensions.enabled = true;
			this.TabIndex = uint.MAX_VALUE;
			_currentPreyCount = 0;
			List_mc.addEventListener(BSScrollingListEx.SELECTION_CHANGE, this.onListSelectionChange);
			TextFieldEx.setTextAutoSize(this.Description_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
			__setProp_List_mc_VORETab_List_0();
		}
		
		public function get actorStatsArray() :Array{
			return _actorStatsArray;
		}
		
		public function set actorStatsArray(value:Array):void{
			_actorStatsArray = value;
		}
		
		public function get PlayerPredLevel() :int{
			return _playerPredLevel;
		}
		
		public function set PlayerPredLevel(value:int):void{
			_playerPredLevel = value;
		}
		
		public function get PlayerPerkPoints() :int{
			return _playerPerkPoints;
		}
		
		public function set PlayerPerkPoints(value:int):void{
			_playerPerkPoints = value;
		}
		
		public function onPipboyChangeEvent_int(param1:PipboyChangeEvent) : void {
			var _loc3_:* = this.visible == true;
			List_mc.InvalidateData();
			if(_loc3_)
			{
				stage.focus = List_mc;
				if(List_mc.selectedIndex == -1)
				{
					List_mc.selectedClipIndex = 0;
				}
			}
			else
			{
				List_mc.selectedIndex = -1;
			}
			SetIsDirty();
		}
		
		public function UpdateStats(index:int){ //StatsArray:Array, PlayerDataArray:Array){
			
			var StatsArray:Array = actorStatsArray[index][0];
			var DataArray:Array = actorStatsArray[index][1];
			trace("[FVSE] VoreTab UpdateStats() index: " + index + " StatsArray.length: " + StatsArray.length + " DataArray.length: " + DataArray.length);
			PlayerPredLevel = actorStatsArray[0][1][9];
			PlayerPerkPoints = actorStatsArray[0][1][7];
			_preyLevel = DataArray[8];
			_predLevel = DataArray[9];
			_currentXP = DataArray[11]
			_reqXP = DataArray[12]
			_maxCapacity = DataArray[16];
			_currentPreyCount = DataArray[17];
			_name = DataArray[18];
			PartialInvalidate();
			
			List_mc.entryList = StatsArray;
			List_mc.InvalidateData();
		}
		
		public function PartialInvalidate(){
			GlobalFunc.SetText(Name_tf, String(_name), false);
			GlobalFunc.SetText(PreyLevel_tf, String(_preyLevel), false);
			XPMeter_mc.SetMeter(_currentXP, 0, _reqXP);
			if(_predLevel > 0){
				GlobalFunc.SetText(PredLevelLabel_tf, "$Pred_Level", false);
				GlobalFunc.SetText(CapacityLabel_tf, "$Capacity", false);
				GlobalFunc.SetText(PredLevel_tf, String(_predLevel), false);
				GlobalFunc.SetText(Capacity_tf, String(_currentPreyCount) + "/" + String(_maxCapacity), false);
			} else {
				GlobalFunc.SetText(PredLevelLabel_tf, "", false);
				GlobalFunc.SetText(PredLevel_tf, "", false);
				GlobalFunc.SetText(CapacityLabel_tf, "", false);
				GlobalFunc.SetText(Capacity_tf, "", false);
			}
		}
		
		override public function redrawUIComponent() : void {
			super.redrawUIComponent();
			GlobalFunc.SetText(Description_tf, _DescText, false);
		}

		public function onListSelectionChange() : * {
			if(List_mc.selectedIndex != -1)
			{
				_DescText = List_mc.selectedEntry.description;
			} else {
				_DescText = "";
			}
			SetIsDirty();
		}
		
		function __setProp_List_mc_VORETab_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "VOREListEntry";
			this.List_mc.numListItems = 10;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "Shrink To Fit";
			this.List_mc.verticalSpacing = 0;
			try
			{
				this.List_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
	
}
