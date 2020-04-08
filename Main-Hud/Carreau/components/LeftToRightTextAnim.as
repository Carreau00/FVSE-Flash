package  Carreau.components{
	
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.events.Event;
   
   public dynamic class LeftToRightTextAnim extends BSUIComponent
   {
       
      
		var DisplayText:String;
		public var LevelUpText_tf:TextField;
		public var BlinkingCursor_mc:MovieClip;
		private var _LevelUpPlayed:Boolean = false;
	   
		public function LeftToRightTextAnim()
		{
			LevelUpText_tf.text = "";
			_LevelUpPlayed = false;
		}
      
		public function AnimateText(param1:String) : void
		{
			this._LevelUpPlayed = false;
			this.DisplayText = param1;
			this.LevelUpText_tf.text = "";
			var _loc2_:Timer = new Timer(60,this.DisplayText.length);
			_loc2_.addEventListener(TimerEvent.TIMER,this.AddLetterHandler);
			_loc2_.start();
			this.BlinkingCursor_mc.gotoAndPlay("Pulse");
		}
	  
		private function AddLetterHandler(e:Event):void{
			AddLetter();
		}
	  
		public function AddLetter() : void
		{
			var _loc2_:Timer = null;
			//trace("AddLetter() LevelUpText_tf", LevelUpText_tf.text, "DisplayText", DisplayText.substr(0, this.LevelUpText_tf.text.length + 1));
			this.LevelUpText_tf.text = this.DisplayText.substr(0, this.LevelUpText_tf.text.length + 1);
			var _loc1_:TextLineMetrics = this.LevelUpText_tf.getLineMetrics(0);
			//trace("this.LevelUpText_tf.x", this.LevelUpText_tf.x, "_loc1_.width", _loc1_.width);
			this.BlinkingCursor_mc.x = this.LevelUpText_tf.x + _loc1_.width + 5;
			if(this.LevelUpText_tf.text.length == this.DisplayText.length)
			{
				_loc2_ = new Timer(4000,1);
				_loc2_.addEventListener(TimerEvent.TIMER, this.StartAnimOutHandler);
				_loc2_.start();
			}
		}
      
		private function StartAnimOutHandler(e:Event):void{
			StartAnimOut();
		}
	  
		public function StartAnimOut() : void
		{
			var _loc1_:Timer = new Timer(60,this.DisplayText.length);
			_loc1_.addEventListener(TimerEvent.TIMER,this.RemoveLetterHandler);
			_loc1_.start();
		}
      
		private function RemoveLetterHandler(e:Event):void{
			RemoveLetter();
		}
	  
		public function RemoveLetter() : void
		{
			var _loc1_:* = this.LevelUpText_tf.text.length - 1 == 0;
			this.LevelUpText_tf.text = this.DisplayText.substr(0, this.LevelUpText_tf.text.length - 1);
			var _loc2_:TextLineMetrics = this.LevelUpText_tf.getLineMetrics(0);
			this.BlinkingCursor_mc.x = this.LevelUpText_tf.x + _loc2_.width + 5;
			if(_loc1_)
			{
				this._LevelUpPlayed = true; 
				this.BlinkingCursor_mc.gotoAndStop("Hidden");
			}
		}
		
		public function get LevelUpPlayed():Boolean{
			return _LevelUpPlayed;
		}
		
		public function set LevelUpPlayed(state:Boolean):void{
			if(_LevelUpPlayed != state){
				_LevelUpPlayed = state;
			}
		}
	}
}
