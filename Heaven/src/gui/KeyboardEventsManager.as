package gui {
	import errors.IllegalArgumentException;
	import data.KeyboardConstants;
	
	import enums.Direction;
	
	import errors.NonStaticCallSingletonPattern;
	import errors.SingletonPatternViolatedError;
	
	import flash.display.Sprite;
	
	import org.flixel.FlxG;
	
	/**
	 * KeyboardEventsManager class
	 * @author Ken
	 * works with the support of flixel keyboard events
	 * manager to avoid two keyboard listeners
	 * working at the same time
	 */
	public class KeyboardEventsManager extends Sprite {
		// Singleton pattern
		private static var instance:KeyboardEventsManager;
		private static var canCreateNew:Boolean = true;
		private static var staticCall:Boolean = false;
		
		/** Get the only instance of this class */
		public static function getInstance():KeyboardEventsManager {
			if ( instance == null ) {
				staticCall = true;
				instance = new KeyboardEventsManager();
				staticCall = false;
			}
			return instance;
		}
		
		/**
		 * Default constructor
		 * 
		 * Singleton pattern, will throw error and terminate
		 * if this constructor is not called by the static function
		 */
		public function KeyboardEventsManager() {
			if ( ! staticCall )
				throw new NonStaticCallSingletonPattern( "KeyboardEventsManager" );
			if ( ! canCreateNew )
				throw new SingletonPatternViolatedError( "KeyboardEventsManager" );
			
			canCreateNew = false;
			_keyHorizontalDirectionDown = Direction.NO_DIRECTION;
			_keyVerticalDirectionDown = Direction.NO_DIRECTION;
			
		}
		
		/** Flag to indicate if some certain keys are down */
//		private var _keyUpDown:Boolean = false;
//		private var _keyDownDown:Boolean = false;
//		private var _keyLeftDown:Boolean = false;
//		private var _keyRightDown:Boolean = false;
//		
//		private var _keyADown:Boolean = false;
//		private var _keyBDown:Boolean = false;
//		private var _keyXDown:Boolean = false;
//		private var _keyYDown:Boolean = false;
//		
//		private var _keyStartDown:Boolean = false;
//		private var _keySelectDown:Boolean = false;
		
		/** The direction of the direction keyboard */
		private var _keyHorizontalDirectionDown:Direction;
		private var _keyVerticalDirectionDown:Direction;
		
		/**
		 * Update the keyboard event listener
		 * to be called every active frame
		 */
		public function update():void {
//			_keyUpDown = FlxG.keys.pressed( KeyboardConstants.UP );
//			_keyDownDown = FlxG.keys.pressed( KeyboardConstants.DOWN );
//			_keyLeftDown = FlxG.keys.pressed( KeyboardConstants.LEFT );
//			_keyRightDown = FlxG.keys.pressed( KeyboardConstants.RIGHT );
//			_keyADown = FlxG.keys.justPressed( KeyboardConstants.A );
//			_keyBDown = FlxG.keys.justPressed( KeyboardConstants.B );
//			_keyXDown = FlxG.keys.pressed( KeyboardConstants.X );
//			_keyYDown = FlxG.keys.pressed( KeyboardConstants.Y );
//			_keyStartDown = FlxG.keys.justPressed( KeyboardConstants.START );
//			_keySelectDown = FlxG.keys.justPressed( KeyboardConstants.SELECT );
			
			// Determine the direction of the pressed keys
			determineHorizontalDirection();
			determineVerticalDirection();
		}
		
		/**
		 * Return whether a key is pressed
		 * 
		 * @param	key
		 * 			is the key to check whether it is currently pressed or not
		 * 			
		 * @return	whether the key is pressed
		 * 
		 * @throws	IllegalArgumentException
		 * 			is the key given does not match any pre-designed key
		 */
		public function pressed(key:String):Boolean {
			switch (key) {
				case KeyboardConstants.UP:
					return FlxG.keys.pressedAny(KeyboardConstants.UP_KEYS);
				case KeyboardConstants.DOWN:
					return FlxG.keys.pressedAny(KeyboardConstants.DOWN_KEYS);
				case KeyboardConstants.LEFT:
					return FlxG.keys.pressedAny(KeyboardConstants.LEFT_KEYS);
				case KeyboardConstants.RIGHT:
					return FlxG.keys.pressedAny(KeyboardConstants.RIGHT_KEYS);
				case KeyboardConstants.A:
					return FlxG.keys.pressedAny(KeyboardConstants.A_KEYS);
				case KeyboardConstants.B:
					return FlxG.keys.pressedAny(KeyboardConstants.B_KEYS);
				case KeyboardConstants.X:
					return FlxG.keys.pressedAny(KeyboardConstants.X_KEYS);
				case KeyboardConstants.Y:
					return FlxG.keys.pressedAny(KeyboardConstants.Y_KEYS);
				case KeyboardConstants.L:
					return FlxG.keys.pressedAny(KeyboardConstants.L_KEYS);
				case KeyboardConstants.R:
					return FlxG.keys.pressedAny(KeyboardConstants.R_KEYS);
				case KeyboardConstants.START:
					return FlxG.keys.pressedAny(KeyboardConstants.START_KEYS);
				case KeyboardConstants.SELECT:
					return FlxG.keys.pressedAny(KeyboardConstants.SELECT_KEYS);
				default:
					throw new IllegalArgumentException("Undefined key:", key);
			}
			return false;
		}
		
		/**
		 * Return whether a key has just been pressed
		 * 
		 * @param	key
		 * 			is the key to check whether it has just been pressed or not
		 * 			
		 * @return	whether the key has just been pressed
		 * 
		 * @throws	IllegalArgumentException
		 * 			is the key given does not match any pre-designed key
		 */
		public function justPressed(key:String):Boolean {
			switch (key) {
				case KeyboardConstants.UP:
					return FlxG.keys.justPressedAny(KeyboardConstants.UP_KEYS);
				case KeyboardConstants.DOWN:
					return FlxG.keys.justPressedAny(KeyboardConstants.DOWN_KEYS);
				case KeyboardConstants.LEFT:
					return FlxG.keys.justPressedAny(KeyboardConstants.LEFT_KEYS);
				case KeyboardConstants.RIGHT:
					return FlxG.keys.justPressedAny(KeyboardConstants.RIGHT_KEYS);
				case KeyboardConstants.A:
					return FlxG.keys.justPressedAny(KeyboardConstants.A_KEYS);
				case KeyboardConstants.B:
					return FlxG.keys.justPressedAny(KeyboardConstants.B_KEYS);
				case KeyboardConstants.X:
					return FlxG.keys.justPressedAny(KeyboardConstants.X_KEYS);
				case KeyboardConstants.Y:
					return FlxG.keys.justPressedAny(KeyboardConstants.Y_KEYS);
				case KeyboardConstants.L:
					return FlxG.keys.justPressedAny(KeyboardConstants.L_KEYS);
				case KeyboardConstants.R:
					return FlxG.keys.justPressedAny(KeyboardConstants.R_KEYS);
				case KeyboardConstants.START:
					return FlxG.keys.justPressedAny(KeyboardConstants.START_KEYS);
				case KeyboardConstants.SELECT:
					return FlxG.keys.justPressedAny(KeyboardConstants.SELECT_KEYS);
				default:
					throw new IllegalArgumentException("Undefined key:", key);
			}
			return false;
		}
		
		/**
		 * Return whether a key has just been released
		 * 
		 * @param	key
		 * 			is the key to check whether it has just been released or not
		 * 			
		 * @return	whether the key hhas just been released
		 * 
		 * @throws	IllegalArgumentException
		 * 			is the key given does not match any pre-designed key
		 */
		public function justReleased(key:String):Boolean {
			switch (key) {
				case KeyboardConstants.UP:
					return FlxG.keys.justReleasedAny(KeyboardConstants.UP_KEYS);
				case KeyboardConstants.DOWN:
					return FlxG.keys.justReleasedAny(KeyboardConstants.DOWN_KEYS);
				case KeyboardConstants.LEFT:
					return FlxG.keys.justReleasedAny(KeyboardConstants.LEFT_KEYS);
				case KeyboardConstants.RIGHT:
					return FlxG.keys.justReleasedAny(KeyboardConstants.RIGHT_KEYS);
				case KeyboardConstants.A:
					return FlxG.keys.justReleasedAny(KeyboardConstants.A_KEYS);
				case KeyboardConstants.B:
					return FlxG.keys.justReleasedAny(KeyboardConstants.B_KEYS);
				case KeyboardConstants.X:
					return FlxG.keys.justReleasedAny(KeyboardConstants.X_KEYS);
				case KeyboardConstants.Y:
					return FlxG.keys.justReleasedAny(KeyboardConstants.Y_KEYS);
				case KeyboardConstants.L:
					return FlxG.keys.justReleasedAny(KeyboardConstants.L_KEYS);
				case KeyboardConstants.R:
					return FlxG.keys.justReleasedAny(KeyboardConstants.R_KEYS);
				case KeyboardConstants.START:
					return FlxG.keys.justReleasedAny(KeyboardConstants.START_KEYS);
				case KeyboardConstants.SELECT:
					return FlxG.keys.justReleasedAny(KeyboardConstants.SELECT_KEYS);
				default:
					throw new IllegalArgumentException("Undefined key:", key);
			}
			return false;
		}
		
		/**
		 * Determine the horizontal direction of the direction keyboards pressed
		 */
		private function determineHorizontalDirection():void {
			// If both keys are down
			if ( pressed(KeyboardConstants.LEFT) &&
				 pressed(KeyboardConstants.RIGHT) ) {
				// Whichever pressed later holds the effect
				if ( justPressed( KeyboardConstants.LEFT ) )
					_keyHorizontalDirectionDown = Direction.LEFT;
				else if ( justPressed( KeyboardConstants.RIGHT ) )
					_keyHorizontalDirectionDown = Direction.RIGHT;
			} else if ( pressed(KeyboardConstants.LEFT) )
				_keyHorizontalDirectionDown = Direction.LEFT;			
			else if ( pressed(KeyboardConstants.RIGHT) )
				_keyHorizontalDirectionDown = Direction.RIGHT;			
			else
				_keyHorizontalDirectionDown = Direction.NO_DIRECTION;
		}
		
		/**
		 * Determine the vertical direction of the direction keyboards pressed
		 */
		private function determineVerticalDirection():void {
			// If both keys are down
			if ( pressed(KeyboardConstants.UP) &&
				 pressed(KeyboardConstants.DOWN) ) {
				// Whichever pressed later holds the effect
				if ( justPressed( KeyboardConstants.UP ) )
					_keyVerticalDirectionDown = Direction.UP;
				else if ( justPressed( KeyboardConstants.DOWN ) )
					_keyVerticalDirectionDown = Direction.DOWN;
			} else if ( pressed(KeyboardConstants.UP) )
				_keyVerticalDirectionDown = Direction.UP;			
			else if ( pressed(KeyboardConstants.DOWN) )
				_keyVerticalDirectionDown = Direction.DOWN;			
			else
				_keyVerticalDirectionDown = Direction.NO_DIRECTION;
		}
		
//		/** Return whether the up key is currently pressed */
//		public function get keyUpDown():Boolean {
//			return _keyUpDown;
//		}
//		
//		/** Return whether the down key is currently pressed */
//		public function get keyDownDown():Boolean {
//			return _keyDownDown;
//		}
//		
//		/** Return whether the left key is currently pressed */
//		public function get keyLeftDown():Boolean {
//			return _keyLeftDown;
//		}
//		
//		/** Return whether the right key is currently pressed */
//		public function get keyRightDown():Boolean {
//			return _keyRightDown;
//		}
//		
//		/** Return whether the up A is currently pressed */
//		public function get keyADown():Boolean {
//			return _keyADown;
//		}
//		
//		/** Return whether the up B is currently pressed */
//		public function get keyBDown():Boolean {
//			return _keyBDown;
//		}
//		
//		/** Return whether the X key is currently pressed */
//		public function get keyXDown():Boolean {
//			return _keyXDown;
//		}
//		
//		/** Return whether the Y key is currently pressed */
//		public function get keyYDown():Boolean {
//			return _keyYDown;
//		}
//		
//		/** Return whether the START key is currently pressed */
//		public function get keyStartDown():Boolean {
//			return _keyStartDown;
//		}
//		
//		/** Return whether the SELECT key is currently pressed */
//		public function get keySelectDown():Boolean {
//			return _keySelectDown;
//		}
		
		/** Get the horizontal direction of the direction keyboard */
		public function get keyHorizontalDirectionDown():Direction {
			return _keyHorizontalDirectionDown;
		}
		
		/** Get the vertical direction of the direction keyboard */
		public function get keyVerticalDirectionDown():Direction {
			return _keyVerticalDirectionDown;
		}
	}
}