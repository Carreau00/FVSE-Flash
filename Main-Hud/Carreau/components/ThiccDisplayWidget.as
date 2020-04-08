package Carreau.components {
	
	import flash.display.MovieClip;
	import Shared.AS3.BSUIComponent;
	import flash.text.TextField;
	import Carreau.components.*;
	import Shared.DebugFunc;
	
	public class ThiccDisplayWidget extends BSUIComponent {
		public var DisplayName_tf:TextField;
		public var SatedBar_mc:ThiccMeterBar;
		public var ThiccBar_mc:ThiccMeterBar;
		public var hungerLoss:Number;
		public var hunger_1_mc:HungerArrow;
		public var hunger_2_mc:HungerArrow;
		public var hunger_3_mc:HungerArrow;
		public var hunger_4_mc:HungerArrow;
		public var hunger_5_mc:HungerArrow;
		public var hunger_6_mc:HungerArrow;
		public var hunger_7_mc:HungerArrow;
		
		private var _data:ActorData;
		private var _fader:ThiccStatusFader;
		private var hungerArrow:Vector.<HungerArrow> = new Vector.<HungerArrow>;
		
		public function ThiccDisplayWidget() {
			// constructor code
			hungerArrow.push(hunger_1_mc);
			hungerArrow.push(hunger_2_mc);
			hungerArrow.push(hunger_3_mc);
			hungerArrow.push(hunger_4_mc);
			hungerArrow.push(hunger_5_mc);
			hungerArrow.push(hunger_6_mc);
			hungerArrow.push(hunger_7_mc);
			hungerLoss = 0;
			setProperties();
			populateFields();
			setHungerArrows();
		}
		public function get data():ActorData {
			return _data;
		}
		public function set data(val:ActorData):void {
			_data = val;
			populateFields();
		}
		public function get fader():ThiccStatusFader {
			return _fader;
		}
		public function set fader(val:ThiccStatusFader):void {
			_fader = val;
		}
		
		private function setProperties():void {
			this.SatedBar_mc.barAlpha = 1;
            this.SatedBar_mc.bracketCornerLength = 6;
            this.SatedBar_mc.bracketLineWidth = 1.5;
            this.SatedBar_mc.bracketPaddingX = 0;
            this.SatedBar_mc.bracketPaddingY = 0;
            this.SatedBar_mc.BracketStyle = "horizontal";
            this.SatedBar_mc.bShowBrackets = false;
            this.SatedBar_mc.bUseShadedBackground = false;
            this.SatedBar_mc.Justification = "left";
            this.SatedBar_mc.MeterPercent = 0;
			this.SatedBar_mc.TargetPercent = 0;
			this.SatedBar_mc.OverflowPercent = 0;
			this.SatedBar_mc.SetScaleX(0);
            this.SatedBar_mc.ShadedBackgroundMethod = "Shader";
            this.SatedBar_mc.ShadedBackgroundType = "normal";
			
			this.ThiccBar_mc.barAlpha = 1;
			this.ThiccBar_mc.bracketCornerLength = 6;
            this.ThiccBar_mc.bracketLineWidth = 1.5;
            this.ThiccBar_mc.bracketPaddingX = 0;
            this.ThiccBar_mc.bracketPaddingY = 0;
            this.ThiccBar_mc.BracketStyle = "horizontal";
            this.ThiccBar_mc.bShowBrackets = false;
            this.ThiccBar_mc.bUseShadedBackground = false;
            this.ThiccBar_mc.Justification = "left";
            this.ThiccBar_mc.MeterPercent = 0;
			this.ThiccBar_mc.TargetPercent = 0;
			this.ThiccBar_mc.OverflowPercent = 0;
			this.ThiccBar_mc.SetScaleX(0);
            this.ThiccBar_mc.ShadedBackgroundMethod = "Shader";
            this.ThiccBar_mc.ShadedBackgroundType = "normal";
		}
		
		private function populateFields():void {
			if (_data) {
				this.DisplayName_tf.text = _data.name;
			}
		}
		
		private function setHungerArrows():void{
			if(_data){
				var UpdateHungerArrow:Boolean = false
				if (this.hungerLoss != _data.hunger || this.hungerLoss == 0){
					UpdateHungerArrow = true;
				}
				if (UpdateHungerArrow){
					this.hungerLoss = _data.hunger;
					for (var i:int = 0; i < hungerArrow.length; i++){
						var ArrowToCheck:HungerArrow = hungerArrow[i];
						
						if (i < this.hungerLoss){
							
							ArrowToCheck.ResetArrowState();
							ArrowToCheck.ArrowFadeIn();
						} else if (!ArrowToCheck.FullyFadedOut && !ArrowToCheck.FadeOutStarted){
							
							ArrowToCheck.ResetArrowState();
							ArrowToCheck.ArrowFadeOut();
						}
					}
			
				}
			}
		}
		
		override public function redrawUIComponent():void {
			if (_data){
				DebugFunc.debugTrace("this.DisplayName_tf.text: " + String(this.DisplayName_tf.text) + " _data.name: " + String(_data.name) + " _data.sated: " + String(_data.sated) + " _data.thiccness: " +String(_data.thiccness));
				this.DisplayName_tf.text = _data.name;
				this.SatedBar_mc.TargetPercent = _data.sated;
				this.ThiccBar_mc.TargetPercent = _data.thiccness;
				setHungerArrows();
			}
		}
	}
	
}
