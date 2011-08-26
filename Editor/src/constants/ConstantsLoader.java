package constants;

/**
 * ConstantsLoader class
 * 
 * @author Ken
 * 
 * This class only makes sure that all the constants
 * are initialized before anything else is run
 *
 */
public class ConstantsLoader {
    
    /**
     * Load all external constants into the memory
     */
    static public void loadConstants() {
        Images.loadTerrainsImages();
        CharactersConstants.loadConstants();
        ItemsConstants.loadConstants();
        TilesConstants.loadConstants();
    }

}
