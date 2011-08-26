package editor;

import java.awt.Dimension;
import java.awt.Image;
import java.awt.Point;

import constants.Images;

/**
 * Character class
 * 
 * @author Ken
 * 
 * This class represents a character in the game
 *
 */
public class Character extends Unit {
    
    static private final long serialVersionUID = 1L;
    
    /** Name of the character */
    private String name;
    
    /**
     * Default constructor
     * 
     * @param   name
     *          is the name of the character
     *          
     * @param   code
     *          is the code of the character, in accordance with the name
     *          
     * @param   imageUrl
     *          is the url to the image of the character, in accordance with name and code
     */
    public Character( String name, int code, String imageUrl, Point offset, Dimension offsetSize ) {
        super( code, imageUrl, offset, offsetSize );
        this.name = name;
    }
    
    @Override
    public Character clone() {
        Character clone = new Character( name, code, imageUrl, offset, offsetSize );
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
            Image image = Images.getCharacterImage( imageUrl );
            setImage( image );
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
        }
    }
    
    @Override
    Image getImage() {
        try {
            return Images.getCharacterImage( imageUrl );
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
            return null;
        }
    }

}
