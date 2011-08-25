package gui.states {
	import gui.characters.PlayableCharacter;
	import gui.SaveLoadManager;
	import data.GameConstants;
	
	import errors.NonStaticCallSingletonPattern;
	import errors.SingletonPatternViolatedError;
	
	import gui.hud.HUDControlsScreen;
	import gui.hud.HUDScreen;
	import gui.hud.HUDScreenItem;
	import gui.hud.HUDScreenItemsList;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.data.FlxSize;

	public class TitleScreenState extends FlxState {
		// Singleton pattern
		static private var instance:TitleScreenState;
		static private var staticCall:Boolean = false;
		static private var canCreateNew:Boolean = true;
		
		static public function getInstance():TitleScreenState {
			if ( instance == null ) {
				staticCall = true;
				instance = new TitleScreenState();
				staticCall = false;
			}
			return instance;
		}
		
		/** List of options for player to choose */
		private var _options:HUDScreenItemsList;
		/** The controls screen */
		private var _controlsScreen:HUDControlsScreen;
		
		public function TitleScreenState() {			
			super();
			
			if ( ! staticCall )
				throw new NonStaticCallSingletonPattern( "GameTitleScreenState" );
			if ( ! canCreateNew )
				throw new SingletonPatternViolatedError( "GameTitleScreenState" );
			
			canCreateNew = false;
			instance = this;
			
			var optionsListLocation:FlxPoint = GameConstants.TITLE_SCREEN_OPTIONS_LIST_LOCATION;
			var optionsListSize:FlxSize = GameConstants.TITLE_SCREEN_OPTIONS_LIST_SIZE;
			_options = new HUDScreenItemsList(optionsListLocation.x, optionsListLocation.y,
				optionsListSize.width, optionsListSize.height, openSubScreen, null, 0, 0, 0, 0,
				GameConstants.HUD_SCREEN_ITEMS_LIST_LINE_SPACING, false);
			add(_options);
			
			// New game option
			var newGameOption:HUDScreenItem = new HUDScreenItem("New game", "", null, startGame);
			_options.addItem(newGameOption);
			
			// Load game option
			var loadGameOption:HUDScreenItem = new HUDScreenItem("Continue", "", null, loadGame);
			_options.addItem(loadGameOption);
			
			// Controls option
			_controlsScreen = new HUDControlsScreen(closeSubScreen);
			add(_controlsScreen);
			var openControlsOption:HUDScreenItem = new HUDScreenItem("Controls", "", _controlsScreen);
			_options.addItem(openControlsOption);
			
			// Exit game option
//			var exitGameOption:HUDScreenItem = new HUDScreenItem("Exit", "", null, exitGame);
//			_options.addItem(exitGameOption);
		}
		
		override public function create():void {
			SaveLoadManager.reset();
			PlayableCharacter.reset();
			_options.updateScreen();
		}
		
		///**
		 //* Reset the state (for return-to-title menu item)
		 //*/
		//public function resetState():void {
			//_options.updateScreen();
		//}
		
		override public function destroy():void {
			//super.destroy();
		}
		
		/**
		 * Start a new game
		 */
		public function startGame():void {
			FlxG.state = PlayState.getInstance();
		}
		
		/**
		 * Load a save game and continue
		 */
		public function loadGame():void {
			// not yet implemented
			//var save:SaveData = SaveLoadManager.load();
			SaveLoadManager.load();
			startGame();
		}
		
		/**
		 * Exit the game
		 */
		public function exitGame():void {
			// not yet implemented
		}
		
		/**
		 * Open a subscreen
		 * 
		 * @param	subscreen
		 * 			is the subscreen to open
		 */
		public function openSubScreen(subscreen:HUDScreen):void {
			_options.active = false;
			subscreen.selected();
		}
		
		/**
		 * Close a subscreen
		 * 
		 * @param	subscreen
		 * 			is the subscreen to close
		 */
		public function closeSubScreen(subscreen:HUDScreen):void {
			_options.active = true;
		}
	}
}