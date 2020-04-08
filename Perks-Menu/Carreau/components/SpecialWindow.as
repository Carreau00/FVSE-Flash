package Carreau.components {
	
	import Shared.AS3.BSUIComponent;
	import flash.text.TextField;
	
	
	public class SpecialWindow extends BSUIComponent {
		
		public var StrengthValue_tf:TextField;
		public var PerceptionValue_tf:TextField;
		public var EnduranceValue_tf:TextField;
		public var CharismaValue_tf:TextField;
		public var IntelligenceValue_tf:TextField;
		public var AgilityValue_tf:TextField;
		public var LuckValue_tf:TextField;
		
		private var _strengthValue:int;
		private var _perceptionValue:int;
		private var _enduranceValue:int;
		private var _charismaValue:int;
		private var _intelligenceValue:int;
		private var _agilityValue:int;
		private var _luckValue:int;
		
		public function SpecialWindow() {
			// constructor code
		}
		
		public function SetSpecialValues(param1:Array): Array {
			param1 = param1.reverse();
			
			StrengthValue = param1.pop();
			PerceptionValue = param1.pop();
			EnduranceValue = param1.pop();
			CharismaValue = param1.pop();
			IntelligenceValue = param1.pop();
			AgilityValue = param1.pop();
			LuckValue = param1.pop();
			
			
			return param1.reverse();
		}
		
		public function get StrengthValue() : int {
			return _strengthValue;
		}
		
		public function set StrengthValue(value:int) : void {
			if(_strengthValue != value){
				_strengthValue = value;
				StrengthValue_tf.text = String(_strengthValue);
			}
		}
		
		public function get PerceptionValue() : int {
			return _perceptionValue;
		}
		
		public function set PerceptionValue(value:int) : void {
			if(_perceptionValue != value){
				_perceptionValue = value;
				PerceptionValue_tf.text = String(_perceptionValue);
			}
		}
		
		public function get EnduranceValue() : int {
			return _enduranceValue;
		}
		
		public function set EnduranceValue(value:int) : void {
			if(_enduranceValue != value){
				_enduranceValue = value;
				EnduranceValue_tf.text = String(_enduranceValue);
			}
		}
		
		public function get CharismaValue() : int {
			return _charismaValue;
		}
		
		public function set CharismaValue(value:int) : void {
			if(_charismaValue != value){
				_charismaValue = value;
				CharismaValue_tf.text = String(_charismaValue);
			}
		}
		
		public function get IntelligenceValue() : int {
			return _intelligenceValue;
		}
		
		public function set IntelligenceValue(value:int) : void {
			if(_intelligenceValue != value){
				_intelligenceValue = value;
				IntelligenceValue_tf.text = String(_intelligenceValue);
			}
		}
		
		public function get AgilityValue() : int {
			return _agilityValue;
		}
		
		public function set AgilityValue(value:int) : void {
			if(_agilityValue != value){
				_agilityValue = value;
				AgilityValue_tf.text = String(_agilityValue);
			}
		}
		
		public function get LuckValue() : int {
			return _strengthValue;
		}
		
		public function set LuckValue(value:int) : void {
			if(_luckValue != value){
				_luckValue = value;
				LuckValue_tf.text = String(_luckValue);
			}
		}
	}
	
}
