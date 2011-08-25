package data {
	import models.skills.SkillPhysicsModel;
	import org.flixel.data.FlxAnim;
	import models.skills.SkillModel;
	import embeded.EmbededConstants;
	
	import enums.SkillActivePassiveType;
	import enums.SkillDamageType;
	import enums.SkillItemEffectType;
	import enums.SkillType;
	import enums.StatsType;
	
	import errors.IllegalArgumentException;
	
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import models.skills.SkillAnimationData;
	import models.stats.Stats;
	
	import org.flixel.FlxPoint;
	
	/**
	 * Skills Constants class
	 * @author Ken
	 * contains data from all skills
	 * read from external file (design period)
	 * or from embeded file (final version)
	 */
	public class SkillsConstants extends Constants {
		
		/**
		 * Name of the attacking animation of the skill
		 */
		static public const SKILL_ATTACKING_ANIMATION:String = "attacking";
		/**
		 * Object which stores all the skills models
		 */
		static private const _skillsModels:Object = new Object();
		/**
		 * Object which stores all the images urls
		 */
		static private const _skillsAnimationData:Object = new Object();
		/**
		 * Object which stores offset properties of all the skills
		 */
		//static private const _skillsOffsets:Object = new Object();
		
		/**
		 * Load/Read constants from external or embeded file
		 */
		override public function loadConstants():void {
			// Is the external constant file embeded?
			if ( GameConstants.EMBEDED_ALL ) {
				// Yes
				// Then just read directly from the embeded file
				readSkillsConstants( new XML( new EmbededConstants.SkillsConstants() ) );
			} else {
				// No
				// Read from external constant file
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, loadConstantsComplete );
				loader.load( new URLRequest( URLs.SKILLS_CONSTANTS_CONFIG_FILE ) );
			}
		}
		
		/**
		 * Event listener to loader of external file
		 * Read and decode the data of external file
		 * dispatch FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE
		 * when all constants are read/initialized
		 * @param	event
		 * 			is the Event.COMPLETE attached to loader
		 * 			of external file
		 */
		private function loadConstantsComplete( event:Event ):void {
			readSkillsConstants( new XML( event.target.data ) );
		}
		
		/**
		 * Read the constants of all the skills
		 * 
		 * @param	skillsConstantsXML
		 * 			is the details of the skillss', in xml format 
		 */
		private function readSkillsConstants(skillsConstantsXML:XML) {
			var skills:XMLList = skillsConstantsXML.skills;
			
			// Read constants for each skills
			for each (var skill:XML in skills.children()) {
				var name:String = skill.name.text();
				var code:int = UnitsConstants.getSkillCode(name);
				var description:String = skill.description.text();
				
				if (skill.hasOwnProperty("animation"))
					_skillsAnimationData[name] = readSkillAnimationData(skill);
				else
					_skillsAnimationData[name] = null;
				
				var skillActivePassiveType:SkillActivePassiveType =
					skill.activepassive.text() == "active" ? SkillActivePassiveType.ACTIVE
					: SkillActivePassiveType.PASSIVE;
				
				var skillTypeString:String = skill.type.text();
				var skillType:SkillType;
				if (skillTypeString == "buff")
					skillType = SkillType.BUFF;
				else if (skillTypeString == "debuff")
					skillType = SkillType.DEBUFF;
				else if (skillTypeString == "attack")
					skillType = SkillType.ATTACK;
				else if (skillTypeString == "action")
					skillType = SkillType.ACTION;
				else if (skillTypeString == "summon")
					skillType = SkillType.SUMMON;
				else
					skillType = SkillType.OTHER;
				
				var skillDamageType:SkillDamageType =
					skill.damageType.text() == "percentage" ? SkillDamageType.PERCENTAGE : SkillDamageType.ABSOLUTE;
				
				var mpCost:int = Number(skill.mpCost.text());
				var coolDown:int = Number(skill.coolDown.text());
				var mpCostPerSecond:int = Number(skill.mpCostPerSecond.text());
				var duration:int = Number(skill.duration.text());
				var effectType:SkillItemEffectType;
				if (! skill.hasOwnProperty("effectType"))
					effectType = null;
				else
					effectType = skill.effectType.text() == "once" ? SkillItemEffectType.ONCE
									: SkillItemEffectType.PER_SECOND;
				var velocity:FlxPoint =
					new FlxPoint(Number(skill.velocity.x.text()),
								 Number(skill.velocity.y.text()));
					
				var stats:XMLList = skill.stats;
				var statsType:StatsType =
					stats.statsType.text() == "percentage" ? StatsType.PERCENTAGE : StatsType.ABSOLUTE;
				if (skillDamageType == SkillDamageType.PERCENTAGE)
					statsType = StatsType.PERCENTAGE;
				
				var maxHp:uint = Number(stats.maxHp.text());
				var hp:uint = Number(stats.hp.text());
				var maxMp:uint = Number(stats.maxMp.text());
				var mp:uint = Number(stats.mp.text());
				var atk:uint = Number(stats.atk.text());
				var def:uint = Number(stats.def.text());
				var spd:uint = Number(stats.spd.text());
				var luck:uint = Number(stats.luck.text());
				var exp:uint = Number(stats.exp.text());
				var lvl:uint = Number(stats.level.text());
				
				if (skillDamageType == SkillDamageType.PERCENTAGE) {
					if (maxHp == 0) maxHp = 100;
					if (hp == 0) hp = 100;
					if (maxMp == 0) maxMp = 100;
					if (mp == 0) mp = 100;
					if (atk == 0) atk = 100;
					if (def == 0) def = 100;
					if (spd == 0) spd = 100;
					if (luck == 0) luck = 100;
					if (exp == 0) exp = 100;
					if (lvl == 0) lvl = 100;
				}
				var skillStats:Stats =
					new Stats(statsType, maxHp, hp, maxMp, mp, atk, def, spd, luck, exp, lvl);
				
				_skillsModels[name] =
					new SkillModel(code, name, skillActivePassiveType, skillType, skillDamageType, skillStats,
								  mpCost, description, coolDown, mpCostPerSecond, effectType, duration, velocity);
			}
			
			// Notify that the constants are loaded successfully
			dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
		}
		
		/**
		 * Read, create and return animation data of one skill
		 * @param	skill				is the xml format of the skill to obtain
		 * 									the necessary information
		 * @return	CharacterPhysicsData	according to the given design
		 */
		private function readSkillAnimationData(skill:XML):SkillAnimationData {
			var skillAnimation:XMLList = skill.animation;			
			var imageUrl:String = skillAnimation.imageUrl.text();
			var width:Number = Number(skillAnimation.width.text());
			var height:Number = Number(skillAnimation.height.text());
			
			var physicsData:SkillPhysicsModel = readSkillPhysicsModel(skill, width, height);
			var animationsData:Vector.<FlxAnim> = new Vector.<FlxAnim>();
			for each ( var animation:XML in skill.animation.animations.children() ) {
				
				var animationName:String = animation.name.text();
				var animationFrames:Array = animation.frames.text().split( " " );
				for ( var index:int = 0; index < animationFrames.length; index++ )
					animationFrames[ index ] = Number( animationFrames[ index ] );
				var animationFPS:int = Number( animation.fps.text() );
				if ( animationFPS == 0 )
					animationFPS = CharactersConstants.DEFAULT_ANIMATION_FPS;
				animationsData.push( new FlxAnim( animationName, animationFrames, animationFPS ) );
			}
			
			return new SkillAnimationData(imageUrl, width, height, physicsData, animationsData);
		}
		
		/**
		 * Read, create and return animation data of one skill
		 * @param	skill				is the xml format of the skill to obtain
		 * 									the necessary information
		 * @param	width				is the width of the frame image of the skill
		 * 								to be used when no offset information is declared
		 * @param	height				is the height of the frame image of the skill
		 * 								to be used when no offset information is declared
		 * @return	CharacterPhysicsData	according to the given design
		 */
		private function readSkillPhysicsModel(skill:XML, width:Number, height:Number):SkillPhysicsModel {
			var skillPhysics:XMLList = skill.animation.physics;
			var skillOffset:Object = new Object();
			var offsetX:Number = 0, offsetY:Number = 0;
			var offsetWidth:Number = width, offsetHeight:Number = height;
					
			if (skillPhysics.hasOwnProperty("offset")) {
				offsetX = Number(skillPhysics.offset.x.text());
				offsetY = Number(skillPhysics.offset.y.text());
				offsetWidth = Number(skillPhysics.offset.width.text());
				offsetHeight = Number(skillPhysics.offset.height.text());
			}
			
			var initialVelocity:Number = Number(skillPhysics.initialVelocity.text());
			var range:Number = Number(skillPhysics.range.text());
			
			return new SkillPhysicsModel(offsetX, offsetY, offsetWidth, offsetHeight, initialVelocity, range);
		}
		
		
		
		/**
		 * Get the data of one skill based on the code of that skill
		 * @param	skillCode					is the code (encoded) of the skill
		 * @return	SkillModel					which is the model of the skill associated
		 * 										with the given skill code
		 * @throws	IllegalArgumentException	if the skillCode given does not match any
		 * 										particular type/class of skill
		 */
		static public function getSkillModelBySkillCode( skillCode:int ):SkillModel {
			return getSkillModelBySkillName( UnitsConstants.getSkillName( skillCode ) );
		}
		
		/**
		 * Get the data of the skill based on the skill code
		 * @param	skillName					is the name of the skill
		 * @return	SkillModel					which is the model of the skill
		 * @throw	IllegalArgumentException	if the skillName given does not match any
		 * 										particular skill
		 */
		static public function getSkillModelBySkillName( skillName:String ):SkillModel {
			if ( _skillsModels[ skillName ] == undefined
				|| _skillsModels[ skillName ] == null )
				throw new IllegalArgumentException( "skillName", skillName );
			return (_skillsModels[ skillName ] as SkillModel).clone();
		}
		
		/**
		 * Get urls of images of all the skills
		 * For safety return value is only a copy version of skillsUrls
		 * @return	Object	which contains urls to images of all the skills
		 */
		static public function getAllSkillsImagesUrls():Object {
			var skillsImagesUrlsClone:Object = new Object();
			for ( var key:String in _skillsAnimationData )
				if (_skillsAnimationData[key] != null)
					skillsImagesUrlsClone[ key ] = (_skillsAnimationData[ key ] as SkillAnimationData).imageUrl;
			return skillsImagesUrlsClone;
		}
		
		/**
		 * Get the animation data of a skill based on its code
		 * 
		 * @param	skillCode
		 * 			is the code of the skill
		 * 			
		 * @return	animation data of the skill with the given code
		 * @throw	IllegalArgumentException
		 * 			is there is no skill with the given code
		 */
		static public function getSkillAnmationDataBySkillCode(skillCode:int):SkillAnimationData {
			return getSkillAnmationDataBySkillName(UnitsConstants.getSkillName(skillCode));
		}
		
		/**
		 * Get the animation data of a skill based on its name
		 * 
		 * @param	skillName
		 * 			is the name of the skill
		 * 			
		 * @return	animation data of the skill with the given name
		 * 			null if there is no animation data associated to the skill
		 */
		static public function getSkillAnmationDataBySkillName(skillName:String):SkillAnimationData {
			return _skillsAnimationData[skillName];
		}
	}
}