package editor;

import constants.ItemsConstants;

/**
 * ItemManager class
 * 
 * @author Ken
 * 
 * Specifically, this class is the JPanel which contains all the
 * available items for game designers to add to the game
 *
 */
public class ItemsManager extends UnitsManager/*< Item >*/ {
    static private final long serialVersionUID = 1L;
    
    /**
     * Default constructor
     */
    ItemsManager() {
        super();
    }
    
    @Override
    protected void displayUnits() {
        displayUnits( ItemsConstants.getAllItemsConstants() );
    }

}
