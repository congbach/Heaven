package gui.skills {
	import gui.characters.Character;
	import enums.SkillType;
	import data.ImagesBitmapConstants;
	import data.UnitsConstants;
	import data.GameConstants;
	import org.flixel.FlxSprite;
	import data.SkillsConstants;
	import models.skills.SkillModel;
	import enums.Direction;
	import models.skills.SkillAnimationData;
	
	/**
	 * SkillFactory class
	 * @author Ken
	 * 
	 * Factory pattern
	 * Create skill of various types
	 */
	public class SkillFactory {
		
		/**
		 * Create a skill based on the type
		 * 
		 * @param	skillCode
		 * 			is the code of this skill
		 * @param	x
		 * 			is the x-coordinate
		 * @param	y
		 * 			is the y-coordinate
		 * @param	model
		 * 			is the model of this skill
		 * @param	direction
		 * 			is the direction of the skill
		 * @param	character
		 * 			is the character who performs the skill
		 * @param	existedSkill
		 * 			is the existed skill, for recycle purpose
		 * 
		 * @return	the skill with the given information
		 */
		static public function createSkill(model:SkillModel, direction:Direction, x:Number, y:Number,
										   character:Character, existedSkill:Skill = null):Skill {
			var skill:Skill;
			var skillAnimationData:SkillAnimationData =
				SkillsConstants.getSkillAnmationDataBySkillCode(model.skillCode);
				
			var followCharacter:Boolean = false;
			// If this skill is buff, then make it follow the character
			if (model.skillType == SkillType.BUFF)
				followCharacter = true;
			var xDist:Number, yDist:Number;
			if (followCharacter) {
				xDist = (character.frameWidth - skillAnimationData.width) / 2;
				yDist = (character.frameHeight - skillAnimationData.height) / 2;
			}
			var solid:Boolean = !followCharacter;
			
			if (existedSkill != null) {
				skill = existedSkill;
				if (followCharacter)
					skill.resetSkill(model, skillAnimationData.physicsData.range, character, 0, 0, 
									 followCharacter, xDist, yDist, solid);
				else skill.resetSkill(model, skillAnimationData.physicsData.range, character, x, y,
										followCharacter, 0, 0, solid);
			} else if (followCharacter)
				skill = new Skill(model, skillAnimationData.physicsData.range, character, 0, 0, followCharacter,
								  xDist, yDist, solid);
			else skill = new Skill(model, skillAnimationData.physicsData.range, character, x, y);
			
//			if (!followCharacter) skill.reset(x, y); 
				
			if ( GameConstants.EMBEDED_ALL )
				trace("Embeded skills images have not been implemented");
			else
				skill.loadBitmapDataGraphic(
					UnitsConstants.getSkillName(model.skillCode),
					ImagesBitmapConstants.getSkillImageBitmapDataByskillCode(model.skillCode),
					true, true, skillAnimationData.width, skillAnimationData.height );
			
			skill.addAnimations(skillAnimationData.animations);
			skill.loadPhysicsConstants(skillAnimationData.physicsData);
			
			if (direction.hasLeftDirection())
				skill.facing = FlxSprite.LEFT;
			
			switch (direction) {
				case Direction.RIGHT:
					skill.velocity.x = skillAnimationData.physicsData.initialVelocity;
					break;
				case Direction.LEFT:
					skill.velocity.x = -skillAnimationData.physicsData.initialVelocity;
					break;
			}
			skill.maxVelocity.x = Math.abs(skill.velocity.x);
			skill.maxVelocity.y = Math.abs(skill.velocity.y);
			skill.play(SkillsConstants.SKILL_ATTACKING_ANIMATION);
			
			
			return skill;
		}
	}
}