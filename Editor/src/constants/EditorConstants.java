package constants;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;

/**
 * MapEditorConstants
 * 
 * @author Ken
 * 
 * Global constants class, contains very general constants
 *
 */
public final class EditorConstants {
    
    /** Size of the map editor windows */
    static public final Dimension DEFAULT_WINDOWS_SIZE = new Dimension( 825, 600 );
    /** Location of map editor windows on the screen */
    static public final Point WINDOWS_LOCATION = new Point( 100, 100 );
    /** Title of the map editor windows */
    static public final String WINDOWS_TITLE = "Map Editor";
    /** Default size of the map which is designed in units */
    static public final Point DEFAULT_MAP_UNITS_SIZE = new Point( 40, 30 );
    /** Minimum size of the map, in units */
    static public final Point MINIMUM_MAP_UNITS_SIZE = new Point( 1, 1 );
    /** Default size of the map which is designed in pixels */
    static public final Dimension DEFAULT_MAP_SIZE = new Dimension( 544, 537 );
    /** Default location of the map on the windows */
    static public final Point MAP_LOCATION = new Point( 0, 0 );
    /**
     * Default size of the units managers (which contains all available
     * terrains/characters/items to add to the map)
     */
    static public final Dimension UNITS_MANAGERS_SIZE = new Dimension( 256, 256 );
    /**
     * Default location of the units managers (which contains all available
     * terrains/characters/items to add to the map) on the windows
     */
    static public final Point UNITS_MANAGERS_DEFAULT_LOCATION = new Point( 546, 275 );
    /** Default size of each unit */
    static public final Dimension UNIT_SLOT_SIZE = new Dimension( 64, 64 );
    /** Default size of each grid on the map */
    static public final Dimension GRID_SIZE = new Dimension( 32, 32 );
    /** Default images frames sizes of character */
    static public final Point CHARACTERS_IMAGES_FRAMES_SIZE = new Point( 4, 10 );
    /** Default terrains size of the terrains image (in col x row) */
    static public final Point TERRAINS_IMAGES_COLS_X_ROWS_SIZE = new Point( 2, 1 );
    /** Position of the first unit manager button */
    static public final Point UNITS_MANAGER_BUTTON_DEFAULT_LOCATION = new Point( 600, 225 );
    /** Distance between two consecutive managers buttons */
    static public final Point UNIT_MANAGERS_BUTTONS_DISTANCE = new Point( 20, 0 );
    /** Blank unit code */
    static public final int BLANK_UNIT_CODE = 0;
    /** Blank unit code in character format */
    static public final char BLANK_UNIT_CHAR = ' ';
    /** Code of the player (in platform game) */
    static public final int PLAYER_CODE = 1;
    /** Spliter between units in the map code */
    static public final String MAP_UNITS_SPLITER = ",";
    /** Velocity of the scroll according to mouse wheel */
    static public final int SCROLL_UNIT_INCREMENT = 20;
	/** The area at the edges where auto scroll is enabled */
    static public final int AUTO_SCROLL_AREA_WIDTH = 32;
    static public final int AUTO_SCROLL_AREA_HEIGHT = 32;
	/** Default size of the ruler */
	static public final Dimension RULER_DEFAULT_SIZE = GRID_SIZE;
	/** Background color of the ruler */
	static public final Color RULER_BACKGROUND_COLOR = Color.WHITE;
	/** Color of ruler labels */
	static public final Color RULER_LABELS_TICKS_COLOR = Color.BLUE;
	/** Font of the ruler labels */
	static public final String RULER_LABELS_FONT = "SansSerif";
	/** Size of the ruler labels */
	static public final int RULER_LABELS_FONT_SIZE = 10;
	/** Length of each tick in the ruler */
	static public final int RULER_TICK_LENGTH = 10;
	/** Delay between auto scroll in custom scroll pane */
	static public final int AUTO_SCROLL_DELAY = 125;
	/** Initial delay to the first auto scroll in custom scroll pane */
	static public final int AUTO_SCROLL_INITIAL_DELAY = 500;
	/** Range of terrain code */
	static public final Point TERRAINS_CODES_RANGE = new Point( Integer.MIN_VALUE, -1 );
	/** Range of character code */
	static public final Point CHARACTERS_CODE_RANGE = new Point( 1, Integer.MAX_VALUE );
	/** Background color of map */
	static public final Color MAP_BACKGROUND_COLOR = Color.BLACK;
	/** Accepted image file type/extension in save map as image function */
	static public final String MAP_IMAGE_FILE_TYPE = "png";
	/** Size of the map thumbnail on the screen */
	static public final Dimension MAP_THUMBNAIL_MAX_SIZE = new Dimension( 250, 200 );
	/** Location of map thumbnail on the screen */
	static public final Point MAP_THUMBNAIL_DEFAULT_LOCATION = new Point( 550, 5 );
	/** Color of the zoom rectangle in map thumbnail */
	static public final Color MAP_THUMBNAIL_ZOOM_RECTANGLE_COLOR = Color.BLUE;
	/** Color of the border of the grid on the map */
	static public final Color GRID_BORDER_COLOR = Color.WHITE;
	
	/**
	 * Prefix of the save file
	 */
	static public final String SAVE_FILE_PREFIX = "map";
	/**
	 * Suffix of the tiles save file
	 */
	static public final String TILES_SAVE_FILE_SUFFIX = "_tiles.txt";
	/**
	 * Suffix of the tiles save file
	 */
	static public final String CHARACTERS_SAVE_FILE_SUFFIX = "_characters.txt";
	/**
	 * Suffix of the tiles save file
	 */
	static public final String ITEMS_SAVE_FILE_SUFFIX = "_items.txt";
	/**
	 * Flag to indicate whether to show error message to user
	 */
	static public final Boolean SHOW_ERRORS_MESSAGE_DIALOG = false;
	/**
	 * Scale of the map
	 */
	static public double SCALE = 1.0;
}
