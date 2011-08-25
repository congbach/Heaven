package data {
	import embeded.EmbededConstants;
	
	import errors.IllegalArgumentException;
	
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * UnitsConstants class
	 * @author Ken
	 * maps unit (character type/class) code to its name
	 */
	public class UnitsConstants	extends Constants {
		
		/**
		 * Start loading the constants
		 */
		override public function loadConstants():void {
			if ( GameConstants.EMBEDED_ALL ) {
				readConstants( new XML( new EmbededConstants.UnitsCodes() ) );
			} else {
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, loadConstantsComplete );
				loader.load( new URLRequest( URLs.UNITS_CODES_CONFIG_FILE ) );
			}
		}
		
		/**
		 * Event listener to indicate that the file which contains
		 * all the appropriate design has been loaded successfully
		 * @param	event	is Event.COMPLETE which is attached to the loader
		 */
		private function loadConstantsComplete( event:Event ):void {
			readConstants( new XML( event.target.data ) );
		}
		
		/**
		 * Read the constants given the data of the external design file
		 * @param	constants	is the data of the external design file
		 * 						in xml format
		 */
		private function readConstants( constants:XML ):void {
			for each ( var character:XML in constants.characters.children() ) {
				if ( character.name.text() == PLAYER_NAME )
					_PLAYER_CODE = Number( character.code.text() );
				charactersNames[ character.code.text() ] = character.name.text();
			}
			
			for each ( var item:XML in constants.items.children() )
				itemsNames[ item.code.text() ] = item.name.text();
			
			for each ( var skill:XML in constants.skills.children() )
				skillsNames[ skill.code.text() ] = skill.name.text();
			
			dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
		}
		
		
		/**
		 * Object which stores and maps character code with the appropriate name
		 */
		static private const charactersNames:Object = new Object();
		/**
		 * Object which stores and maps item code with appropriate name
		 */
		static private const itemsNames:Object = new Object();
		/**
		 * Object which stores and maps skill code with appropriate name
		 */
		static private const skillsNames:Object = new Object();
		
		/**
		 * BLANK in the design of the map
		 */
		static public const BLANK:int = 0;
		
		/**
		 * Maximum value of the code of tile
		 */
		static public const TILE_MIN_VALUE:int = 1;
		
		/**
		 * Mimimun value of the code of npc
		 */
		static public const NON_PLAYABLE_CHARACTER_MIN_VALUE:int = 2;
		static private var _PLAYER_CODE:int = 1;
		static public const PLAYER_NAME:String = "player";
		
		static public function get PLAYER():int {
			return _PLAYER_CODE;
		}
		
		/**
		 * Get the name of a character based on the given code
		 * 
		 * @param	characterCode
		 * 			is the code of the character to get name
		 * 
		 * @return	the name of the character with the given code
		 * @throw	IllegalArgumentException if no character is associated with
		 * 			the given code
		 */	
		static public function getCharacterName( characterCode:int ):String {
			var npcName:String = charactersNames[ String( characterCode ) ];
			if ( npcName == null )
				throw new IllegalArgumentException( "npcCode", characterCode );
			return npcName;
		}
		
		/**
		 * Get the code of the character based on the given name
		 * 
		 * @param	characterName
		 * 			is the name of the character
		 * 
		 * @return	the code of the character with the given name
		 * @throws	IllegalArgumentException if no character is associated with
		 * 			the given name
		 */
		static public function getCharacterCode(characterName:String):int {
			for ( var key:String in charactersNames )
				if (charactersNames[key] == characterName)
					return Number(key);
			throw new IllegalArgumentException( "characterName", characterName );
		}
		
		/**
		 * Get the item of a item based on the given code
		 * 
		 * @param	item
		 * 			is the code of the item to get name
		 * 
		 * @return	the name of the item with the given code
		 * @throw	IllegalArgumentException if no item is associated with
		 * 			the given code
		 */	
		static public function getItemName( itemCode:int ):String {
			var itemName:String = itemsNames[ String( itemCode ) ];
			if ( itemName == null )
				throw new IllegalArgumentException( "itemCode", itemCode );
			return itemName;
		}
		
		/**
		 * Get the code of the item based on the given name
		 * 
		 * @param	itemName
		 * 			is the name of the item
		 * 
		 * @return	the code of the item with the given name
		 * @throws	IllegalArgumentException if no item is associated with
		 * 			the given name
		 */
		static public function getItemCode(itemName:String):int {
			for ( var key:String in itemsNames )
				if (itemsNames[key] == itemName)
					return Number(key);
			throw new IllegalArgumentException( "itemName", itemName );
		}
		
		/**
		 * Get the item of a skill based on the given code
		 * 
		 * @param	skill
		 * 			is the code of the skill to get name
		 * 
		 * @return	the name of the skill with the given code
		 * @throw	IllegalArgumentException if no skill is associated with
		 * 			the given code
		 */	
		static public function getSkillName( skillCode:int ):String {
			var skillName:String = skillsNames[ String( skillCode ) ];
			if ( skillName == null )
				throw new IllegalArgumentException( "skillCode", skillCode );
			return skillName;
		}
		
		/**
		 * Get the code of the skill based on the given name
		 * 
		 * @param	skillName
		 * 			is the name of the skill
		 * 
		 * @return	the code of the skill with the given name
		 * @throws	IllegalArgumentException if no skill is associated with
		 * 			the given name
		 */
		static public function getSkillCode(skillName:String):int {
			for ( var key:String in skillsNames ) 
				if (skillsNames[key] == skillName)
					return Number(key);
			throw new IllegalArgumentException( "skillName", skillName );
		}
		
//		static public function getAllCharactersCodes():Vector.< String > {
//			var allCharactersCodes:Vector.< String > = new Vector.< String >();
//		}
		
	}
}