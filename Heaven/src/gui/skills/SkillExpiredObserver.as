package gui.skills {
	import models.skills.SkillModel;

	/**
	 * SkillExpiredObserver class
	 * 
	 * Observer pattern
	 * 
	 * Obserse to see when some skill's effect is expired
	 * Then remove animation associated to it if any
	 * 
	 * @author Ken
	 */
	public interface SkillExpiredObserver {
		
		/**
		 * Notify the observer that the skill is expired
		 * 
		 * @param	skill
		 * 			is the skill which is expired
		 */
		function skillExpired(skill:SkillModel):void;
	}
}
