package data {
	import flash.events.Event;
	import events.FlixelPlatformGameEvent;
	import flash.ui.Keyboard;
	
	/**
	 * Keyboard constants class
	 * @author Ken
	 * keyboard in this game is similar to Nintendo
	 * gamepad keys
	 * this class maps 'Nintendo' gamepad's keys to
	 * computer keyboards
	 */
	public class KeyboardConstants extends GameConstants {
		/** Up direction key */
		public static const UP:String = "E";
		/** Down direction key */
		public static const DOWN:String = "D";
		/** Left direction key */
		public static const LEFT:String = "S";
		/** Right direction key */
		public static const RIGHT:String = "F";
		
		/** A key, for attack and confirmation */
		public static const A:String = "K";
		/** B key, for jump and cancel */
		public static const B:String = "L";
		/** X key, for skill shortcut */
		public static const X:String = "J";
		/** Y key, for item shortcut */
		public static const Y:String = "H";
		
		/** L key */
		public static const L:String = "R";
		/** R key */
		public static const R:String = "U";
		
		/** Start key, for open menu */
		public static const START:String = "T";
		/** Select key, for open help */
		public static const SELECT:String = "Y";
		
		
		// Special keys, for debugging purpose only
		static public const TOGGLE_SHOW_BOUNDS:String = "B";
		static public const SPEED_UP:String = "N";
		static public const SPEED_DOWN:String = "M";
		
		/** Up direction key */
		public static const UP_KEYS:Vector.<String> = new Vector.<String>();
		/** Down direction key */
		public static const DOWN_KEYS:Vector.<String> = new Vector.<String>();
		/** Left direction key */
		public static const LEFT_KEYS:Vector.<String> = new Vector.<String>();
		/** Right direction key */
		public static const RIGHT_KEYS:Vector.<String> = new Vector.<String>();
		
		/** A key, for attack and confirmation */
		public static const A_KEYS:Vector.<String> = new Vector.<String>();
		/** B key, for jump and cancel */
		public static const B_KEYS:Vector.<String> = new Vector.<String>();
		/** X key, for skill shortcut */
		public static const X_KEYS:Vector.<String> = new Vector.<String>();
		/** Y key, for item shortcut */
		public static const Y_KEYS:Vector.<String> = new Vector.<String>();
		
		/** L key */
		public static const L_KEYS:Vector.<String> = new Vector.<String>();
		/** R key */
		public static const R_KEYS:Vector.<String> = new Vector.<String>();
		
		/** Start key, for open menu */
		public static const START_KEYS:Vector.<String> = new Vector.<String>();
		/** Select key, for open help */
		public static const SELECT_KEYS:Vector.<String> = new Vector.<String>();
		
		override public function loadConstants():void {
			UP_KEYS.push("E", "UP");
			DOWN_KEYS.push("D", "DOWN");
			LEFT_KEYS.push("S", "LEFT");
			RIGHT_KEYS.push("F", "RIGHT");
			A_KEYS.push("K", "Z");
			B_KEYS.push("L", "X");
			X_KEYS.push("J", "C");
			Y_KEYS.push("H", "V");
			L_KEYS.push("R");
			R_KEYS.push("U");
			START_KEYS.push("T", "SPACE");
			SELECT_KEYS.push("Y", "CTRL");
			
			// Notify that the constants are loaded successfully
			dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
		}
	}
}