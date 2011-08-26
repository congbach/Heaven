package editor;

import java.awt.Component;
import java.awt.Container;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseWheelListener;
import java.util.EventListener;

/**
 * EventsListenersAdderRemover class
 * 
 * @author Ken
 * 
 * This class has only one function, which is to
 * add an event listener to a JPanel/JLabel completely
 * i.e. add the event listener to all children/grandchildren,...
 * Also, this class handles remove event listener.
 *
 */
public class EventsListenersAdderRemover {
    
    /**
     * Add an event listener to a component
     * and all of its children as well
     * 
     * @param   component
     *          is the component to add to the event listener
     *        
     * @param   mouseListener
     *          is the event listener to add to the 
     *          component
     */
    static void addEventListener( Component component, EventListener mouseListener ) {
        if ( mouseListener instanceof MouseAdapter ) {
            component.addMouseListener( ( MouseAdapter ) mouseListener );
            component.addMouseMotionListener( ( MouseAdapter ) mouseListener );
        } else if ( mouseListener instanceof MouseWheelListener )
            component.addMouseWheelListener( ( MouseWheelListener ) mouseListener );
        
        if ( component instanceof Container ) {
            // add mouse event too all its children as well
            Component[] children = ( ( Container ) component ).getComponents();
            for ( Component child : children )
                addEventListener( child, mouseListener );
        }
    }
    
    /**
     * Remove an event listener from a component
     * and all of its children as well
     * 
     * @param   component
     *          is the component to remove from the event listener
     *        
     * @param   mouseListener
     *          is the event listener to remove from the 
     *          component
     */
    static void removeEventListener( Component component, EventListener mouseListener ) {
        if ( mouseListener instanceof MouseAdapter ) {
            component.removeMouseListener( ( MouseAdapter ) mouseListener );
            component.removeMouseMotionListener( ( MouseAdapter ) mouseListener );
        } else if ( mouseListener instanceof MouseWheelListener )
            component.removeMouseWheelListener( ( MouseWheelListener ) mouseListener );
        
        if ( component instanceof Container ) {
            // remove mouse event too all its children as well
            Component[] children = ( ( Container ) component ).getComponents();
            for ( Component child : children )
                removeEventListener( child, mouseListener );
        }
    }
}
