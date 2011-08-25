package enums {
	
	import errors.CannotCreateEnumError;
	import errors.IllegalArgumentException;
	
	/**
	 * Direction enumeration
	 * @author Ken
	 * contains all the directions: NO_DIRECTION, UP, LEFT,
	 * DOWN, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT
	 */
	public class Direction {
		public static const totalNumInstances:int = 9;
		public static var currentNumInstances:int = 0;
		
		public static const NO_DIRECTION:Direction = new Direction();
		public static const UP:Direction = new Direction();
		public static const DOWN:Direction = new Direction();
		public static const LEFT:Direction = new Direction();
		public static const RIGHT:Direction = new Direction();
		public static const UP_LEFT:Direction = new Direction();
		public static const UP_RIGHT:Direction = new Direction();
		public static const DOWN_LEFT:Direction = new Direction();
		public static const DOWN_RIGHT:Direction = new Direction();
		
		/**
		 * Combine two one-dimension direction to get two-dimension direction
		 * @param	horizontalDirection			is the horizontal direction to combine
		 * @param 	verticalDirection			is the vertical direction to combine
		 * @return	Direction					which is combined version of the two
		 * 										given directions
		 * @throw	IllegalArgumentException	if one of the two given directions does
		 * 										not fit (like the horizontalDirection is vertical,...)
		 */
		public static function combineDirection(
			horizontalDirection:Direction,
			verticalDirection:Direction ):Direction {
			if ( horizontalDirection != Direction.LEFT
				&& horizontalDirection != Direction.RIGHT
				&& horizontalDirection != Direction.NO_DIRECTION )
				throw new IllegalArgumentException( "horizontalDirection", horizontalDirection );
			return horizontalDirection.combineWithVerticalDirection( verticalDirection );
		}
		
		/**
		 * Constructor
		 */
		public function Direction() {
			// Workaround to create enums
			if ( currentNumInstances >= totalNumInstances )
				throw new CannotCreateEnumError( "Direction" );
			
			currentNumInstances++;
		}
		
		
		/**
		 * Combine this direction with another direction
		 * @param	direction	is the direction to combine
		 * @return	Direction	is the combined version of
		 * 						this and the given direction
		 */
		public function combineWith( direction:Direction ):Direction {
			var horizontalDirection:Direction = Direction.NO_DIRECTION;
			if ( direction.hasLeftDirection() )
				horizontalDirection = Direction.LEFT;
			else if ( direction.hasRightDirection() )
				horizontalDirection = Direction.RIGHT;
			
			var verticalDirection:Direction = Direction.NO_DIRECTION;;
			if ( direction.hasUpDirection() )
				verticalDirection = Direction.UP;
			else if ( direction.hasDownDirection() )
				verticalDirection = Direction.DOWN;
			
			return this.combineWithTwoOneDimensionDirection( horizontalDirection, verticalDirection );
		}
		
		/**
		 * Combine this direction with two one-dimension direction
		 * @param	horizontalDirection			is the horizontal direction to combine
		 * @param 	verticalDirection			is the vertical direction to combine
		 * @return	Direction					which is combined version of this and
		 * 										the two given directions
		 * @throw	IllegalArgumentException	if one of the two given directions does
		 * 										not fit (like the horizontalDirection is vertical,...)
		 */
		public function combineWithTwoOneDimensionDirection(
			horizontalDirection:Direction,
			verticalDirection:Direction	):Direction {
			
			var firstDirection:Direction = this.combineWithHorizontalDirection( horizontalDirection );
			return firstDirection.combineWithVerticalDirection( verticalDirection );
		}
		
		/**
		 * Combine this direction with a horizontal direction
		 * @param	horizontalDirection			is the horizontal direction to combine
		 * @return	Direction					which is combined version of this and
		 * 										the given direction
		 * @throw	IllegalArgumentException	if the given directions is not horizontal
		 */
		public function combineWithHorizontalDirection( horizontalDirection:Direction ):Direction {
			if ( horizontalDirection != Direction.LEFT
					&& horizontalDirection != Direction.RIGHT
					&& horizontalDirection != Direction.NO_DIRECTION )
				throw new IllegalArgumentException( "horizontalDirection", horizontalDirection );
			
			if ( horizontalDirection == Direction.LEFT ) {
				switch ( this ) {
					case NO_DIRECTION: case RIGHT: case LEFT:
						return LEFT;
					case UP: case UP_LEFT: case UP_RIGHT:
						return UP_LEFT;
					case DOWN: case DOWN_LEFT: case DOWN_RIGHT:
						return DOWN_LEFT;
					default:
						throw new Error( "Unknown enum type Direction: " + this );
				}
			} else if ( horizontalDirection == Direction.RIGHT ) {
				switch ( this ) {
					case NO_DIRECTION: case RIGHT: case LEFT:
						return RIGHT;
					case UP: case UP_LEFT: case UP_RIGHT:
						return UP_RIGHT;
					case DOWN: case DOWN_LEFT: case DOWN_RIGHT:
						return DOWN_RIGHT;
					default:
						throw new Error( "Unknown enum type Direction: " + this );
				}
			} else
				return this;
			throw new Error( "This is impossible" );
		}
		
		/**
		 * Combine this direction with a vertical direction
		 * @param	verticalDirection			is the vertical direction to combine
		 * @return	Direction					which is combined version of this and
		 * 										the given direction
		 * @throw	IllegalArgumentException	if the given directions is not vertical
		 */
		public function combineWithVerticalDirection( verticalDirection:Direction ):Direction {
			if ( verticalDirection != Direction.UP
					&& verticalDirection != Direction.DOWN
					&& verticalDirection != Direction.NO_DIRECTION )
				throw new IllegalArgumentException( "verticalDirection", verticalDirection );
			
			if ( verticalDirection == Direction.UP ) {
				switch ( this ) {
					case NO_DIRECTION: case UP: case DOWN:
						return UP;
					case LEFT: case UP_LEFT: case DOWN_LEFT:
						return UP_LEFT;
					case RIGHT: case UP_RIGHT: case DOWN_RIGHT:
						return UP_RIGHT;
					default:
						throw new Error( "Unknown enum type Direction: " + this );
				}
			} else if ( verticalDirection == Direction.DOWN ) {
				switch ( this ) {
					case NO_DIRECTION: case UP: case DOWN:
						return DOWN;
					case LEFT: case UP_LEFT: case DOWN_LEFT:
						return DOWN_LEFT;
					case RIGHT: case UP_RIGHT: case DOWN_RIGHT:
						return DOWN_RIGHT;
					default:
						throw new Error( "Unknown enum type Direction: " + this );
				}
			} else
				return this;
			throw new Error( "This is impossible" );
		}
		
		/**
		 * Clear the horizontal direction of this
		 * @return	Direction	which contains only vertical direction
		 * 						from this
		 */
		public function resetHorizontalDirection():Direction {
			switch ( this ) {
				case LEFT: case RIGHT:
					return NO_DIRECTION;
				case UP_LEFT: case UP_RIGHT:
					return UP;
				case DOWN_LEFT: case DOWN_RIGHT:
					return DOWN;
				case NO_DIRECTION: case UP: case DOWN:
					return this;
				default:
					throw new Error( "Unknown enum type Direction: " + this );
			}
		}
		
		/**
		 * Clear the vertical direction of this
		 * @return	Direction	which contains only horizontal direction
		 * 						from this
		 */
		public function resetVerticalDirection():Direction {
			switch ( this ) {
				case UP: case DOWN:
					return NO_DIRECTION;
				case UP_LEFT: case DOWN_LEFT:
					return LEFT;
				case UP_RIGHT: case DOWN_RIGHT:
					return RIGHT;
				case NO_DIRECTION: case LEFT: case RIGHT:
					return this;
				default:
					throw new Error( "Unknown enum type Direction: " + this );
			}
		}
		
		/**
		 * See whether this direction has UP direction in vertical axis
		 * @return	true	if this direction has UP direction in vertical axis
		 * 					i.e. this is UP or UP_LEFT or UP_RIGHT
		 * 			false	otherwise
		 */
		public function hasUpDirection():Boolean {
			switch ( this ) {
				case UP: case UP_LEFT: case UP_RIGHT:
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * See whether this direction has DOWN direction in vertical axis
		 * @return	true	if this direction has DOWN direction in vertical axis
		 * 					i.e. this is DOWN or DOWN_LEFT or DOWN_RIGHT
		 * 			false	otherwise
		 */
		public function hasDownDirection():Boolean {
			switch ( this ) {
				case DOWN: case DOWN_LEFT: case DOWN_RIGHT:
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * See whether this direction has LEFT direction in horizontal axis
		 * @return	true	if this direction has LEFT direction in horizontal axis
		 * 					i.e. this is LEFT or UP_LEFT or DOWN_LEFT
		 * 			false	otherwise
		 */
		public function hasLeftDirection():Boolean {
			switch ( this ) {
				case LEFT: case UP_LEFT: case DOWN_LEFT:
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * See whether this direction has RIGHT direction in horizontal axis
		 * @return	true	if this direction has RIGHT direction in horizontal axis
		 * 					i.e. this is RIGHT or UP_RIGHT or DOWN_RIGHT
		 * 			false	otherwise
		 */
		public function hasRightDirection():Boolean {
			switch ( this ) {
				case RIGHT: case UP_RIGHT: case DOWN_RIGHT:
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * Convert this direction to useful string to debug easier
		 */
		public function toString():String {
			switch ( this ) {
				case NO_DIRECTION: return "NO_DIRECTION";
				case UP: return "UP";
				case DOWN: return "DOWN";
				case LEFT: return "LEFT";
				case RIGHT: return "RIGHT";
				case UP_LEFT: return "UP_LEFT";
				case UP_RIGHT: return "UP_RIGHT";
				case DOWN_LEFT: return "DOWN_LEFT";
				case DOWN_RIGHT: return "DOWN_RIGHT";
				default:
				throw new Error( "Unknown enum type Direction: " + this );
			}
		}
	}
}