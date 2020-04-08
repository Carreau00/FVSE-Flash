package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSUIComponent;
	import flash.text.TextField;
	import Shared.DebugFunc;
	
	public class XPDisplayWidget extends BSUIComponent {
		
		public var LevelUpBar_mc:XPMeterBar;
		public var NumberText_tf:TextField;
		public var LevelUpText_mc:LeftToRightTextAnim;
		
		private var _oldPercent:Number;
		private var _newPercent:Number;
		
		private var _fader:XPWidgetFader;
		
		public function XPDisplayWidget() {
			// constructor code
			
			setProperties()
		}
		
		
		private function setProperties():void {
			this.LevelUpBar_mc.BarAlpha = 1;
            this.LevelUpBar_mc.bracketCornerLength = 6;
            this.LevelUpBar_mc.bracketLineWidth = 1.5;
            this.LevelUpBar_mc.bracketPaddingX = 0;
            this.LevelUpBar_mc.bracketPaddingY = 0;
            this.LevelUpBar_mc.BracketStyle = "horizontal";
            this.LevelUpBar_mc.bShowBrackets = false;
            this.LevelUpBar_mc.bUseShadedBackground = false;
            this.LevelUpBar_mc.Justification = "left";
            this.LevelUpBar_mc.MeterPercent = _oldPercent;
			this.LevelUpBar_mc.TargetPercent = _oldPercent;
            this.LevelUpBar_mc.ShadedBackgroundMethod = "Shader";
            this.LevelUpBar_mc.ShadedBackgroundType = "normal";
			this.LevelUpBar_mc.MeterFilled = false;
			
		}
		
		public function SetXP(){
			this.LevelUpBar_mc.MeterPercent = _oldPercent;
			this.LevelUpBar_mc.SetScaleX(_oldPercent);
			SetIsDirty();
		}

		public function AddXP(XPtoAdd:int){
			var XPString:String = "";
			DebugFunc.debugTrace("AddXP() XPtoAdd: " + XPtoAdd);
			//var NumberOfZeroes = 4-String(XPtoAdd).length;
			//if (NumberOfZeroes > 0){
				for(var i:int=0; i<4-String(XPtoAdd).length;i++){
					XPString += "0";
				}
			//}
			XPString += String(XPtoAdd);
			this.NumberText_tf.text = XPString; //String(XPtoAdd);
			if(_newPercent >= _oldPercent){
				this.LevelUpBar_mc.TargetPercent = _newPercent;
			}
			else if (_newPercent < _oldPercent){
				this.LevelUpBar_mc.TargetPercent = 1.0;
				this.LevelUpBar_mc.OverflowPercent = _newPercent;
			}
			SetIsDirty();
		}
		
		public function LevelUp(){
			DebugFunc.debugTrace("Player Leveled Up");
			this.LevelUpText_mc.AnimateText("LEVEL UP!");
		}
		
		//public functions for nested variables
		public function GetMeterFilled():Boolean{
			return LevelUpBar_mc.MeterFilled;
		}
		
		public function SetMeterFilled(state:Boolean):void{
			if (LevelUpBar_mc.MeterFilled != state){
				LevelUpBar_mc.MeterFilled = state;
			}
		}
		
		public function GetLevelUpPlayed():Boolean{
			return LevelUpText_mc.LevelUpPlayed;
		}
		//public functions for private variables
		
		public function get fader():XPWidgetFader {
			return _fader;
		}
		public function set fader(val:XPWidgetFader):void {
			_fader = val;
		}
		
		public function get oldPercent():Number {
			return _oldPercent;
		}
		public function set oldPercent(val:Number):void {
			_oldPercent = val;
		}
		
		public function get newPercent():Number {
			return _newPercent;
		}
		public function set newPercent(val:Number):void {
			_newPercent = val;
		}
		
		override public function redrawUIComponent():void {
			//trace("RedrawUI ", this.MeterBar_mc.MeterPercent, _oldPercent, _newPercent);
			
		}
	}
	
}
