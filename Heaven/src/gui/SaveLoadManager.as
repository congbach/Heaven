package gui {
	import gui.characters.PlayableCharacter;
	import gui.states.PlayState;
	import data.GameConstants;
	
	import flash.net.SharedObject;
	
	import models.SaveData;
	
	import org.flixel.FlxPoint;
	
	/**
	 * SaveLoadManager class
	 * @author Ken
	 * 
	 * Handle saving and loading
	 */
	public class SaveLoadManager {
		
		/** The current save which is being loaded */
		static private var _save:Object;
		/** Flag to indicate whether player is loading new save */
		static public function get isLoading():Boolean { return _save != null; }
		/** The model of the player in the save */
		static public function get playerModel():Object {
			if (! isLoading) return null;
			return _save.model;
		}
		/** The id of the current map on the save */
		static public function get mapId():uint {
			if (! isLoading) return null;
			return _save.mapId;
		}
		/** The position of the player on the screen (should be thrown away later */
		static public function get playerLocation():FlxPoint {
			if (! isLoading) return null;
			return new FlxPoint(_save.pos.x, _save.pos.y);
		}
		
		/** Reset the save */
		static public function reset():void { _save = null; }
			
		/**
		 * Save the current state of the game
		 */
		static public function save():void {
			var save:Object = new Object();
			var player:PlayableCharacter = PlayState.getInstance().player;
			var mapId:uint = PlayState.getInstance().mapId;
			
			save.mapId = mapId;
			save.model = player.model.getSaveObject();
			save.pos = new FlxPoint(player.x, player.y);
			
			var sharedObject:SharedObject =
				SharedObject.getLocal(GameConstants.SHARED_OBJECT_NAME, GameConstants.SAVE_PATH);
			sharedObject.data.save = save;
			sharedObject.flush();
		}
		
		/**
		 * Load the previous state of the game
		 * 
		 * @return	SaveData
		 * 			which contains necessary information about the saved
		 * 			state of the game
		 */
		static public function load():void {
			var sharedObject:SharedObject =
				SharedObject.getLocal(GameConstants.SHARED_OBJECT_NAME, GameConstants.SAVE_PATH);
			if (sharedObject.data.save != undefined && sharedObject.data.save != null)
				_save =sharedObject.data.save;
		}
	}
}