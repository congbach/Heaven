package gui.characters {
	
	import gui.HpBarView;
	import org.flixel.FlxGroup;
	import flash.display.BitmapData;
	import org.flixel.FlxSprite;
	import data.CharactersConstants;
	
	import enums.Action;
	import enums.Direction;
	
	import errors.IllegalArgumentException;
	
	import models.characters.CharacterModel;
	
	import org.flixel.FlxObject;
	import org.flixel.FlxTilemap;
	
	/**
	 * NonPlayableCharacter class
	 * @author Ken
	 * represents NPC which is controled by AI
	 */
	public class NonPlayableCharacter extends Character {
		
		/** The AI which controls the character, i.e. the controller */
		private var _ai:AI;
		/** The hp bar of the character */
		protected var _hpBar:HpBarView;
		
		/**
		 * Default contructor
		 * 
		 * @param	model
		 * 			is the default model of this npc
		 * @param	xCoor
		 * 			is the x index of the grid this character is on
		 * @param	yCoor
		 * 			is the y index of the grid this character is on
		 * @param	tileMap
		 * 			is the current map
		 * @param	skillsOnScreen
		 * 			is the list of skills on the screen, to add skill to
		 * 			when a character performs skill's animation
		 */
		public function NonPlayableCharacter( model:CharacterModel, xCoor:int, yCoor:int, tileMap:Array,
											  skillsOnScreen:FlxGroup ) {
			super(model, skillsOnScreen);
			_ai = new AI( this, xCoor, yCoor, tileMap );
			
			// Create hp bar
			_hpBar = new HpBarView(this);
			attachedGroup.add(_hpBar);
		}
		
		override public function loadGraphic(Graphic:Class, Animated:Boolean=false, Reverse:Boolean=false, Width:uint=0,
											 Height:uint=0, Unique:Boolean=false):FlxSprite {
			var sprite:FlxSprite = 
				super.loadGraphic(Graphic, Animated, Reverse, Width, Height, Unique);
			_hpBar.resetHpBar();
			return sprite;
		}
		
		override public function loadBitmapDataGraphic(key:String, bitmapData:BitmapData,Animated:Boolean=false,
			Reverse:Boolean=false,Width:uint=0,Height:uint=0,Unique:Boolean=false):FlxSprite {
			var sprite:FlxSprite = 
				super.loadBitmapDataGraphic(key, bitmapData, Animated, Reverse, Width, Height, Unique);
			_hpBar.resetHpBar();
			return sprite;
		}
		
		/**
		 * Reset this three characters
		 * @param	model
		 * 			is the new model for this character
		 * @param	...args
		 * 			must have at least three arguments: xCoor, ycoor, and tileMap
		 */
		override public function resetCharacter(model:CharacterModel, ...args):void {
			super.resetCharacter(model);
			if (args.length == 3)				
				_ai.resetAI(this, args[0], args[1], args[2]);
			if (_hpBar) _hpBar.resetHpBar();
		}
		
		override public function update():void {
			// Ask the AI to control this
			_ai.controls();
			super.update();
		}
		
		/**
		 * Function to move this NPC towards the given direction
		 * @param	direction					is the direction to move this npc towards
		 * @throw	IllegalArgumentException	if the direction is invalid
		 */
		public function move( direction:Direction ):void {
			switch ( direction ) {
				case Direction.LEFT:
					// If the offset and image are not properly set to left-facing
					if ( facing == RIGHT ) {
						// Adjust x so that the image fits nicely
						//x -= (frameWidth - offset.x - width) - offset.x;
						// Reverse the offset
						offset.x = frameWidth - offset.x - width;
					}
					facing = LEFT;
					acceleration.x = - defaultAcceleration.x;
					velocity.x = Math.min( velocity.x, -velocity.x );
					play( CharactersConstants.NPC_WALK_ANIMATION_NAME );
					break;
				case Direction.RIGHT:
					// If the offset and image are not properly set to left-facing
					if ( facing == LEFT ) {
						// Adjust x so that the image fits nicely
						//x -= (frameWidth - offset.x - width) - offset.x;
						// Reverse the offset
						offset.x = frameWidth - offset.x - width;
					}
					facing = RIGHT;
					acceleration.x = defaultAcceleration.x;
					velocity.x = Math.max( velocity.x, -velocity.x );
					play( CharactersConstants.NPC_WALK_ANIMATION_NAME );
					break;
				default:
					throw new IllegalArgumentException( "direction", direction );
			}
		}
		
		/**
		 * Perform the attack, on the same direction
		 */
		public function attack():void {
			action = Action.ATTACKING;
			velocity.x = velocity.y = acceleration.x = 0;
			play(CharactersConstants.NPC_ATTACK_ANIMATION_NAME);
		}
		
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void {
			super.hitLeft(Contact,Velocity);
			if ( Contact is FlxTilemap ) {
				if ( facing == LEFT )
					move( Direction.RIGHT );
			}
		}
		
		override public function hitRight(Contact:FlxObject, Velocity:Number):void {
			super.hitRight(Contact,Velocity);
			if ( Contact is FlxTilemap ) {
				if ( facing == RIGHT )
					move( Direction.LEFT );
			}
		}
	}
}