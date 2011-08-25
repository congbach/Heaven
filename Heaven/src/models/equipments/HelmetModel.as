package models.equipments {
	import data.GameObjectModel;
	import enums.EquipmentType;
	import models.stats.ImmutableStats;

	/**
	 * HelmetModel class
	 * 
	 * Represents model of a helmet
	 * @author Ken
	 */
	public class HelmetModel extends EquipmentModel {
		
		/**
		 * Convenient constructor
		 * 
		 * @param	helmetCode
		 * 			is the code of this helmet
		 * @param	helmetName
		 * 			is the name of this helmet
		 * @param	baseStats
		 * 			is the base stats of this helmet
		 * @param	description
		 * 			is the description of this helmet
		 * @param	skills
		 * 			is the skills of this helmet
		 */
		public function HelmetModel(equipmentCode:int,
									equipmentName:String, baseStats:ImmutableStats,
									description:String = "", skills:Vector.<int> = null) {
			super(EquipmentType.HELMET, equipmentCode, equipmentName, baseStats, description, skills);
		}
		
		override public function clone():GameObjectModel {
			return new HelmetModel(_equipmentCode, _equipmentName, _baseStats, _description, _skills);
		}
	}
}
