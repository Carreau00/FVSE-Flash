package Carreau.components {
	
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.text.TextField;
	
	public class VORE_ListEntry extends BSScrollingListEntry {
		
		public var Value_tf:TextField;
		
		public function VORE_ListEntry() {
			// constructor code
		}
		
		override public function SetEntryText(param1:Object, param2:String) : * {
			super.SetEntryText(param1,param2);
			var _loc3_:* = "";
			
			_loc3_ = _loc3_ + param1.value.toString();
			GlobalFunc.SetText(Value_tf, _loc3_, false);
			Value_tf.textColor = !!this.selected?uint(0):uint(16777215);
		}
	}
	
}
