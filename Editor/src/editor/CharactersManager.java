package editor;

import constants.CharactersConstants;

/**
 * CharactersManager class
 * 
 * @author Ken
 * 
 * Specifically, this is the JPanel which contains all the available
 * characters for game designers to add to the game
 *
 */
public class CharactersManager extends UnitsManager/*< Character >*/ {
    static private final long serialVersionUID = 1L;
    
    /**
     * Default constructor
     */
    CharactersManager() {
        super();
    }
    
    @Override
    protected void displayUnits() {
        displayUnits( CharactersConstants.getAllCharactersConstants() );
    }
    
}
