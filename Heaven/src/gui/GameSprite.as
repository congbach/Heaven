package gui {
	
	import org.flixel.data.FlxSize;
	import enums.Direction;
	
	import models.ImmutablePhysicsModel;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.data.FlxAnim;
	
	/**
	 * GameSprite class
	 * @author Ken
	 * The sprite used in the game
	 */
	public class GameSprite extends FlxSprite {
		
		/** The default acceleration of the character */
		protected var _defaultAcceleration:FlxPoint;
		/** The default offset of the character */
		protected var _defaultOffset:FlxPoint;
		/** The default size of the offset */
		protected var _defaultOffsetSize:FlxSize;
//		/** The default width of the offset */
//		protected var _defaultOffsetWidth:Number;
//		/** The default height of the offset */
//		protected var _defaultOffsetHeight:Number;
		/**
		 * The posision of x, y to draw on the screen
		 * (not same as for collision detection)
		 */
		protected var _origPos:FlxPoint;
		/**
		 * The group of objects which is attached to this sprite
		 * i.e. it will update call update on all the members of the group
		 */
		public var attachedGroup:FlxGroup;
		/**
		 * The hp view of the character
		 */
		protected var _hpView:FlxObject;
		
		/**
		 * Default constructor
		 * 
		 * @param	x
		 * 			is the x coordinate of the sprite
		 * @param	y
		 * 			is the y coordinate of the sprite
		 * @param	graphics
		 * 			is the graphics of the sprite
		 */
		public function GameSprite(x:Number=0, y:Number=0, graphics:Class=null) {
			super(x, y, graphics);
			attachedGroup = new FlxGroup();
		}
		
		/**
		 * Reset this sprite
		 * For recycle purpose
		 * 
		 * @param	x
		 * 			is the new x coordinate of this
		 * @param	y
		 * 			is the new y coordinate of this
		 */
		public function resetSprite(x:Number = 0, y:Number = 0, ... args):void {
			super.reset(x, y);
			width = 0; height = 0;
			if (_origPos == null) _origPos = new FlxPoint();
			_origPos.x = x; _origPos.y = y;
			attachedGroup.reset(x, y);
			removeAllAnimations();
			facing = RIGHT;
		}
		
		/**
		 * Add all the animations associated with this sprite
		 * @param	animations	is the vector which contains all animations
		 * 						associated with this sprite
		 */
		public function addAnimations( animations:Vector.<FlxAnim> ):void {
			for each ( var animation:FlxAnim in animations ) {
				addAnimation( animation.name, animation.frames, Math.round( 1.0/animation.delay ) );
			}
		}
		
		/**
		 * Remove all animations of this sprite
		 * For recycle purpose
		 */
		public function removeAllAnimations():void {
			//while (_animations.length) _animations.pop();
			_animations.splice(0, _animations.length);
		}
		
		/**
		 * Initialize the physics constants to aid the game in calculating
		 * physics interaction
		 * @param	spritePhysicsData	is the physics data associated with
		 * 									this sprite
		 */
		public function loadPhysicsConstants( physicsData:ImmutablePhysicsModel ):void {
			offset.x = physicsData.offset.x;
			offset.y = physicsData.offset.y;
			_defaultOffset = new FlxPoint();
			_defaultOffset.x = physicsData.offset.x;
			_defaultOffset.y = physicsData.offset.y;
//			_defaultOffsetWidth = physicsData.offsetSize.width;
//			_defaultOffsetHeight = physicsData.offsetSize.height;
			_defaultOffsetSize = new FlxSize(physicsData.offsetSize.width, physicsData.offsetSize.height);
			width = _defaultOffsetSize.width;
			height = _defaultOffsetSize.height;
			_defaultAcceleration = new FlxPoint();
			_defaultAcceleration.x = physicsData.acceleration.x;
			_defaultAcceleration.y = physicsData.acceleration.y;
			//			acceleration.x = _defaultAcceleration.x;
			acceleration.y = _defaultAcceleration.y;
			drag.x = physicsData.drag.x;
			maxVelocity.x = physicsData.maxVelocity.x;
			maxVelocity.y = physicsData.maxVelocity.y;
			facing = RIGHT;
		}
		
		/** Get the default acceleration of the sprite */
		public function get defaultAcceleration():FlxPoint {
			return _defaultAcceleration;
		}
		
		/** Get the default offset of the sprite */
		public function get defaultOffset():FlxPoint {
			return _defaultOffset;
		}
		
		/**
		 * Return the current moving direction of this character
		 * @return	Direction	which is the current moving direction
		 * 						of this character
		 */
		public function getMovingDirection():Direction {
			// Get the horizontal direction
			var horizontalDirection:Direction = Direction.NO_DIRECTION;;
			if ( velocity.x < 0 )
				horizontalDirection = Direction.LEFT;
			else if ( velocity.x > 0 )
				horizontalDirection = Direction.RIGHT;
			
			// Get the vertical direction
			var verticalDirection:Direction = Direction.NO_DIRECTION;;
			if ( velocity.y < 0 )
				verticalDirection = Direction.UP;
			else if ( velocity.y > 0 )
				verticalDirection = Direction.DOWN;
			
			// Combining those two direction we have the current moving direction
			return Direction.combineDirection( horizontalDirection, verticalDirection );
		}
		
		override public function kill():void {
			attachedGroup.kill();
			super.kill();
		}
	}
}