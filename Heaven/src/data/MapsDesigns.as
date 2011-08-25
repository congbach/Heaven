package data {
	import embeded.EmbededMaps;
	
	import errors.IllegalArgumentException;
	
	import events.FlixelPlatformGameEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * MapsDesigns class
	 * @author Ken
	 * contains the design of all maps
	 * in String
	 */
	public class MapsDesigns extends Constants {
		
		/** Enum to indicate which part of the map is currently being loaded */
		static private const TILES:int = 0;
		static private const CHARACTERS:int = 1;
		static private const ITEMS:int = 2;
		static private const SPECIALS:int = 3;
		/** Int to indicate which part of the map is currently being loaded */
		static private var mapPart:int;
		
		/** The array which contains all the maps */
		static private const maps:Vector.< Vector.< String > > = new Vector.< Vector.< String > >();
		/** The array which contains all the specials part (in xml format) of the maps */
		static private const mapsSpecials:Vector.<XML> = new Vector.<XML>();
		/** The map which is currently loaded */
		static private var map:Vector.<String>;
		/** The index of the map which is currently loaded */
		static private var mapIndex:int;
		/** The number of total map */
		static private var totalMap:int;
		
		/**
		 * Start loading all the maps
		 */
		override public function loadConstants():void {
			mapIndex = -1;
			if ( GameConstants.EMBEDED_ALL )
				totalMap = EmbededMaps.TxtMaps.length;
			else
				totalMap = URLs.MAP_URLS.length;
			
			mapPart = TILES;
			loadNextMap();
		}
		
		/**
		 * Event listener to indicate that the current map has
		 * been successfully loaded
		 * stores the map in maps and then load the next map
		 * @param	event	is Event.COMPLETE which is attached to the loader
		 */
		private function loadMapComplete( event:Event ):void {
			loadMap( event.target.data );
		}
		
		/**
		 * Store the map in the list
		 * @param	txtMap	is the string design of the map
		 */
		private function loadMap( txtMap:String ):void {
			if (! map) map = new Vector.<String>();
			switch (mapPart) {
				case TILES: case CHARACTERS: case ITEMS:
					map.push( txtMap );
					break;
				case SPECIALS:
					mapsSpecials.push(new XML(txtMap));
					break;
			}
			
			// If the map is completely loaded
			if (mapPart == SPECIALS) {
				maps.push(map);
				map = null;
			}
			
			// Change the part map which is loading
			switch (mapPart) {
				case TILES: mapPart = CHARACTERS; break;
				case CHARACTERS: mapPart = ITEMS; break;
				case ITEMS: mapPart = SPECIALS; break;
				case SPECIALS: mapPart = TILES; break;
			}
			
			loadNextMap();
		}
		
		/**
		 * Load the next map
		 * if all maps have already been loaded
		 * dispatch FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLET
		 */
		private function loadNextMap():void {
			switch (mapPart) {
				case TILES:
					// If all the maps are loaded
					if ( ++mapIndex >= totalMap ) {
						dispatchEvent( new Event( FlixelPlatformGameEvent.CONSTANTS_LOAD_COMPLETE ) );
						return;
					}
					
					if ( GameConstants.EMBEDED_ALL ) {
						loadMap( new EmbededMaps.TxtMaps[ mapIndex ][ mapPart ]() );
					} else {
						var tileLoader:URLLoader = new URLLoader();
						tileLoader.addEventListener( Event.COMPLETE, loadMapComplete );
						tileLoader.load( new URLRequest( URLs.MAP_URLS[ mapIndex ] + URLs.MAP_TILES_SUFFIX ) );
					}
					break;
					
				case CHARACTERS:
					if ( GameConstants.EMBEDED_ALL ) {
						loadMap( new EmbededMaps.TxtMaps[ mapIndex ][ mapPart ]() );
					} else {
						var characterLoader:URLLoader = new URLLoader();
						characterLoader.addEventListener( Event.COMPLETE, loadMapComplete );
						characterLoader.load( new URLRequest( URLs.MAP_URLS[ mapIndex ] + URLs.MAP_CHARACTERS_SUFFIX ) );
					}
					break;
					
				case ITEMS:
					if ( GameConstants.EMBEDED_ALL ) {
						loadMap( new EmbededMaps.TxtMaps[ mapIndex ][ mapPart ]() );
					} else {
						var itemLoader:URLLoader = new URLLoader();
						itemLoader.addEventListener( Event.COMPLETE, loadMapComplete );
						itemLoader.load( new URLRequest( URLs.MAP_URLS[ mapIndex ] + URLs.MAP_ITEMS_SUFFIX ) );
					}
					break;
					
				case SPECIALS:
					if ( GameConstants.EMBEDED_ALL ) {
						loadMap( new EmbededMaps.TxtMaps[ mapIndex ][ mapPart ]() );
					} else {
						var specialsLoader:URLLoader = new URLLoader();
						specialsLoader.addEventListener( Event.COMPLETE, loadMapComplete );
						specialsLoader.load( new URLRequest( URLs.MAP_URLS[ mapIndex ] + URLs.MAP_SPECIALS_SUFFIX ) );
					}
			}
			
		}
		
		/**
		 * Get the map given the index of that map
		 * @param	mapIndex					is the index of the map to get
		 * @return	Vector.< String >			is the map associated with the given index
		 * @throw	IllegalArgumentException	if the given index < 0 or
		 * 										there is no map associated with
		 * 										that index
		 */
		static public function getMap( mapIndex:int ):Vector.< String > {
			if ( mapIndex < 0 || mapIndex >= maps.length )
				throw new IllegalArgumentException( "mapIndex", mapIndex );
			return maps[ mapIndex ];
		}
		
		/**
		 * Get the map given the index of that map
		 * @param	mapIndex					is the index of the map to get
		 * @return	XML							is the map' specials associated with the given index
		 * @throw	IllegalArgumentException	if the given index < 0 or
		 * 										there is no map associated with
		 * 										that index
		 */
		static public function getMapSpecials( mapIndex:int ):XML {
			if ( mapIndex < 0 || mapIndex >= mapsSpecials.length )
				throw new IllegalArgumentException( "mapIndex", mapIndex );
			return mapsSpecials[ mapIndex ];
		}
		
	}
}