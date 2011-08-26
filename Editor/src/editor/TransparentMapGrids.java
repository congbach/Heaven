package editor;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;

import javax.swing.JPanel;

import constants.EditorConstants;

public class TransparentMapGrids extends JPanel {

    private static final long serialVersionUID = 1L;
    
    /** All the transparent grids inside this */
    private TransparentGrid[][] transparentGrids;
    
    /**
     * Default constructor
     */
    TransparentMapGrids() {
        Point defaultMapGridSize = EditorConstants.DEFAULT_MAP_UNITS_SIZE;
        Dimension gridSize = EditorConstants.GRID_SIZE;
        setSize( new Dimension(
        				defaultMapGridSize.x * gridSize.width,
        				defaultMapGridSize.y * gridSize.height ) );
        setLayout( null );
        setOpaque( false );
        //addTransparentGrids();
        Point defaultMapGrid = EditorConstants.DEFAULT_MAP_UNITS_SIZE;
        int rows = defaultMapGrid.y;
        int cols = defaultMapGrid.x;
        transparentGrids = new TransparentGrid[0][0];
        resizeMap( cols, rows );
    }
    
    /**
     * Constructor
     * 
     * @param	cols
     * 			is the number of cols
     * @param	rows
     * 			is the numbers of rows
     */
    TransparentMapGrids(int cols, int rows) {
    	Point defaultMapGridSize = EditorConstants.DEFAULT_MAP_UNITS_SIZE;
        Dimension gridSize = EditorConstants.GRID_SIZE;
        setSize( new Dimension(
        				defaultMapGridSize.x * gridSize.width,
        				defaultMapGridSize.y * gridSize.height ) );
        setLayout( null );
        setOpaque( false );
//        transparentGrids = new TransparentGrid[0][0];
        resizeMap( cols, rows );
    }
    
    /**
     * Add all the transparent grid to this transparent map
     */
    private void addTransparentGrids() {
        Point defaultMapGrid = EditorConstants.DEFAULT_MAP_UNITS_SIZE;
        int rows = defaultMapGrid.y;
        int cols = defaultMapGrid.x;
        transparentGrids = new TransparentGrid[ rows ][ cols ];
        
        Dimension defaultGridSize = EditorConstants.GRID_SIZE;
        int xPos = 0, yPos = 0;
        for ( int rowIndex = 0; rowIndex < rows; rowIndex++ ) {
            for ( int colIndex = 0; colIndex < cols; colIndex++ ) {
                TransparentGrid transparentGrid = new TransparentGrid( colIndex, rowIndex );
                transparentGrids[ rowIndex ][ colIndex ] = transparentGrid;
                add( transparentGrid );
                transparentGrid.setLocation( xPos, yPos );
                xPos += defaultGridSize.width;
            }
            xPos = 0; yPos += defaultGridSize.height;
        }
    }
    
    /**
     * Return the transparent grid at the give location (in pixels)
     * 
     * @param	location
     * 			is the location (in pixels) of the transparent grid to retrieve
     * 
     * @return	the transparent grid at the given location
     */
    TransparentGrid getTransparentGridAt( Point location ) {
    	Dimension gridSize = EditorConstants.GRID_SIZE;
    	int rowIndex = location.y / (int)(gridSize.height * EditorConstants.SCALE);
    	int colIndex = location.x / (int)(gridSize.width * EditorConstants.SCALE);
    	return getTransparentGrid( new Point( colIndex, rowIndex ) );
    }
    
    /**
     * Return the grid given its coordinate
     * 
     * @param	coordinate
     * 			is the coordinate of the grid
     * 
     * @return	the grid at the given coordinate
     */
    TransparentGrid getTransparentGrid( Point coordinate ) {
    	return transparentGrids[ coordinate.y ][ coordinate.x ];
    }
    
    /**
     * Resize this map
     * 
     * @param	colsCount
     * 			is how many columns the map has after resized
     * 
     * @param	rowsCount
     * 			is how many rows the map has after resized
     */
    void resizeMap( int colsCount, int rowsCount ) throws IllegalArgumentException {
    	if ( colsCount <= 0 || rowsCount <= 0 )
    		throw new IllegalArgumentException();
    	
    	removeAll();
    	transparentGrids = new TransparentGrid[ rowsCount ][ colsCount ];

        int xPos = 0, yPos = 0;
        Dimension gridSize =
    		new Dimension((int)(EditorConstants.GRID_SIZE.width * EditorConstants.SCALE),
					(int)(EditorConstants.GRID_SIZE.height * EditorConstants.SCALE));
        setSize(
        		new Dimension( gridSize.width * colsCount,
        						gridSize.height * rowsCount) );

        // copy back
    	for ( int rowIndex = 0; rowIndex < rowsCount; rowIndex++ ) {
            for ( int colIndex = 0; colIndex < colsCount; colIndex++ ) {
                TransparentGrid transparentGrid = new TransparentGrid( colIndex, rowIndex );
                transparentGrids[ rowIndex ][ colIndex ] = transparentGrid;
                add( transparentGrid );
                transparentGrid.setLocation( xPos, yPos );
                xPos += gridSize.width;
            }
            xPos = 0; yPos += gridSize.height;
        }
//		TransparentGrid[][] oldGrids = transparentGrids;
//    	transparentGrids = new TransparentGrid[ rowsCount ][ colsCount ];
//    	
//    	int oldRowsCount = oldGrids.length;
//    	int oldColsCount = oldRowsCount > 0 ? oldGrids[ 0 ].length : 0;
//    	
//    	int minRowsCount = ( int ) Math.min( rowsCount, oldRowsCount );
//    	int minColsCount = ( int ) Math.min( colsCount, oldColsCount );
//
//        int xPos = 0, yPos = 0;
//        Dimension defaultGridSize = EditorConstants.GRID_SIZE;
//        setSize(
//        		new Dimension( defaultGridSize.width * colsCount,
//        				defaultGridSize.height * rowsCount ) );
//
//    	int rowIndex = 0;
//        // copy back
//    	for ( ; rowIndex < minRowsCount; rowIndex++ ) {
//    		int colIndex = 0;
//    		for ( ; colIndex < minColsCount; colIndex++ ) {
//    			transparentGrids[ rowIndex ][ colIndex ] = oldGrids[ rowIndex ][ colIndex ];
//    			xPos += defaultGridSize.width;
//    		}
//    		// add blank grid if necessary
//    		for ( ; colIndex < colsCount; colIndex++ ) {
//    			TransparentGrid grid = new TransparentGrid( colIndex, rowIndex );
//    			transparentGrids[ rowIndex ][ colIndex ] = grid;
//    			grid.setLocation( xPos, yPos );
//                add( grid );
//                grid.setEnabled( true );
//                grid.setOpaque( true );
//                grid.setBackground( Color.RED );
//    			xPos += defaultGridSize.width;
//    		}
//    		xPos = 0;
//    		yPos += defaultGridSize.height;
//    	}
//		// add blank grid if necessary
//    	for ( ; rowIndex < rowsCount; rowIndex++ ) {
//    		for ( int colIndex = 0; colIndex < colsCount; colIndex++ ) {
//    			TransparentGrid grid = new TransparentGrid( colIndex, rowIndex );
//    			transparentGrids[ rowIndex ][ colIndex ] = grid;
//    			grid.setLocation( xPos, yPos );
//                add( grid );
//                grid.setEnabled( true );
//                grid.setFocusable( true );
//                grid.setOpaque( true );
//                grid.setBackground( Color.RED );
//    			xPos += defaultGridSize.width;
//    		}
//    		xPos = 0;
//    		yPos += defaultGridSize.height;
//    	}
//    	
//    	// delete exceed
//    	rowIndex = 0;
//    	for ( ; rowIndex < minRowsCount; rowIndex++ ) {
//    		for ( int colIndex = colsCount; colIndex < oldColsCount; colIndex++ ) {
//    			TransparentGrid grid = oldGrids[ rowIndex ][ colIndex ];
//    			remove( grid );
//    		}
//    	}
//    	for ( ; rowIndex < oldRowsCount; rowIndex++ ) {
//    		for ( int colIndex = 0; colIndex < oldColsCount; colIndex++ ) {
//    			TransparentGrid grid = oldGrids[ rowIndex ][ colIndex ];
//    			remove( grid );
//    		}
//    	}
//    }
    }
    
    /**
	 * Resize this grid to reflect the new scale
	 */
	public void resizeToNewScale() {
		int rowsCount = transparentGrids.length;
    	int colsCount = rowsCount > 0 ? transparentGrids[0].length : 0;
    	Dimension gridSize =
    		new Dimension((int)(EditorConstants.GRID_SIZE.width * EditorConstants.SCALE),
					(int)(EditorConstants.GRID_SIZE.height * EditorConstants.SCALE));
        Dimension newSize = new Dimension(gridSize.width * colsCount,
        									gridSize.height * rowsCount);
        setSize( newSize );
        
        // Resize all grids' positions and sizez
        int xPos = 0, yPos = 0;
        for (int rowId = 0; rowId < rowsCount; rowId++) {
        	for (int colId = 0; colId < colsCount; colId++) {
        		transparentGrids[rowId][colId].setLocation( xPos, yPos );
        		transparentGrids[rowId][colId].resizeToNewScale();
                xPos += gridSize.width;
            }
            xPos = 0; yPos += gridSize.height;
        }
	}

}
