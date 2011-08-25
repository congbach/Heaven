package gui.items {
	import data.ImmutableGameObjectData;
	import models.ImmutablePhysicsModel;
	import data.CharactersConstants;
	import data.GameConstants;
	import data.ImagesBitmapConstants;
	import data.ItemsConstants;
	import data.UnitsConstants;
	
	import embeded.EmbededImages;
	
	import models.items.ItemModel;
	
	/**
	 * Factory pattern
	 * 
	 * Create item based on its code
	 */
	public class ItemFactory {
		
		/**
		 * Create and return item based on the given item code and position
		 * @param	itemCode					is the code of the item to create
		 * @param	existedItem					is the existed item (for recycling purpose) if any
		 * @return	Item						with everything initialized already (fully-functional)
		 * @throw	IllegalArgumentException	if the given item code does not fit any particular
		 * 										type/class of character
		 */
		static public function createItemByItemCode(itemCode:int, existedItem:Item):Item {
			
			var itemModel:ItemModel = ItemFactory.createItemModelByItemCode(itemCode);
			var item:Item;
			if (existedItem == null)
				item = new Item(itemModel, 0, 0);
			else {
				item = existedItem;
				item.reset(0, 0);
				item.resetItem(itemModel);
			}
			
			if (GameConstants.EMBEDED_ALL)
				item.loadGraphic(EmbededImages.getItemImageByItemCode(itemCode));
			else
				item.loadBitmapDataGraphic(
					UnitsConstants.getItemName(itemCode),
					ImagesBitmapConstants.getItemImageBitmapDataByItemCode(itemCode));
			
			var itemConstants:ImmutableGameObjectData = ItemsConstants.getItemByItemCode(itemCode);
			var physicsModel:ImmutablePhysicsModel = itemConstants.physicsData;
			
			item.offset.x = physicsModel.offset.x; item.offset.y = physicsModel.offset.y;
			item.width = physicsModel.offsetSize.width; item.height = physicsModel.offsetSize.height;
			
			item.acceleration.y = CharactersConstants.GRAVITY_Y_ACCELERATION;
			item.maxVelocity.y = CharactersConstants.GRAVITY_FALLING_Y_VELOCITY_MAX_VALUE;
			return item;
		}
		
		/**
		 * Create and return the model of an item based on its code
		 * 
		 * @param	itemCode
		 * 			is the code of the item
		 * 
		 * @return	ItemModel
		 * 			of the item with the given code
		 * 
		 * @throws	IllegalArgumentException
		 * 			is the is no item with the given code
		 */
		static public function createItemModelByItemCode(itemCode:int):ItemModel {			
			return ItemsConstants.getItemByItemCode(itemCode).model as ItemModel;
		}
	}
}