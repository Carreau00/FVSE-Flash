package Carreau.components {
	
	public class ActorData {
		
		public var id:int;
        public var name:String;
        public var sated:Number = 0;
        public var thiccness:Number = 0;
        public var hunger:Number = 0;
		
		public function ActorData(id:int, name:String = "") {
			// constructor code
			this.id = id;
			this.name = name;
		}

	}
	
}
