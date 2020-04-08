package Carreau.components {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class SpendLevelButton extends MovieClip {
		
		public static const ITEM_PRESS:String = "SpendLevelButton::itemPress";
		public static const LIST_PRESS:String = "SpendLevelButton::listPress";
		public static const PLAY_FOCUS_SOUND:String = "SpendLevelButton::playFocusSound";
		public static const SELECTION_CHANGE:String = "SpendLevelButton::selectionChange";
		
		public var border:MovieClip;
		public var SpendLevelPt_tf:TextField;
		
		protected var bDisableInput:Boolean;
		protected var bDisableSelection:Boolean;
		protected var bMouseDrivenNav:Boolean;
		protected var iSelectedIndex:int;
		
		public function SpendLevelButton() {
			// constructor code
			addEventListener(MouseEvent.CLICK, onEntryPress);
			addEventListener(MouseEvent.MOUSE_OVER, onEntryRollover);
		}
		
		public function onEntryRollover(param1:Event) : *
		{
			var _loc2_:* = undefined;
			this.bMouseDrivenNav = true;
			if(!this.bDisableInput && !this.bDisableSelection)
			{
				_loc2_ = this.iSelectedIndex;
				//this.doSetSelectedIndex((param1.currentTarget as BSScrollingListEntry).itemIndex);
				if(_loc2_ != this.iSelectedIndex)
				{
					dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
				}
			}
		 
		}
		
		public function onEntryPress(param1:MouseEvent) : *
		{
			param1.stopPropagation();
			this.bMouseDrivenNav = true;
			this.onItemPress();
		}
		
		protected function onItemPress() : *
		{
			if(!this.bDisableInput && !this.bDisableSelection && this.iSelectedIndex != -1)
			{
				dispatchEvent(new Event(ITEM_PRESS,true,true));
			}
			else
			{
				dispatchEvent(new Event(LIST_PRESS,true,true));
			}
		}
	}
	
}
