package gui.hud {
	import gui.KeyboardEventsManager;
	import data.GameConstants;
	import data.KeyboardConstants;
	
	import gui.GameGroup;
	
	import org.flixel.FlxSprite;
	import org.flixel.data.FlxSize;
	
	/**
	 * HUDScreenItemsList
	 * @author Ken
	 * 
	 * Represents a list of screen item for player to navigate through
	 */
	public class HUDScreenItemsList extends GameGroup {
		
		/** The back ground of this */
		protected var _background:GameGroup;
		/** List of all the items in this */
		private var _itemsList:Vector.<HUDScreenItem>;
		public function get itemsList():Vector.<HUDScreenItem> { return _itemsList; }
		/** Index of the item which is currently chosen */
		private var _itemIndex:int;
		/** Size of padding left */
		private var _paddingLeft:int;
		/** Size of padding right */
		private var _paddingRight:int;
		/** Size of padding up */
		private var _paddingUp:int;
		/** Size of padding down */
		private var _paddingDown:int;
		/** Space between consecutive lines/items */
		private var _lineSpacing:Number;
		/** CallBack function when an item is selected */
		private var _selectedCallBack:Function;
		/** CallBack function when an item is mouse overed */
		private var _mouseOveredCallback:Function;
		/** Flag to indicate whether this is aligned already */
		public var isAligned:Boolean;
		/** Flag to indicate whether to add background to this or not */
//		private var _hasBackground:Boolean;
		/** Reference to the keyboard event manager */
		private var _keyboardEventManager:KeyboardEventsManager;
		
		/**
		 * Default constructor
		 * 
		 * @param	x
		 * 			is the x coordinate of this list
		 * @param	y
		 * 			is the y coordinate of this list
		 * @param	width
		 * 			is the width of this list
		 * @param	height
		 * 			height is the height of this list
		 * @param	selectedCallBack
		 * 			is the callBack function when an item is selected
		 * @param	mouseOveredCallBack
		 * 			is the callBack function when an item is mouse overed
		 * @param	paddingLeft
		 * 			is the size of the padding left
		 * @param	paddingRight
		 * 			is the size of the padding right
		 * @param	paddingUp
		 * 			is the size of the padding up
		 * @param	paddingDown
		 * 			is the size of the padding down
		 * @param	lineSpacing
		 * 			is the space between consecutive lines/items
		 * @param	hasBackGround
		 * 			indicate whether to add default background to this or not
		 */
		public function HUDScreenItemsList(x:Number, y:Number, width:Number, height:Number,
							selectedCallBack:Function = null,
							mouseOveredCallback:Function = null,
							paddingLeft:Number = 0, paddingRight:Number = 0, paddingUp:Number = 0,
							paddingDown:Number = 0,
							lineSpacing:Number = GameConstants.HUD_SCREEN_ITEMS_LIST_LINE_SPACING,
							hasBackground:Boolean = true) {
			//this.x = x; this.y = y;
			reset(x, y);
			this.width = width; this.height = height;
			_background = new GameGroup();
			add(_background);
			_background.scrollFactor.x = _background.scrollFactor.y = 0;
			if (hasBackground && this.width > 0 && this.height > 0)
				createBackgroundRectangle();
			_paddingLeft = paddingLeft; _paddingRight = paddingRight;
			_paddingUp = paddingUp; _paddingDown = paddingDown;
			_lineSpacing = lineSpacing;
			_selectedCallBack = selectedCallBack; _mouseOveredCallback = mouseOveredCallback;
				
			_itemsList = new Vector.<HUDScreenItem>();
			_itemIndex = 0;
			isAligned = true;
			
			_keyboardEventManager = KeyboardEventsManager.getInstance();
		}
		
		/**
		 * Reset callback
		 * 
		 * @param	selectedCallBack
		 * 			is the callBack function when an item is selected
		 * @param	mouseOveredCallBack
		 * 			is the callBack function when an item is mouse overed
		 */
		public function resetCallBack(selectedCallBack:Function = null, mouseOveredCallback:Function = null):void {
			resetSelectedCallback(selectedCallBack);
			resetMouseOveredCallback(mouseOveredCallback);
		}
		
		/**
		 * Reset selected call back
		 * 
		 * @param	selectedCallBack
		 * 			is the callBack function when an item is selected
		 */
		public function resetSelectedCallback(selectedCallBack:Function = null):void {
			_selectedCallBack = selectedCallBack;
		}
		
		/**
		 * Reset selected call back
		 * 
		 * @param	mouseOveredCallBack
		 * 			is the callBack function when an item is mouse overed
		 */
		public function resetMouseOveredCallback(mouseOveredCallback:Function = null):void {
			_mouseOveredCallback = mouseOveredCallback;
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
		 * Add an item to this list
		 * 
		 * @param	item
		 * 			is the item to add to this list
		 */
		public function addItem(item:HUDScreenItem):void {
			add(item.titleText, true);
			_itemsList.push(item);
			
			// If this is the first item
			if (_itemsList.length == 1)
				// mark the item as mouse over
				item.mouseOver();
			
			isAligned = false;
			//autoAlign();
		}
		
		/**
		 * Auto align the items so that they fit the screen nicely
		 */
		public function autoAlign():void {
			isAligned = true;
			
			var longestItemTitleSize:int = 0;
			for each (var item:HUDScreenItem in _itemsList)
				if (item.titleText.exists && item.title.length > longestItemTitleSize)
					longestItemTitleSize = item.title.length;
			
			var fontSize:FlxSize = GameConstants.FONT_SIZE;
			var lineWidth:Number = longestItemTitleSize * fontSize.width;			
			var verticalMargin:Number = width / 2 - lineWidth / 2;
			
			var numValidItem:int = 0;
			for each (var itemCheckExisted:HUDScreenItem in _itemsList)
				if (itemCheckExisted.titleText.exists) numValidItem++;
			var totalLinesHeight:Number =
				numValidItem * fontSize.height + (numValidItem - 1) * _lineSpacing;
			var horizontalMargin:Number = height / 2 - totalLinesHeight / 2;
			
			var x:Number = verticalMargin + this.x;
			var y:Number = horizontalMargin + this.y;
			for (var i:int = 0; i < _itemsList.length; i++) {
				var it:HUDScreenItem = _itemsList[i];
				if (it.titleText.exists) {
					//it.titleText.x = x; it.titleText.y = y;
					it.titleText.reset(x, y);
					y += fontSize.height + _lineSpacing;
				}
			}
			
		}
		
		/**
		 * Update the screen
		 * Since the screen does not have any animation (most likely), it needs
		 * updating only one, when player selects this screen, or when player returns
		 * from a subscreen of this
		 * 
		 * @param	resetIndex
		 * 			indicate whether to reset the index item to zero
		 */
		public function updateScreen(resetIndex:Boolean = true):void {
			if (resetIndex) {
				_itemIndex = 0;
				while (_itemIndex < _itemsList.length && !_itemsList[_itemIndex].titleText.exists)
					_itemIndex++;
			} else {
				_itemIndex = Math.min(_itemIndex, _itemsList.length - 1);
				while (_itemIndex >= 0 && !_itemsList[_itemIndex].titleText.exists)
					_itemIndex--;
			}
			if (_itemsList.length > 0 && (0 <= _itemIndex && _itemIndex < _itemsList.length))
				_itemsList[_itemIndex].mouseOver();
			for (var i:int = 0; i < _itemsList.length; i++)
				if (i != _itemIndex) _itemsList[i].mouseOut();
			//if (! isAligned) autoAlign();
			autoAlign();
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
		
		override public function update():void {
			super.update();
			
			if (! isAligned) autoAlign();
			
			// If player navigates up through the list
			if (_keyboardEventManager.justPressed(KeyboardConstants.UP)) {
				var firstExistedItemPreviousCurrent:int = _itemIndex - 1;
				while (firstExistedItemPreviousCurrent >= 0 &&
						! _itemsList[firstExistedItemPreviousCurrent].titleText.exists)
					firstExistedItemPreviousCurrent--;
				// If the current item is not the first
				// i.e. there is some existed item before this one
				if (firstExistedItemPreviousCurrent >= 0) {
					_itemsList[_itemIndex].mouseOut();
					_itemIndex = firstExistedItemPreviousCurrent;
					_itemsList[_itemIndex].mouseOver();
					
					// Call call back function if any
					if (_mouseOveredCallback != null) {
						if (_itemsList[_itemIndex].object != null)
							_mouseOveredCallback(_itemsList[_itemIndex].object);
						else _mouseOveredCallback();
					}
				}
				
			// If player navigates down through the list
			} else if (_keyboardEventManager.justPressed(KeyboardConstants.DOWN)) {
				var firstExistedItemAfterCurrent:int = _itemIndex + 1;
				while (firstExistedItemAfterCurrent < _itemsList.length &&
						! _itemsList[firstExistedItemAfterCurrent].titleText.exists)
					firstExistedItemAfterCurrent++;
				// If the current item is not the last
				// i.e. there is some existed item after this one
				if (firstExistedItemAfterCurrent < _itemsList.length) {
					_itemsList[_itemIndex++].mouseOut();
					_itemIndex = firstExistedItemAfterCurrent;
					_itemsList[_itemIndex].mouseOver();
					
					// Call call back function if any
					if (_mouseOveredCallback != null) {
						if (_itemsList[_itemIndex].object != null)
							_mouseOveredCallback(_itemsList[_itemIndex].object);
						else _mouseOveredCallback();
					}
				}
			
			// If player selects an item
			} else if (_keyboardEventManager.justPressed(KeyboardConstants.A)) {
				// If current item is valid
				if (_itemIndex >= 0 && _itemIndex < _itemsList.length
					&& _itemsList[_itemIndex].titleText.exists) {
					// Normally, the list will manage call back funcion, but if an item has a specific
					// call back attack to its, then it has the priority
					if (_itemsList[_itemIndex].hasCallBack)
						_itemsList[_itemIndex].selected();
					else if (_selectedCallBack != null) {
						if (_itemsList[_itemIndex].object != null)
							_selectedCallBack(_itemsList[_itemIndex].object);
						else _selectedCallBack();
					}
				}
			}
		}
	}
}