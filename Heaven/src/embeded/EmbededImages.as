package embeded {
	import data.UnitsConstants;
	
	import errors.IllegalArgumentException;
	
	/**
	 * EmbededImages class
	 * @author Ken
	 * 
	 * contains all the images
	 */
	public class EmbededImages {
		
		/** The image of all the tiles */
		[Embed( source = "/../art/tiles/all_tiles.png" )]
		static public const TilesImages:Class;
		
		/** The image of the player */
		[Embed( source = "/../art/characters/38.png" )]
		static public const PlayerImages:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/32.png" )]
		static public const Mon1Images:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/bear.png" )]
		static public const Mon2Images:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/41.png" )]
		static public const Mon3Images:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/43.png" )]
		static public const Mon4Images:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/38.png" )]
		static public const Mon5Images:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/45.png" )]
		static public const Mon6Images:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/player.png" )]
		static public const Mon7Images:Class;
		
		[Embed(source = "/../art/characters/nonPlayableCharacters/44.png" )]
		static public const Mon8Images:Class;
		
		/** The array which contains all the characters imaeg */
		static private const _CharactersImages:Object = new Object();
		
		/** The image of potion */
		[Embed( source = "/../art/items/potion.png" )]
		static public const PotionImage:Class;
		
		/** The image of ether */
		[Embed( source = "/../art/items/ether.png" )]
		static public const EtherImage:Class;
		
		/** The array which contains all the items images */
		static private const _ItemsImages:Object = new Object();
		
		/**
		 * Initialize the all the images
		 * Add all characters images to the array
		 * Add all items images to the array
		 */
		static public function initialize():void {
			_CharactersImages[ "player" ] = PlayerImages;
			_CharactersImages[ "mon1" ] = Mon1Images;
			_CharactersImages[ "mon2" ] = Mon2Images;
			_CharactersImages[ "mon3" ] = Mon3Images;
			_CharactersImages[ "mon4" ] = Mon4Images;
			_CharactersImages[ "mon5" ] = Mon5Images;
			_CharactersImages[ "mon6" ] = Mon6Images;
			_CharactersImages[ "mon7" ] = Mon7Images;
			_CharactersImages[ "mon8" ] = Mon8Images;
			
			_ItemsImages["potion"] = PotionImage;
			_ItemsImages["ether"] = EtherImage;
		}
		
		/**
		 * Get the image of the character given the code 
		 * 
		 * @param	charCode
		 * 			is the code of the character
		 * 
		 * @return	the image of the character associated with the given code
		 * 
		 * @throw	IllegalArgumentException
		 * 			if no character is associated with the given code
		 */
		static public function getCharacterImageByCharacterCode( charCode:int ):Class {
			return getCharacterImageByCharacterName( UnitsConstants.getCharacterName( charCode ) );
		}
		
		/**
		 * Get the image of the character given the name of that character
		 * 
		 * @param	charName
		 * 			is the name of the character
		 * 
		 * @return	the image of the character associated with the given code
		 * 
		 * @throw	IllegalArgumentException
		 * 			if no character is associated with the given name
		 */
		static public function getCharacterImageByCharacterName( charName:String ):Class {
			if (_CharactersImages[charName] == undefined ||
				_CharactersImages[charName] == null)
				throw new IllegalArgumentException("charName", charName);
			return _CharactersImages[ charName ];
		}
		
		/**
		 * Get the image of the item given the code
		 * 
		 * @param	itemCode
		 * 			is the code of the character
		 * @return	the image of the item with the given code
		 * @throw	IllegalArgumentException
		 * 			if there is no item with the given code
		 */
		static public function getItemImageByItemCode( itemCode:int ):Class {
			return getItemImageByItemName( UnitsConstants.getItemName( itemCode ) );
		}
		
		/**
		 * Get the image of the item given the name
		 * 
		 * @param	itemName
		 * 			is the code of the character
		 * @return	the image of the item with the given name
		 * @throw	IllegalArgumentException
		 * 			if there is no item with the given name
		 */
		static public function getItemImageByItemName( itemName:String ):Class {
			if (_ItemsImages[itemName] == undefined ||
				_ItemsImages[itemName] == null)
				throw new IllegalArgumentException("itemName", itemName);
			return _ItemsImages[ itemName ];
		}
	}
}