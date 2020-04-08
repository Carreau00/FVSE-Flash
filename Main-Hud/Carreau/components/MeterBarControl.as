package  Carreau.components{
	
	import Shared.AS3.BSUIComponent;
    import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MeterBarControl extends BSUIComponent{
		
		private var _StartingPosX:Number;
		private var _StartingSizeX:Number;
		private var _MeterPercent:Number;
		private var _TargetPercent:Number;
		private var _OverflowPercent:Number;
		private var _justification:String;
		private var _barAlpha:Number;
		private var _MeterFilled:Boolean;
		
		
		public function MeterBarControl() {
			// constructor code
		}
		
		public function SetScaleX(percent:Number){
			if (scaleX != percent){
				scaleX = percent;
			}
		}
		
		public function get Justification():String
        {
            return (this._justification);
        }

        public function set Justification(_arg1:String)
        {
            if (this._justification != _arg1)
            {
                this._justification = _arg1;
                SetIsDirty();
            };
        }
		
		public function get MeterPercent() {
			return (this._MeterPercent);
		}
		
		public function set MeterPercent(newPercent:Number) {
			if (this._MeterPercent != newPercent)
			{
                this._MeterPercent = newPercent;
                SetIsDirty();
            };
		}
		
		public function get MeterFilled():Boolean{
			return (this._MeterFilled);
		}
		
		public function set MeterFilled(state:Boolean):void{
			if (_MeterFilled != state){
				_MeterFilled = state;
			}
		}
		
		public function get TargetPercent() {
			return (this._TargetPercent);
		}
		
		public function set TargetPercent(newPercent:Number) {
			if (this._TargetPercent != newPercent)
			{
                this._TargetPercent = newPercent;

            };
		}

		public function get OverflowPercent() {
			return (this._OverflowPercent);
		}
		
		public function set OverflowPercent(newPercent:Number) {
			if (this._OverflowPercent != newPercent)
			{
                this._OverflowPercent = newPercent;

            };
		}
		
		public function get barAlpha() {
			return (this._barAlpha);
		}
		
		public function set barAlpha(newAlpha:Number) {
			if (this._barAlpha != newAlpha)
			{
                this._barAlpha = newAlpha;
                SetIsDirty();
            };
		}
		
		override public function onAddedToStage():void
        {
            super.onAddedToStage();
            this._StartingPosX = x;
            this._StartingSizeX = width;
            this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
		
		//can delete override
		override public function redrawUIComponent():void
        {
            super.redrawUIComponent();
			
			//used to change the meter's from left to right.  May not need
			
            if (this.Justification == "right")
            {
                x = ((this._StartingPosX + this._StartingSizeX) - width);
            };
        }
		
		private function enterFrameHandler(e:Event):void {
			var FillPercent:Number

			if (this.TargetPercent > this.MeterPercent){
				//trace("this.TargetPercent", this.TargetPercent, "this.MeterPercent", this.MeterPercent, "scaleX", scaleX);
				_MeterFilled = false;
				this.MeterPercent += 0.01;
				FillPercent = this.MeterPercent;
			}
			else{
				this.MeterPercent = this.TargetPercent;
				FillPercent = this.TargetPercent;
			}
			var deltaX:Number = FillPercent - scaleX;
			//trace("this", this, "FillPercent ", FillPercent, "MeterPercent ", this.MeterPercent, " TargetPercent ", this.TargetPercent, " deltaX ", deltaX);
			if (Math.abs(deltaX) < 0.01) {
				//trace("Math.abs(deltaX) < 0.01 scaleX", scaleX, " FillPercent ", FillPercent);
				scaleX = FillPercent;
			} else if (deltaX > 0) {
				//trace("deltaX > 0");
				scaleX += 0.01;
			} else {
				//trace("else deltaX ", deltaX, " FillPercent ", FillPercent);
				scaleX = FillPercent;

			}			
			if (this.MeterPercent == this.TargetPercent && !_MeterFilled){
				if (this.OverflowPercent > 0){
					this.TargetPercent = this.OverflowPercent;
					this.MeterPercent = 0;
					this.OverflowPercent = 0;
				}
				else{
					_MeterFilled = true;
				}
			}
		}

	}
	
}
