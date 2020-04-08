package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import Shared.GlobalFunc;
	import Carreau.components.WeightNotification;
	
	public class ContainerBellyInject extends MovieClip {
		
		public var RootMenu:MovieClip;
		public var F4SECodeObj:Object;
		public var WeightIconContainer_mc:WeightContainer;
		
		public function ContainerBellyInject() {
			// constructor code
			F4SECodeObj = new Object();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage() : void {
			trace("OnAddedToStage belly container injection");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			var _loc1_:* = stage.getChildAt(0)["FilterHolder_mc"];
			RootMenu = _loc1_["Menu_mc"];
			/*
			var children:Array = [];
			trace("numChildren: " + stage.numChildren + " RootMenu: " + RootMenu);
			for (var i:uint = 0; i <stage.numChildren; i++){
				children.push(stage.getChildAt(i));
				trace("child " + i + " object: " + stage.getChildAt(i));
			}
			for(var id:String in stage.getChildAt(0)) {
				var value:Object = stage.getChildAt(0)[id];
				trace(id + " = " + value);
			}*/
			
			if(stage.getChildAt(0)["FVSECodeObj"]){
				F4SECodeObj = stage.getChildAt(0)["FVSECodeObj"];
			}
			WeightIconContainer_mc = new WeightContainer();
			RootMenu.addChild(WeightIconContainer_mc);
			try{
				F4SECodeObj.UpdateContainerValues();
			} catch(error:Error){
				trace("Error calling UpdateContainerValues" + error.name + " : " + error.message);
			}
		}
		
		public function UpdateEncumbrance(aCurrWeight:uint, aMaxWeight:uint): void {
			WeightIconContainer_mc.UpdateEncumbrance_int(aCurrWeight, aMaxWeight)
		}
	}
	
}
