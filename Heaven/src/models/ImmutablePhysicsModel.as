package models {
	import org.flixel.data.FlxSize;
	import org.flixel.FlxPoint;
	
	/**
	 * Character Physics Data class
	 * @author Ken
	 * contains all information required
	 * in order to calculate physics interaction
	 * between characters
	 */
	public class ImmutablePhysicsModel {
		
		/** The offset origin to begin collision detection in flixel library */
		private var _offset:FlxPoint;
		/** The size of the offset where collision is detected (flixel library) */
		private var _offsetSize:FlxSize;
//		/** The width of the offset where collision is detect (flixel library) */
//		private var _offsetWidth:Number;
//		/** The height of the offset where collision is detect (flixel library) */
//		private var _offsetHeight:Number;
		/** The default moving acceleration */
		private var _acceleration:FlxPoint;
		/** The drag (deceleration) */
		private var _drag:FlxPoint;
		/** Maximum velocity */
		private var _maxVelocity:FlxPoint;
		
		/**
		 * Default contructor
		 * 
		 * @param	offsetX
		 * 			is the x coordinate of the offset
		 * @param	offsetY
		 * 			is the y coordinate of the offset
		 * @param	offsetWidth
		 * 			is the width of the offset
		 * @param	offsetHeight
		 * 			is the height of the offset
		 * @param	accelerationX
		 * 			is the default x-direction of the acceleration of the character
		 * @param	accelerationY
		 * 			is the default y-direction of the acceleration of the character
		 * @param	dragX
		 * 			is the default x-direction of the deceleration of the character
		 * @param	dragY
		 * 			is the default y-direction of the deceleration of the character
		 * @param	maxVelocityX
		 * 			is the maximum x-direction of velocity of this character
		 * @param	maxVelocityY
		 * 			is the maximum y-direction of velocity of this character
		 */
		public function ImmutablePhysicsModel(
			offsetX:Number, offsetY:Number, offsetWidth:Number, offsetHeight:Number,
			accelerationX:Number, accelerationY:Number, dragX:Number, dragY:Number,
			maxVelocityX:Number, maxVelocityY:Number ) {
			_offset = new FlxPoint( offsetX, offsetY );
//			_offsetWidth = offsetWidth;
//			_offsetHeight = offsetHeight;
			_offsetSize = new FlxSize(offsetWidth, offsetHeight);
			_acceleration = new FlxPoint( accelerationX, accelerationY );
			_drag = new FlxPoint( dragX, dragY );
			_maxVelocity = new FlxPoint( maxVelocityX, maxVelocityY );
		}
		
		/** Get the offset origin */
		public function get offset():FlxPoint {
			return new FlxPoint(_offset.x, _offset.y);
		}
		
		/** Get the size of the offset */
		public function get offsetSize():FlxSize {
			return new FlxSize(_offsetSize.width, _offsetSize.height);
		}
		
//		/** Get the offset width */
//		public function get offsetWidth():Number {
//			return _offsetWidth;
//		}
//		
//		/** Get the offset height */
//		public function get offsetHeight():Number {
//			return _offsetHeight;
//		}
		
		/** Get the default acceleration of this player */
		public function get acceleration():FlxPoint {
			return _acceleration;
		}
		
		/** Get the drag (deceleration) of this player */
		public function get drag():FlxPoint {
			return _drag;
		}
		
		/** Get the maximum velocity of this player */
		public function get maxVelocity():FlxPoint {
			return _maxVelocity;
		}
		
		/**
		 * Return a clone of this physics data
		 */
		public function clone():ImmutablePhysicsModel {
			return new ImmutablePhysicsModel(_offset.x, _offset.y, _offsetSize.width, _offsetSize.height,
				_acceleration.x, _acceleration.y, _drag.x, _drag.y, _maxVelocity.x, _maxVelocity.y);
				
		}
	}
}