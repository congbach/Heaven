package gui.characters {
	import models.characters.CharacterModel;
	import org.flixel.FlxGroup;
	import data.ImmutableGameObjectData;
	import data.CharactersConstants;
	import data.GameConstants;
	import data.ImagesBitmapConstants;
	import data.UnitsConstants;
	
	import embeded.EmbededImages;
	
	import errors.IllegalArgumentException;
	
	/**
	 * NonPlayableCharacterFactory class
	 * @author Ken
	 * Factory pattern
	 * to create NPC based on the npcCode
	 * and return a fully-functional npc
	 */
	public class NonPlayableCharacterFactory {
		
		/**
		 * Create and return npc based on the given character Code, position and tileMap (for AI)
		 * @param	charCode					is the code of the character to create
		 * @param	xCoor						is the x coordinate of this character on tile map
		 * @param	yCoor						is the y coordinate of this character on tile map
		 * @param	tileMap						is the tileMap in Array form in order for AI to calculate
		 * 										necessary information
		 * @param	skillsOnScreen				is the list of skills on the screen, to add skill to
		 * 										when a character performs skill's animation
		 * @param	existedCharacter			is the character (for recycling purpose) if any
		 * @return	NonPlayableCharacter		with everything initialized already (fully-functional)
		 * @throw	IllegalArgumentException	if the given character code does not fit any particular
		 * 										type/class of character
		 */
		static public function createNonPlayableCharacterByCharacterCode(
			charCode:int, xCoor:int, yCoor:int, tileMap:Array,
			skillsOnScreen:FlxGroup,
			existedCharacter:NonPlayableCharacter = null ):NonPlayableCharacter {
			
			if ( charCode < UnitsConstants.NON_PLAYABLE_CHARACTER_MIN_VALUE )
				throw new IllegalArgumentException( "charCode", charCode );
			
			var characterConstants:ImmutableGameObjectData =
				CharactersConstants.getCharacterConstantsByCharacterCode( charCode );
			var nonPlayableCharacter:NonPlayableCharacter;
			if (existedCharacter == null)
				nonPlayableCharacter = 
					new NonPlayableCharacter(characterConstants.model as CharacterModel,
												xCoor, yCoor, tileMap, skillsOnScreen);
			else {
				nonPlayableCharacter = existedCharacter;
				nonPlayableCharacter.resetCharacter(characterConstants.model.clone() as CharacterModel,
													xCoor, yCoor, tileMap);
			}
			
			
			if ( GameConstants.EMBEDED_ALL )
				nonPlayableCharacter.loadGraphic( 
					EmbededImages.getCharacterImageByCharacterCode( charCode ),
					true, true, characterConstants.frameSize.width, characterConstants.frameSize.height );
			else
				nonPlayableCharacter.loadBitmapDataGraphic(
					UnitsConstants.getCharacterName( charCode ),
					ImagesBitmapConstants.getCharacterImageBitmapDataByCharacterCode( charCode ),
					true, true, characterConstants.frameSize.width, characterConstants.frameSize.height );
			
			nonPlayableCharacter.addAnimations( characterConstants.animations );
			nonPlayableCharacter.loadPhysicsConstants( characterConstants.physicsData );
			
			return nonPlayableCharacter;
		}
	}
}