package Carreau.components {
	
	import Shared.AS3.*;
	import Shared.GlobalFunc;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
   
	public dynamic class InfoWindow extends BSUIComponent
	{
       
      
      public var confirmlist_mc:confirmlist;
      
      public var opened:Boolean;
      
      public var text_tf:TextField;
      
      public var InfoBackground_mc:MovieClip;
      
      public function InfoWindow()
      {
         super();
         this.setprops();
         this.confirmlist_mc.border.height = 35;
         this.confirmlist_mc.y = this.confirmlist_mc.y + 35;
         this.opened = false;
         visible = false;
         //Extensions.enabled = true;
         //TextFieldEx.setTextAutoSize(this.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function Open(param1:InteractiveObject, param2:String, param3:Object = null) : *
      {
         var _loc4_:String = null;
         //root.f4se.plugins.PRKF.PlaySound2("UIMenuPopUpGeneric");
         this.prevFocusObj = param1;
		  /*
         _loc4_ = param2.replace(/\$Rank:/g,LevelUpMenu.Translator("$Rank:"));
         _loc4_ = _loc4_.replace(/\$PRKF_Requires/g,LevelUpMenu.Translator("$PRKF_Requires"));
         _loc4_ = _loc4_.replace(/\$PRKF_Level/g,LevelUpMenu.Translator("$PRKF_Level"));
         _loc4_ = _loc4_.replace(/\$PRKF_Learned/g,LevelUpMenu.Translator("$PRKF_Learned"));
         _loc4_ = _loc4_.replace(/\$PRKF_NotLearned/g,LevelUpMenu.Translator("$PRKF_NotLearned"));
         _loc4_ = _loc4_.replace(/\$PRKF_or/g,LevelUpMenu.Translator("$PRKF_or"));*/
         GlobalFunc.SetText(this.text_tf,_loc4_,true);
         this.bg_mc.height = this.text_tf.textHeight + 55;
         this.confirmlist_mc.y = this.text_tf.textHeight + 20;
         this.y = (720 - (this.text_tf.textHeight + 55)) / 2;
         this.redrawCustomBrackets(this.bg_mc);
         visible = true;
         this.opened = true;
         this.confirmlist_mc.selectedIndex = 0;
      }
      
      public function get prevFocus() : InteractiveObject
      {
         return this.prevFocusObj;
      }
      
      public function Close() : *
      {
         this.prevFocusObj = null;
         visible = false;
         this.opened = false;
      }
      
      function setprops() : *
      {
         try
         {
            this.confirmlist_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.confirmlist_mc.listEntryClass = "confirm_listentry";
         this.confirmlist_mc.numListItems = 1;
         this.confirmlist_mc.restoreListIndex = false;
         this.confirmlist_mc.textOption = "None";
         this.confirmlist_mc.verticalSpacing = 0;
         try
         {
            this.confirmlist_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
