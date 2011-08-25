package gui.hud {
	import data.GameConstants;
	
	import gui.items.ItemFactory;
	import gui.states.PlayState;
	import gui.characters.PlayableCharacter;
	
	import models.items.ItemModel;
	
	/**
	 * HUDItemScreen
	 * @author Ken
	 * 
	 * The HUD screen which list all player's items so that player can use
	 */
	public class HUDItemsScreen	extends HUDScreen {
		
		/** Reference to the player */
		private var _player:PlayableCharacter;
		
		/**
		 * Default constructor
		 * 
		 * @param	callBack
		 * 			is the call back function to call when this item is dismissed
		 */
		public function HUDItemsScreen(callBack:Function) {
			super("Items", "", callBack);
			
			var x:Number = GameConstants.HUD_ITEMS_SCREEN_LOCATION.x;
			var y:Number = GameConstants.HUD_ITEMS_SCREEN_LOCATION.y;
			reset(x, y);
			width = GameConstants.HUD_ITEMS_SCREEN_SIZE.width;
			height = GameConstants.HUD_ITEMS_SCREEN_SIZE.height;
			if (width > 0 && height > 0)
				createBackgroundRectangle();
				
			_player = PlayState.getInstance().player;
			_itemsList.width = width; _itemsList.height = height;
			//_itemsList.createBackgroundRectangle();
			_itemsList.resetSelectedCallback(useItem);
			//_itemsList = new HUDScreenItemsList(0, 0, width, height, useItem);
			//_itemsList.active = false;
			_screen.add(_itemsList, true);
		}
		
		override public function updateScreen(... optionalArgs):void {
			
			var currentItemsList:Vector.<HUDScreenItem> = _itemsList.itemsList;
			var playerItemsCodes:Vector.<int> = _player.model.items;
			var playerItems:Vector.<ItemModel> = new Vector.<ItemModel>();
			for each (var itemCode:int in playerItemsCodes)
				playerItems.push(ItemFactory.createItemModelByItemCode(itemCode));
			
			var i:int = 0;
			var item:HUDScreenItem;
			var itemModel:ItemModel;
			while (i < Math.min(currentItemsList.length, playerItems.length)) {
				item = currentItemsList[i];
				itemModel = playerItems[i++];
				item.exists = true;
				item.titleText.exists = true;
				item.resetItem(itemModel.name, itemModel.description, itemModel, useItem);				
			}
			
			// Fade out those exceeds player's items
			while (i < currentItemsList.length) {
				currentItemsList[i].exists = false;
				currentItemsList[i++].titleText.exists = false;
			}
				
			// Add items if there was not enough space
			while (i < playerItems.length) {
				itemModel = playerItems[i++];
				item = new HUDScreenItem(itemModel.name, itemModel.description, itemModel, useItem);
				_itemsList.addItem(item);
			}
			
			super.updateScreen.apply(this, optionalArgs);
//			if (optionalArgs.length > 0) _itemsList.updateScreen(optionalArgs[0]);
//			else	_itemsList.updateScreen();
		}
		
		/**
		 * Use an item on player
		 * 
		 * @param	item
		 * 			is the model of the item to use
		 */
		public function useItem(item:ItemModel):void {
			//_player.useItem(item);
			_player.takeItemEffect(item);
			//item.usedOn(_player);
			//_player.model.removeItem(item.itemCode);
			updateScreen(false);
		}
	}
}