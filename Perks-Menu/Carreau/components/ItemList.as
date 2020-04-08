package Carreau.components {
	
   import Shared.AS3.BSScrollingList;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class ItemList extends BSScrollingList
   {
      
      public static const MOUSE_OVER:String = "ItemList::mouse_over";
       
      
      public function ItemList()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      }
      
      private function onMouseOver(param1:MouseEvent) : *
      {
         //dispatchEvent(new Event(MOUSE_OVER,true,true));
      }
   }
}
