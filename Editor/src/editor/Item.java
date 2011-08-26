package editor;

import java.awt.Dimension;
import java.awt.Image;
import java.awt.Point;

import constants.Images;

/**
 * Item class
 * 
 * @author Ken
 * 
 * This class represents an item in the game
 *
 */
public class Item extends Unit {
    
    static private final long serialVersionUID = 1L;
    
    /** Name of the item */
    private String name;
    
    /**
     * Default constructor
     * 
     * @param   name
     *          is the name of the item
     *          
     * @param   code
     *          is the code of the item, associated with the name
     *          
     * @param   imageUrl
     *          is the url to the image of the item, associated with
     *          the name and code
     */
    public Item( String name, int code, String imageUrl, Point offset, Dimension offsetSize ) {
        super( code, imageUrl, offset, offsetSize );
        this.name = name;
    }
    
    @Override
    public Item clone() {
        Item clone = new Item( name, code, imageUrl, offset, offsetSize );
        if ( displayImage )
            clone.setImage();
        return clone;
    }
    
    /**
     * Set image of this unit with the image given (loaded from URL)
     * 
     * @param   imageUrl
     *          is the url to the image to be attached to this unit
     */
    @Override
    protected void setImage( String imageUrl ) {
        try {
            Image image = Images.getItemImage( imageUrl );
            setImage( image );
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
        }
    }
    
    @Override
    Image getImage() {
        try {
            return Images.getItemImage( imageUrl );
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
            return null;
        }
    }

}
