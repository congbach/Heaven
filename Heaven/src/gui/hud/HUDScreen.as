package gui.hud {
	import data.GameConstants;
	import data.KeyboardConstants;
	
	import gui.GameGroup;
	import gui.KeyboardEventsManager;
	
	import org.flixel.FlxSprite;
	
	/**
	 * HUDScreen class, extends the HUDScreenItem
	 * @author Ken
	 * 
	 * Represent a HUDScreen (Controller)
	 */
	public class HUDScreen extends HUDScreenItem {
		
		/** The back ground of this */
		protected var _background:GameGroup;
		/** The screen of this, when selected */
		protected var _screen:GameGroup;
		/** The screen which contains all hud-subscreens */
		protected var _subScreen:GameGroup;
		/** Flag to indicate whether player is navigating sub-screen of this */
		//protected var _isPlayerNavigatingSubscreen:Boolean;
		/** Reference to the keyboardEventsManager */
		protected var _keyboardEventManager:KeyboardEventsManager;
		/** List of internal items for player to navigate through */
		protected var _itemsList:HUDScreenItemsList;
		public function get itemsList():HUDScreenItemsList { return _itemsList; }
		/** Flag to indicate whether this can listen to keyboard events or not */
		public var canListenKeyboardEvents:Boolean;
		/**
		 * Flag in indicate whether this screen is just selected, so that it won't listen
		 * to keyboard event right away
		 */
		protected var _isJustSelected:Boolean;
		
		/**
		 * Default constructor
		 * 
		 * @param	title
		 * 			is the title of this screen
		 * @param	description
		 * 			is the description of this screen
		 * @param	callBack
		 * 			is the function to call when this screen is dismissed after selected
		 * @param	x
		 * 			is the x coordinate of this screen
		 * @param	y
		 * 			is the y coordinate of this screen
		 * @param	width
		 * 			is the width of this screen (if specified)
		 * @param	height
		 * 			is the height of this screen (if specified)
		 * @param	mouseOver
		 * 			indicated whether this screen is currenly being chosen or not
		 * @param	hasBackGround
		 * 			indicate whether to draw the background or not
		 */
		public function HUDScreen(title:String, description:String, callBack:Function = null, x:int = 0, y:int = 0,
									width:Number = 0, height:Number = 0, mouseOver:Boolean = false,
									hasBackGround:Boolean = true) {
			super(title, description, this, callBack, x, y, mouseOver);
			//this.x = x; this.y = y;
			reset(x, y);
			this.width = width; this.height = height;
			//this.scrollFactor.x = this.scrollFactor.y = 0;
			titleText.exists = false;
			
			//_isPlayerNavigatingSubscreen = false;
			_keyboardEventManager = KeyboardEventsManager.getInstance();
			canListenKeyboardEvents = false;
			_isJustSelected = false;
			
			_screen = new GameGroup();
			_screen.visible = false;
			_screen.active = false;
			//_screen.scrollFactor.x = _screen.scrollFactor.y = 0;
			add(_screen, true);
			
			_background = new GameGroup();
			_screen.add(_background, true);
			
			if (hasBackGround && width > 0 && height > 0)
				createBackgroundRectangle();
			
			_itemsList = new HUDScreenItemsList(0, 0, width, height);
			_itemsList.active = false;
			_screen.add(_itemsList, true);
			
			_subScreen = new GameGroup();
			_subScreen.visible = false;
			_subScreen.active = false;
			//_subScreen.scrollFactor.x = _subScreen.scrollFactor.y = 0;
			add(_subScreen, true);
		}
		
		/**
		 * Create the background rectangle of this screen
		 */
		public function createBackgroundRectangle():void {			
			// Create background rectangle
			var frame:FlxSprite = new FlxSprite();
			frame.createGraphic(width, height, GameConstants.HUD_SCREEN_FRAME_COLOR);
			//frame.scrollFactor.x = frame.scrollFactor.y = 0;
			_background.add(frame, true);
			
			var background:FlxSprite =
				new FlxSprite(GameConstants.HUD_SCREEN_FRAME_THICKNESS,
								GameConstants.HUD_SCREEN_FRAME_THICKNESS);
			background.createGraphic(width - 2 * GameConstants.HUD_SCREEN_FRAME_THICKNESS,
				height - 2 * GameConstants.HUD_SCREEN_FRAME_THICKNESS,
				GameConstants.HUD_SCREEN_BACKGROUND_COLOR);
			//background.scrollFactor.x = background.scrollFactor.y = 0;
			_background.add(background, true);
		}
		
		/**
		 * Open a subscreen
		 * 
		 * @param	subscreen
		 * 			is the subscreen to open
		 */
		public function openSubScreen(subscreen:HUDScreen):void {
			//_isPlayerNavigatingSubscreen = true;
			canListenKeyboardEvents = false;
			//_screen.visible = false;
			_screen.active = false;
			_subScreen.visible = true;
			_subScreen.active = true;
			if (_itemsList != null) _itemsList.active = false;
			subscreen.selected();
		}
		
		/**
		 * Close a subscreen
		 * 
		 * @param	subscreen
		 * 			is the subscreen to close
		 */
		public function closeSubScreen(subscreen:HUDScreen):void {
			//_isPlayerNavigatingSubscreen = false;
			//canListenKeyboardEvents = true;
			//if (_itemsList != null) _itemsList.active = true;
			_isJustSelected = true;
			_screen.visible = true;
			_screen.active = true;
			_subScreen.visible = false;
			_subScreen.active = false;
			updateScreen();
		}
		
		/**
		 * Reset this item
		 * For recycling purpose
		 */
		public function resetScreen(... args):void {
			
		}
		
		/**
		 * Update the screen
		 * Since the screen does not have any animation (most likely), it needs
		 * updating only one, when player selects this screen, or when player returns
		 * from a subscreen of this
		 */
		public function updateScreen(... optionalArgs):void {
			if (_itemsList != null) {
				if (optionalArgs.length > 0) _itemsList.updateScreen(optionalArgs[0]);
				else	_itemsList.updateScreen();
			}
		}
		
		/**
		 * Hide the back ground
		 */
		public function hideBackground():void {
			_background.visible = false;
		}
		
		/**
		 * Show the back ground
		 */
		public function showBackground():void {
			_background.visible = true;
		}
		 
		override public function selected():void {
			//super.selected();
			titleText.visible = false;
			updateScreen();
			this.active = true;
			_screen.visible = true;
			_screen.active = true;
			_isJustSelected = true;
			//canListenKeyboardEvents = true;
		}
		
		override public function finished():void {
			_screen.visible = false;
			_screen.active = false;
			if (_itemsList != null) _itemsList.active = false;
			canListenKeyboardEvents = false;
			titleText.visible = true;
			super.finished();
		}
		
		override public function update():void {
			super.update();
			// Is player contacting directly with this screen
			//if (! _isPlayerNavigatingSubscreen) {
			if (canListenKeyboardEvents) {
				// If player presses button to dismiss this
				if (_keyboardEventManager.justPressed(KeyboardConstants.B))
					finished();
			}
			if (_isJustSelected) {
				_isJustSelected = false;
				canListenKeyboardEvents = true;
				if (_itemsList != null) _itemsList.active = true;
			}
		}
	}
}