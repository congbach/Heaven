package {
	import data.ConstantsInitializer;
	import data.GameConstants;
	import data.GameDebugModeConstants;
	import data.KeyboardConstants;
	import data.URLs;
	
	import embeded.EmbededInitializer;
	
	import flash.events.Event;
	import gui.states.TitleScreenState;
	
	import org.flixel.*;
	
	import utils.MapSplitter;
	
	[SWF(width="1024", height="600", backgroundColor="#000000")]
	[Frame(factoryClass="HeavenPreloader")]
	
	/**
	 * Heaven
	 * 
	 * Main class of the game.
	 * The game is simply a platform game, where player
	 * explores from area to area, picking items/weapons
	 * and fighting monsters. Proposed type of weapon
	 * player can use is gun; sword, axe, spear, bow, ...
	 * will be consider later. Player will have skills
	 * such as double jump, slide,... Monster will
	 * also be of many types, from flying to invisible.
	 */
	public class Heaven extends FlxGame {
		
		/**
		 * Default constructor
		 */
		public function Heaven() {
			var scale:Number = 2;
			var width:Number = 1024;
			var height:Number = 600;
			super( width/scale, height/scale, TitleScreenState, scale );
			FlxState.bgColor = 0xff131c1b;
			useDefaultHotKeys = true;
			
//			var row:int = 22;
//			var col:int = 60;
//			var w:int = 117 - col + 1;
//			var h:int = 38 - row + 1;
//			
//			MapSplitter.extractMapFromUrl(URLs.MAP_FOLDER_URL + "map00_tiles - Copy.txt", row, col, w, h);
//			MapSplitter.extractMapFromUrl(URLs.MAP_FOLDER_URL + "map00_characters - Copy.txt", row, col, w, h);
//			MapSplitter.extractMapFromUrl(URLs.MAP_FOLDER_URL + "map00_items - Copy.txt", row, col, w, h);
		}
		
		/**
		 * The flash file is loaded, flixel library is created.
		 * Then start loading the game
		 */
		override public function createComplete():void {
			// load the constants first (non-embeded mode)
			loadConstants();
		}
		
		/**
		 * Load all the designed constants
		 * Only load when embeded is not enable (i.e. design stage)
		 */
		private function loadConstants():void {
			addEventListener( Event.ENTER_FRAME, checkLoadComplete );
			EmbededInitializer.initialize();
			ConstantsInitializer.initializeConstants();
		}
		
		/**
		 * Event function to check whether constants
		 * are loaded sucessfully. If it is, remove this event
		 * listener and start the game
		 */
		private function checkLoadComplete( event:Event ):void {
			// Is the constants loaded successfully?
			if ( ConstantsInitializer.didLoadComplete() ) {
				// Yes
				removeEventListener( Event.ENTER_FRAME, checkLoadComplete );
				start();
			}
		}
		
		/**
		 * Start this game
		 */
		private function start():void {
			//switchState(PlayState.getInstance());
			switchState(TitleScreenState.getInstance());
			FlxState.screen.unsafeBind(FlxG.buffer);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		override protected function update(event:Event):void {
			super.update(event);
			if (GameDebugModeConstants.DEBUG_MODE_ENABLED && GameDebugModeConstants.SHOW_BOUNDS) {
				if (FlxG.keys.justPressed(KeyboardConstants.TOGGLE_SHOW_BOUNDS))
					FlxG.showBounds = ! FlxG.showBounds;
				//if (FlxG.keys.justPressed(KeyboardConstants.SPEED_UP)) 
					//FlxG.framerate += 10;
				//if (FlxG.keys.justPressed(KeyboardConstants.SPEED_DOWN))
					//FlxG.framerate = Math.max(1, FlxG.framerate - 1);
			}
		}
	}
}
