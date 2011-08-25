package gui.skills {
	import gui.GameAttachedSprite;
	import gui.characters.Character;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxObject;
	import models.skills.SkillModel;
	
	/**
	 * Skill class
	 * @author Ken
	 * 
	 * SkillController, merged with View
	 * Controls view and model of the skill
	 */
	public class Skill extends GameAttachedSprite {
		
		/** Model of this skill */
		private var _model:SkillModel;
		/** The character who casts this skill */
		private var _character:Character;
		/** The character who casts this skill */
		public function get character():Character { return _character; }
		/**
		 * Model of this skill
		 */
		public function get model():SkillModel { return _model; }
		/**
		 * Range of this skill
		 */
		private var _range:Number;
		
		/**
		 * Default constructor
		 * 
		 * @param	model
		 * 			is the model of this skill
		 * @param	range
		 * 			is the range of this skill
		 * @param	x
		 * 			is the x-coordinate
		 * @param	y
		 * 			is the y-coordinate
		 * @param	character
		 * 			is the character who performs the skill
		 * @param	shouldFollow
		 * 			indicates whether this skill should follow the character or not
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
		public function Skill(model:SkillModel, range:Number, character:Character, x:Number = 0, y:Number = 0, 
								 shouldFollow:Boolean = false, xDist:Number = 0, yDist:Number = 0, solid:Boolean = true,
								 followImage:Boolean = true, graphics:Class = null) {
			super(character, xDist, yDist, solid, followImage);
			
			resetSkill(model, range, character, x, y, shouldFollow, xDist, yDist, solid, followImage);
		}
		
		/**
		 * Reset this skill, for recycling purpose
		 * 
		 * @param	model
		 * 			is the model of this skill
		 * @param	range
		 * 			is the range of this skill
		 * @param	x
		 * 			is the x-coordinate
		 * @param	y
		 * 			is the y-coordinate
		 * @param	character
		 * 			is the character who performs the skill
		 * @param	shouldFollow
		 * 			indicates whether this skill should follow the character or not
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
		public function resetSkill(model:SkillModel, range:Number, character:Character, x:Number = 0, y:Number = 0,
									 shouldFollow:Boolean = false, xDist:Number = 0, yDist:Number = 0,
									solid:Boolean = false, followImage:Boolean = true):void {
			if (! shouldFollow)
				resetAttachedSprite(null, xDist, yDist, solid, followImage);
			else resetAttachedSprite(character, xDist, yDist, solid, followImage);
			
			_character = character;			
			if (!shouldFollow) resetSprite(x, y);
			
			_model = model; 
			_range = range;
		}
		
		/**
		 * This skill has hit a character, perform effect on that character, if possible
		 * 
		 * @param	character
		 * 			is the character which this skill hits
		 */
		public function hit(character:Character):void {
			if (character != _character) {
				_model.usedOn(character.model);
				kill();
			}
		}
		
		/**
		 * Update the position and size so that it is correctly the current action's desired
		 * position and size (for overlap detection)
		 */
		public function updatePositionAndSize():void {			
			_origPos.x = x; _origPos.y = y;
			x -= offset.x; y -= offset.y;
			width = frameWidth;
			height = frameHeight;			
		}

		/**
		 * Reset the position and size so that image is draw correctly
		 */
		public function resetPositionAndSize():void {
			x = _origPos.x; y = _origPos.y;
			width = _defaultOffsetSize.width;
			height = _defaultOffsetSize.height;
		}

		override public function hitSide(Contact:FlxObject,Velocity:Number):void {
			// Destroy the skill whenever it hits the tile map
			if (Contact is FlxTilemap) kill();
			else super.hitSide(Contact, Velocity);
		}
		
		override public function hitTop(Contact:FlxObject,Velocity:Number):void {
			// Destroy the skill whenever it hits the tile map
			if (Contact is FlxTilemap) kill();
			else super.hitSide(Contact, Velocity);
		}
		
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void {
			// Destroy the skill whenever it hits the tile map
			if (Contact is FlxTilemap) kill();
			else super.hitSide(Contact, Velocity);
		}
	}
}