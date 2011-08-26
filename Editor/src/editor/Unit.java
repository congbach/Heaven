package editor;

import java.awt.Dimension;
import java.awt.Image;
import java.awt.Point;

import javax.swing.ImageIcon;
import javax.swing.JLabel;

import constants.Images;
import constants.URLs;

/**
 * Unit class
 * 
 * @author Ken
 * 
 * This class is meant only to be parent class of Character, Terrain, Unit.
 * Provide general/common methods for all those classes 
 *
 */
public class Unit extends JLabel {
    
    static private final long serialVersionUID = 1L;
    
    /** URL to the image of the unit */
    public final String imageUrl;
    /** The code associated with this unit */
    public final int code;
    /** Offset of the unit */
    protected Point offset;
    /** Size of the offset of the unit */
    protected Dimension offsetSize;
    /** Flag to indicate whether this unit has displayed its image yet */
    protected boolean displayImage;
    
    /**
     * Default constructor
     * 
     * @param   code
     *          is the code of the unit
     *          
     * @param   imageUrl
     *          is the url to the image of the unit, associated with the code
     */
    Unit( int code, String imageUrl, Point offset, Dimension offsetSize ) {
        this.imageUrl = imageUrl;
        this.code = code;
        this.offset = offset;
        this.offsetSize = offsetSize;
        displayImage = false;
    }
    
    /**
     * Get the code of this unit
     * 
     * @return  the code which represents this unit
     */
    public int getCode() {
        return code;
    }
    
    /**
     * Get the url to the image of this unit
     * 
     * @return  url to the image of this unit
     */
    String getImageUrl() {
        return imageUrl;
    }
    
    /**
     * Automatically set image of this unit
     * the image is obtained (loaded from) through imageURL
     */
    protected void setImage() {
        setImage( imageUrl );
    }
    
    /**
     * Set image of this unit with the image given (loaded from URL)
     * 
     * @param   imageUrl
     *          is the url to the image to be attached to this unit
     */
    protected void setImage( String imageUrl ) {
//        try {
//            Image image = Images.getCharacterImage( imageUrl );
//            setImage( image );
//        } catch ( Exception e ) {
////            e.printStackTrace();
//        	ExceptionHandler.handleException(e);
//        }
    }
    
    /**
     * Set image of this unit to the given image
     * 
     * @param   image
     *          is the image to attach to this unit
     */
    protected void setImage( Image image ) {
        ImageIcon icon = new ImageIcon( image );
        setIcon( icon );
        setOpaque( false );
        setSize( icon.getIconWidth(), icon.getIconHeight() );
        displayImage = true;
    }
    
    /**
     * Return the image of this unit
     * This class must be overriden by all sub-classes
     * 
     * @return  {@code}null{@code}
     */
    Image getImage() {
        // to be overriden by sub-classes
        return null;
    }
    
    /**
     * Get the offset of this unit
     * 
     * @return  the offset of this unit
     */
    Point getOffset() {
        return offset;
    }
    
    /**
     * Get the size of the offset of this unit
     * 
     * @return  size of the offset of this unit
     */
    Dimension getOffsetSize() {
        return offsetSize;
    }
}
