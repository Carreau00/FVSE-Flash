package  {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.text.TextField;
	
	public class WeightWidget extends BSUIComponent {
		
		public var InventoryLabel_tf:TextField;
		public var Weight_tf:TextField;
		
		private var _currentWeight:uint;
		private var _maxWeight:uint;
		
		public function WeightWidget() {
			// constructor code
		}
		
		public function set CurrentWeight(val:uint):void {
			_currentWeight = val;
		}
		
		public function set MaxWeight(val:uint):void {
			_maxWeight = val;
		}
		
		public function SetWidget():void {
			GlobalFunc.SetText(Weight_tf, String(_currentWeight) + "/" + String(_maxWeight), false);
		}
	}
	
}
