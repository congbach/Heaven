package gui.characters {
	import gui.skills.Skill;
	import gui.KeyboardEventsManager;
	import models.characters.CharacterModel;
	import models.characters.PlayableCharacterModel;
	import models.skills.SkillModel;
	import org.flixel.FlxGroup;
	import data.*;
	
	import embeded.*;
	
	import enums.*;
	
	import errors.*;
	
	
	
	
	/**
	 * Player class
	 * 
	 * The only playable character of the game
	 */
	public class PlayableCharacter extends Character {
		// Singleton pattern
		static private var instance:PlayableCharacter;
		static private var staticCall:Boolean = false;
		static private var canCreateNew:Boolean = true;
		
		/**
		 * Initialize the instance of this class
		 * 
		 * @param	skillsOnScreen
		 * 			is the list of skills on the screen, to add skill to
		 * 			when a character performs skill's animation
		 */
		static public function initializeInstance(skillsOnScreen:FlxGroup):PlayableCharacter {
			if ( instance == null ) {
				staticCall = true;
				instance = 
					new PlayableCharacter(
							CharactersConstants.getCharacterConstantsByCharacterCode(UnitsConstants.PLAYER),
							skillsOnScreen);
				staticCall = false;
			}
			return instance;
		}
		
		/** Return the only instance of this class */
		static public function getInstance():PlayableCharacter {
			if ( instance == null )
				throw new ErrorAndExit("Instance has yet been initialized.");
			return instance;
		}
		
		/**
		 * Reset/delete the instance
		 * WARNING: potential conflict in the player, should be called
		 * in title screen state only
		 */
		static public function reset():void {
			if (instance != null)
				instance.hardReset();
		}
		
		/** Reference to the keyboardEventsManager */
		private var _keyboardEventsManager:KeyboardEventsManager;
		/**
		 * Flag to indicate whether the player is jumping
		 * and how many jump has been performed
		 */
		private var _jumping:uint;
		/** Maximum number of jump player can perform */
		private var _maxJump:uint = 2;
		
		/**
		 * Default contrustor
		 * 
		 * Singleton pattern, will throw error if not called by the
		 * static function
		 * 
		 * @param	playerData
		 * 			is the designed data of the player
		 * @param	skillsOnScreen
		 * 			is the list of skills on the screen, to add skill to
		 * 			when a character performs skill's animation
		 */
		public function PlayableCharacter(playerData:ImmutableGameObjectData, skillsOnScreen:FlxGroup) {
			super(playerData.model as CharacterModel, skillsOnScreen);
			
			if ( ! staticCall )
				throw new NonStaticCallSingletonPattern( "Player" );
			if ( ! canCreateNew )
				throw new SingletonPatternViolatedError( "Player" );
			
			canCreateNew = false;
			
			_model = new PlayableCharacterModel(_model.baseStats, _model.lvlStatsIncrease, _model.attackingRange,
												_model.levelsSkills);
			_model.stats.nextLevelExp = GameFormula.getLevelExp(_model.stats.level);
			_keyboardEventsManager = KeyboardEventsManager.getInstance();
			
			if ( GameConstants.EMBEDED_ALL )
				loadGraphic( EmbededImages.getCharacterImageByCharacterCode( UnitsConstants.PLAYER ),
					true, true,	playerData.frameSize.width, playerData.frameSize.height );
			else
				loadBitmapDataGraphic(
					UnitsConstants.PLAYER_NAME,
					ImagesBitmapConstants.getCharacterImageBitmapDataByCharacterCode( UnitsConstants.PLAYER ),
						true, true, playerData.frameSize.width, playerData.frameSize.height );
			
			
			addAnimations( playerData.animations );
			loadPhysicsConstants( playerData.physicsData );
		}
		
		override public function update():void {
			// Flag to indicate whether the player can move horizontally
			// because when the player is attacking, the player cannot
			// move horizontally
			var moveHorizonal:Boolean = true;
			
			// If the player is currently attacking
			if ( action == Action.ATTACKING ) {
				// Did the attack finish?
				if ( ! finished ) {
					// No
					// Is the player currently on the ground
					if ( velocity.y == 0 )  {
						// Yes
						// Disable any horizontal movement
						acceleration.x = 0;
						velocity.x = 0;
						moveHorizonal = false;
					} else 
						// No
						moveHorizonal = false;
				} else {
					// Yes
					// Turn off attacking flag and reupdate
					action = Action.NORMAL;
					update();
					return;
				}
			
			// If the player just pressed the attack button
			// and the attack can be performed
			} else if ( _keyboardEventsManager.justPressed(KeyboardConstants.A) &&
						action == Action.NORMAL ) {
				// Begin the attaking animation
				action = Action.ATTACKING;
				// Is teh player on the ground
				if ( velocity.y == 0 )  {
					// Yes
					// Disable any horizontal movement
					acceleration.x = 0;
					velocity.x = 0;
					moveHorizonal = false;
				}
				play( "attack" );
			
			// If the player is currently using skill
			} else if (action == Action.PERFORMING_SKILL) {
				// Did the action finish?
				if ( ! finished ) {
					// No
					// Is the player currently on the ground
					if ( velocity.y == 0 )  {
						// Yes
						// Disable any horizontal movement
						acceleration.x = 0;
						velocity.x = 0;
						moveHorizonal = false;
					} else 
						// No
						moveHorizonal = false;
				} else {
					// Yes
					// Turn off using skill flag and reupdate
					action = Action.NORMAL;
					update();
					return;
				}
			
			// If the player just pressed the shortcut skill button
			// and the skill can be performed
			} else if ( _keyboardEventsManager.justPressed(KeyboardConstants.X) &&
						action == Action.NORMAL ) {
				// Begin the attaking animation
				action = Action.PERFORMING_SKILL;
				// Is the player on the ground
				if ( velocity.y == 0 )  {
					// Yes
					// Disable any horizontal movement
					acceleration.x = 0;
					velocity.x = 0;
					moveHorizonal = false;
				}
				useShortcutSkill();
			}
			
			if ( ! moveHorizonal ) {
				super.update(); return;
			}
			
			// Move the character based on the direction of the pressed keyboard
			switch ( _keyboardEventsManager.keyHorizontalDirectionDown ) {
				case Direction.LEFT:
					// If the offset and image are not properly set to left-facing
					if ( facing == RIGHT ) {
						// Adjust x so that the image fits nicely
						//x -= (frameWidth - offset.x - width) - offset.x;
						// Reverse the offset
						offset.x = frameWidth - offset.x - width;
					}
					facing = LEFT;
					
					acceleration.x = -defaultAcceleration.x;
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
					break;
				default: // no direction
					// Continue in the old direction
					if ( acceleration.x < 0 )
						acceleration.x = Math.min( acceleration.x + drag.x, 0);
					else if ( acceleration.x > 0 )
						acceleration.x = Math.max( acceleration.x - drag.x, 0 );
			}
			
			// If the player just pressed jump button
			if ( _keyboardEventsManager.justPressed(KeyboardConstants.B) ) {
				// If the player is currently on the ground
				if ( _jumping < _maxJump ) {
					velocity.y = -CharactersConstants.PLAYER_JUMP_MAX_Y_VELOCITY;
					_jumping++;
				}	
			}
			
			// Update jumping if player has reached the ground
			if (onFloor && velocity.y == 0) _jumping = 0;
			// update jumping if player falls from the ground
			if (((! onFloor) || velocity.y != 0) && ! _jumping) _jumping = 1;
			
			// Play the animation
			playAnimation();
			super.update();
		}
		
		/**
		 * Perform the shortcut skill
		 */
		private function useShortcutSkill():void {
			var shortcutSkill:SkillModel = (_model as PlayableCharacterModel).shortcutSkillModel;
			if (shortcutSkill != null) {
				useSkill(shortcutSkill, true);
				
				var skillName:String = UnitsConstants.getSkillName(shortcutSkill.skillCode);
				// Is there some player's animation associated to the shortcut skill?
				if (hasAnimation(skillName)) {
					// Yes
					play(skillName);					
				} else
					// No
					action = Action.NORMAL;
			}
		}
		
		/**
		 * Bind a skill to the shortcut key
		 */
		public function bindShortcutSkill(skillModel:SkillModel):void {
			(_model as PlayableCharacterModel).bindShortcutSkill(skillModel);
		}
		
		/**
		 * Play the appropriate animation
		 */
		private function playAnimation():void {
			// If the player is currently attaking
			if ( action == Action.ATTACKING ) {
				// Did the attack finish?
//				if ( ! finished )
//					// No
//					// Then continue
//					play( "attack" );
//				else {
				if (finished) {
					// Yes
					// Turn off the attacking flag and call
					// the play animation
					action = Action.NORMAL;
					playAnimation();
				}
			
			// If player just pressed the attacking button
			} else if ( _keyboardEventsManager.justPressed(KeyboardConstants.A) ) {
				action = Action.ATTACKING;
				play( "attack" );
			
			// If the player is currently jumpint
			} else if ( velocity.y != 0 ) play( "jump" );
			// If the player is moving
			else if(velocity.x != 0 ) play( "walk" );
			// If the player is lying down
			else if ( _keyboardEventsManager.pressed(KeyboardConstants.DOWN) ) play( "lieDown" );
			// If player is doing nothing
			else play( "idle" );
		}
		
		/**
		 * Soft reset, for changing between map
		 */
		public function softReset():void {
			var i:int = 0;
			while (i < _skillsAnimations.length) {
				var skillAnim:Skill = _skillsAnimations[i];
				// If the skill exists and follows this, then do not kill it
				if (skillAnim.exists && skillAnim.isFollowing) i++;
				else {
					skillAnim.kill();
					_skillsAnimations.splice(i, 1);
				}
			}
		}
		
		/**
		 * Hard reset, for resetting game
		 */
		public function hardReset():void {
			super.reset(0, 0);
			_model.reset(UnitsConstants.PLAYER, UnitsConstants.PLAYER_NAME,
					CharactersConstants.getCharacterConstantsByCharacterCode(UnitsConstants.PLAYER).baseStats);
		}
		
	}
}