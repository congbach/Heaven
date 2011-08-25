package gui {
	import errors.IllegalArgumentException;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * GameAttachedSprite
	 * @author Ken
	 * 
	 * A sprite which is attach to another sprite,
	 * so this will follows the sprite in every frame
	 */
	public class GameAttachedSprite extends GameSprite {
		
		/** The sprite which this sprite is attached to */
		protected var _sprite:FlxSprite;
		/** The distance between this sprite and the followed sprite */
		protected var _dist:FlxPoint;
		/**
		 * Flag to indicate that this sprite follows the image of the followed
		 * sprite or not. If not, then this sprite will follows the coordinate
		 */
		protected var _followImage:Boolean;
		/**
		 * Flag to indicate whether this sprite is following some other sprite
		 */
		public function get isFollowing():Boolean { return _sprite != null; }
		
		/**
		 * Default constructor
		 * 
		 * @param	sprite
		 * 			is the sprite to follow
		 * @param	xDist
		 * 			is the x coordinate distance between this sprite and the
		 * 			followed sprite
		 * @param	yDict
		 * 			is the yCoordinate distance between this sprite and the
		 * 			followed sprite
		 * @param	solid
		 * 			indicate whether collision is enable on this sprite
		 * @param	followImage
		 * 			indicates whether this sprite follows the image or the actual
		 * 			coordinate of the sprite
		 * @param	graphics
		 * 			is the graphics of this sprite, if any
		 */
		public function GameAttachedSprite(sprite:FlxSprite, xDist:Number = 0, yDist:Number = 0,
										   solid:Boolean = false, followImage:Boolean = true,
										   graphics:Class = null) {
			super(0, 0, graphics);
			
//			if (sprite == null)
//				throw new IllegalArgumentException("sprite", sprite);
			
			_dist = new FlxPoint();
			resetAttachedSprite(sprite, xDist, yDist, solid, followImage);
		}
		
		/**
		 * Reset this sprite
		 * For recycle purpose
		 * 
		 * @param	sprite
		 * 			is the sprite to follow
		 * @param	xDist
		 * 			is the x coordinate distance between this sprite and the
		 * 			followed sprite
		 * @param	yDict
		 * 			is the yCoordinate distance between this sprite and the
		 * 			followed sprite
		 * @param	solid
		 * 			indicate whether collision is enable on this sprite
		 * @param	followImage
		 * 			indicates whether this sprite follows the image or the actual
		 * 			coordinate of the sprite
		 */
		public function resetAttachedSprite(sprite:FlxSprite, xDist:Number = 0, yDist:Number = 0,
											solid:Boolean = false, followImage:Boolean = true):void {
			super.resetSprite();			
			_sprite = sprite; this.solid = solid;
			_dist.x = xDist; _dist.y = yDist;
			_followImage = followImage;
			updateLocation();
		}
		
		/**
		 * Update the location of this
		 */
		private function updateLocation():void {
			if (_sprite != null) {
				facing = _sprite.facing;
				if (_followImage) {
					this.x = _sprite.x - _sprite.offset.x - _dist.x;
					this.y = _sprite.y - _sprite.offset.y - _dist.y;
				} else {
					this.x = _sprite.x - _dist.x;
					this.y = _sprite.y - _dist.y;
				}
			}
		}
		
		override public function update():void {
			if (_sprite != null) updateLocation();
			super.update();
		}
	}
}