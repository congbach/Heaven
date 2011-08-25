package models.stats {
	import enums.StatsType;
	
	/**
	 * Immutable Stats class
	 * @author Ken
	 * For sharing between same item/weapon
	 */
	public class ImmutableStats	{
		
		/** Get the zero absolute stats */
		static public const ZERO_ABSOLUTE_STATS:ImmutableStats = new ImmutableStats(StatsType.ABSOLUTE);		
		/** Get the identity absolute stats */
		static public const IDENTITY_ABSOLUTE_STATS:ImmutableStats =
			new ImmutableStats(StatsType.ABSOLUTE, 1, 1, 1, 1, 1, 1, 1, 1);		
		
		/** Type of this stats */
		protected var _statsType:StatsType;
		/** Maximum HP */
		protected var _maxHp:int;
		/** Current HP */
		protected var _hp:Number;
		/** Max MP */
		protected var _maxMp:int;
		/** Current MP */
		protected var _mp:Number;
		/** ATK */
		protected var _atk:int;
		/** DEF */
		protected var _def:int;
		/** SPD */
		protected var _spd:int;
		/** LUCK */
		protected var _luck:int;
		/** Experience point */
		protected var _exp:int;
		/** Level */
		protected var _level:int;
		
		/**
		 * Default contructor
		 * 
		 * @param	statsType
		 * 			is the type of this stats
		 * @param	maxHp
		 * 			is the maximum hp
		 * @param	hp
		 * 			is the hp
		 * @param	maxMp
		 * 			is the maximum mp
		 * @param	mp
		 * 			is the mp
		 * @param	atk
		 * 			is the atk
		 * @param	def
		 * 			is the def
		 * @param	spd
		 * 			is the spd
		 * @param	luck
		 * 			is the luck of the character
		 * @param	exp
		 * 			is the exp points
		 * @param	lvl
		 * 			is the level
		 */ 
		public function ImmutableStats(statsType:StatsType, maxHp:int = 0, hp:Number = 0, maxMp:int = 0,
									   mp:Number = 0, atk:int = 0, def:int = 0, spd:int = 0, luck:int = 0,
									   exp:int = 0, lvl:int = 1) {
			_statsType = statsType;
			_maxHp = maxHp; _hp = hp;
			_maxMp = maxMp; _mp = mp;
			_atk = atk; _def = def; _spd = spd; _luck = luck;
			_exp = exp; _level = lvl;
		}
		
		/**
		 * Return a reverse of this stats
		 */
		public function getReverse():ImmutableStats {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					return new ImmutableStats(_statsType, -_maxHp, -_hp, -_maxMp, -_mp,
											  -_atk, -_def, -_spd, -_luck, -_exp, -_level);
					break;
				case StatsType.PERCENTAGE:
					return new ImmutableStats(_statsType, 10000.0 / _maxHp, 10000.0 / _hp, 10000.0 / _maxMp, 10000.0 / _mp,
											  10000.0/_atk, 10000.0/_def, 10000.0/_spd, 10000.0/_luck, 10000.0/_exp, 10000.0/_level);
					break;
			}
			return null;
		}
		
		/** Get the type of this stats */
		public function get statsType():StatsType { return _statsType; }
		/** Get maximum HP */
		public function get maxHp():int { return _maxHp; }
		/** Get current HP */
		public function get hp():Number { return _hp; }
		/** Get max MP */
		public function get maxMp():int { return _maxMp; }
		/** Get current MP */
		public function get mp():Number { return _mp; }
		/** Get ATK */
		public function get atk():int { return _atk; }
		/** Get DEF */
		public function get def():int { return _def; }
		/** Get SPD */
		public function get spd():int { return _spd; }
		/** Get LUCK */
		public function get luck():int { return _luck; }
		/** Get experience point */
		public function get exp():int { return _exp; }
		/** Get the level */
		public function get level():int { return _level; }
	}
}