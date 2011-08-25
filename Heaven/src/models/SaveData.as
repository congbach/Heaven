package models {
	import models.characters.CharacterModel;
	import gui.characters.PlayableCharacter;
	
	import org.flixel.FlxPoint;
	
	/**
	 * SaveData class
	 * @author Ken
	 * 
	 * Represents data for save file
	 */
	public class SaveData {
		
		/** Model of the player */
		private var _playerModel:CharacterModel;
		public function get playerModel():CharacterModel { return _playerModel; }
		/** The id of the map */
		private var _mapId:int;
		public function get mapId():int { return _mapId; }
		/** The pos of the player on the map */
		private var _pos:FlxPoint;
		public function get pos():FlxPoint { return _pos; }
		
		/**
		 * Default constructor
		 * 
		 * @param	player
		 * 			is the main player of the game
		 * @param	mapId
		 * 			is the id of the current map
		 */
		public function SaveData(player:PlayableCharacter, mapId:int) {
			_playerModel = player.model;
			_mapId = mapId;
			//_pos = pos;
			_pos = new FlxPoint(player.x, player.y);
		}
	}
}