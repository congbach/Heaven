package models.equipments {
	import data.GameObjectModel;
	import enums.EquipmentType;
	import models.stats.ImmutableStats;

	/**
	 * LeggingModel class
	 * 
	 * Represents model of a legging
	 * @author Ken
	 */
	public class LeggingModel extends EquipmentModel {
		
		/**
		 * Convenient constructor
		 * 
		 * @param	leggingCode
		 * 			is the code of this legging
		 * @param	leggingName
		 * 			is the name of this legging
		 * @param	baseStats
		 * 			is the base stats of this legging
		 * @param	description
		 * 			is the description of this legging
		 * @param	skills
		 * 			is the skills of this legging
		 */
		public function LeggingModel(equipmentCode:int,
									equipmentName:String, baseStats:ImmutableStats,
									description:String = "", skills:Vector.<int> = null) {
			super(EquipmentType.LEGGING, equipmentCode, equipmentName, baseStats, description, skills);
		}
		
		override public function clone():GameObjectModel {
			return new LeggingModel(_equipmentCode, _equipmentName, _baseStats, _description, _skills);
		}
	}
}
