package editor;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.swing.JPanel;

/**
 * KeyboardEventsManager class
 * 
 * @author Ken
 * 
 * Handle all keyboard events.
 * Singleton pattern.
 * This one is just a simple class which does not go in specific details
 * like per frame keyboard events detection.
 *
 */
public class KeyboardEventsManager implements KeyListener {
    
    /**
     * The only instance that exists, by singleton pattern.
     * Create at runtime to avoid the case in which multi-threads call the method to create
     * the only instance at the same time, so that actually there are more than one instance
     * which are created. There are some other ways which are more effective, but this way
     * is the easiest.
     */
    static private final KeyboardEventsManager instance = new KeyboardEventsManager();
    
    /**
     * Get the only instance of this class
     */
    static public KeyboardEventsManager getInstance() {
        return instance;
    }
    
    /**
     * All the (common) keys
     */
    static public final String A = "A";
    static public final String B = "B";
    static public final String C = "C";
    static public final String D = "D";
    static public final String E = "E";
    static public final String F = "F";
    static public final String G = "G";
    static public final String H = "H";
    static public final String I = "I";
    static public final String J = "J";
    static public final String K = "K";
    static public final String L = "L";
    static public final String M = "M";
    static public final String N = "N";
    static public final String O = "O";
    static public final String P = "P";
    static public final String Q = "Q";
    static public final String R = "R";
    static public final String S = "S";
    static public final String T = "T";
    static public final String U = "U";
    static public final String V = "V";
    static public final String W = "W";
    static public final String X = "X";
    static public final String Y = "Y";
    static public final String Z = "Z";

    static public final String ONE = "1";
    static public final String TWO = "2";
    static public final String THREE = "3";
    static public final String FOUR = "4";
    static public final String FIVE = "5";
    static public final String SIX = "6";
    static public final String SEVEN = "7";
    static public final String EIGHT = "8";
    static public final String NINE = "9";
    static public final String ZERO = "0";
    
    static public final String F1 = "F1";
    static public final String F2 = "F2";
    static public final String F3 = "F3";
    static public final String F4 = "F4";
    static public final String F5 = "F5";
    static public final String F6 = "F6";
    static public final String F7 = "F7";
    static public final String F8 = "F8";
    static public final String F9 = "F9";
    static public final String F10 = "F10";
    static public final String F11 = "F11";
    static public final String F12 = "F12";

    static public final String SHIFT = "Shift";
    static public final String CTRL = "Ctrl";
    static public final String ENTER = "Enter";
    static public final String ESCAPE = "Escape";
    static public final String BACKSPACE = "Bachspace";
    static public final String TAB = "Tab";
    static public final String SPACE = "Space";
    
    static public final String CAPS_LOCK = "Caps lock";
    static public final String ALT = "Alt";

    static public final String PAGE_UP = "Page up";
    static public final String PAGE_DOWN = "Page down";
    static public final String HOME = "Home";
    static public final String END = "End";
    static public final String INSERT = "Insert";
    static public final String DELETE = "Delete";
    static public final String EQUALS = "Equals";
    static public final String MINUS = "Minus";
    
    static public final String UP = "Up";
    static public final String LEFT = "Left";
    static public final String RIGHT = "Right";
    static public final String DOWN = "Down";
    
    
    static private final int PRESSED = 1;
    static private final int JUST_PRESSED = 2;
    static private final int NOT_PRESSED = 0;
    
    
    /**
     * Hash table which maps the key with integer value
     * to indicate whether the key is currently pressed,
     * or just pressed, or not press at all
     */
    private Hashtable< String, Integer > keysDowns;
    
    /**
     * Default constructor
     */
    private KeyboardEventsManager() {
        initializeHashTable();
    }
    
    /**
     * Initialize the hash table
     * Called at construct time
     */
    private void initializeHashTable() {
        keysDowns = new Hashtable< String, Integer >();
        
        keysDowns.put( A, NOT_PRESSED );
        keysDowns.put( B, NOT_PRESSED );
        keysDowns.put( C, NOT_PRESSED );
        keysDowns.put( D, NOT_PRESSED );
        keysDowns.put( E, NOT_PRESSED );
        keysDowns.put( F, NOT_PRESSED );
        keysDowns.put( G, NOT_PRESSED );
        keysDowns.put( H, NOT_PRESSED );
        keysDowns.put( I, NOT_PRESSED );
        keysDowns.put( J, NOT_PRESSED );
        keysDowns.put( K, NOT_PRESSED );
        keysDowns.put( L, NOT_PRESSED );
        keysDowns.put( M, NOT_PRESSED );
        keysDowns.put( N, NOT_PRESSED );
        keysDowns.put( O, NOT_PRESSED );
        keysDowns.put( P, NOT_PRESSED );
        keysDowns.put( Q, NOT_PRESSED );
        keysDowns.put( R, NOT_PRESSED );
        keysDowns.put( S, NOT_PRESSED );
        keysDowns.put( T, NOT_PRESSED );
        keysDowns.put( U, NOT_PRESSED );
        keysDowns.put( V, NOT_PRESSED );
        keysDowns.put( W, NOT_PRESSED );
        keysDowns.put( X, NOT_PRESSED );
        keysDowns.put( Y, NOT_PRESSED );
        keysDowns.put( Z, NOT_PRESSED );
        
        keysDowns.put( ONE, NOT_PRESSED );
        keysDowns.put( TWO, NOT_PRESSED );
        keysDowns.put( THREE, NOT_PRESSED );
        keysDowns.put( FOUR, NOT_PRESSED );
        keysDowns.put( FIVE, NOT_PRESSED );
        keysDowns.put( SIX, NOT_PRESSED );
        keysDowns.put( SEVEN, NOT_PRESSED );
        keysDowns.put( EIGHT, NOT_PRESSED );
        keysDowns.put( NINE, NOT_PRESSED );
        keysDowns.put( ZERO, NOT_PRESSED );
        
        keysDowns.put( F1, NOT_PRESSED );
        keysDowns.put( F2, NOT_PRESSED );
        keysDowns.put( F3, NOT_PRESSED );
        keysDowns.put( F4, NOT_PRESSED );
        keysDowns.put( F5, NOT_PRESSED );
        keysDowns.put( F6, NOT_PRESSED );
        keysDowns.put( F7, NOT_PRESSED );
        keysDowns.put( F8, NOT_PRESSED );
        keysDowns.put( F, NOT_PRESSED );
        keysDowns.put( F9, NOT_PRESSED );
        keysDowns.put( F10, NOT_PRESSED );
        keysDowns.put( F11, NOT_PRESSED );
        keysDowns.put( F12, NOT_PRESSED );
        
        keysDowns.put( SHIFT, NOT_PRESSED );
        keysDowns.put( CTRL, NOT_PRESSED );
        keysDowns.put( ENTER, NOT_PRESSED );
        keysDowns.put( ESCAPE, NOT_PRESSED );
        keysDowns.put( BACKSPACE, NOT_PRESSED );
        keysDowns.put( TAB, NOT_PRESSED );
        keysDowns.put( SPACE, NOT_PRESSED );

        keysDowns.put( CAPS_LOCK, NOT_PRESSED );
        keysDowns.put( ALT, NOT_PRESSED );
        
        keysDowns.put( PAGE_UP, NOT_PRESSED );
        keysDowns.put( PAGE_DOWN, NOT_PRESSED );
        keysDowns.put( HOME, NOT_PRESSED );
        keysDowns.put( END, NOT_PRESSED );
        keysDowns.put( INSERT, NOT_PRESSED );
        keysDowns.put( DELETE, NOT_PRESSED );
        keysDowns.put( EQUALS, NOT_PRESSED );
        keysDowns.put( MINUS, NOT_PRESSED );
        
        keysDowns.put( UP, NOT_PRESSED );
        keysDowns.put( DOWN, NOT_PRESSED );
        keysDowns.put( LEFT, NOT_PRESSED );
        keysDowns.put( RIGHT, NOT_PRESSED );
    }
    
    /**
     * See whether a key is currently pressed
     * 
     * @param   key
     *          is the key to check whether it is currently pressed or not
     *          
     * @return  whether the key given is currenly pressed or not
     */
    public boolean pressed( String key ) {
        return keysDowns.get( key ) != NOT_PRESSED;
    }
    
    /**
     * See whether a key is just pressed
     * 
     * @param   key
     *          is the key to check whether it is just pressed or not
     *          
     * @return  whetehr the key given is just pressed
     */
    public boolean justPressed( String key ) {
        return keysDowns.get( key ) == JUST_PRESSED;
    }

    @Override
    public void keyPressed( KeyEvent e ) {
    	try {
	        String key = KeyEvent.getKeyText( e.getKeyCode() );
	        int prv = keysDowns.get( key );
	        	
	        int newVal = prv == NOT_PRESSED ? JUST_PRESSED : PRESSED;
	        keysDowns.put( key , newVal );
	        
	        ( ( JPanel ) e.getSource() ).requestFocusInWindow();
	        
    	} catch ( Exception ex ) {
//    		System.out.println( "Undefined key: " + e.getKeyCode() + ", " + KeyEvent.getKeyText( e.getKeyCode() ) );
    		ExceptionHandler.handleException( "Undefined key: " + e.getKeyCode() + ", " + KeyEvent.getKeyText( e.getKeyCode() ) );
    	}
    }

    @Override
    public void keyReleased( KeyEvent e ) {
	    String key = KeyEvent.getKeyText( e.getKeyCode() );
	    keysDowns.put( key, NOT_PRESSED );

        ( ( JPanel ) e.getSource() ).requestFocusInWindow();
    }

    @Override
    public void keyTyped( KeyEvent e ) {
        // do nothing
    }
    
    /**
     * Reset all keys to not-pressed
     */
    void reset() {
    	Enumeration< String > keys = keysDowns.keys();
    	while ( keys.hasMoreElements() )
    		keysDowns.put( keys.nextElement(), NOT_PRESSED );
    }
    
    
    
    

}
