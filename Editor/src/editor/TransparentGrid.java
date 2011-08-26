package editor;

import java.awt.Point;

import javax.swing.JPanel;

import constants.EditorConstants;

/**
 * TransparentGrid class
 * 
 * @author Ken
 * 
 * The only function of this class
 * is to suck up mouse event listener
 * in place of the real map grid
 *
 */
public class TransparentGrid extends JPanel {

    private static final long serialVersionUID = 1L;
    
    /**
     * Coordinate of this grid on the map
     */
    private final Point coordinate;
    
    /**
     * Default constructor
     */
    TransparentGrid( int x, int y ) {
        coordinate = new Point( x, y );
        
        setLayout( null );
        setSize( (int)(EditorConstants.GRID_SIZE.width * EditorConstants.SCALE),
    			(int)(EditorConstants.GRID_SIZE.height * EditorConstants.SCALE));
        setOpaque( false );
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

}
