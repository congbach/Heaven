package editor;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;

import constants.EditorConstants;
import constants.URLs;

/**
 * UnitSlot clas
 * 
 * @author Ken
 * 
 * This class represents a slot that holds an unit inside in Characters/Terrains/Items-Manager
 *
 */
public class UnitSlot extends EmbededButton {

    static private final long serialVersionUID = 1L;
    
//    /**
//     * Background of all the units slot
//     */
//    static private Image unitSlotBackgroundImage;
//    
//    /**
//     * Get the background image of the unit slot
//     * Initialize the backgroundImage if that has not been done
//     * 
//     * @return  background image of the unit slot
//     */
//    static private Image getUnitSlotBackgroundImage() {
//        if ( unitSlotBackgroundImage == null ) {
//            try {
//                unitSlotBackgroundImage = 
//                    ImageIO.read( ClassLoader.getSystemResourceAsStream( URLs.UNIT_SLOT_BACKGROUND_IMAGE_URL ) );
//            } catch ( Exception e ) {
//                e.printStackTrace();
//            }
//        }
//        return unitSlotBackgroundImage;
//    }
    
    /** The unit which is contained in this UnitSlot */
    private Unit unit;
    
    /**
     * Default constructor
     * 
     * @param   unit
     *          is the unit to contain in this UnitSlot.
     */
    UnitSlot( Unit unit ) {
    	super( URLs.UNIT_SLOT_BACKGROUND_IMAGE_URL );
        this.unit = unit;
//        setImage();
        setUnitImage();
    }
    
//    /**
//     * Initialize the image of this UnitSlot
//     */
//    private void setImage() {
//        setBackgroundImage();
//        setUnitImage();
//    }
//    
//    /**
//     * Initialize the background image of this unit slot
//     */
//    private void setBackgroundImage() {
//        ImageIcon backgroundImageIcon = new ImageIcon( getUnitSlotBackgroundImage() );
//        setIcon( backgroundImageIcon );
//        setSize( EditorConstants.UNIT_SLOT_SIZE );
//        setOpaque( false );
//    }
    
    /**
     * Initialize the image of the unit and add it to this unit slot
     */
    private void setUnitImage() {
//    	if (unit instanceof Character) {
//    		try {
//    			BufferedImage image = ImageIO.read( new File( unit.imageUrl ) );                
//                AnimatedImage animatedImage =
//                	new AnimatedImage(image, EditorConstants.CHARACTERS_IMAGES_FRAMES_SIZE.x,
//                			EditorConstants.CHARACTERS_IMAGES_FRAMES_SIZE.y);
//                add(animatedImage);
//                int[] frames = { 27, 26, 25, 24 };
//                animatedImage.startAnimation( frames, 4, false );
////                animatedImage.setLocation(
////                        this.getWidth() / 2 - animatedImage.getWidth() / 2,
////                        this.getHeight() / 2 - animatedImage.getHeight() / 2 );
//            } catch ( Exception e ) {
//                e.printStackTrace();
//            }
//    	} else {
        ImageIcon unitImageIcon = new ImageIcon( unit.getImage() );
        JLabel unitImage = new JLabel();
        unitImage.setIcon( unitImageIcon );
        unitImage.setSize( unitImageIcon.getIconWidth(), unitImageIcon.getIconHeight() );
        
        add( unitImage );
        unitImage.setLocation(
                this.getWidth() / 2 - unitImage.getWidth() / 2,
                this.getHeight() / 2 - unitImage.getHeight() / 2 );
//    	}
    }
    
    /**
     * Get the unit contained in this UnitSlot
     * 
     * @return  the unit contained in this UnitSlot
     */
    Unit getUnit() {
        return unit;
    }
    
    /**
     * Create new unit which is a clone of the contained unit
     * and return it
     * 
     * @return  a clone of the unit which is contained in this UnitSlot
     */
    Unit createNewUnit() {
        return UnitFactory.clone( unit );
    }

}
