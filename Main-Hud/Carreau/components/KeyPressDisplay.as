package Carreau.components {
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import Shared.AS3.BSUIComponent;
	
	public class KeyPressDisplay extends BSUIComponent {
		
		public var Control_Down_mc:MovieClip;
		public var Control_Jump_mc:MovieClip;
		public var Control_Left_mc:MovieClip;
		public var Control_Right_mc:MovieClip;
		public var Control_Quick_Down_mc:MovieClip;
		public var Control_Quick_Left_mc:MovieClip;
		public var Control_Quick_Right_mc:MovieClip;
		public var Control_Quick_Up_mc:MovieClip;
		public var Control_Sneak_mc:MovieClip;
		public var Control_Up_mc:MovieClip;
		public var Control_Down_alt_mc:MovieClip;
		public var Control_Left_alt_mc:MovieClip;
		public var Control_Right_alt_mc:MovieClip;
		public var Control_Up_alt_mc:MovieClip;
		
		private var ControlKeyDown = "Back";
		private var ControlKeyJump = "Jump";
		private var ControlKeyLeft = "StrafeLeft";
		private var ControlKeyRight = "StrafeRight";
		private var ControlKeyUp = "Forward";
		private var ControlKeySneak = "Sneak";
		private var ControlKeyQKDown = "QuickkeyDown";
		private var ControlKeyQKLeft = "QuickkeyLeft";
		private var ControlKeyQKRight = "QuickkeyRight";
		private var ControlKeyQKUp = "QuickkeyUp";
		
		public var MarkForDelete:Boolean = false;
		public var UseAlternateControl:Boolean = false;
		
		private var _fader:KeyPressFader;
		
		public function KeyPressDisplay() {
			// constructor code
			HideAll();
		}
		
		public function ShowMessage(keyToShow:String):void {
			HideAll();
			if(keyToShow == ControlKeyDown && !UseAlternateControl){
				Control_Down_mc.visible = true;
			} else if(keyToShow == ControlKeyDown && UseAlternateControl){
				Control_Down_alt_mc.visible = true;
			} else if(keyToShow == ControlKeyJump){
				Control_Jump_mc.visible = true;
			} else if(keyToShow == ControlKeyLeft && !UseAlternateControl){
				Control_Left_mc.visible = true;
			} else if(keyToShow == ControlKeyDown && UseAlternateControl){
				Control_Left_alt_mc.visible = true;
			} else if(keyToShow == ControlKeyRight && !UseAlternateControl){
				Control_Right_mc.visible = true;
			} else if(keyToShow == ControlKeyDown && UseAlternateControl){
				Control_Right_alt_mc.visible = true;
			} else if(keyToShow == ControlKeyUp && !UseAlternateControl){
				Control_Up_mc.visible = true;
			} else if(keyToShow == ControlKeyDown && UseAlternateControl){
				Control_Up_alt_mc.visible = true;
			} else if(keyToShow == ControlKeySneak){
				Control_Sneak_mc.visible = true;
			} else if(keyToShow == ControlKeyQKDown){
				Control_Quick_Down_mc.visible = true;
			} else if(keyToShow == ControlKeyQKLeft){
				Control_Quick_Left_mc.visible = true;
			} else if(keyToShow == ControlKeyQKRight){
				Control_Quick_Right_mc.visible = true;
			} else if(keyToShow == ControlKeyQKUp){
				Control_Quick_Up_mc.visible = true;
			}

		}
		
		public function get fader():KeyPressFader {
			return _fader;
		}
		public function set fader(val:KeyPressFader):void {
			_fader = val;
		}
		
		public function HideAll():void {
			Control_Down_mc.visible = false;
			Control_Jump_mc.visible = false;
			Control_Left_mc.visible = false;
			Control_Right_mc.visible = false;
			Control_Up_mc.visible = false;
			//Control_Wrong_mc.visible = false;
			Control_Sneak_mc.visible = false;
			Control_Quick_Down_mc.visible = false;
			Control_Quick_Left_mc.visible = false;
			Control_Quick_Right_mc.visible = false;
			Control_Quick_Up_mc.visible = false;
			Control_Down_alt_mc.visible = false;
			Control_Left_alt_mc.visible = false;
			Control_Right_alt_mc.visible = false;
			Control_Up_alt_mc.visible = false;
			
		}
	}
	
}
