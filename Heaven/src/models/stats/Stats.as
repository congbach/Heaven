package models.stats {
	import enums.StatsType;
	
	/**
	 * Stats class
	 * @author Ken
	 * Represents stats for common stuff like: character, item, weapon
	 */
	public class Stats extends ImmutableStats {
		
		/** Maximum HP */
		public function set maxHp(newMaxHp:int):void { _maxHp = newMaxHp; }
		/** Current HP */
		public function set hp(newHp:Number):void { _hp = Math.min(newHp, maxHp); }
		/** Max MP */
		public function set maxMp(newMaxMp:int):void { _maxMp = newMaxMp; }
		/** Current MP */
		public function set mp(newMp:Number):void { _mp = Math.min(newMp, maxMp); }
		/** ATK */
		public function set atk(newAtk:int):void { _atk = newAtk; }
		/** DEF */
		public function set def(newDef:int):void { _def = newDef; }
		/** SPD */
		public function set spd(newSpd:int):void { _spd = newSpd; }
		/** LUCK */
		public function set luck(newLuck:int):void { _luck = newLuck; }
		/** Experience point */
		public function set exp(newExp:int):void { _exp = newExp; }
		/** Level */
		public function set level(newLvl:int):void { _level = newLvl; }
		
		/** For character only, exp required to gain level */
		public var nextLevelExp:int;
		
		/**
		 * Get a mutable stats from an immutable stats
		 * 
		 * @param	immutableStats
		 * 			is the immutableStats to convert to Stats
		 */
		static public function getStatsFromImmutableStats(immutableStats:ImmutableStats):Stats {
			return new Stats(immutableStats.statsType, immutableStats.maxHp, immutableStats.hp,
				immutableStats.maxMp, immutableStats.mp, immutableStats.atk, immutableStats.def,
				immutableStats.spd, immutableStats.luck, immutableStats.exp, immutableStats.level);
		}
		
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
		 * 			is the luck
		 * @param	exp
		 * 			is the exp points
		 * @param	lvl
		 * 			is the level
		 */ 
		public function Stats(statsType:StatsType, maxHp:int, hp:Number, maxMp:int, mp:Number, atk:int,
							  def:int, spd:int, luck:int, exp:int, lvl:int = 1) {
			super(statsType, maxHp, hp, maxMp, mp, atk, def, spd, luck, exp, lvl);
			nextLevelExp = 0;
		}
		
		/**
		 * Combine max hp of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineMaxHp(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_maxHp += stats.maxHp;
							break;
						case StatsType.PERCENTAGE:
							_maxHp *= stats.maxHp / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_maxHp *= stats.maxHp / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_maxHp *= stats.maxHp / 100;
							break;
					}
					break;
			}
		}
		
		/**
		 * Combine hp of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineHp(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_hp += stats.hp;
							break;
						case StatsType.PERCENTAGE:
							_hp *= stats.hp / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_hp *= stats.hp / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_hp *= stats.hp / 100;
							break;
					}
					break;
			}
			
//			if (_statsType == StatsType.ABSOLUTE)
//				_hp = Math.min(_hp, _maxHp);
		}
		
		/**
		 * Combine max mp of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineMaxMp(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_maxMp += stats.maxMp;
							break;
						case StatsType.PERCENTAGE:
							_maxMp *= stats.maxMp / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_maxMp *= stats.maxMp / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_maxMp *= stats.maxMp / 100;
							break;
					}
					break;
			}
		}
		
		/**
		 * Combine mp of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineMp(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_mp += stats.mp;
							break;
						case StatsType.PERCENTAGE:
							_mp *= stats.mp / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_mp *= stats.mp / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_mp *= stats.mp / 100;
							break;
					}
					break;
			}
			
//			if (_statsType == StatsType.ABSOLUTE)
//				_mp = Math.min(_mp, _maxMp);
		}
		
		/**
		 * Combine atk of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineAtk(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_atk += stats.atk;
							break;
						case StatsType.PERCENTAGE:
							_atk *= stats.atk / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_atk *= stats.atk / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_atk *= stats.atk / 100;
							break;
					}
					break;
			}
		}
		
		/**
		 * Combine def of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineDef(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_def += stats.def;
							break;
						case StatsType.PERCENTAGE:
							_def *= stats.def / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_def *= stats.def / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_def *= stats.def / 100;
							break;
					}
					break;
			}
		}
		
		/**
		 * Combine spd of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineSpd(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_spd += stats.spd;
							break;
						case StatsType.PERCENTAGE:
							_spd *= stats.spd / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_spd *= stats.spd / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_spd *= stats.spd / 100;
							break;
					}
					break;
			}
		}
		
		/**
		 * Combine exp of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineExp(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_exp += stats.exp;
							break;
						case StatsType.PERCENTAGE:
							_exp *= stats.exp / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_exp *= stats.exp / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_exp *= stats.exp / 100;
							break;
					}
					break;
			}
		}
		
		/**
		 * Combine level of this stats with another stats
		 * 
		 * @param	stats
		 * 			is the stats to combine
		 */
		public function combineLevel(stats:ImmutableStats):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_level += stats.level;
							break;
						case StatsType.PERCENTAGE:
							_level *= stats.level / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							_level *= stats.level / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							_level *= stats.level / 100;
							break;
					}
					break;
			}
		}
		
		/**
		 * Combine stats to this
		 * 
		 * @param	stats
		 * 			is the new stats to add to this
		 * @param	combineMaxHp
		 * 			indicates whether to combine max hp
		 * @param	combineHp
		 * 			indicates whether to combine hp
		 * @param	combineMaxMp
		 * 			indicates whether to combine max mp
		 * @param	combineMp
		 * 			indicates whether to combine mp
		 * @param	combineAtk
		 * 			indicates whether to combine atk
		 * @param	combineDef
		 * 			indicates whether to combine def
		 * @param	combineSpd
		 * 			indicates whether to combine spd
		 * @param	combineLuck
		 * 			indicates whether to combine luck
		 * @param	combineExp
		 * 			indicates whether to combine exp
		 * @param	combineLevel
		 * 			indicates whether to combine level
		 */
		public function combineStats(stats:ImmutableStats, combineMaxHp:Boolean = true, combineHp:Boolean = true,
									 combineMaxMp:Boolean = true, combineMp:Boolean = true, combineAtk:Boolean = true,
									 combineDef:Boolean = true, combineSpd:Boolean = true, combineLuck:Boolean = true,
									 combineExp:Boolean = true, combineLevel:Boolean = true):void {
			switch (_statsType) {
				case StatsType.ABSOLUTE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							if (combineMaxHp) _maxHp += stats.maxHp;
							if (combineHp) _hp += stats.hp; //_hp = Math.min(hp, maxHp);
							if (combineMaxMp) _maxMp += stats.maxMp;
							if (combineMp) _mp += stats.mp; //_mp = Math.min(mp, maxMp); 
							if (combineAtk) _atk += stats.atk;
							if (combineDef) _def += stats.def;
							if (combineSpd) _spd += stats.spd;
							if (combineLuck) _luck += stats.luck;
							if (combineExp) _exp += stats.exp;
							if (combineLevel) _level += stats.level;
							break;
						case StatsType.PERCENTAGE:
							if (combineMaxHp) _maxHp *= stats.maxHp / 100;
							if (combineHp) _hp *= stats.hp / 100; //_hp = Math.min(hp, maxHp);
							if (combineMaxMp) _maxMp *= stats.maxMp / 100;
							if (combineMp) _mp *= stats.mp / 100; //_mp = Math.min(mp, maxMp); 
							if (combineAtk) _atk *= stats.atk / 100;
							if (combineDef) _def *= stats.def / 100;
							if (combineSpd) _spd *= stats.spd / 100;
							if (combineLuck) _luck *= stats.luck / 100;
							if (combineExp) _exp *= stats.exp / 100;
							if (combineLevel) _level *= stats.level / 100;
							break;
					}
					break;
				case StatsType.PERCENTAGE:
					switch (stats.statsType) {
						case StatsType.ABSOLUTE:
							if (combineMaxHp) _maxHp *= stats.maxHp / 100;
							if (combineHp) _hp *= stats.hp / 100;
							if (combineMaxMp) _maxMp *= stats.maxMp / 100;
							if (combineMp) _mp *= stats.mp / 100;
							if (combineAtk) _atk *= stats.atk / 100;
							if (combineDef) _def *= stats.def / 100;
							if (combineSpd) _spd *= stats.spd / 100;
							if (combineLuck) _luck *= stats.luck / 100;
							if (combineExp) _exp *= stats.exp / 100;
							if (combineLevel) _level *= stats.level / 100;
							_statsType = StatsType.ABSOLUTE;
							break;
						case StatsType.PERCENTAGE:
							if (combineMaxHp) _maxHp *= stats.maxHp / 100;
							if (combineHp) _hp *= stats.hp / 100;
							if (combineMaxMp) _maxMp *= stats.maxMp / 100;
							if (combineMp) _mp *= stats.mp / 100;
							if (combineAtk) _atk *= stats.atk / 100;
							if (combineDef) _def *= stats.def / 100;
							if (combineSpd) _spd *= stats.spd / 100;
							if (combineLuck) _luck *= stats.luck / 100;
							if (combineExp) _exp *= stats.exp / 100;
							if (combineLevel) _level *= stats.level / 100;
							break;
					}
					break;
			}
			
		}
		
		/**
		 * Adjust hp and mp of this, so that hp <= maxHP, and mp <= maxMp
		 */
		public function adjustHpMp():void {
			_hp = Math.min(_hp, _maxHp);
			_mp = Math.min(_mp, _maxMp);
		}
		
		/**
		 * Return a clone of this
		 */
		public function clone():Stats {
			return new Stats(_statsType, maxHp, hp, maxMp, mp, atk, def, spd, luck, exp, level);
		}
		
	}
}