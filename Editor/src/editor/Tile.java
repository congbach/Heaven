package editor;

import java.awt.Dimension;
import java.awt.Image;
import java.awt.Point;

import constants.Images;

/**
 * Terrain class
 * 
 * @author Ken
 * 
 * This class represents terrains in RPG/TBS game and tiles in platform
 * game
 *
 */
public class Tile extends Unit {
    
    static private final long serialVersionUID = 1L;
    
    /**
     * Flag to indicate whether this terrain can contain characters inside it
     * For example, land in TBS/RPG and ladder in platform game can contain
     * characters inside it
     * However, water/mountain in TBS/RPG usually not, neither do normal tiles
     * in platform game
     */
    private boolean canContainCharacters = false; // not implemented outside yet, for simplicity
    
    /**
     * Default constructor
     * 
     * @param   code
     *          is the code of the terrain
     *          
     * @param   imageUrl
     *          is the url to the image of the terrain, associated with the code
     */
    public Tile( int code, String imageUrl ) {
        super( code, imageUrl, new Point( 0, 0 ), null );
    }
    
    /**
     * See whether this terrain can contain characters inside it
     * 
     * @return  whether this terrain can contain characters inside it
     */
    boolean canContainCharacters() {
        return canContainCharacters;
    }
    
    @Override
    public Tile clone() {
        Tile clone = new Tile( code, imageUrl );
        clone.offsetSize = this.offsetSize;
        if ( displayImage )
            clone.setImage();
        return clone;
    }
    
    @Override
    protected void setImage() {
        setImage( Images.getTerrainImage( code ) );
    }
    
    @Override
    protected void setImage( Image image ) {
        super.setImage( image );
        offsetSize = new Dimension( this.getWidth(), this.getHeight() );
    }
    
    @Override
    Image getImage() {
        return Images.getTerrainImage( code );
    }

}
