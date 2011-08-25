package gui.items {
	import models.items.ItemModel;
	
	import org.flixel.FlxSprite;
	
	/**
	 * Item class
	 * 
	 * Represents an item on the screen
	 * After picked up by users, only the model remains
	 */
	public class Item extends FlxSprite {
		
		/** Model of this item */
		private var _model:ItemModel;
		/** Code of this item */
		public function get itemCode():int { return _model.code; }
		
		/**
		 * Default constructor
		 * 
		 * @param	model
		 * 			is the model of the item
		 * @param	x
		 * 			is the x coordinate of the item on the screen
		 * @param	y
		 * 			is the y coordinate of the item on the screen
		 */
		public function Item(model:ItemModel, x:Number, y:Number) {
			super(x, y);
			_model = model;
		}
		
		/**
		 * Reset this item
		 * 
		 * @param	model
		 * 			is the new model for this
		 */
		public function resetItem(model:ItemModel, ...args):void {
			_model = model;
		}
		
	}
}