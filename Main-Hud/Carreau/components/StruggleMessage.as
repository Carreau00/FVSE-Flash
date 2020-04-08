package Carreau.components {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import Shared.AS3.BSUIComponent;
	
	public class StruggleMessage extends BSUIComponent {
		
		public var MessageWindow_tf:TextField;
		
		public function StruggleMessage() {
			// constructor code
			MessageWindow_tf.text = "";
		}
		
		public function UpdateMessage(MessageString:String):void {
			MessageWindow_tf.text = MessageString;
			MessageWindow_tf.autoSize = TextFieldAutoSize.CENTER;
		}
	}
	
}
