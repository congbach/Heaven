package embeded {
	
	/**
	 * EmbededMaps class
	 * @author Ken
	 * contains all the designs of the maps
	 */
	public class EmbededMaps {
		
		/** The designed maps */
		[Embed( source="/../design/maps/map00_tiles.txt", mimeType="application/octet-stream" )]
		static private const TxtMap00Tiles:Class;
		[Embed( source="/../design/maps/map00_characters.txt", mimeType="application/octet-stream" )]
		static private const TxtMap00Characters:Class;
		[Embed( source="/../design/maps/map00_items.txt", mimeType="application/octet-stream" )]
		static private const TxtMap00Items:Class;
		[Embed( source="/../design/maps/map00_specials.xml", mimeType="application/octet-stream" )]
		static private const TxtMap00Specials:Class;
		
		[Embed( source="/../design/maps/map01_tiles.txt", mimeType="application/octet-stream" )]
		static private const TxtMap01Tiles:Class;
		[Embed( source="/../design/maps/map01_characters.txt", mimeType="application/octet-stream" )]
		static private const TxtMap01Characters:Class;
		[Embed( source="/../design/maps/map01_items.txt", mimeType="application/octet-stream" )]
		static private const TxtMap01Items:Class;
		[Embed( source="/../design/maps/map01_specials.xml", mimeType="application/octet-stream" )]
		static private const TxtMap01Specials:Class;
		
		[Embed( source="/../design/maps/map02_tiles.txt", mimeType="application/octet-stream" )]
		static private const TxtMap02Tiles:Class;
		[Embed( source="/../design/maps/map02_characters.txt", mimeType="application/octet-stream" )]
		static private const TxtMap02Characters:Class;
		[Embed( source="/../design/maps/map02_items.txt", mimeType="application/octet-stream" )]
		static private const TxtMap02Items:Class;
		[Embed( source="/../design/maps/map02_specials.xml", mimeType="application/octet-stream" )]
		static private const TxtMap02Specials:Class;
		
		[Embed( source="/../design/maps/map03_tiles.txt", mimeType="application/octet-stream" )]
		static private const TxtMap03Tiles:Class;
		[Embed( source="/../design/maps/map03_characters.txt", mimeType="application/octet-stream" )]
		static private const TxtMap03Characters:Class;
		[Embed( source="/../design/maps/map03_items.txt", mimeType="application/octet-stream" )]
		static private const TxtMap03Items:Class;
		[Embed( source="/../design/maps/map03_specials.xml", mimeType="application/octet-stream" )]
		static private const TxtMap03Specials:Class;
		
		/**
		 * Vector which contains all the designs of the maps
		 */
		static private const _TxtMaps:Vector.< Vector.< Class > > =  new Vector.< Vector.< Class > >();
		
		/**
		 * Initialize funtion to push all the maps designs
		 * into one vector
		 */
		static public function initialize():void {
			var map00:Vector.<Class> = new Vector.<Class>();
			map00.push(TxtMap00Tiles); map00.push(TxtMap00Characters);
			map00.push(TxtMap00Items); map00.push(TxtMap00Specials);
			_TxtMaps.push( map00 );
			
			var map01:Vector.<Class> = new Vector.<Class>();
			map01.push(TxtMap01Tiles); map01.push(TxtMap01Characters);
			map01.push(TxtMap01Items); map01.push(TxtMap01Specials);
			_TxtMaps.push( map01 );
			
			var map02:Vector.<Class> = new Vector.<Class>();
			map02.push(TxtMap02Tiles); map02.push(TxtMap02Characters);
			map02.push(TxtMap02Items); map02.push(TxtMap02Specials);
			_TxtMaps.push( map02 );
			
			var map03:Vector.<Class> = new Vector.<Class>();
			map03.push(TxtMap03Tiles); map03.push(TxtMap03Characters);
			map03.push(TxtMap03Items); map03.push(TxtMap03Specials);
			_TxtMaps.push( map03 );
		}
		
		/**
		 * Return the vector which contains all the designs of the maps
		 * For safety, only return a clone of the vector
		 * @return	Vector	which contains all the maps designs
		 */
		static public function get TxtMaps():Vector.< Vector.< Class > > {
			return _TxtMaps.slice();
		}
	}
}