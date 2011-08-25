package data {
	import models.stats.Stats;

	/**
	 * @author Ken
	 */
	public interface GameObjectModel {
		
		/** Base stats of this game objects */
		function get baseStats():Stats;
		/** Name of this game object */
		function get name():String;
		
		/** Return an exact clone of this game object */
		function clone():GameObjectModel;
	}
}
