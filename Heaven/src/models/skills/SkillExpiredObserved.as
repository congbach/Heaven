package models.skills {

	import gui.skills.SkillExpiredObserver;
	/**
	 * SkillExpiredObserver class
	 * 
	 * Observer pattern
	 * 
	 * Obserse to see when some skill's effect is expired
	 * Then remove animation associated to it if any
	 * 
	 * This is the observed
	 * 
	 * @author Ken
	 */
	public interface SkillExpiredObserved {
		
		/**
		 * Add a new observer
		 * 
		 * @param	observer
		 * 			is the new observer to add to
		 */
		function addSkillExpiredObserver(observer:SkillExpiredObserver):void;
		
		/**
		 * Notify all the observers
		 */
		function notifySkillExpiredObservers():void;
	}
}
