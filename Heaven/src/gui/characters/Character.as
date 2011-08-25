package gui.characters {
	import gui.GameSprite;
	import gui.skills.SkillFactory;
	import gui.skills.Skill;
	import gui.skills.SkillExpiredObserver;
	import org.flixel.data.FlxAnim;
	import enums.Direction;
	import org.flixel.FlxObject;
	import org.flixel.FlxGroup;
	import data.SkillsConstants;
	import models.skills.SkillModel;
	import data.CharactersConstants;
	import data.GameConstants;
	
	import enums.Action;
	
	import models.characters.CharacterModel;
	import models.items.ItemModel;
	import models.skills.SkillAnimationData;
	
	import org.flixel.FlxG;
	
	/**
	 * Character class
	 * @author Ken
	 * represents all living characters
	 * Player is controled by real player
	 * Each NPC is controls by AI
	 * other than that there is no difference between
	 * Player and NPC
	 */
	public class Character extends GameSprite implements SkillExpiredObserver {
		
		/** The model of the character */
		protected var _model:CharacterModel;
		/**
		 * The model of the character
		 */
		public function get model():CharacterModel { return _model; }
		/** The action the character is currently doing */
		public var action:Action;
		/** Blinking time, active when get hit */
		protected var _blink:uint;
		/**
		 * List of skills on the screen, to add skill to when a character performs
		 * skill's animation
		 */
		protected var _skillsOnScreen:FlxGroup;
		/**
		 * List of animation of skills of this character only
		 */
		protected var _skillsAnimations:Vector.<Skill>;
		
		/**
		 * Default contructor
		 * 
		 * @param	model
		 * 			is the model of the character
		 * @param	skillsOnScreen
		 * 			is the list of skills on the screen, to add skill to
		 * 			when a character performs skill's animation
		 */
		public function Character(model:CharacterModel, skillsOnScreen:FlxGroup) {
			super( 0, 0, null );
			action = Action.NORMAL;
			_skillsOnScreen = skillsOnScreen;
			_skillsAnimations = new Vector.<Skill>();
			
			resetCharacter(model);
		}
		
		
		
		/** Get whether this object is blinking */
		public function get isBlinking():Boolean {
			return _blink > 0;
		}
		
		/**
		 * Reset this character
		 * 
		 * @param	model
		 * 			is the new model for this sprite
		 */
		public function resetCharacter(model:CharacterModel, ...args):void {
			_model = model;
			// learn skill if necessary
			//model.learnLevelsSkills();
			for each (var skillAnim:Skill in _skillsAnimations)
				skillAnim.kill();
			_skillsAnimations.splice(0, _skillsAnimations.length);
			play(CharactersConstants.NPC_IDLE_ANIMATION_NAME, true);
			super.resetSprite();
		}
		
		/**
		 * Update the position and size so that it is correctly the current action's desired
		 * position and size (for overlap detection)
		 */
		public function updatePositionAndSize():void {			
			_origPos.x = x; _origPos.y = y;
			if (action == Action.ATTACKING) {
				width += _model.attackingRange.x;
				height += _model.attackingRange.y;
				
				// Adjust offset based on the facing
				if (facing == LEFT)
					x -= _model.attackingRange.x;
				
			}
		}
		
		/**
		 * Reset the position and size so that image is draw correctly
		 */
		public function resetPositionAndSize():void {
			x = _origPos.x; y = _origPos.y;
			width = _defaultOffsetSize.width;
			height = _defaultOffsetSize.height;
		}

		/**
		 * Being attacked by a damage
		 * die if hp left is zero
		 * 
		 * @param	damage
		 * 			is the calculated damage this character will receive
		 */
		public function attacked(damage:Number):void {
			_model.stats.hp -= damage;
			
			// Kill this character if hp is 0 or lower
			if (model.stats.hp <= 0) kill();
			
			// start blinking
			if (! dead) {
				_blink = Math.round(GameConstants.BLINKING_TIME * FlxG.framerate);
				this.alpha = GameConstants.BLINKING_ALPHA;
			}
		}
		
		override public function update():void {
			_model.update();
			if (! _model.isAlive) kill();
			super.update();
			// Is this blinking but the blinking is over?
			if (_blink && !--_blink) this.alpha = 1;
		}
		
		/**
		 * Take effect of a certain item when used
		 */
		public function takeItemEffect(item:ItemModel):void {
			_model.useItem(item);
		}
		
		/**
		 * Use a certain skill
		 * 
		 * @param	skill
		 * 			is the skill to use
		 * @param	animated
		 * 			indicates whether to enable animation
		 */
		public function useSkill(skill:SkillModel, animated:Boolean = true):void {
			// If the skill is used successfully
			if (_model.useSkill(skill)) {				
				var skillAnimationData:SkillAnimationData;
				// If animation is enabled, and this skill has animation
				if (animated &&
					(skillAnimationData = SkillsConstants.getSkillAnmationDataBySkillCode(skill.skillCode)) != null) {					
					skill.addSkillExpiredObserver(this);
					var direction:Direction = facing == LEFT ? Direction.LEFT : Direction.RIGHT;
					var skillX:Number = direction == Direction.LEFT ?
											x - skillAnimationData.physicsData.offsetSize.width
										:	x + width + 1;
					var skillY:Number = y + (height - skillAnimationData.physicsData.offsetSize.height) / 2;
//					var skillAnimation:Skill = SkillFactory.createSkill(skill.clone(), direction, skillX, skillY,
//												this, _skillsOnScreen.getFirstAvail() as Skill);
					var skillAnimation:Skill = SkillFactory.createSkill(skill.clone(), direction, skillX, skillY,
												this, null);
					_skillsOnScreen.add(skillAnimation);
					_skillsAnimations.push(skillAnimation);
				}
			}
		}
		
		/**
		 * Return whether this player has some animation or not
		 * 
		 * @param	name
		 * 			is the name of the animation
		 * @return	whether this player has animation with the given
		 * 			name or not
		 */
		public function hasAnimation(name:String):Boolean {
			for each (var animation:FlxAnim in _animations)
				if (animation.name == name)
					return true;
			return false;
		}
		
		/**
		 * Unused a certain skill
		 * 
		 * @param	skill
		 * 			is the skill to unuse
		 */
		public function unuseSkill(skill:SkillModel):void {
			_model.unUseSkill(skill);
			stopSkillAnimation(skill);
		}
		
		public function skillExpired(skill:SkillModel):void {
			stopSkillAnimation(skill);
		}
		
		/**
		 * Stop the animation of a skill
		 * 
		 * @param	skill
		 * 			is the skill to stop the animation
		 */
		public function stopSkillAnimation(skill:SkillModel):void {
			for each (var skillAnim:Skill in _skillsAnimations)
				if (skillAnim.model.skillCode == skill.skillCode)
					skillAnim.kill();
		}
		
		/**
		 * Take effect of a certain skill
		 * 
		 * @param	skill
		 * 			is the skill to take effect
		 */
		public function takeSkillEffect(skill:SkillModel):void {
			_model.takeSkillEffect(skill);
		}
		
		//=======================
		// DATA RELATED TO MODEL
		//=======================
		
		// We replicate model data here to avoid direct changing of moel
		///** Get maximum HP of the character */
		//public function get maxHp():uint { return model.stats.maxHp; }
		///** Get current HP of the character */
		//public function get hp():int { return model.stats.hp };
		///** Get max MP of the character */
		//public function get maxMp():uint { return model.stats.maxMp; }
		///** Get current MP of the character */
		//public function get mp():int { return model.stats.mp; }
		///** Get ATK of the character */
		//public function get atk():uint { return model.stats.atk; }
		///** Get DEF of the character */
		//public function get def():uint { return model.stats.def; }
		///** Get detecting range of the character */
		//public function get detectingRange():FlxPoint { return model.detectingRange; }
		///** Get attacking range of the character */
		//public function get attackingRange():FlxPoint { return model.attackingRange; }
	}
}