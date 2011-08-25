package enums {
	
	/**
	 * Action Class
	 * 
	 * Enum for action: attacking, defending,...
	 */ 
	public class Action {
		/** Enum for normal action like: walk, move, jump,... */
		static public const NORMAL:Action = new Action();
		/** Enum for attacking */
		static public const ATTACKING:Action = new Action();
		/** Enum for performing skill */
		static public const PERFORMING_SKILL:Action = new Action();
	}
}