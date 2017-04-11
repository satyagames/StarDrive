


package data {
	public class RACE_STATE extends Object {
		public function RACE_STATE(_val : int = 0) {
			value = _val;
		
		}

		public static const WAITING_FOR_START : RACE_STATE = new RACE_STATE(0);		public static const COLLECTING_CHECK_POINTS : RACE_STATE = new RACE_STATE(1);		public static const WAITING_FOR_FINISH : RACE_STATE = new RACE_STATE(2);		public static const AFTER_RACE : RACE_STATE = new RACE_STATE(3);
		
		//
		public var value : int = 0;
		public var stringVal : String = "";
		public var specialValue1 : int = 0;
		public var specialValue2 : int = 0;
		public var specialValue3 : int = 0;
	}
}