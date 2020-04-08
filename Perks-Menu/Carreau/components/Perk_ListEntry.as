package Carreau.components {
	
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import scaleform.gfx.Extensions;
	
	public class Perk_ListEntry extends BSScrollingListEntry {
		
		
		public function Perk_ListEntry() {
			// constructor code
			super();
			Extensions.enabled = true;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			
			var _loc3_:* = border.alpha;
			if (param1.rank > 1){
				GlobalFunc.SetText(this.textField, param1.text + " " + param1.rank, true);
			}
			if((param1.filterFlag & (2 << 4)) != 0 || param1.disabled)	//Main menu shows this as param1.disabled
			{
				border.alpha = !!this.selected?Number(0.35):Number(0);	//!! ensures boolean logic.  If selected == true, then set alpha to .35, else set to 0
				textField.textColor = !!this.selected?uint(2236962):uint(4473924); //2236962 = 0x222222 and 4473924 = 0x444444
			}
			else
			{
				border.alpha = !!this.selected?Number(_loc3_):Number(0);
				textField.textColor = !!this.selected?uint(0):uint(16777215); //16777215 == 0xFFFFFF
			}
         
		}
	}
	
}
