package editor;

import constants.TilesConstants;

/**
 * TerrainManager class
 * 
 * @author Ken
 * 
 * Specifically, this class is the JPanel which contains all the
 * available terrains for the game designers to add to the game
 *
 */
public class TerrainsManager extends UnitsManager/*< Terrain >*/ {

    static private final long serialVersionUID = 1L;
    
    /**
     * Default constructor
     */
    TerrainsManager() {
        
    }
    
    @Override
    protected void displayUnits() {
        displayUnits( TilesConstants.getAllTerrainsConstants() );
    }

}
