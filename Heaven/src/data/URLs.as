package data {
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	
	/**
	 * URLs class
	 * @author Ken
	 * contains all the URLs to external
	 * constants files
	 */
	public class URLs extends Constants {
		/** The url to the general config files */
		static public const GENERAL_CONTANTS_URL:String = GameConstants.ROOT_URL + "design/config/constants.xml";
		/** The folder which contains all the maps */
		static public const MAP_FOLDER_URL:String = GameConstants.ROOT_URL + "design/maps/";
		/** The vector which contains all the maps' urls */
		static public const MAP_URLS:Vector.< String > = new Vector.<String>();
		/** Suffix of all the maps' parts */
		static public const MAP_TILES_SUFFIX:String = "_tiles.txt";
		static public const MAP_CHARACTERS_SUFFIX:String = "_characters.txt";
		static public const MAP_ITEMS_SUFFIX:String = "_items.txt";
		static public const MAP_SPECIALS_SUFFIX:String = "_specials.xml";
		
		/** Url to the config file of characters */
		static public const CHARACTERS_CONSTANTS_CONFIG_FILE:String =
			GameConstants.ROOT_URL + "design/config/charactersConstants.xml";
		/** Url to the config file of items */
		static public const ITEMS_CONSTANTS_CONFIG_FILE:String = 
			GameConstants.ROOT_URL + "design/config/itemsConstants.xml";
		/** Url to the config file of skills */
		static public const SKILLS_CONSTANTS_CONFIG_FILE:String =
			GameConstants.ROOT_URL + "design/config/skillsConstants.xml";
		/** Url to the config file of units' codes */
		static public const UNITS_CODES_CONFIG_FILE:String = 
			GameConstants.ROOT_URL + "design/config/unitsCodes.xml";
		/** Url to the images of all the tiles */
		static public const TILES_IMAGES_URL:String = "../art/tiles/all_tiles.png";
		
		override public function loadConstants():void {
			for (var mapId:int = 0; mapId < GameConstants.TOTAL_MAPS; mapId++)
				MAP_URLS.push( MAP_FOLDER_URL + "map" + (mapId < 10 ? "0" : "") + mapId );
			
			dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
		}
	}
}