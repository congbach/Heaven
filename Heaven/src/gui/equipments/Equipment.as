package gui.equipments {
	import models.equipments.EquipmentModel;
	
	import org.flixel.FlxSprite;
	
	/**
	 * equipment class
	 * 
	 * Represents an equipment on the screen
	 * After picked up by users, only the model remains
	 */
	public class Equipment extends FlxSprite {
		
		/** Model of this equipment */
		private var _model:EquipmentModel;
		/** Code of this equipment */
		public function get equipmentCode():int { return _model.code; }
		
		/**
		 * Default constructor
		 * 
		 * @param	model
		 * 			is the model of the equipment
		 * @param	x
		 * 			is the x coordinate of the equipment on the screen
		 * @param	y
		 * 			is the y coordinate of the equipment on the screen
		 */
		public function Equipment(model:EquipmentModel, x:Number, y:Number) {
			super(x, y);
			_model = model;
		}
		
		/**
		 * Reset this equipment
		 * 
		 * @param	model
		 * 			is the new model for this
		 */
		public function resetEquipment(model:EquipmentModel, ...args):void {
			_model = model;
		}
		
	}
}