package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import Shared.GlobalFunc;
	import Carreau.components.WeightNotification;
	import Shared.AS3.BSScrollingListEntry;
	
	public class WeightContainer extends ContainerList {
	
		public var WeightNotification_mc:WeightNotification;
		public var RootMenu:Object;
		public var CurrWeight:uint;
		public var MaxWeight:uint;
		
		public function WeightContainer() {
			// constructor code
			CurrWeight = 0;
			MaxWeight = 75;
			WeightNotification_mc = new WeightNotification();
			addEventListener(Event.ADDED_TO_STAGE, ModifyContainerList);
		}
		
		public function ModifyContainerList(): void{
			//trace("ModifyContainerList() called");
			/*var children:Array = [];
			trace("numChildren: " + stage.numChildren + " RootMenu: " + RootMenu);
			for (var j:uint = 0; j <stage.numChildren; j++){
				children.push(stage.getChildAt(j));
				trace("child " + j + " object: " + stage.getChildAt(j));
			}*/
			if(!RootMenu){
				var rootTemp:* = stage.getChildAt(0)["FilterHolder_mc"];
				RootMenu = rootTemp["Menu_mc"];
			}
			//trace("ModifyContainerList() get ContainerList_mc");
			var _loc1_:ContainerList = RootMenu["ContainerList_mc"];
			//trace("ModifyContainerList() get ContainerInventory_mc");
			var _loc2_:MovieClip = RootMenu["ContainerInventory_mc"];
			//trace("ModifyContainerList() get PlayerInventory_mc");
			var _loc3_:MovieClip = RootMenu["PlayerInventory_mc"];
			//trace("ModifyContainerList() get PlayerList_mc");
			var _loc4_:PlayerList = _loc3_["PlayerList_mc"];
			//var _loc5_:Array = _loc1_.entryList;
			/*trace("ModifyContainerList() checking ContainerList_mc greater than numListItems");
			if (_loc1_.entryList.length >= _loc1_.numListItems){
				trace("ContainerList_mc.entryList greater than or equal to numListItems");
				trace("ContainerList_mc.EntryHolder_mc.numchildren: " + _loc1_.EntryHolder_mc.numChildren);
				for(var i:int = 0; i < _loc1_.EntryHolder_mc.numChildren; i++){
					trace("EntryHolder_mc child " + i + " " + _loc1_.EntryHolder_mc.getChildAt(i));
				}
			}*/
			_loc1_.EntryHolder_mc.removeChildAt(_loc1_.EntryHolder_mc.numChildren-1);
			trace("ModifyContainerList() set numListItems old: " + _loc1_.numListItems + " new: " + _loc4_.numListItems);
			_loc1_.numListItems = _loc4_.numListItems;
			_loc1_.ScrollDown.y = _loc1_.ScrollDown.y - 27.5;	//27.5 is change in overall y from playerlist.scrolldown and containerlist.scrolldown
			/*if(_loc3_["p1"]){
				//DEF_Inv edits conatinermenu pretty extensively.  Need special handler for positioning
				trace("DEF_Inv detected.");
				RootMenu.addChild(WeightNotification_mc);
				WeightNotification_mc.x = _loc2_.x + 6.2;
				WeightNotification_mc.y = _loc3_["p1"].y;
			} else {*/
				//trace("Vanilla position");
				_loc2_.addChild(WeightNotification_mc);
				WeightNotification_mc.x = 6.2;
				//WeightNotification_mc.y = _loc2_.height - WeightNotification_mc.height - 10.5; //place it with a small buffer from the bottom of the window;
			//}
			WeightNotification_mc.y = _loc2_["ContainerBracketBackground_mc"].y + _loc2_["ContainerBracketBackground_mc"].height - WeightNotification_mc.height - 10.5;
			_loc1_.InvalidateData();
		}
		
		public function UpdateEncumbrance_int(aCurrWeight:uint, aMaxWeight:uint): void {
			CurrWeight = aCurrWeight;
			MaxWeight = aMaxWeight;
			if(WeightNotification_mc.BellyWeight_tf != null){
				GlobalFunc.SetText(WeightNotification_mc.BellyWeight_tf, CurrWeight.toString() + "/" + MaxWeight.toString(), false);
            }
		}
	}
}