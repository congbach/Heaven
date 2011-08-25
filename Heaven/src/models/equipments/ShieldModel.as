package models.equipments {
	import data.GameObjectModel;
	import enums.EquipmentType;
	import models.stats.ImmutableStats;

	/**
	 * ShieldModel class
	 * 
	 * Represents model of a shield
	 * @author Ken
	 */
	public class ShieldModel extends EquipmentModel {
		
		/**
		 * Convenient constructor
		 * 
		 * @param	shieldCode
		 * 			is the code of this shield
		 * @param	shieldName
		 * 			is the name of this shield
		 * @param	baseStats
		 * 			is the base stats of this shield
		 * @param	description
		 * 			is the description of this shield
		 * @param	skills
		 * 			is the skills of this shield
		 */
		public function ShieldModel(equipmentCode:int,
									equipmentName:String, baseStats:ImmutableStats,
									description:String = "", skills:Vector.<int> = null) {
			super(EquipmentType.SHIELD, equipmentCode, equipmentName, baseStats, description, skills);
		}
		
		override public function clone():GameObjectModel {
			return new ShieldModel(_equipmentCode, _equipmentName, _baseStats, _description, _skills);
		}
	}
}
