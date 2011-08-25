package models.equipments {
	import models.stats.ImmutableStats;
	import data.GameObjectModel;
	import enums.EquipmentType;
	import enums.WeaponType;

	/**
	 * WeaponModel class
	 * 
	 * Represents model of a weapon
	 * 
	 * @author Ken
	 */
	public class WeaponModel extends EquipmentModel {
		
		/**
		 * Type of this weapon
		 */
		private var _weaponType:WeaponType;
		/**
		 * Type of this weapon
		 */
		public function get weaponType():WeaponType { return _weaponType; }
		
		/**
		 * Convenient constructor
		 * 
		 * @param	weaponType
		 * 			is the type of this weapon
		 * @param	weaponCode
		 * 			is the code of this weapon
		 * @param	weaponName
		 * 			is the name of this weapon
		 * @param	baseStats
		 * 			is the base stats of this weapon
		 * @param	description
		 * 			is the description of this weapon
		 * @param	skills
		 * 			is the skills of this weapon
		 */
		public function WeaponModel(weaponType:WeaponType, equipmentCode:int,
									equipmentName:String, baseStats:ImmutableStats,
									description:String = "", skills:Vector.<int> = null) {
			super(EquipmentType.WEAPON, equipmentCode, equipmentName, baseStats, description, skills);
			_weaponType = weaponType;
		}
		
		
		override public function clone():GameObjectModel {
			return new WeaponModel(_weaponType, _equipmentCode,
									_equipmentName, _baseStats, _description, _skills);
		}
		
	}
}
