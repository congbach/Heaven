package models.equipments {
	import data.GameObjectModel;
	import enums.EquipmentType;
	import models.stats.ImmutableStats;

	/**
	 * ArmbandModel class
	 * 
	 * Represents model of a armband
	 * @author Ken
	 */
	public class ArmbandModel extends EquipmentModel {
		
		/**
		 * Convenient constructor
		 * 
		 * @param	armbandCode
		 * 			is the code of this armband
		 * @param	armbandName
		 * 			is the name of this armband
		 * @param	baseStats
		 * 			is the base stats of this armband
		 * @param	description
		 * 			is the description of this armband
		 * @param	skills
		 * 			is the skills of this armband
		 */
		public function ArmbandModel(equipmentCode:int,
									equipmentName:String, baseStats:ImmutableStats,
									description:String = "", skills:Vector.<int> = null) {
			super(EquipmentType.ARMBAND, equipmentCode, equipmentName, baseStats, description, skills);
		}
		
		override public function clone():GameObjectModel {
			return new ArmbandModel(_equipmentCode, _equipmentName, _baseStats, _description, _skills);
		}
	}
}
