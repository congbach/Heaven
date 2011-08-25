package models.characters {
	import models.equipments.EquipmentModel;
	import errors.IllegalArgumentException;
	import enums.EquipmentType;

	/**
	 * CharacterEquipments class
	 * 
	 * Represent all the equipment slots of the character
	 * 
	 * @author Ken
	 */
	public class CharacterEquipments {
		/**
		 * Head equipment
		 */
		private var _head:EquipmentModel;
		/**
		 * Head equipment
		 */
		public function get head():EquipmentModel { return _head; }
		/**
		 * Head equipment
		 */
		public function set head(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.HELMET)
				throw IllegalArgumentException("Only helmet can be equiped on head: " + equipment);
			_head = equipment;
		}
		/**
		 * Left hand equipment
		 */
		private var _leftHand:EquipmentModel;
		/**
		 * Left hand equipment
		 */
		public function get leftHand():EquipmentModel { return _leftHand; }
		/**
		 * Left hand equipment
		 */
		public function set leftHand(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.WEAPON &&
				equipment.equipmentType != EquipmentType.SHIELD)
				throw IllegalArgumentException("Only weapon or shield can be equiped on hand: " + equipment);
			_leftHand = equipment;
		}
		/**
		 * Right hand equipment
		 */
		private var _rightHand:EquipmentModel;
		/**
		 * Right hand equipment
		 */
		public function get rightHand():EquipmentModel { return _rightHand; }
		/**
		 * Right hand equipment
		 */
		public function set rightHand(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.WEAPON &&
				equipment.equipmentType != EquipmentType.SHIELD)
				throw IllegalArgumentException("Only weapon or shield can be equiped on hand: " + equipment);
			_rightHand = equipment;
		}
		/**
		 * Body equipment
		 */
		private var _body:EquipmentModel;
		/**
		 * Body equipment
		 */
		public function get body():EquipmentModel { return _body; }
		/**
		 * Body equipment
		 */
		public function set body(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.ARMOR)
				throw IllegalArgumentException("Only armor can be equiped on body: " + equipment);
			_body = equipment;
		}
		/**
		 * Arm equipment
		 */
		private var _arm:EquipmentModel;
		/**
		 * Arm equipment
		 */
		public function get arm():EquipmentModel { return _arm; }
		/**
		 * Arm equipment
		 */
		public function set arm(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.ARMBAND)
				throw IllegalArgumentException("Only armband can be equiped on arm: " + equipment);
			_arm = equipment;
		}
		/**
		 * Leg equipment
		 */
		private var _leg:EquipmentModel;
		/**
		 * Leg equipment
		 */
		public function get leg():EquipmentModel { return _leg; }
		/**
		 * Leg equipment
		 */
		public function set leg(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.LEGGING)
				throw IllegalArgumentException("Only legging can be equiped on leg: " + equipment);
			_leg = equipment;
		}
//		/**
//		 * Shoes equipment
//		 */
//		private var _shoes:EquipmentModel;
//		/**
//		 * Shoes equipment
//		 */
//		public function get shoes():EquipmentModel { return _shoes; }
//		/**
//		 * Shoes equipment
//		 */
//		public function set shoes(equipment:EquipmentModel):void {
//			if (equipment != null && equipment.equipmentType != EquipmentType.SHOES)
//				throw IllegalArgumentException("Only shoes can be equiped on shoes: " + equipment);
//			_shoes = equipment;
//		}
		/**
		 * First accessories equipment
		 */
		private var _firstAccessory:EquipmentModel;
		/**
		 * First accessories equipment
		 */
		public function get firstAccessory():EquipmentModel { return _firstAccessory; }
		/**
		 * First accessories equipment
		 */
		public function set firstAccessory(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.ACCESSORY)
				throw IllegalArgumentException("Only accessory can be equiped on accessory: " + equipment);
			_firstAccessory = equipment;
		}
		/**
		 * Second accessories equipment
		 */
		private var _secondAccessory:EquipmentModel;
		/**
		 * Second accessories equipment
		 */
		public function get secondAccessory():EquipmentModel { return _secondAccessory; }
		/**
		 * Second accessories equipment
		 */
		public function set secondAccessory(equipment:EquipmentModel):void {
			if (equipment != null && equipment.equipmentType != EquipmentType.ACCESSORY)
				throw IllegalArgumentException("Only accessory can be equiped on accessory: " + equipment);
			_secondAccessory = equipment;
		}
		
	}
}
