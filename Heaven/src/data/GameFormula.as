package data {
	import enums.StatsType;
	
	import models.characters.CharacterModel;
	import models.stats.ImmutableStats;
	import models.stats.Stats;
	
	import org.flixel.FlxG;
	
	/**
	 * GameFormular class
	 * @author Ken
	 * 
	 * contains various formula in the game, like how damage is calculated based
	 * on characters' stats, how level exp is calculated, and so on
	 */
	public class GameFormula {
		
		/**
		 * Return the damage of normal attack, based on the stats of two characters
		 * 
		 * @param	attackingCharacterMdel
		 * 			is the model of the attacking character
		 * @param	attackedCharacter
		 * 			is the model of the attacked character
		 * 
		 * @return	the damage attacking character does to attacked character
		 */
		static public function getNormalAttackDamage(attackingCharacterModel:CharacterModel,
													 attackedCharacterModel:CharacterModel):Number {
			return (Math.max(attackingCharacterModel.stats.atk - attackedCharacterModel.stats.def,
							GameConstants.MIN_NORMAL_ATTACK_DAMAGE) as Number) / FlxG.framerate;
		}
		
		/**
		 * Return the damage of the attack, based on two stats
		 * 
		 * @param	attackingStats
		 * 			is the stats of the attack, must be of ABSOLUTE type
		 * @param	attackedCharacterStats
		 * 			is the stats of the attacked character
		 * 
		 * @return	the stats the attack does to attacked character
		 */
		static public function getAttackDamageStats(attackingStats:Stats,
											   attackedCharacterStats:Stats):ImmutableStats {
			switch (attackingStats.statsType) {
				case StatsType.PERCENTAGE:
					return attackingStats;
				case StatsType.ABSOLUTE:
					var hpDamage:int = Math.max(attackingStats.atk - attackedCharacterStats.def,
												GameConstants.MIN_NORMAL_ATTACK_DAMAGE);
					return new ImmutableStats(StatsType.ABSOLUTE, attackingStats.maxHp, hpDamage,
												attackingStats.maxMp, attackingStats.mp, attackingStats.atk,
												attackingStats.def, attackingStats.exp, attackingStats.level);
			}
			return null;
		}
		
		/**
		 * Return the damage of the attack, based on two stats
		 * 
		 * @param	attackingStats
		 * 			is the stats of the attack, must be of ABSOLUTE type
		 * @param	attackedCharacterStats
		 * 			is the stats of the attacked character
		 * 
		 * @return	the stats the attack does to attacked character
		 */
		static public function getAttackDamage(attackingStats:Stats,
													attackedCharacterStats:Stats):Number {
			switch (attackingStats.statsType) {
				case StatsType.PERCENTAGE:
					return attackingStats.hp * attackedCharacterStats.hp / 100;
				case StatsType.ABSOLUTE:
					return Math.max(attackingStats.atk - attackedCharacterStats.def,
									GameConstants.MIN_NORMAL_ATTACK_DAMAGE);
			}
			return 0;
		}
		
		/**
		 * Get the required exp for player to be proceed to some level
		 * 
		 * @param	level
		 * 			is the level to return the exp to proceed to that level
		 */
		static public function getLevelExp(level:uint):int {
			return level * (level + 1) * 50;
		}
	}
}