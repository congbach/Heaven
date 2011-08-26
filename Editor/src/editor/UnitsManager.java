package editor;

import java.awt.Dimension;
import java.util.ArrayList;

import javax.swing.JPanel;

import constants.EditorConstants;

/**
 * UnitsManager class
 * 
 * @author Ken
 * 
 * This class represents the JPanel which contains all the available characters/terrains/items
 * to add to the game
 *
 */
public class UnitsManager/*< AnyUnitType extends Unit >*/ extends JPanel {
    
    private static final long serialVersionUID = 1L;

    /**
     * Default constructor
     */
    UnitsManager() {
        setLayout( null );
        setSize( EditorConstants.UNITS_MANAGERS_SIZE );
        setLocation( EditorConstants.UNITS_MANAGERS_DEFAULT_LOCATION );
        setOpaque( false );
        displayUnits();
    }
    
    /**
     * This function initialize this units manager
     * i.e. it will retrieve and display all the available units
     * which can be added to the map
     */
    protected void displayUnits() {
        // to be overriden by sub classes
    }
    
    /**
     * Displays all units given
     * 
     * @param   units
     *          all the units to display on the screen
     */
    protected void displayUnits( ArrayList< /*AnyUnitType*/Unit > units ) {
        int xPos = 0, yPos = 0;
        Dimension unitSize = EditorConstants.UNIT_SLOT_SIZE;
        for ( Unit unit : units ) {
        	if ( unit.getCode() != EditorConstants.BLANK_UNIT_CODE ) {
	            UnitSlot unitSlot = new UnitSlot( unit );
	            add( unitSlot );
	            if ( xPos + unitSize.width > this.getWidth() ) {
	                xPos = 0;
	                yPos += unitSize.height;
	            }
	            unitSlot.setLocation( xPos, yPos );
	            xPos += unitSize.width;
        	}
        }
    }
}
