package data {
	import embeded.EmbededConstants;
	
	import enums.StatsType;
	
	import errors.IllegalArgumentException;
	
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	import models.characters.CharacterModel;
	import models.stats.Stats;
	import models.ImmutablePhysicsModel;
	import models.stats.PercentageStats;
	
	import org.flixel.FlxPoint;
	import org.flixel.data.FlxAnim;
	
	/**
	 * Character Constants class
	 * @author Ken
	 * contains data from all characters
	 * read from external file (design period)
	 * or from embeded file (final version)
	 */
	public class CharactersConstants extends Constants {
		
		/**
		 * Object which stores all the character constants
		 */
		static private const charactersConstants:Object = new Object();
		
		
		//---------
		// GENERAL
		//---------
		
		/** Global y acceleration of gravity */
		static private var _GRAVITY_Y_ACCELERATION:Number;
		/** Maximum velocity of falling object */
		static private var _GRAVITY_FALLING_Y_VELOCITY_MAX_VALUE:Number;
		/** Friction acceleration in x-coordiante to be reduce from character's velocity */
		static private var _FRICTION_X_ACCELERATION:Number;
		/** Default frame rate of animation */
		static private var _DEFAULT_ANIMATION_FPS:int = 5;
		
		/**
		 * Required/Compulsory animation for all NPC
		 */
		/** Idle animation of character */
		static public const NPC_IDLE_ANIMATION_NAME:String = "idle";
		/** Walk animation of character */
		static public const NPC_WALK_ANIMATION_NAME:String = "walk";
		/** Attack animation of character */
		static public const NPC_ATTACK_ANIMATION_NAME:String = "attack";
		
		/** Get the global y acceleration of gravity */
		static public function get GRAVITY_Y_ACCELERATION():Number {
			return _GRAVITY_Y_ACCELERATION;
		}
		
		/** Get the maximum velocity of falling object */
		static public function get GRAVITY_FALLING_Y_VELOCITY_MAX_VALUE():Number {
			return _GRAVITY_FALLING_Y_VELOCITY_MAX_VALUE;
		} 
		
		/** 
		 * Get the friction acceleration in x-coordiante
		 * to be reduce from character's velocity
		 */
		static public function get FRICTION_X_ACCELERATION():Number {
			return _FRICTION_X_ACCELERATION;
		}
		
		/** Get the default frame rate of animation */
		static public function get DEFAULT_ANIMATION_FPS():int {
			return _DEFAULT_ANIMATION_FPS;
		}
		
		
		//--------
		// PLAYER
		//--------
		
		//		static public const PLAYER_OFFSET_X:Number = 14;
		//		static public const PLAYER_OFFSET_Y:Number = 10;
		//		static public const PLAYER_OFFSET_WIDTH:Number = 24;
		//		static public const PLAYER_OFFSET_HEIGHT:Number = 40;
		
		/** Maximum jump velocity of player */
		static private var _PLAYER_JUMP_MAX_Y_VELOCITY:Number = 2000;
		
		static public function get PLAYER_JUMP_MAX_Y_VELOCITY():Number {
			return _PLAYER_JUMP_MAX_Y_VELOCITY;
		}
		
		
		//==============================================================
		
		/**
		 * Load/Read constants from external or embeded file
		 */
		override public function loadConstants():void {
			// Is the external constant file embeded?
			if ( GameConstants.EMBEDED_ALL ) {
				// Yes
				// Then just read directly from the embeded file
				readConstants( new XML( new EmbededConstants.CharactersConstants() ) );
			} else {
				// No
				// Read from external constant file
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, loadConstantsComplete );
				loader.load( new URLRequest( URLs.CHARACTERS_CONSTANTS_CONFIG_FILE ) );
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
			readConstants( new XML( event.target.data ) );
		}
		
		/**
		 * Initialize all constants based on the details of the design file
		 * @param	constants	
		 * 			is the details of external/embeded file
		 * 			in xml format
		 */
		private function readConstants( constants:XML ):void {
			var general:XMLList = constants.general;
			
			// Read the general physics data: gravity y, friction, ...
			var physicsGeneral:XMLList = general.physics;
			_GRAVITY_Y_ACCELERATION = Number( physicsGeneral.grav.acc.y.text() );
			_GRAVITY_FALLING_Y_VELOCITY_MAX_VALUE = Number( physicsGeneral.grav.max_velocity.y.text() );
			_FRICTION_X_ACCELERATION = Number( physicsGeneral.friction.acc.x.text() );
			
			// Read the general animation data: default fps,...
			var animationsGeneral:XMLList = general.animations;			
			_DEFAULT_ANIMATION_FPS = Number( animationsGeneral.defaultfps );
			
			// Read constants for each character
			var characters:XMLList = constants.characters;
			
			for each ( var character:XML in characters.children() ) {
				var characterImageUrl:String = character.imageUrl.text();
				var characterWidth:Number = Number( character.width.text() );
				var characterHeight:Number = Number( character.height.text() );
				
				var characterPhysicsData:ImmutablePhysicsModel = readCharacterPhysicsConstants( character );
				var characterAnimations:Vector.< FlxAnim > = 
					readCharacterAnimations( character, characterPhysicsData.offset );
				
				var characterModel:CharacterModel = readCharacterModel(character);
				
				var characterData = 
					new ImmutableGameObjectData( 
						characterImageUrl, characterWidth, characterHeight,
						characterPhysicsData, characterAnimations, characterModel );
				charactersConstants[ String( character.name() ) ] = characterData;
			}
			
			// Notify that the constants are loaded successfully
			dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
		}
		
		/**
		 * Read, create and return physics data of one type/class of character/npc
		 * @param	character				is the xml format of one type of character to obtain
		 * 									the necessary information
		 * @return	CharacterPhysicsData	according to the given design
		 */
		private function readCharacterPhysicsConstants( character:XML ):ImmutablePhysicsModel {
			var characterPhysics:XMLList = character.physics;
			
			// Read the offset information
			var characterOffset:FlxPoint = new FlxPoint();
			characterOffset.x = Number( characterPhysics.offset.x.text() );
			characterOffset.y = Number( characterPhysics.offset.y.text() );
			
			var characterOffsetWidth:Number = Number( characterPhysics.offset.width );
			var characterOffsetHeight:Number = Number( characterPhysics.offset.height );
			
			// Read acceleration and velocity
			var characterWalkAcceleration:FlxPoint = new FlxPoint();
			characterWalkAcceleration.x = Number( characterPhysics.acc.x.text() );
			characterWalkAcceleration.y = 0;
			
			var characterMaxVelocity:FlxPoint = new FlxPoint();
			characterMaxVelocity.x = Number( characterPhysics.walk_max_velocity.x.text() );
			characterMaxVelocity.y = _GRAVITY_FALLING_Y_VELOCITY_MAX_VALUE;
			
			if ( String( character.name() ) == UnitsConstants.PLAYER_NAME )					
				_PLAYER_JUMP_MAX_Y_VELOCITY = Number( characterPhysics.jump_max_velocity.y.text() );
			
			return new ImmutablePhysicsModel(
				characterOffset.x, characterOffset.y, characterOffsetWidth, characterOffsetHeight,
				characterWalkAcceleration.x, _GRAVITY_Y_ACCELERATION, _FRICTION_X_ACCELERATION,
				0, characterMaxVelocity.x, _GRAVITY_FALLING_Y_VELOCITY_MAX_VALUE );
		}
		
		/**
		 * Read, create and return all the animations of one type/class of character/npc
		 * @param	character				is the xml format of one type of character to obtain
		 * 									the necessary information
		 * @param	offset					is the default offset of the character
		 * @return	Vector.<AnimationData>	which contains all the animations of the characters
		 * 									according to the design	
		 */
		private function readCharacterAnimations( character:XML, offset:FlxPoint ):Vector.< FlxAnim > {
			var characterAnimations:XMLList = character.animations;
			
			var characterAnimationsData:Vector.< FlxAnim > = new Vector.< FlxAnim >();
			for each ( var animation:XML in characterAnimations.children() ) {
				
				var animationName:String = animation.name.text();
				var animationFrames:Array = animation.frames.text().split( " " );
				for ( var index:int = 0; index < animationFrames.length; index++ )
					animationFrames[ index ] = Number( animationFrames[ index ] );
				var animationFPS:int = Number( animation.fps.text() );
				if ( animationFPS == 0 )
					animationFPS = _DEFAULT_ANIMATION_FPS;
				characterAnimationsData.push( new FlxAnim( animationName, animationFrames, animationFPS ) );
			}
			
			// Read skills animation if any
			var characterModel:XMLList = character.model;
			if (characterModel.hasOwnProperty("skills")) {
				var characterSkills:XMLList = characterModel.skills;
				for each (var skill:XML in characterSkills.children()) {
					if (skill.hasOwnProperty("animation")) {
						var skillName:String = skill.name.text();
						var skillAnimationFrames:Array = skill.animation.frames.text().split(" ");
						for ( var id:int = 0; id < skillAnimationFrames.length; id++ )
							skillAnimationFrames[ id ] = Number( skillAnimationFrames[ id ] );
						var skillAnimationFPS:int = Number( skill.animation.fps.text() );
						if ( skillAnimationFPS == 0 )
							skillAnimationFPS = _DEFAULT_ANIMATION_FPS;
						characterAnimationsData.push(new FlxAnim(skillName, skillAnimationFrames, skillAnimationFPS));
					}
				}
			}
			return characterAnimationsData;
		}
		
		/**
		 * Read, create and return model of one type/class of character/npc
		 * @param	character				is the xml format of one type of character to obtain
		 * 									the necessary information
		 * @return	characterModel			according to the given design
		 */
		private function readCharacterModel(character:XML):CharacterModel {
			var characterModel:XMLList = character.model;
			
			var characterName:String = character.name();
			// Read the stats information
			var characterStats:XMLList = characterModel.stats;
			var maxHp:uint = Number(characterStats.maxHp.text());
			var maxMp:uint = Number(characterStats.maxMp.text());
			var atk:uint = Number(characterStats.atk.text());
			var def:uint = Number(characterStats.def.text());
			var spd:uint = Number(characterStats.spd.text());
			var luck:uint = Number(characterStats.luck.text())
			var exp:uint = Number(characterStats.exp.text());
			var stats:Stats = new Stats(StatsType.ABSOLUTE, maxHp, maxHp, maxMp, maxMp, atk, def, spd, luck, exp);
			
			var characterLvlUpStats:XMLList = characterStats.levelup;
			var lvlUpMaxHp:uint = Number(characterLvlUpStats.maxHp.text());
			var lvlUpMaxMp:uint = Number(characterLvlUpStats.maxMp.text());
			var lvlUpAtk:uint = Number(characterLvlUpStats.atk.text());
			var lvlUpDef:uint = Number(characterLvlUpStats.def.text());
			var lvlUpStats:PercentageStats = new PercentageStats(lvlUpMaxHp, lvlUpMaxMp, lvlUpAtk, lvlUpDef);
			
			var detectingRange:FlxPoint = 
				new FlxPoint(Number(characterStats.detectingRange.x.text()),
							 Number(characterStats.detectingRange.y.text()));
			var attackingRange:FlxPoint = 
				new FlxPoint(Number(characterStats.attackingRange.x.text()),
							 Number(characterStats.attackingRange.y.text()));
			
			var lvlsSkills:Object;
			if (characterModel.hasOwnProperty("skills")) {
				lvlsSkills = new Object();
				var skills:XMLList = characterModel.skills;
				for each (var skill:XML in skills.children())
					lvlsSkills[skill.level.text()] = skill.name.text();
			}
			return new CharacterModel(UnitsConstants.getCharacterCode(characterName), characterName,
						stats, lvlUpStats, attackingRange, detectingRange, lvlsSkills);
		}
		
		
		/**
		 * Get the data of one type/class of character based on the code of that type/class
		 * @param	characterCode				is the code (encoded) of the character
		 * @return	CharacterData				which contains all information of the character associated
		 * 										with the given character code
		 * @throw	IllegalArgumentException	if the characterCode given does not match any
		 * 										particular type/class of character
		 */
		static public function getCharacterConstantsByCharacterCode( characterCode:int ):ImmutableGameObjectData {
			return getCharacterConstantsByCharacterName( UnitsConstants.getCharacterName( characterCode ) );
		}
		
		/**
		 * Get the data of one type/class of character based on the name of that type/class
		 * @param	characterName				is the name of the type/class of character
		 * @return	CharacterData				which contains all information of the character associated
		 * 										with the given character name
		 * @throw	IllegalArgumentException	if the characterName given does not match any
		 * 										particular type/class of character
		 */
		static public function getCharacterConstantsByCharacterName( characterName:String ):ImmutableGameObjectData {
			if ( charactersConstants[ characterName ] == undefined
				|| charactersConstants[ characterName ] == null )
				throw new IllegalArgumentException( "characterName", characterName );
			return charactersConstants[ characterName ];
		}
		
		/**
		 * Get data of all types/classes of character
		 * For safety return value is only a copy version of charactersConstants
		 * @return	Object	which contains data of all types/classes of character
		 */
		static public function getAllCharactersConstants():Object {
			var charactersConstantsClone:Object = new Object();
			for ( var key:String in charactersConstants )
				charactersConstantsClone[ key ] = charactersConstants[ key ];
			return charactersConstantsClone;
		}
		
	}
}