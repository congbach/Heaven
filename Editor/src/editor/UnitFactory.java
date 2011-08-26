package editor;

import java.awt.Point;

import constants.CharactersConstants;
import constants.EditorConstants;
import constants.ItemsConstants;

/**
 * UnitCloneFactory class
 * 
 * @author Ken
 * 
 * Factory pattern
 * This class handle creating and cloning an unit of which exact type
 * is not known (so unit.clone() is impossible to call)
 *
 */
public class UnitFactory {
    
//	/**
//	 * Create a unit based on its code
//	 * 
//	 * @param	unitCode
//	 * 			is the code which represents this unit
//	 * 
//	 * @return	the unit represented by the code given
//	 * 
//	 * @throws	IllegalArgumentException
//	 * 			if the given unitCode does not match any actual unit
//	 */
//	public static Unit create( int unitCode ) throws IllegalArgumentException {
//		try {
//			Unit unit = null;
//			
//			Point terrainsCodesRange = EditorConstants.TERRAINS_CODES_RANGE;
//			if ( terrainsCodesRange.x <= unitCode && unitCode <= terrainsCodesRange.y )
//				unit = new Tile( unitCode, null );
//			
//			Point charactersCodesRange = EditorConstants.CHARACTERS_CODE_RANGE;
//			if ( charactersCodesRange.x <= unitCode && unitCode <= charactersCodesRange.y )
//				unit = CharactersConstants.getCharacter( unitCode );
//			
//			unit.setImage();
//			
//			return unit;
//		} catch ( Exception e ) {
//			ExceptionHandler.handleException( "Undefined unit code: " + unitCode );
//			throw new IllegalArgumentException( "Undefined unit code: " + unitCode );
//		}
//		
//	}
	
	/**
	 * Create a tile based on its code
	 * 
	 * @param	unitCode
	 * 			is the code which represents this unit
	 * 
	 * @return	the unit represented by the code given
	 * 
	 * @throws	IllegalArgumentException
	 * 			if the given unitCode does not match any actual unit
	 */
	public static Tile createTile( int unitCode ) throws IllegalArgumentException {
		Tile unit = new Tile( unitCode, null );			
		unit.setImage();			
		return unit;
	}
	
	/**
	 * Create a character based on its code
	 * 
	 * @param	unitCode
	 * 			is the code which represents this unit
	 * 
	 * @return	the unit represented by the code given
	 * 
	 * @throws	IllegalArgumentException
	 * 			if the given unitCode does not match any actual unit
	 */
	public static Character createCharacter( int unitCode ) throws IllegalArgumentException {
		Character unit = CharactersConstants.getCharacter( unitCode );	
		unit.setImage();			
		return unit;
	}
	
	/**
	 * Create an item based on its code
	 * 
	 * @param	unitCode
	 * 			is the code which represents this unit
	 * 
	 * @return	the unit represented by the code given
	 * 
	 * @throws	IllegalArgumentException
	 * 			if the given unitCode does not match any actual unit
	 */
	public static Item createItem( int unitCode ) throws IllegalArgumentException {
		Item unit = ItemsConstants.getItem( unitCode );		
		unit.setImage();			
		return unit;
	}
	
    /**
     * Clone a unit and return the clone version
     * 
     * @param   unit
     *          the unit to generate a clone of it
     *          
     * @return  the clone of the given unit
     * 
     * @throws	IllegalArgumentException
     * 			is the given unit type is unknown
     */
    public static Unit clone( Unit unit ) throws IllegalArgumentException {
        Unit clone;
        if ( unit instanceof Character )
            clone = ( ( Character ) unit ).clone();
        else if ( unit instanceof Tile )
            clone = ( ( Tile ) unit ).clone();
        else if ( unit instanceof Item )
            clone = ( ( Item ) unit ).clone();
        else {
        	ExceptionHandler.handleException( "Undefined unit: " + unit.toString() );
            throw new IllegalArgumentException( "Undefined unit: " + unit.toString() );
        }
        return clone;
    }

}
