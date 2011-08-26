package constants;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

import editor.Tile;
import editor.Unit;


/**
 * TerrainsConstants class
 * 
 * @author Ken
 * 
 * This class contains pre-designed constants regarding all the terrains
 * in the game
 *
 */
public class TilesConstants {
    
    /**
     * Hash table which maps terrain code with its constants
     */
    static private final Hashtable< Integer, Tile > terrainsConstants = new Hashtable< Integer, Tile >();
    
    /**
     * Load the constants from external file
     */
    static void loadConstants() {
        int terrainsCount = Images.getTerrainsCount();
//        for ( int terrainCode = 0; -terrainCode < terrainsCount; terrainCode-- )
//            terrainsConstants.put( terrainCode, new Tile( terrainCode, null ) );
        for ( int terrainCode = 0; terrainCode < terrainsCount; terrainCode++ )
          terrainsConstants.put( terrainCode, new Tile( terrainCode, null ) );
    }
    
    /**
     * Return all the terrain constants
     * for safety purpose, all the return values are clones
     * 
     * @return  ArrayList
     *          which contains all the terrains constants
     */
    static public ArrayList< Unit > getAllTerrainsConstants() {
        Enumeration< Tile > terrains = terrainsConstants.elements();
        ArrayList< Unit > terrainsClones = new ArrayList< Unit >();
        while ( terrains.hasMoreElements() )
            terrainsClones.add( terrains.nextElement().clone() );
        return terrainsClones;
    }
}
