package models.stats {
	import enums.StatsType;
	
	/**
	 * PercentageStats
	 * @author Ken
	 * 
	 * Represents the increase in stats in level up
	 */
	public class PercentageStats {
		
		/** The average percentage of increase in max HP */
		private var _maxHp:Number;
		/** The average percentage of increase in max HP */
		public function get maxHp():Number { return _maxHp; }
		/** The average percentage of increase in max MP */
		private var _maxMp:Number;
		/** The average percentage of increase in max MP */
		public function get maxMp():Number { return _maxMp; }
		/** The average percentage of increase in atk */
		private var _atk:Number;
		/** The average percentage of increase in atk */
		public function get atk():Number { return _atk; }
		/** The average percentage of increase in def */
		private var _def:Number;
		/** The average percentage of increase in def */
		public function get def():Number { return _def; }
		
		/**
		 * Default constructor
		 * 
		 * @param	maxHp
		 * 			is the average percentage of increase in max hp
		 * @param	maxMp
		 * 			is the average percentage of increase in max mp
		 * @param	atk
		 * 			is the average percentage of increase in atk
		 * @param	def
		 * 			is the average percentage of increase in def
		 */
		public function PercentageStats(maxHp:Number, maxMp:Number, atk:Number, def:Number) {
			_maxHp = maxHp; _maxMp = maxMp; _atk = atk; _def = def;
		}
		
		/**
		 * Return a stats to increase when leveling up
		 */
		public function generateStats():ImmutableStats {
			var maxHp:int = Math.round(2 * this.maxHp * Math.random());
			var hp:int = maxHp;
			var maxMp:int = Math.round(2 * this.maxMp * Math.random());
			var mp:int = maxMp;
			var atk:int = Math.round(2 * this.atk * Math.random());
			var def:int = Math.round(2 * this.def * Math.random());
			
			return new ImmutableStats(StatsType.ABSOLUTE, maxHp, hp, maxMp, mp, atk, def);
		}
		
		/**
		 * Return a clone of this
		 */
		public function clone():PercentageStats {
			return new PercentageStats(maxHp, maxMp, atk, def);
		}
	}
}