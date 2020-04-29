package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSUIComponent;
	import Shared.DebugFunc
	import Shared.GlobalFunc;
	import flash.text.TextField;
	
	public class HPDisplayWidget extends BSUIComponent {
		
		public var DisplayName_tf:TextField;
		public var HPMeterBar_mc:HPMeterBar;
		
		
		private var _preyName:String;
		private var _healthPercent:Number;
		
		private static var SCALEX_MODIFIER:Number = 0.5;
		
		public function HPDisplayWidget() {
			// constructor code
			
			setProperties();
		}
		
		public function set PreyName(val:String):void {
			_preyName = val;
			GlobalFunc.SetText(DisplayName_tf, _preyName, false, true);
		}
		
		public function set HealthPercent(val:Number):void {
			_healthPercent = val;
			if(_healthPercent > 0){
				this.HPMeterBar_mc.TargetPercent = _healthPercent*SCALEX_MODIFIER;
			} else {
				this.HPMeterBar_mc.TargetPercent = 0;
			}
			SetIsDirty();
		}
		
		private function setProperties():void {
			this.HPMeterBar_mc.SetScaleX(SCALEX_MODIFIER);
			this.HPMeterBar_mc.BarAlpha = 1;
            this.HPMeterBar_mc.bracketCornerLength = 6;
            this.HPMeterBar_mc.bracketLineWidth = 1.5;
            this.HPMeterBar_mc.bracketPaddingX = 0;
            this.HPMeterBar_mc.bracketPaddingY = 0;
            this.HPMeterBar_mc.BracketStyle = "horizontal";
            this.HPMeterBar_mc.bShowBrackets = false;
            this.HPMeterBar_mc.bUseShadedBackground = false;
            this.HPMeterBar_mc.Justification = "left";
			this.HPMeterBar_mc.MeterPercent = SCALEX_MODIFIER;
			//this.HPMeterBar_mc.TargetPercent = 1;
            this.HPMeterBar_mc.ShadedBackgroundMethod = "Shader";
            this.HPMeterBar_mc.ShadedBackgroundType = "normal";
			this.HPMeterBar_mc.MeterFilled = false;
		}
		
		
	}
	
}
