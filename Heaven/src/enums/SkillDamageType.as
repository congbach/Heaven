package enums {
	
	/**
	 * SkillDamageType enum
	 * @author Ken
	 * 
	 * Represents damage type: either absolute (damage deal is directly
	 * subtracted to attacked character's stats, i.e. independent), or percentage (damage deal depends
	 * on character's stats, i.e. dependent)
	 */
	public class SkillDamageType {
		
		/**
		 * Absolute type: damage deal is directly
		 * subtracted to character's stats, i.e. independent
		 */
		static public const ABSOLUTE:SkillDamageType = new SkillDamageType();
		/**
		 * Percentage type: damage deal depends
		 * on character's stats, i.e. dependent
		 */
		static public const PERCENTAGE:SkillDamageType = new SkillDamageType();
	}
}