package editor;

import java.awt.Graphics;
import java.awt.Image;
import java.awt.Point;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JLabel;

import constants.EditorConstants;
import constants.URLs;

/**
 * Grid class
 * 
 * @author Ken
 * 
 * This class represents one grid on the designed map
 *
 */
public class Grid extends JLabel {
    
    static private final long serialVersionUID = 1L;
    
    /**
     * Type of the grid
     */
    static enum GridType {
    	SQUARE, HEX
    }
    
    /**
     * Image of all the grid
     * Remember it so that the next grid does not need to load
     * the image one more time
     */
    static private Image gridImage;
    
    /**
     * Get the image of the grid
     * if the image has not yet been initialzied, then load the image
     * and save it as gridImage static variable
     * 
     * @return  image of the grid
     */
    static private Image getImage() {
        if ( gridImage == null ) {   
            try {
                gridImage = ImageIO.read( ClassLoader.getSystemResourceAsStream( URLs.SQUARE_GRID_IMAGE_URL ) );
            } catch ( Exception e ) {
//                e.printStackTrace();
            	ExceptionHandler.handleException(e);
            }
        }
        return gridImage;
    }
    
    /**
     * Coordinate of this grid on the map
     */
    private final Point coordinate;
    /**
     * Type of this grid
     */
    private GridType type;
    /**
     * The unit which is currently on this grid
     */
    private Unit unit;
    
    /**
     * Default constructor
     */
    Grid( int x, int y ) {
    	super();
    	setOpaque( false );
        coordinate = new Point( x, y );
        setImage();
        type = GridType.SQUARE;
    }
    
    /**
     * Set image of this to the image of the grid
     */
    private void setImage() {
//        Image gridImage = getImage();
//        ImageIcon gridIcon = new ImageIcon( gridImage );
//        setIcon( gridIcon );
//        setOpaque( false );
//        setSize( gridIcon.getIconWidth(), gridIcon.getIconHeight() );
    	setSize( (int)(EditorConstants.GRID_SIZE.width * EditorConstants.SCALE),
    			(int)(EditorConstants.GRID_SIZE.height * EditorConstants.SCALE));
    }
    
    /**
     * Resize this grid to reflect the new scale
     */
    public void resizeToNewScale() {
    	setSize( (int)(EditorConstants.GRID_SIZE.width * EditorConstants.SCALE),
    			(int)(EditorConstants.GRID_SIZE.height * EditorConstants.SCALE));
    }
    
    /**
     * Get the coordinate of this grid
     * 
     * @return  coordinate of this grid
     */
    Point getCoordinate() {
        return coordinate;
    }
    
    /**
     * Add a unit to this grid
     * 
     * @param   unit
     *          is the unit to add to this grid
     */
    void setUnit( Unit unit ) {
        this.unit = unit;
    }
    
    /**
     * Get the unit on this grid
     * 
     * @return  the unit which is currently on this grid
     */
    Unit getUnit() {
        return unit;
    }
    
    /**
     * Change the type of this grid
     * 
     * @param	newGridType
     * 			is the new type of this grid
     */
    void changeGridType( GridType newGridType ) {
    	type = newGridType;
    }
    
	@Override
	public void paint( Graphics g ) {
		super.paint( g );
		g.setColor( EditorConstants.GRID_BORDER_COLOR );
		
		switch ( type ) {
			case SQUARE:
				g.drawRect( 0, 0, getWidth() - 1, getHeight() - 1 );
				break;
			case HEX:
				// TASK: HARD CODE:
				double ratio = 32.0 / ( double ) getWidth();
				g.drawLine( 0, ( int ) ( 15 * ratio ), ( int ) ( 8 * ratio ), 0 );
				g.drawLine( ( int ) ( 8 * ratio ), 0, ( int ) ( 23 * ratio ), 0 );
				g.drawLine( ( int ) ( 23 * ratio ), 0,
						( int ) ( 32 * ratio ), ( int ) ( 15 * ratio ) );
				g.drawLine( ( int ) ( 32 * ratio ), ( int ) ( 16 * ratio ),
						( int ) ( 23 * ratio ), ( int ) ( 31 * ratio ) );
				g.drawLine( ( int ) ( 23 * ratio ), ( int ) ( 31 * ratio ),
						( int ) ( 8 * ratio ), ( int ) ( 31 * ratio ) );
				g.drawLine( ( int ) ( 8 * ratio ), ( int ) ( 31 * ratio ),
						0, ( int ) ( 16 * ratio ) );
				break;
		}
	}
	
}
