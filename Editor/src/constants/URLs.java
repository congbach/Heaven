package constants;

import java.io.File;

/**
 * URLs class
 * 
 * @author Ken
 * 
 * This class contains all URLs to external config/image files to load
 * as well as internal embeded images/config files
 *
 */
public class URLs {
    
    //static public final String ROOT_URL = "/home/ken/Dropbox/Game development/Editor/";
	static public final String ROOT_URL() {
		//= ".../Heaven/src/";
		File f = new File("");
		f = new File(f.getAbsolutePath());
		return f.getParent() + "/Heaven/";
		//return "";
	}
    
    //==============
    // CONFIG FILES
    //==============
    
    static public final String UNITS_CODES_URL = ROOT_URL() + "design/config/unitsCodes.xml";
    static public final String CHARACTERS_CONSTANTS_URL = ROOT_URL() + "design/config/charactersConstants.xml";
//    static public final String TERRAINS_CODES_URL = ROOT_URL() + "design/config/tilesCodes.xml";
    static public final String ITEMS_CONSTANTS_URL = ROOT_URL() + "design/config/itemsConstants.xml";
    
    //==============
    // IMAGES FILES
    //==============
    
    static public final String TILES_IMAGES_URL = ROOT_URL() + "art/tiles/all_tiles.png";
    static public final String BUTTON_SELECTED_SUFFIX = "_selected.png";
    static public final String BUTTON_UNSELECTED_SUFFIX = "_unselected.png";
    
    //=============
    // JAR EMBEDED
    //=============
    static public final String EMBEDED_IMAGE_FOLDER = "image/";
    static public final String SQUARE_GRID_IMAGE_URL = EMBEDED_IMAGE_FOLDER + "grid.png";
    static public final String UNIT_SLOT_BACKGROUND_IMAGE_URL = EMBEDED_IMAGE_FOLDER + "unitSlot";
    static public final String[] UNITS_MANAGERS_BUTTONS_IMAGES_URL =
    { EMBEDED_IMAGE_FOLDER + "terrainsButton", EMBEDED_IMAGE_FOLDER + "charactersButton",
      EMBEDED_IMAGE_FOLDER + "itemsButton" };

}
