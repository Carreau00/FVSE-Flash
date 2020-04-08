package Shared
{
	public class DebugFunc
	{
		public static var DebugEnabled:Boolean = false;
		
		public static function debugTrace(messageString:String): *{
			trace("[vore_hud]" + messageString);
		}
		
		public static function GetDebugEnabled():Boolean{
			return DebugEnabled;
		}
		
		public static function SetDebugEnabled(value:int):void{
			if(value == 0){
				DebugEnabled = false;
			} else {
				DebugEnabled = true;
			}
		}
	}   
	

}