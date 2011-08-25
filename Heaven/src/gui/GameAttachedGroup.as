package gui {
	import errors.IllegalArgumentException;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * GameAttachedGroup
	 * @author Ken
	 * 
	 * Represents a group of flx object/game object
	 * which follows a sprite
	 */
	public class GameAttachedGroup extends FlxGroup {
		
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
		 * 
		 * @throws	IllegalArgumentException
		 * 			if the sprite is null
		 */
		public function GameAttachedGroup(sprite:FlxSprite, xDist:Number = 0, yDist:Number = 0,
										  solid:Boolean = false, followImage:Boolean = true) {
			super();
			
			if (sprite == null)
				throw new IllegalArgumentException("sprite", sprite);
			
			_dist = new FlxPoint();
			resetAttachedGroup(sprite, false, xDist, yDist, solid, followImage);
		}
		
		/**
		 * Reset this group
		 * For recycle purpose
		 * 
		 * @param	sprite
		 * 			is the sprite to follow
		 * @param	destroyOld
		 * 			indicates whether to destroy every old stuff
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
		public function resetAttachedGroup(sprite:FlxSprite, destroyOld:Boolean = false,
											xDist:Number = 0, yDist:Number = 0,
											solid:Boolean = false, followImage:Boolean = true):void {
			if (destroyOld)
				members.splice(0, members.length);
			
			_sprite = sprite; this.solid = solid;
			_dist.x = xDist; _dist.y = yDist;
			_followImage = followImage;
			updateLocation();
		}
		
		/**
		 * Update the location of this
		 */
		private function updateLocation():void {			
			if (_followImage)
				reset(_sprite.x - _sprite.offset.x, _sprite.y - _sprite.offset.y);
			else
				reset(_sprite.x, _sprite.y);
		}
		
		override public function update():void {
			updateLocation();
			super.update();
		}
	}
}