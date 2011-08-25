package gui.hud {
	import gui.KeyboardEventsManager;
	import data.GameConstants;
	import data.KeyboardConstants;
	
	import gui.states.PlayState;
	import gui.characters.PlayableCharacter;
	import gui.SaveLoadManager;
	import gui.states.TitleScreenState;
	
	import org.flixel.FlxG;
	
	/**
	 * HUDMenuScreen
	 * @author Ken
	 * 
	 * The menu screen when player presses START during playing the game
	 */
	public class HUDMenuScreen extends HUDScreen {
		
		/** The sub-screen which displays the stats of the character */
		private var _characterStatsHUDScreen:HUDCharacterStatsScreen;
		/** The items hud screen */
		private var _itemsHUDScreen:HUDItemsScreen;
		/** The skills hud screen */
		private var _skillsHUDScreen:HUDCharacterSkillsScreen;
		/** The controls hud screen */
		private var _controlsHUDScreen:HUDControlsScreen;
		
		/**
		 * Default constructor
		 * 
		 * @param	callBack
		 * 			is the callBack function when this screen is dismissed
		 */
		public function HUDMenuScreen(callBack:Function) {
			super("Nil", "Nil", callBack);
			
			var x:Number = GameConstants.HUD_MENU_SCREEN_LOCATION.x;
			var y:Number = GameConstants.HUD_MENU_SCREEN_LOCATION.y;
			reset(x, y);
			width = GameConstants.HUD_MENU_SCREEN_SIZE.width;
			height = GameConstants.HUD_MENU_SCREEN_SIZE.height;
			createBackgroundRectangle();
			
			var player:PlayableCharacter = PlayState.getInstance().player;
			_characterStatsHUDScreen = new HUDCharacterStatsScreen(player, closeSubScreen);
			_characterStatsHUDScreen.selected();
			_characterStatsHUDScreen.canListenKeyboardEvents = false;
			_screen.add(_characterStatsHUDScreen, true);
			
//			_itemsList =
//				new HUDScreenItemsList(GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_LOCATION.x,
//					GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_LOCATION.y,
//					GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_SIZE.width,
//					GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_SIZE.height,
//					openSubScreen);
			_itemsList.reset(GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_LOCATION.x,
				GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_LOCATION.y);
			_screen.remove(_itemsList);
			//trace(_itemsList.x, _itemsList.y);
			_screen.add(_itemsList, true);
			//trace(_itemsList.x, _itemsList.y);
			_itemsList.width = GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_SIZE.width;
			_itemsList.height = GameConstants.HUD_MENU_SCREEN_ITEMS_LIST_SIZE.height;
			_itemsList.createBackgroundRectangle();
			_itemsList.resetSelectedCallback(openSubScreen);
			//_itemsList.active = false;
			_screen.add(_itemsList);
			
			_itemsHUDScreen = new HUDItemsScreen(closeSubScreen);
			_subScreen.add(_itemsHUDScreen);
			_itemsList.addItem(
				new HUDScreenItem(_itemsHUDScreen.title, _itemsHUDScreen.description, _itemsHUDScreen));
			
			_skillsHUDScreen = new HUDCharacterSkillsScreen(player, closeSubScreen);
			_subScreen.add(_skillsHUDScreen);
			_itemsList.addItem(
				new HUDScreenItem(_skillsHUDScreen.title, _skillsHUDScreen.description, _skillsHUDScreen));
			
			_controlsHUDScreen = new HUDControlsScreen(closeSubScreen);
			_subScreen.add(_controlsHUDScreen);
			_itemsList.addItem(
				new HUDScreenItem(_controlsHUDScreen.title, _controlsHUDScreen.description,
								  _controlsHUDScreen));
			
			_itemsList.addItem(new HUDScreenItem("SAVE", "", null, saveGame));
			_itemsList.addItem(new HUDScreenItem("RETURN TO TITLE", "", null, returnToTitle));
			
			//_itemsList.selected();
		}
		
		/**
		 * Save the game
		 */
		public function saveGame():void {
			SaveLoadManager.save();
		}
		
		/**
		 * Return to title function, get the game state back to title screen state
		 */
		public function returnToTitle():void {
			//TitleScreenState.getInstance().resetState();
			FlxG.state = TitleScreenState.getInstance();
		}
		
		override public function resetScreen(...args):void {
			super.resetScreen();
			
			var player:PlayableCharacter = PlayState.getInstance().player;
			_characterStatsHUDScreen.resetScreen(player);
			_characterStatsHUDScreen.selected();
			_characterStatsHUDScreen.canListenKeyboardEvents = false;
			
			finished();
		}
		
		override public function updateScreen(... optionalArgs):void {
			_characterStatsHUDScreen.updateScreen();
			_itemsList.updateScreen();
		}
		
		override public function update():void {
			// If the player wants to quit this menu
			if (/*! _isPlayerNavigatingSubscreen */
				canListenKeyboardEvents && _keyboardEventManager.justPressed(KeyboardConstants.START))
				finished();
			else
				super.update();
		}
	}
}