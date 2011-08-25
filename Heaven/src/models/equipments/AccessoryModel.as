package models.equipments {
	import data.GameObjectModel;
	import enums.EquipmentType;
	import models.stats.ImmutableStats;

	/**
	 * AccessoryModel class
	 * 
	 * Represents model of a accessory
	 * @author Ken
	 */
	public class AccessoryModel extends EquipmentModel {
		
		/**
		 * Convenient constructor
		 * 
		 * @param	accessoryCode
		 * 			is the code of this accessory
		 * @param	accessoryName
		 * 			is the name of this accessory
		 * @param	baseStats
		 * 			is the base stats of this accessory
		 * @param	description
		 * 			is the description of this accessory
		 * @param	skills
		 * 			is the skills of this accessory
		 */
		public function AccessoryModel(equipmentCode:int,
									equipmentName:String, baseStats:ImmutableStats,
									description:String = "", skills:Vector.<int> = null) {
			super(EquipmentType.ACCESSORY, equipmentCode, equipmentName, baseStats, description, skills);
		}
		
		override public function clone():GameObjectModel {
			return new AccessoryModel(_equipmentCode, _equipmentName, _baseStats, _description, _skills);
		}
	}
}
