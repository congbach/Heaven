package editor;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.geom.AffineTransform;
import java.util.ArrayList;
import javax.swing.JPanel;

import constants.MessagesConstants;
import constants.EditorConstants;

/**
 * Map class
 * 
 * @author Ken
 * 
 * This class represents the real map which is currently being
 * designed by the game designer
 *
 */
public class Map extends JPanel implements Resizable {

    static private final long serialVersionUID = 1L;
    
    /** Transparent map to suck up all mouse events */
    private TransparentMapGrids transparentMap;
    /** The code of all the grid of the map */
//    private int[][] mapCodes;
    /** All the grids of the map */
    private Grid[][] grids;
    /** Flag to see whether this map has player in it already, or not */
    private boolean hasPlayer;
    /** List of all non-terrain units */
    private ArrayList< Unit > nonTerrainUnits;
    /** The temporary unit on this map, for preview purpose */
    private Unit temporaryUnit;
    /** Thumbnail of this map */
    private MapThumbnail mapThumbnail;
    /** Background, contains all the 'real' grids */
    private JPanel background;
    /** The real map, without back ground grids */
    private JPanel map;
    /** Observer to resize action of this map */
    private ArrayList<ResizeObserver> resizeObservers;
    
    /**
     * The unit which is at the temporary unit location,
     * which is not displayed because the temporary unit
     * is displayed instead.
     */
    private Unit unitAtTemporaryUnitLocation;
    
    /**
     * Default constructor
     */
    Map() {
        Point defaultMapGridSize = EditorConstants.DEFAULT_MAP_UNITS_SIZE;
        Dimension gridSize = EditorConstants.GRID_SIZE;
//        setPreferredSize( new Dimension(
//        				defaultMapGridSize.x * gridSize.width,
//        				defaultMapGridSize.y * gridSize.height ) );
        setLayout( null );
        setBackground( EditorConstants.MAP_BACKGROUND_COLOR );
        
        hasPlayer = false;
        nonTerrainUnits = new ArrayList< Unit >();
        
        background = new JPanel();
//        background.setSize( new Dimension(
//        				defaultMapGridSize.x * gridSize.width,
//        				defaultMapGridSize.y * gridSize.height ) );
        background.setLayout( null );
        background.setOpaque( false );
        
        map = new JPanel();
//        map.setSize( new Dimension(
//        				defaultMapGridSize.x * gridSize.width,
//        				defaultMapGridSize.y * gridSize.height ) );
        map.setLayout( null );
        map.setOpaque( false );
        
        add( background, 0 );
        add( map, 0 );
        
//        mapCodes = new int[ defaultMapGridSize.y ][ defaultMapGridSize.x ];
//        for ( int i = 0; i < mapCodes.length; i++ )
//            for ( int j = 0; j < mapCodes[ i ].length; j++ )
//                mapCodes[ i ][ j ] = EditorConstants.BLANK_UNIT_CODE;
        
        
        // add the transparent map on top of everything
        transparentMap = new TransparentMapGrids();
        add( transparentMap, 0 );

        displayGrids();
        notifyMapThumbnailBackgroundChanged();
        notifyMapThumbnailMapChanged();
    }
    
    /**
     * Display all grids on the map, so that deploying/designing
     * is much easier 
     */
    private void displayGrids() {
        Point defaultMapGridSize = EditorConstants.DEFAULT_MAP_UNITS_SIZE;
        int rows = defaultMapGridSize.y;
        int cols = defaultMapGridSize.x;
        grids = new Grid[0][0];
        resizeMapGrid( cols, rows );
//        grids = new Grid[ defaultMapGridSize.y ][ defaultMapGridSize.x ];
//        Dimension defaultGridSize = EditorConstants.GRID_SIZE;
//        int xPos = 0, yPos = 0;
//        for ( int rowIndex = 0; rowIndex < rows; rowIndex++ ) {
//            for ( int colIndex = 0; colIndex < cols; colIndex++ ) {
//                Grid grid = new Grid( colIndex, rowIndex );
//                grids[ rowIndex ][ colIndex ] = grid;
//                background.add( grid );
//                grid.setLocation( xPos, yPos );
//                xPos += defaultGridSize.width;
//            }
//            xPos = 0; yPos += defaultGridSize.height;
//        }
    }
    
    /**
     * Display an unit on this map temporarily only
     * only for the purpose of preview the map when the game designer
     * is adding stuff to this map
     * 
     * @param   unit
     *          is the unit to temporarily display on the map
     *          
     * @param   coordinate
     *          is the coordiante of teh grid to display the unit temporarily
     */
    void displayTemporaryUnit( Unit unit, Point coordinate ) {
        if ( unitAtTemporaryUnitLocation != null ) {
            unitAtTemporaryUnitLocation.setVisible( true );
//            map.add( unitAtTemporaryUnitLocation, 0 );
        }
        
        Grid grid = grids[ coordinate.y ][ coordinate.x ];
        unitAtTemporaryUnitLocation = grid.getUnit();
        if ( unitAtTemporaryUnitLocation != null )
            unitAtTemporaryUnitLocation.setVisible( false );
        
        Point gridLocation = Library.getRealCoordinate( grid, background );
        int y =
            gridLocation.y + EditorConstants.GRID_SIZE.height 
            - unit.getOffset().y - unit.getOffsetSize().height;
        int x = 
            gridLocation.x + EditorConstants.GRID_SIZE.width 
            - unit.getOffset().x - unit.getOffsetSize().width;
        unit.setLocation( x, y );
        map.add( unit, 0 );
        temporaryUnit = unit;

        moveTerrainsToBack();
        map.repaint();
        notifyMapThumbnailMapChanged();
    }
    
    /**
     * Remove the temporary unit from this map
     */
    void removeTemporaryUnit() {
        if ( temporaryUnit != null ) {
            map.remove( temporaryUnit );
            temporaryUnit = null;
            if ( unitAtTemporaryUnitLocation != null ) {
                unitAtTemporaryUnitLocation.setVisible( true );
                unitAtTemporaryUnitLocation = null;
            }
            notifyMapThumbnailMapChanged();
        }
    }
    
    /**
     * Add an unit to this map
     * 
     * @param   unit
     *          is the unit to add to this map
     * 
     * @param   coordinate
     *          is the coordinate of the grid to add the unit to
     */
    void addUnit( Unit unit, Point coordinate ) {
//        if ( ! canAddUnit( unit.getCode() ) ) {
    	if ( ! canAddUnit( unit ) ) {
            if ( unit.getCode() == EditorConstants.PLAYER_CODE && hasPlayer )
                ErrorLog.showError( 
                        this, MessagesConstants.ERROR_ONLY_PLAYER_ALLOWED_MESSAGE,
                        MessagesConstants.ERROR_ONLY_PLAYER_ALLOWED_TITLE );
            else {
            	ExceptionHandler.handleException( unit.toString() );
        		throw new IllegalArgumentException( unit.toString() );
            }
            
            return;
        }
        
        removeUnit( coordinate );
        
//        mapCodes[ coordinate.y ][ coordinate.x ] = unit.getCode();
        Grid grid = grids[ coordinate.y ][ coordinate.x ];
        grid.setUnit( unit );
        Point gridLocation = Library.getRealCoordinate( grid, background );
        int x = 
            gridLocation.x + EditorConstants.GRID_SIZE.width 
            - unit.getOffset().x - unit.getOffsetSize().width;
        int y =
            gridLocation.y + EditorConstants.GRID_SIZE.height 
            - unit.getOffset().y - unit.getOffsetSize().height;
        unit.setLocation( x, y );
        map.add( unit, 0 );
//        mapCodes[ coordinate.y ][ coordinate.x ] = unit.getCode();
        
        if ( ! ( unit instanceof Tile ) )
            nonTerrainUnits.add( unit );

        moveTerrainsToBack();
        notifyMapThumbnailMapChanged();
        
        if ( unit instanceof Character && unit.getCode() == EditorConstants.PLAYER_CODE )
            hasPlayer = true;
    }
    
    /**
     * Remove an unit from this map
     * 
     * @param   coordinate
     *          is the coordinate of the grid to remove the unit from
     */
    void removeUnit( Point coordinate ) {
        Grid grid = grids[ coordinate.y ][ coordinate.x ];
        Unit unit = grid.getUnit();
        if ( unit != null ) {
//            mapCodes[ coordinate.y ][ coordinate.x ] = EditorConstants.BLANK_UNIT_CODE;
            grid.setUnit( null );
            map.remove( unit );
            if ( ! ( unit instanceof Tile ) )
                nonTerrainUnits.remove( unit );
            if ( unit instanceof Character && unit.getCode() == EditorConstants.PLAYER_CODE )
            	hasPlayer = false;
            notifyMapThumbnailMapChanged();
//            repaint();
            map.repaint();
        }
    }
    
    /**
     * Move all terrains to the back, so that
     * they do not overlap (hide) characters
     */
    private void moveTerrainsToBack() {
    	ArrayList< Tile > terrains = new ArrayList< Tile >();
    	for ( Component child : map.getComponents() )
    		if ( child instanceof Tile )
    			terrains.add( ( Tile ) child );
    	for ( Tile terrain : terrains )
    		map.add( terrain, map.getComponentCount() - 1 );
    }
        
    /**
     * Return whether this map has player inside it or not
     * 
     * @return  whether this map has player inside it or not
     */
    boolean hasPlayer() {
        return hasPlayer;
    }
    
//    /**
//     * Return whether thsi map can add a specific type of unit to it or not
//     * like in platform game, there can be only one player in the map.
//     * Also, as in TBS game, each PC is unique, so duplication is not allow
//     * 
//     * @param   unitCode
//     *          is the code of the unit to check whether can add it to the map
//     *          
//     * @return  whether can add the unit with the given unitCode to the map
//     */
//    boolean canAddUnit( int unitCode ) {
//        if ( unitCode == EditorConstants.PLAYER_CODE && hasPlayer )
//            return false;
//        else
//            return true;
//    }
    
    /**
     * Return whether thsi map can add a specific type of unit to it or not
     * like in platform game, there can be only one player in the map.
     * Also, as in TBS game, each PC is unique, so duplication is not allow
     * 
     * @param   unitCode
     *          is the code of the unit to check whether can add it to the map
     *          
     * @return  whether can add the unit with the given unitCode to the map
     */
    boolean canAddUnit( Unit unit ) {
        if (hasPlayer && (unit instanceof Character && unit.getCode() == EditorConstants.PLAYER_CODE))
            return false;
        else
            return true;
    }
    
    /**
     * Return the unit at the given coordinate
     * 
     * @param	coordinate
     * 			is the coordinate of the grid to get the unit
     * 
     * @return	unit at the given coordinate
     */
    Unit getUnit( Point coordinate ) {
    	return grids[ coordinate.y ][ coordinate.x ].getUnit();
    }
    
    /**
     * Return the transparent grid at the specific location
     * 
     * @param	location
     * 			is the location (in pixels) of the transparent grid to retrieve
     * 
     * @return	the transparent grid at the given location
     */
    TransparentGrid getTransparentGridAt( Point location ) {
    	return transparentMap.getTransparentGridAt( location );
    }
    
    /**
     * Return the grid at the specific location
     * 
     * @param	location
     * 			is the location (in pixels) of the grid to retrieve
     * 
     * @return	the grid at the given location
     */
    Grid getGridAt( Point location ) {
    	TransparentGrid transparentGridAtLocation = getTransparentGridAt( location );
    	return getGrid( transparentGridAtLocation.getCoordinate() );
    }
    
    /**
     * Return the grid given its coordinate
     * 
     * @param	coordinate
     * 			is the coordinate of the grid
     * 
     * @return	the grid at the given coordinate
     */
    Grid getGrid( Point coordinate ) {
    	return grids[ coordinate.y ][ coordinate.x ];
    }
    
    /**
     * Return the grids size of this map, i.e. size of this map in grids
     * 
     * @return	size of this map in grid x grid ( col * row )
     */
    Point getMapSizeInGrid() {
//    	return new Point( mapCodes[ 0 ].length, mapCodes.length );
    	if (grids.length == 0)
    		return new Point(0, 0);
    	return new Point(grids[0].length, grids.length);
    }
    
//    /**
//     * Load the construct the map based on the given map codes
//     * (from external file)
//     */
//    void loadMap( String stringMapCodes ) throws IllegalArgumentException {
//    	throw new RuntimeException( "Not supported yet." );
////    	try {
////    		reset();
////	    	String[] lines = stringMapCodes.split( "\n" );
////	    	ArrayList< String[] > grids = new ArrayList< String[] >();
////	    	for ( String line : lines )
////	    		grids.add( line.split( EditorConstants.MAP_UNITS_SPLITER ) );
////	    	
////	    	mapCodes = new int[ lines.length ][ grids.get( 0 ).length ];
////	    	for ( int i = 0; i < grids.size(); i++ ) {
////	    		String[] line = grids.get( i );
////	    		for ( int j = 0; j < line.length; j++ )
////	    			mapCodes[ i ][ j ] = Integer.parseInt( line[ j ] );
////	    	}
////	    	constructMap();
////    	} catch ( Exception e ) {
////    		e.printStackTrace();
////    		throw new IllegalArgumentException( "Undefined map code style:\n" + stringMapCodes );
////    	}
//    }
    
    /**
     * Load the map from external file
     * 
     * @param	tileMap
     * 			is the txt of the tile map
     * @param	characterMap
     * 			is the txt of the character map
     * @param	itemMap
     * 			is the txt of the item map
     */
    public void loadMap(String tileMap, String characterMap, String itemMap) {
    	String[] maps = { tileMap, characterMap, itemMap };
    	ArrayList< int[][] > mapsGrids = new ArrayList< int[][] >();
    	for (int i = 0; i < maps.length; i++) {
    		ArrayList<String[]> map = new ArrayList< String[] >();
    		String[] mapLines = maps[i].split( "\n" );
    		for (int j = 0; j < mapLines.length; j++)
    			if (mapLines[j].trim().length() > 0)
    				map.add( mapLines[j].split( EditorConstants.MAP_UNITS_SPLITER ) );
    		int row = map.size();
    		int col = row > 0 ? map.get(0).length : 0;
    		int[][] mapGrids = new int[row][col];
    		for (int rowId = 0; rowId < row; rowId++)
    			for (int colId = 0; colId < col; colId++)
    				try {
    					mapGrids[rowId][colId] = Integer.parseInt( map.get( rowId )[colId] );
    				} catch (NumberFormatException e) {
    					mapGrids[rowId][colId] = EditorConstants.BLANK_UNIT_CODE;
    				}
    		mapsGrids.add(mapGrids);
    	}
    	constructMap(mapsGrids.get(0), mapsGrids.get(1), mapsGrids.get(2));
    }
    
    /**
     * Load the map from external file
     * 
     * @param	tileMap
     * 			is the txt of the tile map
     * @param	characterMap
     * 			is the txt of the character map
     * @param	itemMap
     * 			is the txt of the item map
     */
    public void constructMap(int[][] tileMap, int[][] characterMap, int[][] itemMap) {
    	int row = Math.min( tileMap.length, Math.min( characterMap.length, itemMap.length ) );
    	int col = row > 0 ? Math.min(tileMap[0].length, Math.min(characterMap[0].length, itemMap[0].length)): 0;
    	int[][][] maps = { tileMap, characterMap, itemMap };
    	reset();
    	resizeMapGrid( col, row );
    	for (int k = 0; k < 3; k++)
    		for (int i = 0; i < row; i++)
    			for (int j = 0; j < col; j++) {
    				int unitCode = maps[k][i][j];
    				if (unitCode != EditorConstants.BLANK_UNIT_CODE) {
    					Unit unit = null;
    					if (k == 0)
    						unit = UnitFactory.createTile( unitCode );
    					else if (k == 1)
    						unit = UnitFactory.createCharacter( unitCode );
    					else if (k == 2)
    						unit = UnitFactory.createItem( unitCode );
    					addUnit( unit, new Point( j, i ) );
    				}	
    			}
    }
    
//    /**
//     * Construct the map, based on the mapCodes
//     */
//    private void constructMap() throws IllegalArgumentException {
//    	throw new RuntimeException( "Not supported yet." );
////    	try {
////    		int rows = mapCodes.length;
////    		int cols = mapCodes[ 0 ].length;
////    		for ( int rowIndex = 0; rowIndex < rows; rowIndex++ )
////    			for ( int colIndex = 0; colIndex < cols; colIndex++ ) {
////    				int unitCode =  mapCodes[ rowIndex ][ colIndex ];
////    				if ( unitCode != EditorConstants.BLANK_UNIT_CODE ) 
////	    				addUnit( UnitFactory.create( unitCode ), new Point( colIndex, rowIndex ) );
////    			}
////    	} catch ( Exception e ) {
////    		throw new IllegalArgumentException();
////    	}
//    }
    
    /**
     * Hide all the grids background
     * 
     * @param	gridVisible
     * 			indicate whether the grids' background image is shown or not
     */
    void setGridVisible( boolean gridVisible ) {
    	background.setVisible( gridVisible );
    	background.repaint();
    	notifyMapThumbnailBackgroundChanged();
    }
    
    /**
     * Get whether the grids are visible
     * 
     * @return	whether the grids are visible
     */
    boolean areGridsVisible() {
    	return background.isVisible();
    }
    
    /**
     * Reset this map to blank
     */
    void reset() {
//    	int rows = mapCodes.length;
//		int cols = mapCodes[ 0 ].length;
    	Point mapGridSize = getMapSizeInGrid();
    	int cols = mapGridSize.x;
    	int rows = mapGridSize.y;
		for ( int rowIndex = 0; rowIndex < rows; rowIndex++ )
			for ( int colIndex = 0; colIndex < cols; colIndex++ )
				removeUnit( new Point( colIndex, rowIndex ) );
    }
    
    /**
     * Add a thumbnail which represents a small version of this map
     * 
     * @param	mapThumbnail
     * 			is the thumbnail of this map
     */
    void addMapThumbnail( MapThumbnail mapThumbnail ) {
    	this.mapThumbnail = mapThumbnail;
    }
    
    /**
     * Notify mapThumbnail that this map has been changed
     */
    private void notifyMapThumbnailMapChanged() {
    	if ( mapThumbnail != null )
    		mapThumbnail.updateMap();
    }
    
    /*
     * Notify mapThumbnail that this map's background has been changed
     */
    private void notifyMapThumbnailBackgroundChanged() {
    	if ( mapThumbnail != null )
    		mapThumbnail.updateBackground();
    }
    
    /**
     * Get the background image of this
     * i.e. all the grid
     */
    JPanel getGridsBackground() {
    	return background;
    }
    
    /**
     * Get the map without the background (i.e. grids)
     */
    JPanel getMap() {
    	return map;
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
    void resizeMapGrid( int colsCount, int rowsCount ) throws IllegalArgumentException {
    	if ( colsCount <= 0 || rowsCount <= 0 )
    		throw new IllegalArgumentException();
    	
//    	int[][] oldMapCodes = mapCodes;
//    	mapCodes = new int[ rowsCount ][ colsCount ];
    	
    	Grid[][] oldGrids = grids;
    	grids = new Grid[ rowsCount ][ colsCount ];
    	
//    	int oldRowsCount = oldMapCodes.length;
//    	int oldColsCount = oldMapCodes[ 0 ].length;
    	int oldRowsCount = oldGrids.length;
    	int oldColsCount = oldRowsCount > 0 ? oldGrids[ 0 ].length : 0;
    	
    	int minRowsCount = ( int ) Math.min( rowsCount, oldRowsCount );
    	int minColsCount = ( int ) Math.min( colsCount, oldColsCount );

        int xPos = 0, yPos = 0;
        Dimension defaultGridSize = EditorConstants.GRID_SIZE;
        Dimension newSize = new Dimension((int)(defaultGridSize.width * colsCount * EditorConstants.SCALE),
											(int)(defaultGridSize.height * rowsCount * EditorConstants.SCALE));
        setPreferredSize( newSize );
        background.setSize(newSize);
        map.setSize(newSize);

    	int rowIndex = 0;
        // copy back
    	for ( ; rowIndex < minRowsCount; rowIndex++ ) {
    		int colIndex = 0;
    		for ( ; colIndex < minColsCount; colIndex++ ) {
//    			mapCodes[ rowIndex ][ colIndex ] = oldMapCodes[ rowIndex ][ colIndex ];
    			grids[ rowIndex ][ colIndex ] = oldGrids[ rowIndex ][ colIndex ];
    			xPos += defaultGridSize.width;
    		}
    		// add blank grid if neccessary
    		for ( ; colIndex < colsCount; colIndex++ ) {
//    			mapCodes[ rowIndex ][ colIndex ] = EditorConstants.BLANK_UNIT_CODE;
    			Grid grid = new Grid( colIndex, rowIndex );
    			grids[ rowIndex ][ colIndex ] = grid;
    			grid.setLocation( xPos, yPos );
                background.add( grid );
    			xPos += defaultGridSize.width;
    		}
    		xPos = 0;
    		yPos += defaultGridSize.height;
    	}
		// add blank grid if neccessary
    	for ( ; rowIndex < rowsCount; rowIndex++ ) {
    		for ( int colIndex = 0; colIndex < colsCount; colIndex++ ) {
//    			mapCodes[ rowIndex ][ colIndex ] = EditorConstants.BLANK_UNIT_CODE;
    			Grid grid = new Grid( colIndex, rowIndex );
    			grids[ rowIndex ][ colIndex ] = grid;
    			grid.setLocation( xPos, yPos );
                background.add( grid );
    			xPos += defaultGridSize.width;
    		}
    		xPos = 0;
    		yPos += defaultGridSize.height;
    	}
    	
    	// delete exceed
    	rowIndex = 0;
    	for ( ; rowIndex < minRowsCount; rowIndex++ ) {
    		for ( int colIndex = colsCount; colIndex < oldColsCount; colIndex++ ) {
    			Grid grid = oldGrids[ rowIndex ][ colIndex ];
    			background.remove( grid );
    			Unit unit = grid.getUnit();
    			if ( unit != null )
    				map.remove( unit );
    		}
    	}
    	for ( ; rowIndex < oldRowsCount; rowIndex++ ) {
    		for ( int colIndex = 0; colIndex < oldColsCount; colIndex++ ) {
    			Grid grid = oldGrids[ rowIndex ][ colIndex ];
    			background.remove( grid );
    			Unit unit = grid.getUnit();
    			if ( unit != null )
    				map.remove( unit );
    		}
    	}
    	
    	transparentMap.resizeMap( colsCount, rowsCount );
    	this.revalidate();
    	notifyResizeObservers();
    }
    
    /**
     * Change the grid type
     * 
     * @param	newGridType
     * 			is the new type of the grid inside this map
     */
    void changeGridType( Grid.GridType newGridType ) {
    	// TASK
    }
    
    /**
     * Resize this map display size on the screen
     * 
     * @param	newWindowsSize
     * 			is the new size of the windows
     */
    void resizeDisplaySize( Dimension newWindowsSize ) {
    	
    }
    

    
//    /**
//     * Return the code of this map
//     * 
//     * @return	code of this map to save to external file
//     */
//    String getCode() {
//    	String mapCode = "";
//    	int rowsCount = grids.length;
//    	int colsCount = grids[ 0 ].length;
//    	for ( int rowIndex = 0; rowIndex < rowsCount; rowIndex++ ) {
//    		for ( int colIndex = 0; colIndex < colsCount; colIndex++ ) {
////    			mapCode += mapCodes[ rowIndex ][ colIndex ];
//    			if ( colIndex < colsCount - 1 )
//    				mapCode += EditorConstants.MAP_UNITS_SPLITER;
//    		}
//    		if ( rowIndex < rowsCount - 1 )
//    			mapCode += "\n";
//    	}
//    	return mapCode;
//    }
    
	/**
	 * Return the code of this map
	 * 
	 * @return code of this map to save to external file
	 */
	String getCode() {
		String mapCode = "";
		mapCode += "=================\n" + "TILES:\n" + "=================\n";
		mapCode += getTileCode();
		mapCode += "\n\n\n\n";
		mapCode += "=================\n" + "CHARACTERS:\n"
				+ "=================\n";
		mapCode += getCharacterCode();
		mapCode += "\n\n\n\n";
		mapCode += "=================\n" + "ITEMS:\n" + "=================\n";
		mapCode += getItemCode();
		mapCode += "\n\n\n\n";
		return mapCode;
	}
    
    /**
     * Return the tile code of this map to save to external file
     * 
     * @return	the tile code of this map to save to external file
     */
    String getTileCode() {
    	String tileCode = "";
    	int rowsCount = grids.length;
    	int colsCount = grids[ 0 ].length;
    	for ( int rowIndex = 0; rowIndex < rowsCount; rowIndex++ ) {
    		for ( int colIndex = 0; colIndex < colsCount; colIndex++ ) {
    			Unit unit = grids[rowIndex][colIndex].getUnit();
    			if (unit instanceof Tile)
    				tileCode += unit.getCode();
    			else
    				tileCode += EditorConstants.BLANK_UNIT_CHAR;
    			if ( colIndex < colsCount - 1 )
    				tileCode += EditorConstants.MAP_UNITS_SPLITER;
    		}
    		if ( rowIndex < rowsCount - 1 )
    			tileCode += "\n";
    	}
    	return tileCode;
    }
    
    /**
     * Return the character code of this map to save to external file
     * 
     * @return	the character code of this map to save to external file
     */
    String getCharacterCode() {
    	String characterCode = "";
    	int rowsCount = grids.length;
    	int colsCount = grids[ 0 ].length;
    	for ( int rowIndex = 0; rowIndex < rowsCount; rowIndex++ ) {
    		for ( int colIndex = 0; colIndex < colsCount; colIndex++ ) {
    			Unit unit = grids[rowIndex][colIndex].getUnit();
    			if (unit instanceof Character)
    				characterCode += unit.getCode();
    			else
    				characterCode += EditorConstants.BLANK_UNIT_CHAR;
    			if ( colIndex < colsCount - 1 )
    				characterCode += EditorConstants.MAP_UNITS_SPLITER;
    		}
    		if ( rowIndex < rowsCount - 1 )
    			characterCode += "\n";
    	}
    	return characterCode;
    }
    
    /**
     * Return the item code of this map to save to external file
     * 
     * @return	the item code of this map to save to external file
     */
    String getItemCode() {
    	String itemCode = "";
    	int rowsCount = grids.length;
    	int colsCount = grids[ 0 ].length;
    	for ( int rowIndex = 0; rowIndex < rowsCount; rowIndex++ ) {
    		for ( int colIndex = 0; colIndex < colsCount; colIndex++ ) {
    			Unit unit = grids[rowIndex][colIndex].getUnit();
    			if (unit instanceof Item)
    				itemCode += unit.getCode();
    			else
    				itemCode += EditorConstants.BLANK_UNIT_CHAR;
    			if ( colIndex < colsCount - 1 )
    				itemCode += EditorConstants.MAP_UNITS_SPLITER;
    		}
    		if ( rowIndex < rowsCount - 1 )
    			itemCode += "\n";
    	}
    	return itemCode;
    }
    
    /**
	 * Resize this grid to reflect the new scale
	 */
	public void resizeToNewScale() {
    	int rowsCount = grids.length;
    	int colsCount = rowsCount > 0 ? grids[0].length : 0;
    	Dimension defaultGridSize = EditorConstants.GRID_SIZE;
        Dimension newSize = new Dimension((int)(defaultGridSize.width * colsCount * EditorConstants.SCALE),
											(int)(defaultGridSize.height * rowsCount * EditorConstants.SCALE));
        setPreferredSize( newSize );
        background.setSize(newSize);
        map.setSize(newSize);
//        // Resize all grids
//        for (int rowId = 0; rowId < rowsCount; rowId++)
//        	for (int colId = 0; colId < colsCount; colId++)
//        		grids[rowId][colId].resizeToNewScale();
        transparentMap.resizeToNewScale();
        revalidate();
    	notifyResizeObservers();
    }

	@Override
	public void addResizeObserver( ResizeObserver observer )
			throws IllegalArgumentException {
		if (resizeObservers == null)
			resizeObservers = new ArrayList< ResizeObserver >();
		resizeObservers.add( observer );
	}

	@Override
	public void notifyResizeObservers() {
		if (resizeObservers != null)
			for (ResizeObserver observer : resizeObservers)
				observer.resizableObjectResized();
	}

	@Override
	public void removeResizeObservers() {
		resizeObservers.clear();
	}
	
	@Override
	public void paint(Graphics g) {
		Graphics2D g2d = (Graphics2D) g;
		AffineTransform backup = g2d.getTransform();
		g2d.scale(EditorConstants.SCALE, EditorConstants.SCALE);
		super.paint( g );
		g2d.setTransform( backup );
	}
}
