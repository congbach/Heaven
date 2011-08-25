package enums {
	
	/**
	 * SkillType enums
	 * @author Ken
	 * 
	 * Represents type of a skill: ATTACK, BUFF, DEBUFF, SUMMON,...
	 */
	public class SkillType {
		
		/** Attack type */
		static public const ATTACK:SkillType = new SkillType();
		/** Buff type */
		static public const BUFF:SkillType = new SkillType();
		/** Debuff type */
		static public const DEBUFF:SkillType = new SkillType();
		/** Summon type */
		static public const SUMMON:SkillType = new SkillType();
		/** Action type: jump, slide, ...*/
		static public const ACTION:SkillType = new SkillType();
		/** Non of the above */
		static public const OTHER:SkillType = new SkillType();
	}
}