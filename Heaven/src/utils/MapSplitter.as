package utils {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * MapSplitter class
	 * 
	 * Split the map into smaller maps
	 * 
	 * @author Ken
	 */
	public class MapSplitter {
		
		/** The index of the row of starting point */
		static private var _row:uint;
		/** The index of the col of starting point */
		static private var _col:uint;
		/** The width of the extracted map */
		static private var _width:uint;
		/** The height of the extracted map */
		static private var _height:uint;
		
		/**
		 * Extract a small map from the given map
		 * 
		 * @param	mapUrl
		 * 			is the url to the map
		 * @param	row
		 * 			is the index of the row of starting point
		 * @param	col
		 * 			is the index of the col of starting point
		 * @param	width
		 * 			is the width of the extracted map
		 * @param	height
		 * 			is the height of the extracted map
		 */
		static public function extractMapFromUrl(mapUrl:String, row:uint, col:uint, width:uint, height:uint):void {
			_row = row; _col = col; _width = width; _height = height;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, loadComplete );
			loader.load( new URLRequest( mapUrl ) );
		}
		
		/**
		 * Extract a small map from the given map
		 * 
		 * @param	mapTxt
		 * 			is the txt format of the map
		 * @param	row
		 * 			is the index of the row of starting point
		 * @param	col
		 * 			is the index of the col of starting point
		 * @param	width
		 * 			is the width of the extracted map
		 * @param	height
		 * 			is the height of the extracted map
		 */
		static public function extractMap(mapTxt:String, row:uint, col:uint, width:uint, height:uint):void {
			var map:Array = mapTxt.split( "\n" );
			for (var i:int = 0; i < map.length; i++)
				map[i] = (map[i] as String).split(",");
			
			var extractedMap:String = "";			
			for (var rowIndex:int = row; rowIndex < row + height; rowIndex++) {
				for (var colIndex:int = col; colIndex < col + width; colIndex++) {
					extractedMap += map[rowIndex][colIndex];
					if (colIndex < col + width - 1) extractedMap += ",";
				}
				if (rowIndex < row + height - 1) extractedMap += "\n";
			}
			
			trace(extractedMap);
			trace("==================================");
			
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
		static public function loadComplete(event:Event):void {
			extractMap(event.target.data, _row, _col, _width, _height);
		}
	}
}