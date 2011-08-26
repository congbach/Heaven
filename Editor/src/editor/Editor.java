package editor;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.HierarchyBoundsAdapter;
import java.awt.event.HierarchyEvent;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Scanner;

import javax.imageio.ImageIO;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JFrame;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.filechooser.FileFilter;


import constants.ConstantsLoader;
import constants.EditorConstants;
import constants.MessagesConstants;
import constants.URLs;
import editor.CustomScrollPane.ScrollEvent;
import editor.CustomScrollPane.ScrollEventAdapter;
import editor.Grid.GridType;

/**
 * Editor class
 * 
 * @author Ken
 * 
 * This class is the Logic class of the editor.
 * Basically, it does nothing but controlling the flows of information
 * between internal JPanels (map, CharactersManager,...)
 *
 */
public class Editor extends JFrame {
   
	/**
	 * Main method
	 * show the windows
	 * 
	 * @param	args
	 */
    static public void main( String[] args ) {
        Editor mapEditor = new Editor();
        mapEditor.setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
        JLabel mapEditorLabel = new JLabel();
        mapEditorLabel.setPreferredSize( EditorConstants.DEFAULT_WINDOWS_SIZE );
        mapEditor.getJContentPane().add( mapEditorLabel, BorderLayout.CENTER );
        mapEditor.setLocation( EditorConstants.WINDOWS_LOCATION );
        mapEditor.pack();
        mapEditor.setVisible( true );
        mapEditor.start();
    }
    
    static private final long serialVersionUID = 1L;
    
    /**
     * Status of the game (indicates current action)
     * 
     * @author Ken
     *
     */
    static private enum Status {
    	/**
    	 * The game is still initializing
    	 */
    	NOT_READY,
    	/**
    	 * The programming is currently loading and constructing external map
    	 */
    	LOAD_EXTERNAL_MAP,
    	/**
    	 * The game designer is currently selecting unit to place on the map
    	 */
        SELECT_UNIT,
        /**
         * The game designer is currently dragging unit (non-terrain type)
         * to place on the map. Also valid when the game designer move
         * placed unit around on the map
         */
        DRAG_UNIT,
        /**
         * The game designer has decided the terrain type to place on the map,
         * and is currently selecting the grids to place the terrain
         */
        SELECT_GRID_PLACE_TERRAIN,
        /**
         * The game designer is currently placing terrain on the map
         * by pressing and dragging the mouse around
         */
        PLACING_TERRAIN
    }
    
    /**
     * Reference to this
     * to be referred to inside event listeners functions
     */
    private Editor self;
    /**
     * JPanel which contains everything in the map editor
     * i.e. the root
     */
    private JPanel jContentPane;
    /**
     * The area which shows the map which is currently designed
     */
    private Map map;
    /**
     * The map which contains the scroll bar
     */
    private CustomScrollPane mapScroller;
    /**
     * Thumbnail of map on the screen
     */
    private MapThumbnail mapThumbnail;
    /**
     * ArrayList of UnitsManager which contains all the UnitsManagers
     * on the screen
     */
    private ArrayList< UnitsManager > unitsManagers;
    /**
     * The panel which shows all the available characters
     * to put into the maps
     */
    private CharactersManager charactersManager;
    /**
     * The panel which shows all the available terrains (tiles
     * in the case of platform game) to put into the map
     */
    private TerrainsManager terrainsManager;
    /**
     * The panel which shows all the available items to put into
     * the map
     */
    private ItemsManager itemsManager;
    /**
     * The array listh which contains all the buttons to show/hide
     * units managers
     */
    private ArrayList< EmbededButton > unitsManagersButtons;
    /**
     * The transparent panel to suck up all mouse events when it is
     * necessary (like drag and drop)
     */
    private JPanel transparentPanel;
    
    
    
    //==================
    // EVENTS LISTENERS
    //==================
    /**
     * Listener to resize windows event
     * to adjust screen accordingly
     */
    private HierarchyBoundsAdapter windowsResizeListener;
    /**
     * Listener to event in file menu
     */
    private ActionListener fileMenuActionListener;
    /**
     * Listener to event in edit menu
     */
    private ActionListener editMenuActionListener;
    /**
     * Listener to event in check box in view menu
     */
    private ActionListener viewCheckBoxMenuItemsActionListener;
    /**
     * Listener to event in unit pop up menu
     */
    private ActionListener unitPopupMenuActionListener;
    /**
     * KeyboardEventsManager which will handle all keyboard events
     */
    private KeyboardEventsManager keyboardEventsManager;
    /**
     * Listener to mouse events on terrainsManager
     */
    private MouseAdapter terrainsManagerMouseEventListener;
    /**
     * Listener to mouse events on unitsManager other than
     * terrainsManager, since terrainsManager has a special
     * way of handling placing terrain on the map
     */
    private MouseAdapter nonTerrainsUnitsManagersMouseEventsListener;
    /**
     * Listener to press/click on the units managers buttons to show/hide
     * the units managers accordingly
     */
    private MouseAdapter unitsManagersButtonsMouseEventListener;
    /**
     * Listener to press/click on the transparent map
     * when there is no unit which is currently deploying/putting on the map
     */
    private MouseAdapter mapMouseEventListener;
    /**
     * Listener to scroll event in map scroller
     * to perform according actions
     */
    private ScrollEventAdapter mapScrollerScrollEventListener;
    
    
    
    //======
    // MENU
    //======    
    /** The global menu bar */
    private JMenuBar menuBar;
    
    /** File menu, contains: open, save, save as */
    private JMenu fileMenu;
    /** Open menu item */
    private JMenuItem openMenuItem;
    /** Save menu item */
    private JMenuItem saveMenuItem;
    /** Save As menu item */
    private JMenuItem saveAsMenuItem;
    /** Save As Image menu item */
    private JMenuItem saveAsImageMenuItem;
    
    /** View menu */
    private JMenu viewMenu;
    /** Checkbox item to show/hide grids */
    private JMenuItem showHideGridsMenuItem;
    
    /** Edit menu */
    private JMenu editMenu;
    /** Menu item to clear the current map */
    private JMenuItem clearMapMenuItem;
    /** Menu item to resize the current map */
    private JMenuItem resizeMapMenuItem;
    /** Menu item to change the scale of the map */
    private JMenuItem rescaleMapMenuItem;
    /** Change grid type */
    private JMenu changeGridTypeMenu;
    /** Change grid type to square */
    private JMenuItem changeGridTypeToSquareMenuItem;
    /** Change grid type to hex */
    private JMenuItem changeGridTypeToHexMenuItem;
    
    /** Unit pop up menu, activated on right click on any unit */
    private JPopupMenu unitPopupMenu;
    /** Delete unit */
    private JMenuItem deleteUnitMenuItem;
    
    
    
    //===========
    // VARIABLES
    //===========
    /** Current status of the map editor */
    private Status status;
    /**
     * The unit which is currently attach to the mouse (to place on the map)
     */
    private Unit selectedUnit;
    /**
     * File chooser, the path to the currently designed map (if selected)
     * also, this handles save and open fle
     */
    private JFileChooser fileChooser;
    /**
     * The current Grid the mouse is on (if any) 
     */
    private TransparentGrid currentMouseGrid;
    /**
     * The previous grid the mouse is on (if any)
     * so that update only when mouse grid has changed
     */
    private TransparentGrid prevMouseGrid;

    
    
    
    
    
    
    /**
     * This is the default constructor
     */
    private Editor() {
        super();
        self = this;
        status = Status.NOT_READY;
    }
    
    /**
     * Start the map after all the external configuration
     * is done
     */
    private void start() {
        ConstantsLoader.loadConstants();
        initialize();
    }
    
    /**
     * This method initializes this
     * Set the sign and title according to defined/designed
     * in the constants
     */
    private void initialize() {
        this.setSize( EditorConstants.DEFAULT_WINDOWS_SIZE );
        this.setTitle( EditorConstants.WINDOWS_TITLE );
        this.setContentPane( getJContentPane() );
        
        // initialize variable
        unitsManagers = new ArrayList< UnitsManager >();
        unitsManagersButtons = new ArrayList< EmbededButton >();
        fileChooser = new JFileChooser();
        keyboardEventsManager = KeyboardEventsManager.getInstance();        
        getJContentPane().addKeyListener( keyboardEventsManager );
        getJContentPane().requestFocusInWindow();
        
        initializeMenu();
        
        // initialize child panels        
        mapScroller = new CustomScrollPane( getMap(),
        		JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
        		JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS );
        mapScroller.setSize( EditorConstants.DEFAULT_MAP_SIZE );
        Dimension gridSize = EditorConstants.GRID_SIZE;
        mapScroller.showHorizontalRuler( (int)(gridSize.width * EditorConstants.SCALE),
        		EditorConstants.RULER_DEFAULT_SIZE.height );
        mapScroller.showVerticalRuler( EditorConstants.RULER_DEFAULT_SIZE.width,
        		(int)(gridSize.height * EditorConstants.SCALE));
        getJContentPane().add( mapScroller );
        
        mapThumbnail = new MapThumbnail( mapScroller, true );
        mapScroller.addThumbnail( mapThumbnail );
        getJContentPane().add( mapThumbnail, 0 );
        
        jContentPane.add( getTerrainsManager(), 0 );
        jContentPane.add( getCharactersManager(), 0 );
        jContentPane.add( getItemsManager(), 0 );
        
        initializeUnitsManagersButtons();
        jContentPane.add( getTransparentPanel(), 0 );
        
        // default is display terrains
        terrainsManager.setVisible( true );
        charactersManager.setVisible( false );
        itemsManager.setVisible( false );
        transparentPanel.setVisible( false );
        
        status = Status.SELECT_UNIT;
        repaint();
    }
    
    
    /**
     * Initialize all the available menu
     */
    private void initializeMenu() {
    	menuBar = new JMenuBar();
    	
    	// file menu
    	fileMenu = new JMenu( "File" );
    	fileMenu.setMnemonic( KeyEvent.VK_F );
    	openMenuItem = new JMenuItem( "Open", KeyEvent.VK_O );
    	openMenuItem.setAccelerator( KeyStroke.getKeyStroke( KeyEvent.VK_O, KeyEvent.CTRL_DOWN_MASK ) );
    	openMenuItem.addActionListener( getFileMenuActionListener() );
    	fileMenu.add( openMenuItem );
    	saveMenuItem = new JMenuItem( "Save", KeyEvent.VK_S );
    	saveMenuItem.setAccelerator( KeyStroke.getKeyStroke( KeyEvent.VK_S, KeyEvent.CTRL_DOWN_MASK ) );
    	saveMenuItem.addActionListener( getFileMenuActionListener() );
    	fileMenu.add( saveMenuItem );
    	saveAsMenuItem = new JMenuItem( "Save As", KeyEvent.VK_A );
    	saveAsMenuItem.addActionListener( getFileMenuActionListener() );
    	fileMenu.add( saveAsMenuItem );
    	saveAsImageMenuItem = new JMenuItem( "Save Map As Image", KeyEvent.VK_I );
    	saveAsImageMenuItem.addActionListener( getFileMenuActionListener() );;
    	fileMenu.add( saveAsImageMenuItem );
    	
    	// edit menu
    	editMenu = new JMenu( "Edit" );
    	editMenu.setMnemonic( KeyEvent.VK_E );
    	clearMapMenuItem = new JMenuItem( "Clear current map", KeyEvent.VK_C );
    	clearMapMenuItem.addActionListener( getEditMenuActionListener() );
    	editMenu.add( clearMapMenuItem );
    	resizeMapMenuItem = new JMenuItem( "Resize map", KeyEvent.VK_R );
    	resizeMapMenuItem.addActionListener( getEditMenuActionListener() );
    	editMenu.add( resizeMapMenuItem );
    	rescaleMapMenuItem = new JMenuItem( "Rescale map", KeyEvent.VK_S );
    	rescaleMapMenuItem.addActionListener( getEditMenuActionListener() );
    	editMenu.add( rescaleMapMenuItem );
//    	changeGridTypeMenu = new JMenu( "Change grid type" );
//    	changeGridTypeMenu.setMnemonic( KeyEvent.VK_G );
//    	changeGridTypeToSquareMenuItem = new JMenuItem( "SQUARE", KeyEvent.VK_S );
//    	changeGridTypeToSquareMenuItem.addActionListener( getEditMenuActionListener() );
//    	changeGridTypeMenu.add( changeGridTypeToSquareMenuItem );
//    	changeGridTypeToHexMenuItem = new JMenuItem( "HEX", KeyEvent.VK_H );
//    	changeGridTypeToHexMenuItem.addActionListener( getEditMenuActionListener() );
//    	changeGridTypeMenu.add( changeGridTypeToHexMenuItem );
//    	editMenu.add( changeGridTypeMenu );
    	
    	// view menu
    	viewMenu = new JMenu( "View" );
    	viewMenu.setMnemonic( KeyEvent.VK_V );
    	showHideGridsMenuItem = new JCheckBoxMenuItem( "Show grids" );
    	showHideGridsMenuItem.setSelected( true );
    	showHideGridsMenuItem.setMnemonic( KeyEvent.VK_G );
    	showHideGridsMenuItem.addActionListener( getViewCheckBoxMenuItems() );
    	viewMenu.add( showHideGridsMenuItem );
    	
    	// pop up menu
    	unitPopupMenu = new JPopupMenu();
    	deleteUnitMenuItem = new JMenuItem( "Delete", KeyEvent.VK_D );
    	deleteUnitMenuItem.addActionListener( getUnitPopupMenuActionListener() );
    	unitPopupMenu.add( deleteUnitMenuItem );
    	
    	menuBar.add( fileMenu );
    	menuBar.add( editMenu );
    	menuBar.add( viewMenu );
    	setJMenuBar( menuBar );
    }
    
    
    //=================
    // JPANELS/JLABELS
    //=================
    
    /**
     * This method initializes jContentPane
     * 
     * @return  the JPanel which contains everything in the Editor
     * (parent/root of everything)
     */
    private JPanel getJContentPane() {
        if ( jContentPane == null ) {
            jContentPane = new JPanel();
            jContentPane.setLayout( null );
            jContentPane.setSize( EditorConstants.DEFAULT_WINDOWS_SIZE );
            jContentPane.addHierarchyBoundsListener( getWindowsResizeListener() );
        }
        return jContentPane;
    }
    
    /**
     * Initialize the area which displays the map which
     * is currently designed
     * 
     * @return  the Map which displays the map the user is
     * currently designing
     */
    private Map getMap() {
        if ( map == null ) {
            map = new Map();
            EventsListenersAdderRemover.addEventListener( map, getMapMouseEventListener() );
        }
        return map;
    }
    
    /**
     * Initialize the area which displays all the available terrains
     * to add to the map
     * 
     * @return the terrainsManager which contains all the available terrains
     * to add to the map
     */
    private TerrainsManager getTerrainsManager() {
        if ( terrainsManager == null ) {
            terrainsManager = new TerrainsManager();
            unitsManagers.add( terrainsManager );
            EventsListenersAdderRemover.addEventListener( terrainsManager, getTerrainsManagerMouseEventListener() );
        }
        return terrainsManager;
    }
    
    /**
     * Initialize the area which displays all the available characters
     * to add to the map
     * 
     * @return the charactersManager which contains and displays all the available characters
     * to add to the map
     */
    private CharactersManager getCharactersManager() {
        if ( charactersManager == null ) {
            charactersManager = new CharactersManager();
            unitsManagers.add( charactersManager );
            EventsListenersAdderRemover.addEventListener( 
            		charactersManager, getNonTerrainsUnitsManagersMouseEventsListener() );
        }
        return charactersManager;
    }
    
    /**
     * Initialize the area which displays all the available items
     * to add to the map
     * 
     * @return the ItemsManager which contains and displays all the available items
     * to add to the map
     */
    private ItemsManager getItemsManager() {
        if ( itemsManager == null ) {
            itemsManager = new ItemsManager();
            unitsManagers.add( itemsManager );
            EventsListenersAdderRemover.addEventListener(
            		itemsManager, nonTerrainsUnitsManagersMouseEventsListener );
        }
        return itemsManager;
    }
    
    /**
     * Initialize the transparent panel which will suck up all mouse events
     * when it is necessary, like in the case of drag and drop
     * 
     * @return  the transparent panel which will suck up all mouse events
     * when it is necessary, like in the case of drag and drop
     */
    private JPanel getTransparentPanel() {
        if ( transparentPanel == null ) {
            transparentPanel = new JPanel();
            transparentPanel.setSize( getJContentPane().getSize() );
            transparentPanel.setOpaque( false );
        }
        return transparentPanel;
    }
    
    /**
     * Initialize all the manager buttons to indicate which manager to show
     * on the screen
     */
    private void initializeUnitsManagersButtons() {
        String[] unitsManagersButtonsImagesUrls = URLs.UNITS_MANAGERS_BUTTONS_IMAGES_URL;
        
        Point buttonsDistance = EditorConstants.UNIT_MANAGERS_BUTTONS_DISTANCE;
        Point firstLocation = EditorConstants.UNITS_MANAGER_BUTTON_DEFAULT_LOCATION;
        int xPos = firstLocation.x;
        int yPos = firstLocation.y;
        
        for ( String imageUrl : unitsManagersButtonsImagesUrls ) {
            EmbededButton button = new EmbededButton( imageUrl );
            unitsManagersButtons.add( button );
            getJContentPane().add( button, 0 );
            button.setLocation( xPos, yPos );
            button.addMouseListener( getUnitsManagersButtonsMouseEventListener() );
            xPos += button.getWidth() + buttonsDistance.x;
            yPos += buttonsDistance.y;
        }
    }
    
    
    
    //==================
    // EVENTS LISTENERS
    //==================
    
    /**
     * Get the listener to resize windows event
     * to adjust screen accordingly
     * 
     * @return the listener to resize windows event
     * to adjust screen accordingly
     */
    private HierarchyBoundsAdapter getWindowsResizeListener() {
    	if ( windowsResizeListener == null )
    		windowsResizeListener = new HierarchyBoundsAdapter() {
    			@Override
    			public void ancestorResized( HierarchyEvent e ) {
    				if ( status != Status.NOT_READY ) {
	    				Dimension newWindowsSize = self.getSize();
	    				Dimension defaultWindowsSize = EditorConstants.DEFAULT_WINDOWS_SIZE;
	    				int widthChange = newWindowsSize.width - defaultWindowsSize.width;
	    				int heightChange = newWindowsSize.height - defaultWindowsSize.height;
	    				
	    				Dimension defaultMapSize = EditorConstants.DEFAULT_MAP_SIZE;
	    				mapScroller.setSize(
	    						Math.max( defaultMapSize.width + widthChange, 0 ),
	    						Math.max( defaultMapSize.height + heightChange, 0 ) );
	    				
	    				Point mapThumbnailDefaultLocation = EditorConstants.MAP_THUMBNAIL_DEFAULT_LOCATION;
	    				Dimension mapThumbnailMargin = mapThumbnail.getMargin();
	    				mapThumbnail.setLocation(
	    						newWindowsSize.width - 
	    							( defaultWindowsSize.width - mapThumbnailDefaultLocation.x )
	    							+ mapThumbnailMargin.width,
	    							mapThumbnail.getY() );
	    				
	    				
	    				Point unitsManagerButtonDefaultLocation =
	    					EditorConstants.UNITS_MANAGER_BUTTON_DEFAULT_LOCATION;
	    				int xUnitsManagerButton = 
	    						newWindowsSize.width - 
									( defaultWindowsSize.width - unitsManagerButtonDefaultLocation.x );
	    				int yUnitsManagerButton =
	    						unitsManagerButtonDefaultLocation.y;
	    				Point unitManagerButtonDistance = EditorConstants.UNIT_MANAGERS_BUTTONS_DISTANCE;
	    				
	    				for ( EmbededButton unitsManagerButton : unitsManagersButtons ) {
	    					unitsManagerButton.setLocation( xUnitsManagerButton, yUnitsManagerButton );
	    					xUnitsManagerButton +=
	    						unitsManagerButton.getWidth() + unitManagerButtonDistance.x;
	    					yUnitsManagerButton += unitManagerButtonDistance.y;
	    				}
	    				
	    				Point unitsManagerDefaultLocation = EditorConstants.UNITS_MANAGERS_DEFAULT_LOCATION;
	    				int xUnitsManager = 
		    					newWindowsSize.width - 
								( defaultWindowsSize.width - unitsManagerDefaultLocation.x );
	    				
	    				for ( UnitsManager unitsManager : unitsManagers )
	    					unitsManager.setLocation( xUnitsManager, unitsManager.getY() );
	    				
	    				mapThumbnail.initializeScroller();
	    				repaint();
    				}
    			}
			};
    	return windowsResizeListener;
    }
    
    /**
     * Get the listener to event in file menu
     * 
     * @return	listener to event in file menu
     */
    private ActionListener getFileMenuActionListener() {
    	if ( fileMenuActionListener == null )
    		fileMenuActionListener = new ActionListener() {
				@Override
				public void actionPerformed( ActionEvent e ) {
					keyboardEventsManager.reset();
					if ( e.getSource() == openMenuItem ) {
						openFile();
					} else if ( e.getSource() == saveMenuItem ) {
						if ( fileChooser.getSelectedFile() == null )
							saveAsFile();
						else
							saveFile();
					} else if ( e.getSource() == saveAsMenuItem ) {
						saveAsFile();
					} else if ( e.getSource() == saveAsImageMenuItem ) {
						saveAsImageFile();
					}
				}
			};
    	return fileMenuActionListener;
    }
    
    /**
     * Get the listenter to event in edit menu
     * 
     * @return	listener to event in edit menu
     */
    private ActionListener getEditMenuActionListener() {
    	if ( editMenuActionListener == null )
    		editMenuActionListener = new ActionListener() {				
				@Override
				public void actionPerformed( ActionEvent e ) {
					Object source = e.getSource();
					if ( source == clearMapMenuItem ) {
						map.reset();
						//repaint();
						map.repaint();
						
					} else if ( source == resizeMapMenuItem ) {
						keyboardEventsManager.reset();
						Point currentGridSize = map.getMapSizeInGrid();
						final JTextField colsCount = new JTextField( "" + currentGridSize.x );
						final JTextField rowsCount = new JTextField( "" + currentGridSize.y );
						Object[] msg = { "Enter map size:", colsCount, rowsCount };
						final JOptionPane resizeMapOptionPane = 
							new JOptionPane( msg, JOptionPane.QUESTION_MESSAGE,
									JOptionPane.OK_CANCEL_OPTION, null );//, options, options[ 0 ] );
						final JDialog dialog = resizeMapOptionPane.createDialog( self, "Enter map size: " );
						
						final Point mapSize = new Point();
						
						dialog.setDefaultCloseOperation( DO_NOTHING_ON_CLOSE );
						resizeMapOptionPane.addPropertyChangeListener( new PropertyChangeListener() {
							@Override
							public void propertyChange( PropertyChangeEvent e ) {
								String prop = e.getPropertyName();
								
								if ( JOptionPane.VALUE_PROPERTY.equals( prop ) ||
									             JOptionPane.INPUT_VALUE_PROPERTY.equals( prop ) ) {
									Object value = resizeMapOptionPane.getValue();
									
									if ( value != null && value.toString().equals( "0" ) ) {
										boolean areInputsNumeric = true;
										try {
											mapSize.x = Integer.parseInt( colsCount.getText() );
											mapSize.y = Integer.parseInt( rowsCount.getText() );
										} catch ( Exception ex ) {
											areInputsNumeric = false;
											ErrorLog.showError( dialog, "Invalid input.", "Try again" );
											dialog.setVisible( true );
										}
										
										if ( areInputsNumeric ) {
											Point minMapSize = EditorConstants.MINIMUM_MAP_UNITS_SIZE;
											if ( mapSize.x < minMapSize.x || mapSize.y < minMapSize.y ) {
												ErrorLog.showError( dialog, 
														"Map too small. Minimum map is: "
														+ minMapSize.x + "x" + minMapSize.y + ".",
														"Try again" );
												dialog.setVisible( true );
											} else
												resizeMap( mapSize );
										}
									}
								}
							}
						} );
						colsCount.requestFocusInWindow();
						dialog.pack();
						dialog.setLocationRelativeTo( self );
						dialog.setVisible( true );
						
					} else if (source == rescaleMapMenuItem) {
						keyboardEventsManager.reset();
						final JTextField scaleTextField = new JTextField( "" + EditorConstants.SCALE );
						Object[] msg = { "Enter new scale:", scaleTextField };
						final JOptionPane rescaleMapOptionPane = 
							new JOptionPane( msg, JOptionPane.QUESTION_MESSAGE,
									JOptionPane.OK_CANCEL_OPTION, null );//, options, options[ 0 ] );
						final JDialog dialog = rescaleMapOptionPane.createDialog( self, "Enter new scale: " );
												
						dialog.setDefaultCloseOperation( DO_NOTHING_ON_CLOSE );
						rescaleMapOptionPane.addPropertyChangeListener( new PropertyChangeListener() {
							@Override
							public void propertyChange( PropertyChangeEvent e ) {
								String prop = e.getPropertyName();
								
								if ( JOptionPane.VALUE_PROPERTY.equals( prop ) ||
									             JOptionPane.INPUT_VALUE_PROPERTY.equals( prop ) ) {
									Object value = rescaleMapOptionPane.getValue();
									
									if ( value != null && value.toString().equals( "0" ) ) {
										boolean isInputValid = true;
										double newScale = EditorConstants.SCALE;
										try {
											newScale = Double.parseDouble( scaleTextField.getText() );
										} catch ( Exception ex ) {
											isInputValid = false;
											ErrorLog.showError( dialog, "Invalid input.", "Try again" );
											dialog.setVisible( true );
										}
										
										if ( isInputValid ) {
											EditorConstants.SCALE = newScale;
											map.resizeToNewScale();
										}
									}
								}
							}
						} );
						scaleTextField.requestFocusInWindow();
						dialog.pack();
						dialog.setLocationRelativeTo( self );
						dialog.setVisible( true );
					} else if ( source == changeGridTypeToSquareMenuItem ) {
						map.changeGridType( GridType.SQUARE );
//						repaint();
						map.repaint();
					} else if ( source == changeGridTypeToHexMenuItem ) {
						map.changeGridType( GridType.HEX );
//						repaint();
						map.repaint();
					}
				}
			};
    	return editMenuActionListener;
    }
    
    /**
     * Get the listener to event in check box items in setting menu
     * 
     * @return	the listener to event in check box items in setting menu
     */
    private ActionListener getViewCheckBoxMenuItems() {
    	if ( viewCheckBoxMenuItemsActionListener == null )
    		viewCheckBoxMenuItemsActionListener = new ActionListener() {
				@Override
				public void actionPerformed( ActionEvent e ) {
					if ( e.getSource() == showHideGridsMenuItem ) {
						boolean isSelected = ( ( JCheckBoxMenuItem ) e.getSource() ).isSelected();
						map.setGridVisible( isSelected );
						mapScroller.setRulerDisplayTick( ! isSelected );
//						repaint();
//						map.repaint();
					}
					
				}
			};
    	return viewCheckBoxMenuItemsActionListener;
    }
    
    /**
     * Get the listener to event in unit pop up menu
     * 
     * @return	the listener to event in unit pop up menu
     */
    private ActionListener getUnitPopupMenuActionListener() {
    	if ( unitPopupMenuActionListener == null )
    		unitPopupMenuActionListener = new ActionListener() {
				@Override
				public void actionPerformed( ActionEvent e ) {
					if ( e.getSource() == deleteUnitMenuItem ) {
						map.removeUnit( currentMouseGrid.getCoordinate() );
						currentMouseGrid = null;
						//repaint();
					}
				}
			};
		return unitPopupMenuActionListener;
    }
    
    /**
     * Get the listener to mouse event on the terrainsManager
     * Initialize it if it has not been initialized yet
     * 
     * @return  the listener to mouse event on the terrainsManager
     */
    private MouseAdapter getTerrainsManagerMouseEventListener() {
        if ( terrainsManagerMouseEventListener == null )
            terrainsManagerMouseEventListener = new MouseAdapter() {
                @Override
                public void mouseClicked( MouseEvent e ) {
                	switch ( status ) {
                		case SELECT_UNIT: case SELECT_GRID_PLACE_TERRAIN:
                			if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	                			 UnitSlot unitSlot = null;
	                             if ( e.getSource() instanceof UnitSlot ) 
	                            	 unitSlot = ( ( UnitSlot ) e.getSource() );
	                             else if ( ( ( Container ) e.getSource() ).getParent() instanceof UnitSlot )
	                            	 unitSlot =
	                                	 ( ( UnitSlot ) ( ( Container ) e.getSource() ).getParent() );
	                             
	                             if ( unitSlot != null ) {
	                            	 selectedUnit = unitSlot.getUnit();
	                            	 try {
		                            	 for ( Component terrainsManagerChild : terrainsManager.getComponents() )
		                            		 if ( terrainsManagerChild instanceof UnitSlot 
		                            				 && terrainsManagerChild != unitSlot )
		                            			 ( ( UnitSlot ) terrainsManagerChild ).setUnselected();
		                            	 unitSlot.setSelectedPermanent();
	                            	 } catch ( Exception ex ) {
	                            		 //ex.printStackTrace();
	                            		 ExceptionHandler.handleException( ex );
	                            	 }
	                                 status = Status.SELECT_GRID_PLACE_TERRAIN;
//	                                 repaint();
	                             } else
	                            	 // DEBUG
	                                 System.out.println( "TerrainsManagerMouseEventListener: " + e.getSource() );
                			}
                             break;
                             
                		case DRAG_UNIT: break;
                		case PLACING_TERRAIN: break;
                	}
                   
                }
            };
        return terrainsManagerMouseEventListener;
    }
    
    /**
     * Get the listener to mouse event on the UnitsManagers other than
     * the terrainsManager, since terrainsManager has a special type
     * of handling the placing
     * 
     * @return	the listener to mouse event on the UnitsManagers other than
     * the terrainsManager
     */
    private MouseAdapter getNonTerrainsUnitsManagersMouseEventsListener() {
    	if ( nonTerrainsUnitsManagersMouseEventsListener == null )
    		nonTerrainsUnitsManagersMouseEventsListener = new MouseAdapter() {
    			@Override
                public void mouseDragged( MouseEvent e ) {
                	switch ( status ) {
                		case SELECT_UNIT:
                			if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	                			 boolean unitSlotPressed = true;
	                             if ( e.getSource() instanceof UnitSlot ) 
	                                 selectedUnit = ( ( UnitSlot ) e.getSource() ).createNewUnit();
	                             else if ( ( ( Container ) e.getSource() ).getParent() instanceof UnitSlot )
	                                 selectedUnit =
	                                	 ( ( UnitSlot ) ( ( Container ) e.getSource() ).getParent() ).createNewUnit();
	                             else
	                                 unitSlotPressed = false;
	                             
	                             if ( unitSlotPressed ) {
	                                 selectedUnit.setImage();
	                                 
	                                 Point mousePos = getJContentPane().getMousePosition( true );
	                                 dragUnit( transparentPanel, mousePos.x, mousePos.y );
	                                 startDraggingUnit();
	                                 
//	                                 repaint();
	                             } else
	                            	 // DEBUG
	                                 System.out.println( "TerrainsManagerMouseEventListener: " + e.getSource() );
                			}
                             break;
                             
                		case DRAG_UNIT:
                			if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	                			Point mousePos = getJContentPane().getMousePosition( true );
	                			if ( mousePos != null ) {
		                			Component mouseSource = getComponentAtLocation( mousePos );
		                			if ( mouseSource instanceof TransparentGrid ) {
			                			Point mouseSourceCoordinate = 
			                				Library.getRealCoordinate( ( Container ) mouseSource, getJContentPane() );
			                			int mouseXOnSource = mousePos.x - mouseSourceCoordinate.x;
			                			int mouseYOnSource = mousePos.y - mouseSourceCoordinate.y;
			                			dragUnit( mouseSource, mouseXOnSource, mouseYOnSource );
			                			autoScroll( mapScroller, 
			                					mousePos.x - mapScroller.getX(), mousePos.y - mapScroller.getY() );
		                			} else {
		                				dragUnit( transparentPanel, mousePos.x, mousePos.y );
		                				stopAutoScroll( mapScroller );
		                			}
//		                			repaint();
	                			}
                			}
                			break;
                			
                		case SELECT_GRID_PLACE_TERRAIN: break;
                		case PLACING_TERRAIN: break;
                	}
                   
                }
                
                @Override
                public void mouseReleased( MouseEvent e ) {
                	switch ( status ) {
                		case SELECT_UNIT: break;
                		case DRAG_UNIT:
                			if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	                			Point mousePos = getJContentPane().getMousePosition( true );
	                			Component mouseSource = getComponentAtLocation( mousePos );
	                			if ( mouseSource instanceof TransparentGrid ) {
	                				dropUnit( ( ( TransparentGrid ) mouseSource ).getCoordinate() );
	                			} else {
	                				getJContentPane().remove( selectedUnit );
	                				map.removeTemporaryUnit();
	                				selectedUnit = null;
	                			}
                				status = Status.SELECT_UNIT;
	            				stopAutoScroll( mapScroller );
//	                			repaint();
                			}
                			break;
                		case SELECT_GRID_PLACE_TERRAIN: break;
                		case PLACING_TERRAIN: break;
                	}
                }
            };
    	return nonTerrainsUnitsManagersMouseEventsListener;
    }
    
    /**
     * Get the listener to press/click on the units managers buttons to show/hide
     * the units managers accordingly
     * 
     * @return  the listener to press/click on the units managers buttons to show/hide
     * the units managers accordingly
     */
    private MouseAdapter getUnitsManagersButtonsMouseEventListener() {
        if ( unitsManagersButtonsMouseEventListener == null )
            unitsManagersButtonsMouseEventListener = new MouseAdapter() {
                @Override
                public void mousePressed( MouseEvent e ) {
                	if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
                		if ( terrainsManager.isVisible() )
                			 try {
                            	 for ( Component terrainsManagerChild : terrainsManager.getComponents() )
                            		 if ( terrainsManagerChild instanceof UnitSlot )
                            			 ( ( UnitSlot ) terrainsManagerChild ).setUnselected();
                        	 } catch ( Exception ex ) {
//                        		 ex.printStackTrace();
                        		 ExceptionHandler.handleException(ex);
                        	 }
                        	 
	                    int buttonIndex = unitsManagersButtons.indexOf( e.getSource() );
	                    
	                    for ( int i = 0; i < unitsManagers.size(); i++ )
	                        if ( i != buttonIndex )
	                            unitsManagers.get( i ).setVisible( false );
	                        else
	                            unitsManagers.get( i ).setVisible( true );
	                    
	                    try {
		                    for ( int i = 0; i < unitsManagersButtons.size(); i++ ) {
		                    	EmbededButton unitsManagerButton = unitsManagersButtons.get( i );
		                    	if ( i != buttonIndex )
		                    		unitsManagerButton.setUnselected();
		                    	else
		                    		unitsManagerButton.setSelectedPermanent();
		                    }
	                    } catch ( Exception ex ) {
//	                    	ex.printStackTrace();
	                    	ExceptionHandler.handleException(ex);
	                    }
	                    		
	
	                    selectedUnit = null;
	                    status = Status.SELECT_UNIT;
//	                    repaint();
                	}
                }
            };
        return unitsManagersButtonsMouseEventListener;
    }
    
    /**
     * Get the listener to press/click on the transparent map
     * when there is no unit which is currently deploying/putting on the map
     * 
     * @return  the listener to press/click on the transparent map
     * when there is no unit which is currently deploying/putting on the map
     */
    private MouseAdapter getMapMouseEventListener() {
        if ( mapMouseEventListener == null )
            mapMouseEventListener = new MouseAdapter() {
            	
	        	@Override
	        	public void mouseClicked( MouseEvent e ) {
	        		switch ( status ) {
	        			case SELECT_UNIT:
	        				switch ( e.getModifiers() ) {
	        					// right click
	        					case InputEvent.BUTTON3_MASK:
	        						if ( e.getSource() instanceof TransparentGrid ) {
		        						currentMouseGrid = ( TransparentGrid ) e.getSource();
		        						if ( map.getUnit( currentMouseGrid.getCoordinate() ) != null )
		        							unitPopupMenu.show( ( Component ) e.getSource(), e.getX(), e.getY() );
		        						else
		        							currentMouseGrid = null;
	        						} else if (e.getSource() instanceof TransparentMapGrids) {
		                				Point moustPos = e.getPoint();
		                				currentMouseGrid =
		                					((TransparentMapGrids) e.getSource()).getTransparentGridAt(moustPos);
		                				if ( map.getUnit( currentMouseGrid.getCoordinate() ) != null )
		        							unitPopupMenu.show( ( Component ) e.getSource(), e.getX(), e.getY() );
		        						else
		        							currentMouseGrid = null;
	        						} else 
	        							// DEBUG:
	        							System.out.println( "Map mouse click: " + e.getSource() );
	        						break;
	        				}
	        				break;
	        			case DRAG_UNIT: break;
	        			case SELECT_GRID_PLACE_TERRAIN:
	        				switch ( e.getModifiers() ) {
	        					// right click
	        					case InputEvent.BUTTON3_MASK:
	        						if ( e.getSource() instanceof TransparentGrid ) {
		        						currentMouseGrid = ( TransparentGrid ) e.getSource();
		        						if ( map.getUnit( currentMouseGrid.getCoordinate() ) != null )
		        							unitPopupMenu.show( ( Component ) e.getSource(), e.getX(), e.getY() );
		        						else
		        							currentMouseGrid = null;
	        						} else 
	        							// DEBUG:
	        							System.out.println( "Map mouse click: " + e.getSource() );
	        						break;
	        				}
	        				break;
	        			case PLACING_TERRAIN: break;
	        		}
	        	}
	        	
            	@Override
            	public void mousePressed( MouseEvent e ) {
            		switch ( status ) {
            			case SELECT_UNIT: break;
            			case DRAG_UNIT: break;
            			case SELECT_GRID_PLACE_TERRAIN:
            				if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
        						if ( e.getSource() instanceof TransparentGrid ) {
		            				TransparentGrid grid = ( TransparentGrid ) e.getSource();
		            				placeSelectedTerrain( grid.getCoordinate() );
		            				status = Status.PLACING_TERRAIN;
//		            				repaint();
        						} else if (e.getSource() instanceof TransparentMapGrids) {
	                				Point moustPos = e.getPoint();
	                				TransparentGrid grid  =
	                					((TransparentMapGrids) e.getSource()).getTransparentGridAt(moustPos);
	                				placeSelectedTerrain( grid.getCoordinate() );
		            				status = Status.PLACING_TERRAIN;
//		            				repaint();
        						} else
        							// DEBUG:
        							System.out.println( "Map mouse click: " + e.getSource() );
		            				
            				}
            				break;
            			case PLACING_TERRAIN: break;
            		}
            	}
            	
            	@Override
            	public void mouseDragged( MouseEvent e ) {
            		Point mousePos;
            		Component mouseSource;
            		
            		switch ( status ) {
            			case SELECT_UNIT:
            				if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	            				if ( e.getSource() instanceof TransparentGrid ) {
	                				Point gridCoordinate = ( ( TransparentGrid ) e.getSource()  ).getCoordinate();
	                				Unit unitAtGrid = map.getUnit( gridCoordinate );
	                				if ( unitAtGrid != null ) {
	                					// duplicate
	                					if ( keyboardEventsManager.pressed( KeyboardEventsManager.CTRL ) ) {
	                    					selectedUnit = UnitFactory.clone( unitAtGrid );                    					
	                    				// move
	                					} else {
	                						selectedUnit = unitAtGrid;
	                						map.removeUnit( gridCoordinate );
	                						map.displayTemporaryUnit( selectedUnit, gridCoordinate );
	                					}
	            						startDraggingUnit();
	                				}
//	                				repaint();
	                			} else if (e.getSource() instanceof TransparentMapGrids) {
	                				Point moustPos = e.getPoint();
	                				Point gridCoordinate =
	                					((TransparentMapGrids) e.getSource()).getTransparentGridAt(moustPos).getCoordinate();
	                				Unit unitAtGrid = map.getUnit( gridCoordinate );
	                				if ( unitAtGrid != null ) {
	                					// duplicate
	                					if ( keyboardEventsManager.pressed( KeyboardEventsManager.CTRL ) ) {
	                    					selectedUnit = UnitFactory.clone( unitAtGrid );                    					
	                    				// move
	                					} else {
	                						selectedUnit = unitAtGrid;
	                						map.removeUnit( gridCoordinate );
	                						map.displayTemporaryUnit( selectedUnit, gridCoordinate );
	                					}
	            						startDraggingUnit();
	                				}
//	                				repaint();
	                				
	                			} else
	                				// DEBUG:
	                				System.out.println( "not transparent grid: " + e.getSource() );
            				}
            				break;
            				
            			case DRAG_UNIT:
            				if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	            				mousePos = getJContentPane().getMousePosition( true );
	                			mouseSource = mousePos == null ? null 
	                					: getComponentAtLocation( mousePos );
	                			if ( mouseSource instanceof TransparentGrid ) {
		                			Point mouseSourceCoordinate = 
		                				Library.getRealCoordinate( ( Container )mouseSource, getJContentPane() );
		                			int mouseXOnSource = mousePos.x - mouseSourceCoordinate.x;
		                			int mouseYOnSource = mousePos.y - mouseSourceCoordinate.y;
		                			dragUnit(
		                					mouseSource, mouseXOnSource, mouseYOnSource );
		                			autoScroll( mapScroller,
		                					mousePos.x - mapScroller.getX(), mousePos.y - mapScroller.getY() );
	                			} else if ( mousePos != null )
	                				dragUnit( transparentPanel, mousePos.x, mousePos.y );
	                			else
	                				;
//	                			repaint();
            				}
                			break;
            				
            			case SELECT_GRID_PLACE_TERRAIN: break;
            			
            			case PLACING_TERRAIN:
            				if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	            				mousePos = getJContentPane().getMousePosition( true );
	            				mouseSource = getComponentAtLocation( mousePos );
	            				if ( mouseSource instanceof TransparentGrid ) {
	            					TransparentGrid grid = ( TransparentGrid ) mouseSource;
	            					currentMouseGrid = grid;
	            					if (currentMouseGrid != prevMouseGrid) {
		            					placeSelectedTerrain( grid.getCoordinate() );
			                			autoScroll( mapScroller, 
			                					mousePos.x - mapScroller.getX(), mousePos.y - mapScroller.getY() );
	            					}
	            					prevMouseGrid = currentMouseGrid;
	            				}
//	            				repaint();
            				}
            				break;
            		}
            	}
            	
            	@Override
                public void mouseReleased( MouseEvent e ) {
                	switch ( status ) {
                		case SELECT_UNIT: break;
                		case DRAG_UNIT:
                			if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	                			Point mousePos = getJContentPane().getMousePosition( true );
	                			Component mouseSource = mousePos == null ? null 
	                					: getComponentAtLocation( mousePos );
	                			if ( mouseSource instanceof TransparentGrid ) {
	                				dropUnit( ( ( TransparentGrid ) mouseSource ).getCoordinate() );
	                			} else {
	                				getTransparentPanel().remove( selectedUnit );
	                				map.removeTemporaryUnit();
	                				selectedUnit = null;
	                			}
	                			status = Status.SELECT_UNIT;
//	                			repaint();
                			}
                			break;
                		case SELECT_GRID_PLACE_TERRAIN: break;
                		case PLACING_TERRAIN:
                			if ( e.getModifiers() == InputEvent.BUTTON1_MASK ) {
	                			stopAutoScroll( mapScroller );
	                			status = Status.SELECT_GRID_PLACE_TERRAIN;
	                			currentMouseGrid = prevMouseGrid = null;
                			}
                			break;
                	}
                }
            	
            	@Override
            	public void mouseEntered( MouseEvent e ) {
            		Point mousePos = getJContentPane().getMousePosition( true );
        			autoScroll( mapScroller, 
        					mousePos.x - mapScroller.getX(), mousePos.y - mapScroller.getY() );
//        			repaint();
            	}
            	
            	@Override
            	public void mouseExited( MouseEvent e ) {
            		stopAutoScroll( mapScroller );
            	}
            };
        return mapMouseEventListener;
    }
    
    /**
     * Get the event listener to auto-scroll in map scroller
     * to update accordingingly
     * 
     * @return	the event listener to auto-scroll in map scroller
     * to update accordingingly
     */
    private ScrollEventAdapter getMapScrollerScrollEventListener() {
    	if ( mapScrollerScrollEventListener == null )
    		mapScrollerScrollEventListener = new ScrollEventAdapter() {
    			@Override
    			public void autoScrolled( ScrollEvent e ) {
    				Point mousePos;
    				Component mouseSource;
    				switch ( status ) {
    					case SELECT_UNIT: break;
    					case DRAG_UNIT:
    						mousePos = getJContentPane().getMousePosition( true );
    						if ( mousePos != null ) {
	                			mouseSource = getComponentAtLocation( mousePos );
	                			if ( mouseSource != null ) {
		                			Point mouseSourceCoordinate = 
		                				Library.getRealCoordinate( ( Container ) mouseSource, getJContentPane() );
		                			if ( mouseSourceCoordinate != null ) {
			                			int mouseXOnSource = mousePos.x - mouseSourceCoordinate.x;
			                			int mouseYOnSource = mousePos.y - mouseSourceCoordinate.y;
			                			dragUnit( mouseSource, mouseXOnSource, mouseYOnSource );
		                			}
//		                			repaint();
	                			}
    						}
    						break;
    					case SELECT_GRID_PLACE_TERRAIN: break;
    					case PLACING_TERRAIN:
    						mousePos = getJContentPane().getMousePosition( true );
            				mouseSource = getComponentAtLocation( mousePos );
            				if ( mouseSource instanceof TransparentGrid ) {
            					TransparentGrid grid = ( TransparentGrid ) mouseSource;
            					placeSelectedTerrain( grid.getCoordinate() );
            				}
//            				repaint();
    						break;
    				}
    			}
    		};
    	return mapScrollerScrollEventListener;
    }
    
    
    //=================
    // EVENTS HANDLERS
    //=================
    
    /**
     * Open an external map file
     */
    private void openFile() {
		int openVal = fileChooser.showOpenDialog( getJContentPane() );
		
		if ( openVal == JFileChooser.APPROVE_OPTION ) {
			try {
				status = Status.LOAD_EXTERNAL_MAP;
				File openFile = fileChooser.getSelectedFile();
				String name = openFile.getName();
				int mapID = Integer.parseInt(name.replaceAll("[a-zA-Z]*(\\d+).*", "$1"));
				String openFilePrefix = EditorConstants.SAVE_FILE_PREFIX + (mapID < 10 ? "0" : "") + mapID;
				String[] openFilesNames = 
				{
					openFilePrefix + EditorConstants.TILES_SAVE_FILE_SUFFIX,
					openFilePrefix + EditorConstants.CHARACTERS_SAVE_FILE_SUFFIX,
					openFilePrefix + EditorConstants.ITEMS_SAVE_FILE_SUFFIX
				};
				String openDirectory = openFile.getParent() + "/";
				String[] openFilesContents = new String[3];
				for (int i = 0; i < openFilesNames.length; i++) {
					File singleOpenFile = new File(openDirectory + openFilesNames[i]);
					FileReader fReader = new FileReader( singleOpenFile );
					BufferedReader reader = new BufferedReader( fReader );
					
					String content = "";
					String line = reader.readLine();
					while ( line != null ) {
						content += line;
						line = reader.readLine();
						if ( line != null )
							content += "\n";
					}
					openFilesContents[i] = content;
				}
				map.loadMap(openFilesContents[0], openFilesContents[1], openFilesContents[2]);
//				repaint();
				status = Status.SELECT_UNIT;
				
			} catch ( Exception e ) {
//				e.printStackTrace();
				ExceptionHandler.handleException(e);
			}
		}
    }
    
    /**
     * Save the current map using save as function
     */
    private void saveAsFile() {
		int saveVal = fileChooser.showSaveDialog( getJContentPane() );
		if ( saveVal == JFileChooser.APPROVE_OPTION ) {
			saveFile();
		}
    }
    
    /**
     * Save the current map, using save
     * Only call when save as is called before
     */
    private void saveFile() {
		try {
			File saveFile = fileChooser.getSelectedFile();
			String name = saveFile.getName();
			int mapID = Integer.parseInt(name.replaceAll("[a-zA-Z]*(\\d+).*", "$1"));
			String saveFilePrefix = EditorConstants.SAVE_FILE_PREFIX + (mapID < 10 ? "0" : "") + mapID;
			String[] saveFilesNames = 
			{
				saveFilePrefix + EditorConstants.TILES_SAVE_FILE_SUFFIX,
				saveFilePrefix + EditorConstants.CHARACTERS_SAVE_FILE_SUFFIX,
				saveFilePrefix + EditorConstants.ITEMS_SAVE_FILE_SUFFIX
			};
			String[] saveFilesContents =
			{ map.getTileCode(), map.getCharacterCode(), map.getItemCode() };
			String saveDirectory = saveFile.getParent() + "/";
			for (int i = 0; i < saveFilesNames.length; i++) {
				File singleSaveFile = new File(saveDirectory + saveFilesNames[i]);
				FileWriter fWriter = new FileWriter( singleSaveFile );
				BufferedWriter writer = new BufferedWriter( fWriter );
				
				String singleSaveContent = saveFilesContents[i];
				String[] lines = singleSaveContent.split( "\n" );
				for ( int j = 0; j < lines.length; j++ ) {
					writer.write( lines[ j ] );
					if ( j < lines.length - 1 )
						writer.newLine();
				}
				writer.close();
			}
			JOptionPane.showMessageDialog( JOptionPane.getFrameForComponent( this ),
					MessagesConstants.SAVE_SUCCESSFULLY_MESSAGE,
					MessagesConstants.SAVE_SUCCESSFULLY_TITLE, JOptionPane.INFORMATION_MESSAGE );
		} catch ( Exception ex ) {
			//ex.printStackTrace();
			ExceptionHandler.handleException( ex );
		}
    }
    
    /**
     * Save the current map as image file
     */
    private void saveAsImageFile() {
    	try {
			FileFilter imageFilter = new MapImageFileFilter();
    		fileChooser.addChoosableFileFilter( imageFilter );
    		fileChooser.setAcceptAllFileFilterUsed( false );
    		
    		int saveVal = fileChooser.showSaveDialog( getJContentPane() );
    		if ( saveVal == JFileChooser.APPROVE_OPTION ) {
    			File saveFile = fileChooser.getSelectedFile();
    			String saveFileExt = Library.getExtension( saveFile );
		        if ( saveFileExt == null || ! saveFileExt.equalsIgnoreCase( "EditorConstants.MAP_IMAGE_FILE_TYPE" ) ) {
		        	String saveFilePath = 
		        		saveFile.getPath() + "." + EditorConstants.MAP_IMAGE_FILE_TYPE.toLowerCase();
		        	fileChooser.setSelectedFile( new File( saveFilePath ) );
		        	saveFile = fileChooser.getSelectedFile();
		        }
        		ImageIO.write( 
        				Library.getBufferedImage( map.getMap() ),
        				EditorConstants.MAP_IMAGE_FILE_TYPE, saveFile );
    		}
    		
    		fileChooser.resetChoosableFileFilters();
    		fileChooser.setAcceptAllFileFilterUsed( true );
    		fileChooser.setSelectedFile( null );
    		
    	} catch ( Exception e ) {
    		//e.printStackTrace();
    		ExceptionHandler.handleException( e );
    	}
    }
    
    /**
     * Start dragging the selected unit to place it on the map
     */
    private void startDraggingUnit() {
        transparentPanel.setVisible( true );
        getJContentPane().add( transparentPanel, 0 );        
        getJContentPane().add( mapScroller, 0 );     
        
        status = Status.DRAG_UNIT;
    }
    
    /**
     * Stop moving the selected unit to place on the map
     * (The unit has already been placed, or the action has been canceled)
     */
    private void stopDraggingUnit() {
        transparentPanel.setVisible( false );
        currentMouseGrid = prevMouseGrid = null;
        status = Status.SELECT_UNIT;
    }
    
    /**
     * Place the selected unit at the selected grid
     * 
     * @param   gridCoordinate
     * 			is the coordinate of the grid to put the selected unit on
     */
    private void dropUnit( Point gridCoordinate ) {
        map.removeTemporaryUnit();
        map.addUnit( selectedUnit, gridCoordinate );
        selectedUnit = null;
        currentMouseGrid = prevMouseGrid = null;
        stopDraggingUnit();
    }
    
    /**
     * Place the selected terrain at the selected grid
     * 
     * @param	gridCoordinate
     * 			is the coordinate of the grid to put the selected terrain on
     */
    private void placeSelectedTerrain( Point gridCoordinate ) {
    	Unit terrain = UnitFactory.clone( selectedUnit );
    	terrain.setImage();
    	map.addUnit( terrain, gridCoordinate );
    }
    
    /**
     * Set the position of the selected ship so that it is attached to the mouse
     * 
     * @param   mouseSource
     *          is the JPanel which sucks up the mouse move event
     * 
     * @param   mouseXOnSource
     *          is the x position of the mouse on the source
     *          
     * @param   mouseYOnSource
     *          is the y position of the mouse on the source         
     */
    private void dragUnit( Component mouseSource, int mouseXOnSource, int mouseYOnSource ) {
        if ( mouseSource == transparentPanel ) {
            map.removeTemporaryUnit();
            getJContentPane().add( selectedUnit, 0 );
            selectedUnit.setLocation(
                    mouseXOnSource - selectedUnit.getOffset().x
                    - selectedUnit.getOffsetSize().width / 2,
                    mouseYOnSource - selectedUnit.getOffset().y
                    - selectedUnit.getOffsetSize().height / 2 );
        
        } else if ( mouseSource instanceof TransparentGrid ) {
        	currentMouseGrid = ( TransparentGrid ) mouseSource;
        	if (currentMouseGrid != prevMouseGrid)
        		map.displayTemporaryUnit( selectedUnit, ( ( TransparentGrid ) mouseSource  ).getCoordinate() );
        	prevMouseGrid = currentMouseGrid;
        } else
            // DEBUG:
            System.out.println( "setSelectedUnitPosition: " + mouseSource );
    }
    
    
    
    //===============
    // MISCELLANEOUS
    //===============
    
    /**
     * Get the component at a specific location on the screen
     * not-recommended
     * 
     * @param	location
     * 			is the location to get the component at that point
     * 
     * @return	the component at the specific location
     */
    @Deprecated
    private Component getComponentAtLocation( Point location ) {
    	int x = location.x;
    	int y = location.y;
    	
    	Component component = null;
    	for ( Component child : getJContentPane().getComponents() )
    		if ( child.getX() <= x && x <= child.getX() + child.getWidth() 
    				&& child.getY() <= y && y <= child.getY() + child.getHeight()
    				&& child.isVisible() && child != transparentPanel )
    			component = child;
    	
    	if ( component instanceof CustomScrollPane )
    		component = ( ( CustomScrollPane ) component ).getComponentAtLocation( location );
    	
    	return component;
    }
    
    /**
     * Auto-scroll the CustomScrollPane
     * 
     * @param	scrollPane
     * 			is the CustomScrollPane to perform the autoscroll
     * 
     * @param	mouseX
     * 			is the x mouse position on the scrollPane
     * 
     * @param	mousY
     * 			is the y mouse position on the scrollPane
     */
    private void autoScroll( CustomScrollPane scrollPane, int mouseX, int mouseY ) {
//    	stopAutoScroll( scrollPane );
//		scrollPane.autoScroll( mouseX, mouseY );
//    	if ( scrollPane == mapScroller ) {
//    		scrollPane.addScrollEventListener( getMapScrollerScrollEventListener() );
//    	}
    }
    
    /**
     * Stop auto-scroll in the CustomScrollPane
     * 
     * @param	scrollPane
     * 			is the CustomScrollPane to stop the autoscroll
     */
    private void stopAutoScroll( CustomScrollPane scrollPane ) {
//    	scrollPane.stopAutoScroll();
//    	if ( scrollPane == mapScroller ) {
//    		scrollPane.removeScrollEventListener( getMapScrollerScrollEventListener() );
//    	}
    }
    
    /**
     * Resize the map
     * 
     * @param	mapSize
     * 			is the new map size
     */
    private void resizeMap( Point mapSize ) {
    	map.resizeMapGrid( mapSize.x, mapSize.y );
//    	map.revalidate();
//    	Dimension gridSize = EditorConstants.GRID_SIZE;
//        mapScroller.showHorizontalRuler( gridSize.width, gridSize.height );
//        mapScroller.showVerticalRuler( gridSize.width, gridSize.height );
//    	mapThumbnail.initializeMap();
//    	mapThumbnail.initializeScroller();
//    	repaint();
    }
    
    @Override
    public void repaint() {
    	// TODO Auto-generated method stub
    	super.repaint();
    	System.out.println("repaint");
    }
    
}
