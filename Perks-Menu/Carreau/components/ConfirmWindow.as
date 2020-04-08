package Carreau.components {
	
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	
	public class ConfirmWindow extends BSUIComponent {
		
      
		public var CommandText_tf:TextField;
		public var DescriptorText_tf:TextField;
		public var ActionButtons_mc:ActionButtons_List;
		public var MessageTarget:Object;
		
		static public var MODE_LEARN_PERK:uint = 0;
		static public var MODE_CANT_LEARN:uint = 1;
		static public var MODE_LEARN_LEVEL:uint = 2;
		
		
		protected var prevFocusObj:InteractiveObject;
		
		private var _isOpened:Boolean;
		private var _confirmMode:uint;
		
		public function ConfirmWindow() {
			// constructor code
			_confirmMode = MODE_LEARN_PERK;
			IsOpened = false;
			visible = false;
			setprop();
		}
		
		public function get IsOpened() : Boolean{
			return _isOpened;
		}
		
		public function set IsOpened(value:Boolean): void{
			if(_isOpened != value){
				_isOpened = value;
			}
		}
		
		public function get prevFocus() : InteractiveObject{
			return prevFocusObj;
		}
		
		public function get ConfirmMode():uint{
			return _confirmMode;
		}
		
		public function set ConfirmMode(value:uint):void{
			if(_confirmMode != value){
				_confirmMode = value;
			}
		}
		
		public function Open(PrevFocus:InteractiveObject, CommandString:String, PerkToPurchase:Object = null) : void {
			//(stage.GetChildAt(0) as MovieClip).f4se.plugins.PRKF.PlaySound2("UIMenuPopUpGeneric");
			prevFocusObj = PrevFocus;
			GlobalFunc.SetText(CommandText_tf, CommandString, false);
			if(PerkToPurchase)
			{
				GlobalFunc.SetText(DescriptorText_tf, PerkToPurchase.text, false);
				this.MessageTarget = PerkToPurchase;
			}
			else
			{
				GlobalFunc.SetText(DescriptorText_tf, "", false);
			}
			visible = true;
			IsOpened = true;
			ActionButtons_mc.selectedIndex = 0;
		}
		
		public function Close() : *
		{
			prevFocusObj = null;
			MessageTarget = null;
			visible = false;
			IsOpened = false;
			//confirmtype = CONFIRM_TYPE_NONE;
		}
		
		function setprop() : *
		{
			try
			{
				ActionButtons_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			ActionButtons_mc.listEntryClass = "Carreau.components.ActionButtons_ListEntry";
			ActionButtons_mc.numListItems = 2;
			ActionButtons_mc.restoreListIndex = false;
			ActionButtons_mc.textOption = "None";
			ActionButtons_mc.verticalSpacing = 0;
			try
			{
				ActionButtons_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
			
		}
	}
	
}
