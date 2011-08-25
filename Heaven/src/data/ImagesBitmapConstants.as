package data {
	import errors.IllegalArgumentException;
	
	import events.FlixelPlatformGameEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * ImagesBitmapConstants class
	 * @author Ken
	 * contains all BitmapData of external Image
	 * to be used only during design stage (images are
	 * embeded but not read from that)
	 */
	public class ImagesBitmapConstants extends Constants {
		
		/** The image of all the tiles */
		static private var _TILES_IMAGES:BitmapData;
		
		/** Get the image of all the tiles */
		static public function get TILES_IMAGES():BitmapData {
			return _TILES_IMAGES;
		}
		
		/**
		 * Object which contains all the character images
		 */
		static private const _allCharactersImages:Object = new Object();
		
		/**
		 * Object which contains all character type/class names and urls to
		 * image of that type/class of character
		 * also, it contains url to image of all the tiles as well
		 */
		static private const _allCharactersImagesUrlsAndNames:Array = new Array();
		
		/**
		 * Object which contains all items images
		 */
		static private const _allItemsImages:Object = new Object();
		
		/**
		 * Object which contains all items name and urls to image
		 */
		static private const _allItemsUrlsAndNames:Array = new Array();
		
		/**
		 * Object which contains all skills images
		 */
		static private const _allSkillsImages:Object = new Object();
		
		/**
		 * Object which contains all items name and urls to image
		 */
		static private const _allSKillsUrlsAndNames:Array = new Array();
		
		/**
		 * Enum indicating images of characters or items are currently being loaded
		 */
		static private const _CHARACTERS_AND_TILES_IMAGES:int = 1;
		static private const _ITEMS_IMAGES:int = 2;
		static private const _SKILLS_IMAGES:int = 3;
		static private var _imageType:int;
		
		/**
		 * Index to indicate which image is currently loading
		 */
		static private var _imageIndex:int;
		
		/**
		 * Start loading images from external files
		 */
		override public function loadConstants():void {
			initializeImagesUrlsAndNames();
			_imageIndex = -1;
			_imageType = _CHARACTERS_AND_TILES_IMAGES;
			loadNextImage();
		}
		
		/**
		 * Initialize the character type/class names and images urls
		 * by reading all characterData from CharactersConstants.as
		 * Also, remember tileImages url which is provided by URLs class
		 */
		private function initializeImagesUrlsAndNames():void {
			
			// retrieve urls of images of all the characters
			var charactersConstants:Object = CharactersConstants.getAllCharactersConstants();
			for ( var characterName:String in charactersConstants ) {
				var characterImage:Object = new Object();
				characterImage[ "key" ] = characterName;
				characterImage[ "url" ] = charactersConstants[ characterName ].imageUrl;
				_allCharactersImagesUrlsAndNames.push( characterImage );
			}
			
			// retrieve url of the tiles image
			var tilesImages:Object = new Object();
			tilesImages[ "key" ] = "tileImages";
			tilesImages[ "url" ] = URLs.TILES_IMAGES_URL;
			_allCharactersImagesUrlsAndNames.push( tilesImages );
			
			// retrieve url of images of all the items
			var itemsImagesUrls:Object = ItemsConstants.getAllItemsImagesUrls();
			for ( var itemName:String in itemsImagesUrls) {
				var itemImage:Object = new Object();
				itemImage["key"] = itemName; itemImage["url"] = itemsImagesUrls[itemName];
				_allItemsUrlsAndNames.push(itemImage);
			}
			
			// retrieve url of images of all the skill
			var skillsImagesUrls:Object = SkillsConstants.getAllSkillsImagesUrls();
			for ( var skillName:String in skillsImagesUrls) {
				var skillImage:Object = new Object();
				skillImage["key"] = skillName; skillImage["url"] = skillsImagesUrls[skillName];
				_allSKillsUrlsAndNames.push(skillImage);
			}
		}
		
		/**
		 * Load the next image
		 * dispatch FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE
		 * if all images are loaded
		 */
		private function loadNextImage():void {
			if (_imageType == _CHARACTERS_AND_TILES_IMAGES) {
				// Are all characters and tiles images loaded?
				if ( ++_imageIndex >= _allCharactersImagesUrlsAndNames.length ) {
					// Yes
					// Load items images
					_imageIndex = -1; _imageType = _ITEMS_IMAGES;
					loadNextImage();
				} else {
					// No
					// Load next image
					var characterTileImageLoader:Loader = new Loader();
					characterTileImageLoader.contentLoaderInfo.addEventListener(
						Event.COMPLETE, loadImageComplete );
					characterTileImageLoader.load(
						new URLRequest( _allCharactersImagesUrlsAndNames[ _imageIndex ][ "url" ] ) );
				}
			} else if (_imageType == _ITEMS_IMAGES) {
				// Are all items images loaded?
				if ( ++_imageIndex >= _allItemsUrlsAndNames.length ) {
					// Yes
					// Load skills images
					_imageIndex = -1; _imageType = _SKILLS_IMAGES;
					loadNextImage();
					return;
				} else {
					// No
					// Load next image
					var itemImageLoader:Loader = new Loader();
					itemImageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadImageComplete );
					itemImageLoader.load( new URLRequest( _allItemsUrlsAndNames[ _imageIndex ][ "url" ] ) );
				}
			} else if (_imageType == _SKILLS_IMAGES) {
				// Are all items images loaded?
				if ( ++_imageIndex >= _allSKillsUrlsAndNames.length ) {
					// Yes
					// Indicate loading is done
					dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
					return;
				} else {
					// No
					// Load next image
					var skillImageLoader:Loader = new Loader();
					skillImageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadImageComplete );
					skillImageLoader.load( new URLRequest( _allSKillsUrlsAndNames[ _imageIndex ][ "url" ] ) );
				}
			}
		}
		
		
		/**
		 * Event listener to loader of external image
		 * then read the bitmap data of the external image
		 * and stores it in allCharactersImages
		 * and then load the next image
		 * @param	event	is Event.COMPLETE which is attached to image loader
		 */
		private function loadImageComplete( event:Event ):void {
			if (_imageType == _CHARACTERS_AND_TILES_IMAGES) {
				// Is the image tiles' image?
				if ( _allCharactersImagesUrlsAndNames[ _imageIndex ][ "key" ] == "tileImages" )
					// Yes
					_TILES_IMAGES = ( Bitmap( LoaderInfo( event.target ).content ) ).bitmapData;
				else
					// No
					_allCharactersImages[ _allCharactersImagesUrlsAndNames[ _imageIndex ][ "key" ] ] =
						( Bitmap( LoaderInfo( event.target ).content ) ).bitmapData;
				loadNextImage();
			} else if (_imageType == _ITEMS_IMAGES) {
				_allItemsImages[_allItemsUrlsAndNames[_imageIndex]["key"]] = 
					( Bitmap( LoaderInfo( event.target ).content ) ).bitmapData;
				loadNextImage();				
			} else if (_imageType == _SKILLS_IMAGES) {
				_allSkillsImages[_allSKillsUrlsAndNames[_imageIndex]["key"]] = 
					( Bitmap( LoaderInfo( event.target ).content ) ).bitmapData;
				loadNextImage();				
			}
		}
		
		/**
		 * Get the bitmap data of the image of one type/class of character given the characterCode
		 * @param	charCode					is the code of the character to get the image
		 * @return	BitmapData					of the image of the type/class of character associated with
		 * 										the given characterCode
		 * @throw	IllegalArgumentException	if the characterCode given does not match any
		 * 										particular type/class of character
		 */
		static public function getCharacterImageBitmapDataByCharacterCode( charCode:int ):BitmapData {
			return getCharacterImageBitmapDataByCharacterName( UnitsConstants.getCharacterName( charCode ) );
		}
		
		/**
		 * Get the bitmap data of the image of one type/class of character given the characterName
		 * @param	charName					is the name of the character to get the image
		 * @return	BitmapData					of the image of the type/class of character associated with
		 * 										the given characterCode
		 * @throw	IllegalArgumentException	if the characterName given does not match any
		 * 										particular type/class of character
		 */
		static public function getCharacterImageBitmapDataByCharacterName( charName:String ):BitmapData {
			if ( _allCharactersImages[ charName ] == undefined || _allCharactersImages[ charName ] == null )
				throw new IllegalArgumentException( "charName", charName );
			return _allCharactersImages[ charName ];
		}
		
		/**
		 * Get the bitmap data of the image of a item, given its code
		 * 
		 * @param	itemCode
		 * 			is the code of the item to get the image
		 * @return	BitmapData
		 * 			of the image of the item with the given code
		 * @throw	IllegalArgumentException
		 * 			if there is no item with the given code
		 */
		static public function getItemImageBitmapDataByItemCode(itemCode:int):BitmapData {
			return getItemImageBitmapDataByItemName(UnitsConstants.getItemName(itemCode));
		}
		
		/**
		 * Get the bitmap data of the image of a item, given its name
		 * 
		 * @param	itemName
		 * 			is the name of the item to get the image
		 * @return	BitmapData
		 * 			of the image of the item with the given name
		 * @throw	IllegalArgumentException
		 * 			if there is no item with the given name
		 */
		static public function getItemImageBitmapDataByItemName(itemName:String):BitmapData {
			if ( _allItemsImages[ itemName ] == undefined || _allItemsImages[ itemName ] == null )
				throw new IllegalArgumentException( "itemName", itemName );
			return _allItemsImages[ itemName ];
		}
		
		/**
		 * Get the bitmap data of the image of a skill, given its code
		 * 
		 * @param	skillCode
		 * 			is the code of the skill to get the image
		 * @return	BitmapData
		 * 			of the image of the skill with the given code
		 * @throw	IllegalArgumentException
		 * 			if there is no skill with the given code
		 */
		static public function getSkillImageBitmapDataByskillCode(skillCode:int):BitmapData {
			return getSkillImageBitmapDataByskillName(UnitsConstants.getSkillName(skillCode));
		}
		
		/**
		 * Get the bitmap data of the image of a skill, given its name
		 * 
		 * @param	skillName
		 * 			is the name of the skill to get the image
		 * @return	BitmapData
		 * 			of the image of the skill with the given name
		 * @throw	IllegalArgumentException
		 * 			if there is no skill with the given name
		 */
		static public function getSkillImageBitmapDataByskillName(skillName:String):BitmapData {
			if ( _allSkillsImages[ skillName ] == undefined || _allSkillsImages[ skillName ] == null )
				throw new IllegalArgumentException( "skillName", skillName );
			return _allSkillsImages[ skillName ];
		}
	}
}