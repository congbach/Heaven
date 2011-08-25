package enums {
	
	/**
	 * SkillItemEffectType
	 * @author Ken
	 * 
	 * Represents effect type of skill and item: ONCE, PER_SECOND,...
	 */
	public class SkillItemEffectType {
		
		/** Effect one time only */
		static public const ONCE:SkillItemEffectType = new SkillItemEffectType();
		/** Effect last per second */
		static public const PER_SECOND:SkillItemEffectType = new SkillItemEffectType();
	}
}