package Shared.AS3{
	
	import Shared.AS3.BSScrollingList;
	import flash.utils.getDefinitionByName;
	
	public class BSScrollingListEx extends BSScrollingList{
		
		public static const SELECTION_CHANGE:String = "BSScrollingList::selectionChange";
		
		public function BSScrollingListEx(){
			//constructor code
		}
		
		override public function set listEntryClass(param1:String) : *
		{
			trace("[FVSE] Voretab listEntryClass setter: " + param1);
			this.ListEntryClass = getDefinitionByName(param1) as Class;
			//this._itemRendererClassName = param1;	//only used for mobile
		}
		
		override protected function doSetSelectedIndex(param1:int) : *
		{
			
			if(!this.bInitialized || this.numListItems == 0)
			{
				//trace("BSScrollingList::doSetSelectedIndex -- Can\'t set selection before list has been created. bInitialized: " + this.bInitialized + " numListItems: " + this.numListItems);
			}
			super.doSetSelectedIndex(param1);
		}
		
		override public function UpdateList() : *
		{
			
			if(!this.bInitialized || this.numListItems == 0)
			{
				//trace("BSScrollingList::UpdateList -- Can\'t update list before list has been created. bInitialized: " + this.bInitialized + " numListItems: " + this.numListItems);
			}
			super.UpdateList();
		}
		
		override protected function SetNumListItems(param1:uint) : * {
			//trace("BSScrollingList::SetNumListItems ListEntryClass: " + this.ListEntryClass + " param1: " + param1);
			super.SetNumListItems(param1);
		}
	}
}