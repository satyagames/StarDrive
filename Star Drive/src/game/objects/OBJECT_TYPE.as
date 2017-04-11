package game.objects {

	public class OBJECT_TYPE extends Object {
		public function OBJECT_TYPE(_val:int=0, _stringVal:String="MISC", _specialValue1:int=0, _specialValue2:int=0, _specialValue3:int=0) {
			value=_val;
			stringVal=_stringVal
			specialValue1=_specialValue1;
			specialValue2=_specialValue2;
			specialValue3=_specialValue3;
		}
		public static const PLAYER_CAR_BODY:OBJECT_TYPE=new OBJECT_TYPE(1, "PLAYER_CAR_BODY");
		public static const PLAYER_CHASIS:OBJECT_TYPE=new OBJECT_TYPE(2, "PLAYER_CHASIS");
		//
		public static const PLAYER_FRONT_WHEEL:OBJECT_TYPE=new OBJECT_TYPE(10, "PLAYER_FRONT_WHEEL");
		//
		public static const PLAYER_BACK_WHEEL:OBJECT_TYPE=new OBJECT_TYPE(20, "PLAYER_BACK_WHEEL");
		//
		public static const RAMP_LEFT_1:OBJECT_TYPE=new OBJECT_TYPE(30, "RAMP_LEFT_1");
		public static const RAMP_LEFT_2:OBJECT_TYPE=new OBJECT_TYPE(31, "RAMP_LEFT_2");
		//
		public static const RAMP_RIGHT_1:OBJECT_TYPE=new OBJECT_TYPE(40, "RAMP_RIGHT_1");
		public static const RAMP_RIGHT_2:OBJECT_TYPE=new OBJECT_TYPE(41, "RAMP_RIGHT_2");
		//
		public static const PIVOT_POINT:OBJECT_TYPE=new OBJECT_TYPE(50, "PIVOT_POINT");
		public static const PIVOT_PLATFORM_1:OBJECT_TYPE=new OBJECT_TYPE(51, "PIVOT_PLATFORM_1");
		public static const PIVOT_PLATFORM_2:OBJECT_TYPE=new OBJECT_TYPE(51, "PIVOT_PLATFORM_2");
		public static const PIVOT_PLATFORM_3:OBJECT_TYPE=new OBJECT_TYPE(51, "PIVOT_PLATFORM_3");
		//
		public static const COIN:OBJECT_TYPE=new OBJECT_TYPE(60, "COIN");
		;
		public static const TURBO_BOOST:OBJECT_TYPE=new OBJECT_TYPE(61, "TURBO_BOOST");
		//
		public static const WALL_GROUND:OBJECT_TYPE=new OBJECT_TYPE(70, "WALL_GROUND");
		public static const WALL_RIGHT:OBJECT_TYPE=new OBJECT_TYPE(71, "WALL_RIGHT");
		public static const WALL_LEFT:OBJECT_TYPE=new OBJECT_TYPE(72, "WALL_LEFT");
		public static const WALL_CEILING:OBJECT_TYPE=new OBJECT_TYPE(73, "WALL_CEILING");
		//
		public static const FINISH_LINE:OBJECT_TYPE=new OBJECT_TYPE(80, "FINISH_LINE");
		//
		public static const PLANK_1:OBJECT_TYPE=new OBJECT_TYPE(90, "PLANK_1");
		public static const PLANK_2:OBJECT_TYPE=new OBJECT_TYPE(91, "PLANK_2");
		public static const PLANK_3:OBJECT_TYPE=new OBJECT_TYPE(92, "PLANK_3");
		//
		public static const BOX_1:OBJECT_TYPE=new OBJECT_TYPE(100, "BOX_1");
		public static const BOX_2:OBJECT_TYPE=new OBJECT_TYPE(101, "BOX_2");
		//
		public static const CURVED_RAMP_1_NORMAL:OBJECT_TYPE=new OBJECT_TYPE(110, "CURVED_RAMP_1_NORMAL");
		public static const CURVED_RAMP_1_FLIP_H:OBJECT_TYPE=new OBJECT_TYPE(111, "CURVED_RAMP_1_FLIP_H");
		//
		public static const CURVED_RAMP_2_NORMAL:OBJECT_TYPE=new OBJECT_TYPE(120, "CURVED_RAMP_2_NORMAL");
		public static const CURVED_RAMP_2_FLIP_H:OBJECT_TYPE=new OBJECT_TYPE(121, "CURVED_RAMP_2_FLIP_H");
		//
		public static const CURVED_RAMP_3_NORMAL:OBJECT_TYPE=new OBJECT_TYPE(130, "CURVED_RAMP_3_NORMAL");
		public static const CURVED_RAMP_3_FLIP_H:OBJECT_TYPE=new OBJECT_TYPE(131, "CURVED_RAMP_3_FLIP_H");
		//
		public static const CURVED_RAMP_4_NORMAL:OBJECT_TYPE=new OBJECT_TYPE(140, "CURVED_RAMP_4_NORMAL");
		public static const CURVED_RAMP_4_FLIP_H:OBJECT_TYPE=new OBJECT_TYPE(141, "CURVED_RAMP_4_FLIP_H");
		//
		public static const CURVED_RISE_RAMP_1:OBJECT_TYPE=new OBJECT_TYPE(150, "CURVED_RISE_RAMP_1");
		public static const CURVED_RISE_RAMP_2:OBJECT_TYPE=new OBJECT_TYPE(151, "CURVED_RISE_RAMP_2");
		public static const CURVED_RISE_RAMP_3:OBJECT_TYPE=new OBJECT_TYPE(152, "CURVED_RISE_RAMP_3");
		public static const CURVED_RISE_RAMP_4:OBJECT_TYPE=new OBJECT_TYPE(153, "CURVED_RISE_RAMP_4");
		//
		public static const PINBALL_FLICKER_1:OBJECT_TYPE=new OBJECT_TYPE(160, "PINBALL_FLICKER_1");
		public static const PINBALL_FLICKER_2:OBJECT_TYPE=new OBJECT_TYPE(161, "PINBALL_FLICKER_2");
		//
		public static const MESSAGE_TURBO_BOOST:OBJECT_TYPE=new OBJECT_TYPE(900, "MESSAGE_TURBO_BOOST");
		public static const MESSAGE_COIN_COLLECTED:OBJECT_TYPE=new OBJECT_TYPE(901, "MESSAGE_COIN_COLLECTED");
		public static const MESSAGE_180:OBJECT_TYPE=new OBJECT_TYPE(902, "MESSAGE_180");
		public static const MESSAGE_360:OBJECT_TYPE=new OBJECT_TYPE(903, "MESSAGE_360");
		public static const MESSAGE_MEDIUM_JUMP:OBJECT_TYPE=new OBJECT_TYPE(904, "MESSAGE_MEDIUM_JUMP");
		public static const MESSAGE_LONG_JUMP:OBJECT_TYPE=new OBJECT_TYPE(905, "MESSAGE_LONG_JUMP");
		public static const MESSAGE_HUGE_JUMP:OBJECT_TYPE=new OBJECT_TYPE(906, "MESSAGE_HUGE_JUMP");
		//
		public static const UNDEFINED:OBJECT_TYPE=new OBJECT_TYPE(1001, "UNDEFINED");
		//
		//
		public var value:int=0;
		public var stringVal:String="";
		public var specialValue1:int=0;
		public var specialValue2:int=0;
		public var specialValue3:int=0;
	}
}