package gui {
	
	/**
	 * Door class
	 * 
	 * Represents a door which connects two maps
	 * 
	 * @author Ken
	 */
	public class Door extends GameSprite {
		
		/** The id of this door */
		private var _id:uint;
		public function get id():uint { return _id; }
		/** The id of the destination door */
		private var _desDoorId:uint;
		public function get desDoorId():uint { return _desDoorId; }
		/** The id of the destination map */
		private var _desMapId:uint;
		public function get desMapId():uint { return _desMapId; }
		
		/**
		 * Default constructor
		 * 
		 * @param	id
		 * 			is the id of this door
		 * @param	desDoorId
		 * 			is the id of the destination door
		 * @param	desMapId
		 * 			is the id of the destination map
		 */
		public function Door(id:uint, desDoorId:uint, desMapId:uint) {
			super();
			visible = false;
			_id = id; _desDoorId = desDoorId; _desMapId = desMapId;
		}
	}
}