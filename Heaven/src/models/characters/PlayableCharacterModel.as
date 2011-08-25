package models.characters {
	import data.UnitsConstants;
	import data.CharactersConstants;
	import models.stats.PercentageStats;
	import models.stats.Stats;
	import models.skills.SkillModel;
	
	import org.flixel.FlxPoint;

	/**
	 * PlayableCharacterModel class
	 * 
	 * Extends PlayableCharacter
	 * 
	 * Contains some information associated only to playable characters
	 * such as shortcut skill,...
	 * 
	 * @author Ken
	 */
	public class PlayableCharacterModel extends CharacterModel {
		
		/**
		 * The skill which is bind to the shortcut key
		 */
		private var _shortcutSkillModel:SkillModel;
		/**
		 * The skill which is bind to the shortcut key
		 */
		public function get shortcutSkillModel():SkillModel { return _shortcutSkillModel; }
		
		/**
		 * Default constructor
		 * 
		 * @param	baseStats
		 * 			is the base stats of this character
		 * @param	lvlStatsIncrease
		 * 			is the increase in stats of this character when leveling up
		 * @param	attackingRange
		 * 			is the range to increase in the offset of
		 * 			the character when currently attacking
		 * @param	lvlSkills
		 * 			is hash map/table of skills character will learn when level up
		 */
		public function PlayableCharacterModel(baseStats:Stats, lvlStatsIncrease:PercentageStats,
									    attackingRange:FlxPoint, lvlSkills:Object = null) {	
			super(UnitsConstants.PLAYER, UnitsConstants.PLAYER_NAME,
					baseStats, lvlStatsIncrease, attackingRange, null, lvlSkills);
		}
		
		/**
		 * Bind a skill to shortcut
		 * 
		 * @param	skillModel
		 * 			is the model of the skill to bind to the shortcut
		 */
		public function bindShortcutSkill(skillModel:SkillModel):void {
			_shortcutSkillModel = skillModel;
		}
		
//		override public function constructFromSaveObject(model:Object):void {
//			super.constructFromSaveObject(model);
//		}
//		
//		override public function getSaveObject():Object {
//			var save:Object = super.getSaveObject();
//			return save;
//		}
	}
}
