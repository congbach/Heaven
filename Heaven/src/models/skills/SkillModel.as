package models.skills {
	import models.stats.Stats;
	import models.stats.ImmutableStats;
	import models.characters.CharacterModel;
	import gui.skills.SkillExpiredObserver;
	import data.GameFormula;
	
	import enums.SkillActivePassiveType;
	import enums.SkillDamageType;
	import enums.SkillItemEffectType;
	import enums.SkillType;
	import enums.StatsType;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * SkillModel class
	 * @author Ken
	 * 
	 * Represents the model of the skill: stats, effects,...
	 */
	public class SkillModel	implements SkillExpiredObserved {
		
		/** Code of this skill */
		private var _skillCode:int;
		public function get skillCode():int { return _skillCode; }
		/** Name of this skill */
		private var _skillName:String;
		public function get skillName():String { return _skillName; }
		/** Description of this skill */
		private var _description:String;
		public function get description():String { return _description; }
		/** Type of this skill: passive or active */
		private var _skillActivePassiveType:SkillActivePassiveType;
		public function get skillActivePassiveType():SkillActivePassiveType {
			return _skillActivePassiveType;
		}
		/** Type of this skill: atk, buff, debuff, summon, action,...*/
		private var _skillType:SkillType;
		public function get skillType():SkillType { return _skillType; }
		/** Damage type of this skill */
		private var _skillDamageType:SkillDamageType;
		public function get skillDamageType():SkillDamageType { return _skillDamageType; }
		/** Base stats of this skill */
		private var _baseStats:Stats;
		/** Stats of this skills */
		private var _stats:Stats;
		/** Damage stats of this skill */
		private var _damageStats:Stats;
		public function get damageStats():Stats { return _damageStats; }
		/** Initial cost of this skill */
		private var _mpCost:int;
		/** Cool down time (in frames) of this skill */
		private var _coolDown:int;
		/** For active skill only: initial velocity of this skill */
		private var _velocity:FlxPoint;
		/** For passive skill only: mp cost per second of this skill */
		private var _mpCostPerFrame:Number;
		/** For passive skill only: effect type of this skill */
		private var _effectType:SkillItemEffectType;
		/** For passive skill only: duration of this skill, in frames */
		private var _duration:int;
		/** Remaining duration of the skill, in frames */
		private var _remainingDuration:int;
		/** Current cool down time (in frames) of this skill */
		private var _currentCoolDown:int;
		/** Flag to indicate whether this skill is available to use */
		public function get isAvailable():Boolean {
			return (! enabled) && _remainingDuration <= 0 && _currentCoolDown <= 0;
		}
		/** Flag to see whether this is enabled or not */
		//private var _enabled:Boolean;
		/** Flag to see whether this is enabled or not */
		public function get enabled():Boolean { return _target != null; }//_enabled; }
		/** Current target of this skill */
		private var _target:CharacterModel;
		
		/**
		 * Default constructor
		 * 
		 * @param	skillCode
		 * 			is the code of this skill
		 * @param	skillName
		 * 			is the name of this skill
		 * @param	skillActivePassiveType
		 * 			is the type of this skill, ACTIVE or PASSIVE
		 * @param	skillType
		 * 			is the type of the skill: ATTACK, BUFF, DEBUFF,...
		 * @param	skillDamageType
		 * 			is the damage type of this skill
		 * @param	baseStats
		 * 			is the base stats of this skill
		 * @param	mpCost
		 * 			is the initial mp cost of this skill
		 * @param	description
		 * 			is the description of the skill
		 * @param	coolDown
		 * 			is the smallest interval between uses of this skill - in seconds
		 * @param	mpCostPerSecond
		 * 			is the mp cost per second of this skill (passive skill only)
		 * @param	effectType
		 * 			is the effect type of this skill, passive skill only
		 * @param	duration
		 * 			is the duration, in seconds, of the skill (passive and of effect type 'once' only)
		 * @param	velocity
		 * 			is the initial velocity of this skill (active skill only)
		 * @param	stats
		 * 			is the current stats of this skill
		 * @param	damageStats
		 * 			is the damage stats of this skill
		 */
		public function SkillModel(skillCode:int, skillName:String,
								   skillActivePassiveType:SkillActivePassiveType, skillType:SkillType,
								   skillDamageType:SkillDamageType, baseStats:Stats, mpCost:int,
								   description:String = "", coolDown:Number = 0, mpCostPerSecond:Number = 0, 
								   effectType:SkillItemEffectType = null, duration:int = 0,
								   velocity:FlxPoint = null, stats:Stats = null, damageStats:Stats = null) {
			_skillCode = skillCode; _skillName = skillName;
			_skillActivePassiveType = skillActivePassiveType;
			_skillType = skillType; _skillDamageType = skillDamageType; 
			_baseStats = baseStats; _stats = stats; _damageStats = damageStats;
			_description = description;
			if (_stats == null) _stats = _baseStats.clone();
			_mpCost = mpCost; _mpCostPerFrame = mpCostPerSecond / FlxG.framerate;
			_duration = duration * FlxG.framerate;
			if (effectType == null) _effectType = SkillItemEffectType.ONCE;
			else _effectType = effectType;
			_coolDown = coolDown * FlxG.framerate;
			if (velocity == null)	_velocity = new FlxPoint();
			else 	_velocity = velocity;
//			_enabled = false;
		}
		
		/**
		 * Return whether this can be use by some character
		 * 
		 * @param	characterModel
		 * 			is the model of the character to check whether
		 * 			he/she can use this skill
		 */
		public function canBeUsedBy(characterModel:CharacterModel):Boolean {
			if (! this.isAvailable) return false;
			
			return characterModel.stats.mp >= _mpCost;
		}
		
		/**
		 * Use this skill by some character
		 * 
		 * @param	characterModel
		 * 			is the model of the character who uses this skill
		 * 			
		 * @return	true
		 * 			if the skill is used successfully
		 * 			false otherwise
		 */
		public function usedBy(characterModel:CharacterModel):Boolean {
			if (! canBeUsedBy(characterModel)) return false;
			
			characterModel.stats.mp -= _mpCost;
			
			_damageStats = _stats.clone();
			// change the stats of this stats, based on the type of the skill
			switch (_skillType) {
				case SkillType.ATTACK:
					// combine atk only
					_damageStats.combineAtk(characterModel.stats);
					break;
				case SkillType.BUFF:
					switch (_effectType) {
						case SkillItemEffectType.ONCE:
							// change the stats of the character
							//characterModel.stats.combineStats(_damageStats);
							//characterModel.stats.adjustHpMp();
							// start the duration interval
							//_remainingDuration = _duration;
							break;
						case SkillItemEffectType.PER_SECOND:
							// scale the _damageStats so that it reflects
							// change per frame
							var fps:int = FlxG.framerate;
							var scale:Number = 100.0 / fps;
							var scaleStats:ImmutableStats =
								new ImmutableStats(StatsType.PERCENTAGE, scale, scale,
									scale, scale, scale, scale, scale, scale, scale, scale);
							_damageStats.combineStats(scaleStats);
					}
					break;
				case SkillType.DEBUFF: case SkillType.ACTION:
				case SkillType.SUMMON: case SkillType.OTHER:
					break;
			}
			
			switch (_skillType) {
				case SkillType.BUFF:
//					_enabled = true;
			}
			return true;
		}
		
		/**
		 * Reapply the effects of this skill on the character
		 * Call when base stats of character changes, or some skills
		 * end their effects
		 */
		public function reUsed():void {
			if (! enabled) return;
			
			// change the stats of this stats, based on the type of the skill
			switch (_skillType) {
				case SkillType.ATTACK:
					break;
				case SkillType.BUFF:
					switch (_effectType) {
						case SkillItemEffectType.ONCE:
							// change the stats of the character
							_target.stats.combineStats(_damageStats);
							_target.stats.adjustHpMp();
							// start the duration interval
							_remainingDuration = _duration;
							break;
						case SkillItemEffectType.PER_SECOND:
					}
					break;
				case SkillType.DEBUFF: case SkillType.ACTION:
				case SkillType.SUMMON: case SkillType.OTHER:
					break;
			}
		}
		
		/**
		 * Unused this skill
		 */
		public function unUsed():void {
			if (! enabled) return;
			
//			_enabled = false;
			_remainingDuration = 0;
			_currentCoolDown = _coolDown;
			var target:CharacterModel = _target;
			_target = null;
			target.reCalculateStats();
			notifySkillExpiredObservers();
		}
		
		/**
		 * Use this skill on some character
		 * 
		 * @param	characterModel
		 * 			is the model of the character on which this skill is used	
		 */
		public function usedOn(characterModel:CharacterModel):void {			
			switch (_skillType) {
				case SkillType.ATTACK:
					characterModel.stats.hp -=
						GameFormula.getAttackDamage(_damageStats, characterModel.stats); 
					break;
				case SkillType.BUFF:
				case SkillType.DEBUFF:
					characterModel.stats.combineStats(_damageStats);
					characterModel.stats.adjustHpMp();
					_target = characterModel;
					_target.addAffectedSkill(this);
					_remainingDuration = _duration;
					break;
				case SkillType.ACTION:
				case SkillType.SUMMON:
				case SkillType.OTHER:
					break;
			}
		}
		
		/**
		 * Update this skill in every frame
		 * 
		 * @return	true	if the cooldown is over,...,
		 * 		 			i.e. no more effects is needed
		 * 		 	false	otherwise
		 */
		public function update():Boolean {
			if (_currentCoolDown > 0)
				return --_currentCoolDown == 0;
			else return true;		
		}
		
		/**
		 * Update the effect of this skill on the target
		 * 
		 * @return	true	if the effect is over
		 * 			false	otherwise
		 */
		public function updateEffect():Boolean {
			if (! enabled) return true;
			
			if (_skillActivePassiveType == SkillActivePassiveType.ACTIVE &&
				_effectType == SkillItemEffectType.ONCE && _remainingDuration-- <= 0) {
				unUsed();
				return true;
			}
				
			if (_effectType == SkillItemEffectType.PER_SECOND) {
				// Reduce mp of character per mpCostPerSecond
				if (_target.stats.mp < _mpCostPerFrame) {
					unUsed();
					return true;
				}					
				_target.stats.mp -= _mpCostPerFrame;
				switch (_skillType) {
					case SkillType.ATTACK:
						_target.stats.hp -=
						GameFormula.getAttackDamage(_damageStats, _target.stats); 
						break;
					case SkillType.BUFF:
					case SkillType.DEBUFF:
						_target.stats.combineStats(_damageStats);
						_target.stats.adjustHpMp();
						break;
					case SkillType.ACTION:
					case SkillType.SUMMON:
					case SkillType.OTHER:
						break;
				}
			}
			return false;
		}
		
		/**
		 * Return a clone of this skill model
		 */
		public function clone():SkillModel {
			return	new SkillModel(_skillCode, _skillName, _skillActivePassiveType, _skillType, _skillDamageType,
								  _baseStats.clone(), _mpCost, _description, _coolDown, _mpCostPerFrame * FlxG.framerate,
								  _effectType, _duration / FlxG.framerate, _velocity, _stats, _damageStats);
		}
		
		//==================
		// OBSERVER PATTERN
		//==================
		
		/**
		 * List of all the SkillExpiredObserver
		 */
		private var _skillExpiredObservers:Vector.<SkillExpiredObserver> = new Vector.<SkillExpiredObserver>();
		
		public function addSkillExpiredObserver(observer:SkillExpiredObserver):void {
			_skillExpiredObservers.push(observer);
		}
		
		public function notifySkillExpiredObservers():void {
			for each (var skillExpiredObservers:SkillExpiredObserver in _skillExpiredObservers)
				skillExpiredObservers.skillExpired(this);
			
			// Done with one cycle, we no longer need those observer
			removeSkillExpiredObservers();
		}
		
		public function removeSkillExpiredObservers():void {
			_skillExpiredObservers.splice(0, _skillExpiredObservers.length);
		}
	}
}