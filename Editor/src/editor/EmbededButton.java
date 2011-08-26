package editor;

import java.awt.Component;
import java.awt.Image;
import java.awt.event.ContainerAdapter;
import java.awt.event.ContainerEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.FileNotFoundException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import constants.URLs;

/**
 * Button class
 * 
 * @author Ken
 * 
 * Image button on the screen
 * only embeded buttons (i.e. the images for the
 * buttons are embeded)
 * have two forms: selected - mouseover
 * unselected - else
 */
public class EmbededButton extends JLabel {

    private static final long serialVersionUID = 1L;
    /** Url to the image of this button */
    private String imageUrl;
    /**
     * Listener to mouse over and click event
     * to change the image of the button accordingly
     */
    private MouseAdapter mouseOverClickListener; 
    /**
     * Listener to container event (add/remove component)
     * so that even when the mouse over/click on the child
     * the state of the button is still updated
     */
    private ContainerAdapter containerListener;
    /**
     * Flag to indicate whether to set this button
     * as selected permanently
     */
    private boolean isSelectedPermanent;
    
    /**
     * Constructor
     * 
     * @param	imageUrl
     * 			is the incomplete path to the
     * 			name of the button
     * 			if it is "one/two", then the images for the button
     * 			is "one/two_selected.png" and "one/two_unselected.png"
     * 			suffix are given by CSSConstant.BUTTON_SELECTED_SUFFIX
     * 			and CSSConstant.BUTTON_UNSELECTED_SUFFIX 
     */
    EmbededButton( String imageUrl ) {
        this.imageUrl = imageUrl;
        try {
            setUnselected();
        } catch ( FileNotFoundException e ) {
//            System.err.println( e );
        	ExceptionHandler.handleException(e);
        }
        this.addMouseListener( getMouseOverClickListener() );
        this.addContainerListener( getContainerListener() );
    }
    
    /**
     * Set the button to selected mode permanently
     */
    void setSelectedPermanent() throws FileNotFoundException {
    	isSelectedPermanent = true;
    	setSelected();
    }
    /**
     * Set the button to selected mode
     * called by this when mouse over this button
     * change the picture of the button to indicate taht this
     * one is currently under selected
     * 
     * @throws  FileNotFoundException if the image for the selected
     *          mode is not found
     */
    void setSelected() throws FileNotFoundException { 
        setImage( imageUrl + URLs.BUTTON_SELECTED_SUFFIX );
        repaint();
    }
    
    /**
     * Set the button to unselected mode
     * reset isSelectedPermanent as well
     * called by this when mouse over this button
     * change the picture of the button to indicate taht this
     * one is currently under selected
     * 
     * @throws  FileNotFoundException if the image for the selected
     *          mode is not found
     */
    void setUnselected() throws FileNotFoundException {
    	isSelectedPermanent = false;
        setImage( imageUrl + URLs.BUTTON_UNSELECTED_SUFFIX );
        repaint();
    }
    
    /**
     * Set image of this button to the given image
     * 
     * @param   imageUrl
     *          is the url to the image
     *          
     * @throws  FileNotFoundException if the image is not found
     */
    private void setImage( String imageUrl ) throws FileNotFoundException {
        try {
            Image image =
               ImageIO.read( ClassLoader.getSystemResourceAsStream( imageUrl ) );
//        	Image image = ImageIO.read( new File(imageUrl) );
            ImageIcon icon = new ImageIcon( image );
            setIcon( icon );
            setSize( icon.getIconWidth(), icon.getIconHeight() );
            repaint();
        } catch ( Exception e ) {
//            e.printStackTrace();
            System.out.println( imageUrl );
            ExceptionHandler.handleException(e);
        }
    }
    
    
    /**
     * Listener to container event (add/remove component)
     * so that even when the mouse over/click on the child
     * the state of the button is still updated
     */
    private ContainerAdapter getContainerListener() {
    	if ( containerListener == null )
    		containerListener = new ContainerAdapter() {
    			@Override
    			public void componentAdded( ContainerEvent e ) {
    				EventsListenersAdderRemover.addEventListener(
    						( Component ) e.getSource(), getMouseOverClickListener() );
    			}
    			
    			@Override
    			public void componentRemoved( ContainerEvent e ) {
    				EventsListenersAdderRemover.removeEventListener(
    						( Component ) e.getSource(), getMouseOverClickListener() );
    			}
			};
		return containerListener;
    }
    
    /**
     * Return mouse listener to mouse over/exit event on this button
     * to switch to selected/unselected mode accordingly
     * 
     * @return  mouseAdapter
     * 			is the listener to mouse over/exit event on this button
     *          to switch to selected/unselected mode accordingly
     */
    private MouseAdapter getMouseOverClickListener() {
        if ( mouseOverClickListener == null ) {
            mouseOverClickListener = new MouseAdapter() {
                @Override
                public void mouseEntered( MouseEvent e ) {
                    try {
                        setSelected();
                    } catch ( FileNotFoundException ex ) {
//                        System.err.println( ex );
                    	ExceptionHandler.handleException(ex);
                    }
                }
                
                @Override
                public void mouseExited( MouseEvent e ) {
                	if ( ! isSelectedPermanent )
	                    try {
	                        setUnselected();
	                    } catch ( FileNotFoundException ex ) {
//	                        System.err.println( ex );
	                    	ExceptionHandler.handleException(ex);
	                    }
                }
            };
        }
        return mouseOverClickListener;
    }
    
    /**
     * Remove all event listener attached to this
     * called before this button is removed
     */
    void removeMouseEventListener() {
        this.removeMouseListener( mouseOverClickListener );
    }

}
