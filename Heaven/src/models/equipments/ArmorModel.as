package models.equipments {
	import data.GameObjectModel;
	import enums.EquipmentType;
	import models.stats.ImmutableStats;

	/**
	 * ArmorModel class
	 * 
	 * Represents model of a armor
	 * @author Ken
	 */
	public class ArmorModel extends EquipmentModel {
		
		/**
		 * Convenient constructor
		 * 
		 * @param	armorCode
		 * 			is the code of this armor
		 * @param	armorName
		 * 			is the name of this armor
		 * @param	baseStats
		 * 			is the base stats of this armor
		 * @param	description
		 * 			is the description of this armor
		 * @param	skills
		 * 			is the skills of this armor
		 */
		public function ArmorModel(equipmentCode:int,
									equipmentName:String, baseStats:ImmutableStats,
									description:String = "", skills:Vector.<int> = null) {
			super(EquipmentType.ARMOR, equipmentCode, equipmentName, baseStats, description, skills);
		}
		
		override public function clone():GameObjectModel {
			return new ArmorModel(_equipmentCode, _equipmentName, _baseStats, _description, _skills);
		}
	}
}
