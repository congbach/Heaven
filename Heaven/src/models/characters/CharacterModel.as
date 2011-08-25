package models.characters {
	import models.items.ItemModel;
	import models.stats.ImmutableStats;
	import models.stats.PercentageStats;
	import models.stats.Stats;
	import models.skills.SkillModel;
	import models.equipments.EquipmentModel;
	import data.GameObjectModel;
	import enums.EquipmentPosition;
	import data.GameConstants;
	import data.GameFormula;
	import data.SkillsConstants;
	import data.UnitsConstants;
	
	import enums.SkillActivePassiveType;
	import enums.SkillType;
	import enums.StatsType;
	
	import org.flixel.FlxPoint;
	
	/**
	 * CharacterModel
	 * @author Ken
	 * The model of the character
	 * Contains statistics like hp, mp, atk, def
	 */
	public class CharacterModel	implements GameObjectModel {
//		/** Maximum HP of the character */
//		private var _maxHp:uint;
//		/** Current HP of the character */
//		private var _hp:int;
//		/** Max MP of the character */
//		private var _maxMp:uint;
//		/** Current MP of the character */
//		private var _mp:int;
//		/** ATK of the character */
//		private var _atk:uint;
//		/** DEF of the character */
//		private var _def:uint;
//		/** Detecting range of the character */
//		private var _detectingRange:FlxPoint;
//		/** Attacking range of the character */
//		private var _attackingRange:FlxPoint;
		/** The code of this character */
		private var _characterCode:int;
		/** The code of this character */
//		public function get characterCode():int { return _characterCode; }
		public function get code():int { return _characterCode; }
		/** The name of this character */
		private var _characterName:String;
		/** The name of this character */
//		public function get characterName():String { return _characterName; }
		/** The name of this character */
		public function get name():String { return _characterName; }
		/** Base stats of the character */
		private var _baseStats:Stats;
		public function get baseStats():Stats { return _baseStats.clone(); }
		/** Stats of the character */
		private var _stats:Stats;
		/** Stats of the character */
		public function get stats():Stats { return _stats; }
		/** The increase in stats when level up */
		public var lvlStatsIncrease:PercentageStats;
		/** The object which stores the skills character will learn when level up */
		private var _levelsSkills:Object;
		public function get levelsSkills():Object {
			var levelsSkillsClone:Object = new Object();
			for (var key:String in _levelsSkills)
				levelsSkillsClone[key] = _levelsSkills[key];
			return levelsSkillsClone;
		}
		/** All the skills of the character */
		protected var _skillsModels:Vector.<SkillModel>;
		/** All the skills of the character */
		public function get skillsModels():Vector.<SkillModel> {
			return _skillsModels;// .slice();
		}
		/**
		 * All the skills of this character which have just been used
		 * and are currently waiting for cooldown,...
		 */
		protected var _usedSkills:Vector.<SkillModel>;
		/**
		 * All the skills which currently have effects on this character
		 */
		protected var _affectedSkills:Vector.<SkillModel>;
		/** Flag to indicate whether the character is alive or not */
		public function get isAlive():Boolean { return stats.hp > 0; }
		/** Detecting range of the character */
		protected var _detectingRange:FlxPoint;
		/** Detecting range of the character */
		public function get detectingRange():FlxPoint { return _detectingRange; }
		/** Attacking range of the character */
		protected var _attackingRange:FlxPoint;
		/** Attacking range of the character */
		public function get attackingRange():FlxPoint { return _attackingRange; }
		/** All the items of the character, in code format only */
		private var _items:Vector.<int>;
		public function get items():Vector.<int> {
			return _items.slice();
		}
		/** Equipments of this character */
		private var _equipments:CharacterEquipments;
		/** Equipments of this character */
		public function get equipments():CharacterEquipments { return _equipments; }
		///**
		 //* Default contructor
		 //* 
		 //* @param	maxHp
		 //* 			is the maximum hp of the character
		 //* @param	maxMp
		 //* 			is the maximum mp of the character
		 //* @param	atk
		 //* 			is the atk of the character
		 //* @param	def
		 //* 			is the def of the character
		 //* @param	exp
		 //* 			is the exp points player gets when defeating this character
		 //* @param	detectingRange
		 //* 			is for npc only, which determines the
		 //* 			range in which it can detect the player
		 //* @param	attackingRange
		 //* 			is the range to increase in the offset of
		 //* 			the character when currently attacking
		 //*/ 
		//public function CharacterModel(maxHp:uint, maxMp:uint, atk:uint, def:uint, exp:uint,
									   //detectingRange:FlxPoint, attackingRange:FlxPoint) {
			//stats = new Stats(maxHp, maxHp, maxMp, maxMp, atk, def, exp);
			//this.detectingRange = new FlxPoint(detectingRange.x, detectingRange.y);
			//this.attackingRange = new FlxPoint(attackingRange.x, attackingRange.y);
		//}
		/**
		 * Default constructor
		 * 
		 * @param	characterCode
		 * 			is the code of this character
		 * @param	characterName
		 * 			is the name of this character
		 * @param	baseStats
		 * 			is the base stats of this character
		 * @param	lvlStatsIncrease
		 * 			is the increase in stats of this character when leveling up
		 * @param	attackingRange
		 * 			is the range to increase in the offset of
		 * 			the character when currently attacking
		 * @param	detectingRange
		 * 			is for npc only, which determines the
		 * 			range in which it can detect the player
		 * @param	lvlSkills
		 * 			is hash map/table of skills character will learn when level up
		 */
		public function CharacterModel(characterCode:int, characterName:String, baseStats:Stats, lvlStatsIncrease:PercentageStats,
									   attackingRange:FlxPoint, detectingRange:FlxPoint = null,
									   lvlSkills:Object = null) {	
			_characterCode = characterCode;
			_characterName = characterName;
			_baseStats = baseStats;
			_baseStats.nextLevelExp = GameFormula.getLevelExp(_baseStats.level);
			_stats = _baseStats.clone();
			this.lvlStatsIncrease = lvlStatsIncrease;
			_detectingRange = detectingRange;
			_attackingRange = attackingRange;
			_items = new Vector.<int>();
			_levelsSkills = lvlSkills;//lvlSkills != null ? lvlSkills : new Object();
			_skillsModels = new Vector.<SkillModel>();
			_usedSkills = new Vector.<SkillModel>();
			_affectedSkills = new Vector.<SkillModel>();
			_equipments = new CharacterEquipments();
			learnLevelsSkills();
		}
		
		/**
		 * Add an item to player's inventory
		 * 
		 * @param	itemCode
		 * 			is code of the item to add to player's inventory
		 */
		public function addItem(itemCode:int):void {
			_items.push(itemCode);
		}
		
		/**
		 * Remove an item from player's inventory
		 * 
		 * @param	itemCode
		 * 			is the code of the item to remove from player's inventory
		 * 
		 * @return	true
		 * 			if there is item with the given code in player's inventory,
		 * 			and it is removed successfully
		 * 			false otherwise
		 */
		public function removeItem(itemCode:int):Boolean {
			var index:int = _items.lastIndexOf(itemCode);
			if (index == -1) return false;
			
			_items.splice(index, 1);
			return true;
		}
		
		/**
		 * Gain exp by attacking/killing other characters/monsters or using
		 * items,...
		 * 
		 * @param	expAmount
		 * 			is the emount of gained exp
		 * 
		 * @return	true if player gains (at least) a level
		 * 			false otherwise
		 */
		public function gainExp(expAmount:int):Boolean {
			stats.exp += expAmount;
			stats.nextLevelExp -= expAmount;
			
			var gainLvl:Boolean = stats.nextLevelExp <= 0;
			
			// If character levels up
			while (stats.nextLevelExp <= 0)
				gainLevel();
			
			return gainLvl;
		}
		
		/**
		 * Gain some level, increases stats and 
		 * 
		 * @param	lvl
		 * 			is the number of level gained
		 */
		public function gainLevel(lvl:int=1):void {
			// Only increase if not reach max level yet
			if (stats.level < GameConstants.CHARACTERS_MAX_LEVEL) {
				for (var i:int = 0; i < lvl; i++) {
					stats.level += 1;
					
					// Increase the stats
					var lvlStatsIncrease:ImmutableStats = this.lvlStatsIncrease.generateStats();
					_baseStats.combineStats(lvlStatsIncrease);
					stats.hp += lvlStatsIncrease.hp;
					stats.mp += lvlStatsIncrease.mp;
					stats.hp = Math.min(stats.hp, stats.maxHp);
					stats.mp = Math.min(stats.mp, stats.maxMp);
					reCalculateStats();
					stats.nextLevelExp = GameFormula.getLevelExp(stats.level + 1) - stats.exp;
					
					// Learn skills if any
					learnCurrentLevelSkill();
				}
			} else stats.nextLevelExp = Infinity;
		}
		
		/**
		 * Reapply all the enable skills/items
		 * Call when level up (base stats change), or some
		 * skill/item's effect is over
		 */
		public function reCalculateStats():void {
			// keep old hp, mp, exp, and nextLvlExp
			var oldHp:Number = stats.hp;
			var oldMp:Number = stats.mp;
			var oldExp:Number = stats.exp;
			var oldNextLvlExp:Number = stats.nextLevelExp;
			
			// Reset stats
			_stats = _baseStats.clone();
			
//			for each (var skill:SkillModel in _skillsModels)
//				if (skill.skillActivePassiveType == SkillActivePassiveType.PASSIVE &&
//					skill.enabled)
			for each (var skill:SkillModel in _affectedSkills)
					if (skill.enabled) skill.reUsed();
			
			stats.hp = oldHp;
			stats.mp = oldMp;
			stats.exp = oldExp;
			stats.nextLevelExp = oldNextLvlExp;
		}
		
		/**
		 * Relearn all the skills
		 * Call when some equipment with skills is unequiped
		 */
		public function reLearnSkills():void {
			learnLevelsSkills();
		}
		
		/**
		 * Learn the skill assiciated to the current level
		 */
		public function learnCurrentLevelSkill():void {
			learnSkillByLevel(stats.level);
		}
		
		/**
		 * Learn all the skills up to current level
		 */
		public function learnLevelsSkills():void {
			_skillsModels.splice(0, _skillsModels.length);
			for (var lvl:int = 1; lvl <= stats.level; lvl++)
				learnSkillByLevel(lvl);
		}
		
		/**
		 * Learn the skill assicicated with the given level
		 * 
		 * @param	level
		 * 			is the level to retrieve the skill to learn
		 */
		private function learnSkillByLevel(level:int):void {
			if (_levelsSkills != null && _levelsSkills[String(level)] != undefined &&
				_levelsSkills[String(level)] != null) {
				var skillCode:int = UnitsConstants.getSkillCode(_levelsSkills[String(level)]);
				learnSkill(skillCode);
			}
		}
		
		/**
		 * Learn a certain skill
		 * 
		 * @param	skillCode
		 * 			is the code of the skill to learn
		 * 
		 * @return	true	if this skill was not learnts and now has been
		 * 					learnt successfully
		 * 			false	otherwise
		 */
		public function learnSkill(skillCode:int):Boolean {
			// Check whether this skill is learnt yet
			for each (var learntSkill:SkillModel in _skillsModels)
				if (learntSkill.skillCode == skillCode)
					return false;
			
			var skillModel:SkillModel = SkillsConstants.getSkillModelBySkillCode(skillCode);
			_skillsModels.push(skillModel);
			return true;
		}
		
		/**
		 * Take effect of a certain item when used
		 */
		public function useItem(item:ItemModel):void {
			item.usedOn(this);
			removeItem(item.code);
		}
		
		/**
		 * Use a certain skill
		 * 
		 * @param	skill
		 * 			is the skill to use
		 * 			
		 * @return	true
		 * 			if the skill is successfully used
		 * 			false
		 * 			otherwise
		 */
		public function useSkill(skill:SkillModel):Boolean {
			if (skill.usedBy(this)) {
				_usedSkills.push(skill);
				if (skill.skillType == SkillType.BUFF)
					skill.usedOn(this);
				return true;
			} else return false;
		}
		
		/**
		 * Unused a certain skill
		 * 
		 * @param	skill
		 * 			is the skill to unuse
		 */
		public function unUseSkill(skill:SkillModel):void {
			if (skill.skillActivePassiveType == SkillActivePassiveType.ACTIVE &&
				skill.enabled)
				skill.unUsed();
		}
		
		/**
		 * Take effect of a certain skill
		 * 
		 * @param	skill
		 * 			is the skill to take effect
		 */
		public function takeSkillEffect(skill:SkillModel):void {
			skill.usedOn(this);
		}
		
		/**
		 * Add a skill to affected skills list
		 * 
		 * @param	skill
		 * 			is the skill this character is affected by
		 */
		public function addAffectedSkill(skill:SkillModel):void {
			_affectedSkills.push(skill);
		}
		
		/**
		 * Equip an equipment
		 * 
		 * @param	equipment
		 * 			is the equipment to equip
		 * @param	position
		 * 			is the position of the equipment to equip on
		 */
		public function equip(equipment:EquipmentModel, position:EquipmentPosition):void {
			switch (position) {
				case EquipmentPosition.HEAD:
					_equipments.head = equipment;
					break;
				case EquipmentPosition.LEFT_HAND:
					_equipments.leftHand = equipment;
					break;
				case EquipmentPosition.RIGHT_HAND:
					_equipments.rightHand = equipment;
					break;
				case EquipmentPosition.ARM:
					_equipments.arm = equipment;
					break;
				case EquipmentPosition.BODY:
					_equipments.body = equipment;
					break;
				case EquipmentPosition.LEG:
					_equipments.leg = equipment;
					break;
//				case EquipmentPosition.SHOES:
//					_equipments.shoes = equipment;
//					break;
				case EquipmentPosition.FIRST_ACCESSORIES:
					_equipments.firstAccessory = equipment;
					break;
				case EquipmentPosition.SECOND_ACCESSORIES:
					_equipments.secondAccessory = equipment;
					break;
			}
		}

		/**
		 * Update this model in every frame
		 */
		public function update():void {
			// Call all skills to update
			//for each (var skill:SkillModel in _skillsModels)
			//	skill.update();
			//for each (var usedSkill:SkillModel in _usedSkills)
			var i:int = 0;
			while (i < _usedSkills.length) {
				var usedSkill:SkillModel = _usedSkills[i];
				if (usedSkill.update())
					_usedSkills.splice(i, 1);
				else i++;
			}
			//for each (var affectedSkill:SkillModel in _affectedSkills)
			i = 0;
			while (i < _affectedSkills.length) {
				var affectedSkill:SkillModel = _affectedSkills[i];
				if (affectedSkill.updateEffect())
					_affectedSkills.splice(i, 1);
				else i++;
			}
		}
		
		
		
		/**
		 * Construct this model from a save object
		 * 
		 * @param	model
		 * 			is the model in the save data
		 */
		public function constructFromSaveObject(model:Object):void {
			reset();
			_baseStats = new Stats(StatsType.ABSOLUTE, model.baseStats.maxHp, model.baseStats.hp,
									model.baseStats.maxMp, model.baseStats.mp, model.baseStats.atk,
									model.baseStats.def, model.baseStats.spd, model.baseStats.luck,
									model.baseStats.exp, model.baseStats.level);
			_baseStats.nextLevelExp = model.baseStats.nextLevelExp;
			_stats = _baseStats.clone();
			stats.hp = model.stats.hp; stats.mp = model.stats.mp;
			var items:Vector.<int> = model.items;
			for each (var item:int in items)
				_items.push(item);
			learnLevelsSkills();
		}
		
		/**
		 * Construct a save object for this
		 * Only non-constants properties will be saved
		 */
		public function getSaveObject():Object {
			var saveObject:Object = new Object();
			saveObject.baseStats = _baseStats;
			saveObject.items = _items;
			var stats:Object = new Object();
			stats.hp = this.stats.hp; stats.mp = this.stats.mp;
			saveObject.stats = stats;
//			var skills:Vector.<int> = new Vector.<int>();
//			for each (var skill:SkillModel in _skillsModels)
//				skills.push(skill.skillCode);
//			saveObject.skills = skills;
			return saveObject;
		}
		/**
		 * Reset this model to the original state
		 * 
		 * @param	baseStats
		 * 			is the original base stats of this character
		 */
		public function reset(characterCode:int = -1, characterName:String = null, baseStats:Stats = null):void {
			if (characterCode != -1) _characterCode = characterCode;
			if (characterName != null) _characterName = characterName;
			if (baseStats != null) _baseStats = baseStats;
			_stats = _baseStats.clone();
			_skillsModels.splice(0, _skillsModels.length);
			_items.splice(0, _items.length);
		}
		
		
//		/** Get maximum HP of the character */
//		public function get maxHp():uint { return _maxHp; }
//		/** Get current HP of the character */
//		public function get hp():int { return _hp };
//		/** Get max MP of the character */
//		public function get maxMp():uint { return _maxMp; }
//		/** Get current MP of the character */
//		public function get mp():int { return _mp; }
//		/** Get ATK of the character */
//		public function get atk():uint { return _atk; }
//		/** Get DEF of the character */
//		public function get def():uint { return _def; }
//		/** Get detecting range of the character */
//		public function get detectingRange():FlxPoint { return _detectingRange; }
//		/** Get attacking range of the character */
//		public function get attackingRange():FlxPoint { return _attackingRange; }
		
		/**
		 * Return a clone of this model
		 */
		public function clone():GameObjectModel {
			return new CharacterModel(_characterCode, _characterName, baseStats.clone(), lvlStatsIncrease.clone(),
									  new FlxPoint(attackingRange.x, attackingRange.y),
									  new FlxPoint(detectingRange.x, detectingRange.y),
									  _levelsSkills);
		}
		
		
	}
}