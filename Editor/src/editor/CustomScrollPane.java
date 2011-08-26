package editor;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.EventListener;
import java.util.EventObject;

import javax.swing.JComponent;
import javax.swing.JScrollPane;
import javax.swing.JViewport;
import javax.swing.Timer;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.EventListenerList;

import constants.EditorConstants;

/**
 * CustomScrollPane class
 * 
 * @author Ken
 * 
 * Subclass of JScrollPane
 * Automatically scroll when mouse is at the edge position
 */

public class CustomScrollPane extends JScrollPane implements Thumbnailable, ResizeObserver {

	static private final long serialVersionUID = 1L;
	
	
	//==========================
	// IMPLEMENTS CUSTOM EVENTS
	//==========================
	
	/**
	 * ScrollEvent
	 */
	static class ScrollEvent extends EventObject {
		private static final long serialVersionUID = 1L;
		
		/**
		 * Default constructor
		 * 
		 * @param	source
		 * 			is where the event occurs
		 */
		public ScrollEvent( Object source ) {
			super( source );
		}
	}
	
	/**
	 * ScrollEventListener interface
	 */
	static interface ScrollEventListener extends EventListener {
		/**
		 * Indicate that this custom scroll just perform an auto scroll
		 * so that the external parent can update accordingly
		 */
		public void autoScrolled( ScrollEvent evt );
	}
	
	/**
	 * ScrollEventAdapter class
	 * Provide all methods which are all actually blank
	 * so that subclasses only have to override necessary methods  
	 */
	static class ScrollEventAdapter implements ScrollEventListener {
		@Override
		public void autoScrolled( ScrollEvent evt ) {
			// do nothing
		}
	}
	
	/**
	 * Listener list which contains all ScrollEvent listener attached
	 * to this
	 */
	protected EventListenerList listenerList = new EventListenerList();
	
	/**
	 * Add a ScrollEventListener to this
	 * 
	 * @param	listener
	 * 			is the ScrollEventListener to add to this
	 */
	void addScrollEventListener( ScrollEventListener listener ) {
		listenerList.add( ScrollEventListener.class, listener );
	}
	
	/**
	 * Remove a ScrollEventListener from this
	 * 
	 * @param	listener
	 * 			is the ScrollEventListener to remove from this
	 */
	void removeScrollEventListener( ScrollEventListener listener ) {
		listenerList.remove( ScrollEventListener.class, listener );
	}
	
	/**
	 * Indicate that this custom scroll just perform an auto scroll
	 * so that the external parent can update accordingly
	 */
	
	protected void fireAutoScrollEvent( ScrollEvent evt ) {
		Object[] listeners = listenerList.getListenerList();
		for ( int i = 0; i < listeners.length; i = i + 2 ) {
			if ( listeners[ i ] == ScrollEventListener.class ) {
				( ( ScrollEventListener ) listeners[ i + 1 ] )
						.autoScrolled( evt );
			}
		}
	}
	
	
	
	/**
	 * Ruler class to show on the scroll
	 */
	static private class Ruler extends JComponent {
		private static final long serialVersionUID = 1L;

		/** Orientation of the ruler */
		static private enum RulerOrientation {
			HORIZONTAL, VERTICAL
		}
		/** Orientaion of the ruler */
		private RulerOrientation orientation;
		/**
		 * Width of the ruler, if orientation is vertical
		 * Unit width of the ruler, if orientation is horizontal
		 */
		private int width;
		/**
		 * Height of the ruler, if orientation is horizontal
		 * Unit height of the ruler, if orienation is vertical
		 */
		private int height;
		/** Increment of this ruler */
		private int increment;
		/** Flag to indicate whether to display tick or not */
		private boolean displayTick;
		
		/**
		 * Default constructor
		 * 
		 * @param	orientation
		 * 			is the orientation of the ruler
		 * 
		 * @param	width
		 * 			is the width of the ruler, if orientation is vertical
		 * 			is the width of each unit of the ruler, if orientation is horizontal
		 * 
		 * @param	height
		 * 			is the height of each unit of the ruler, if orientation is vertical
		 * 			is the height of the ruler, if orientation is horizontal
		 */
		Ruler( RulerOrientation orientation, int width, int height ) {
			this.orientation = orientation;
			this.width = width;
			this.height = height;
			displayTick = true;
			setIncrement();
		}
		
		/**
		 * Initialize the increment of this ruler
		 */
		private void setIncrement() {
			increment = orientation == RulerOrientation.HORIZONTAL ? width : height;
		}
		
		/**
		 * Set the display tick variable of this one
		 * to show/hide tick
		 * 
		 * @param	displayTick
		 * 			is the flag to indicate whether to display tick or not
		 */
		private void setDisplayTick( boolean displayTick ) {
			this.displayTick = displayTick;
		}
		
		/**
		 * Set preferred size of this ruler
		 * based on the unit count
		 * 
		 * @param	unitCount
		 * 			is the number of units should be in this ruler
		 */
		void setPreferredSizeByUnitCount( int unitCount ) {
			switch ( orientation ) {
				case HORIZONTAL:
					setPreferredSize( new Dimension( unitCount * width, height ) );
					break;
				case VERTICAL:
					setPreferredSize( new Dimension( width, unitCount * height ) );
					break;
			}
		}
		
		/**
		 * Reset size of this rulder
		 * 
		 * @param	width
		 * 			is the new width of this ruler
		 * @param	height
		 * 			is the new height of this ruler
		 */
		void resetSize(int width, int height) {
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Set preferred size of this ruler, based
		 * on the given preferred width
		 * 
		 * @param	preferredWidth
		 * 			is the preferredWidth of this ruler
		 */
		void setPreferredWidth( int preferredWidth ) {
			setPreferredSize( new Dimension( preferredWidth, height ) );
		}
		
		/**
		 * Set preferred size of this ruler, based
		 * on the given preferred height
		 * 
		 * @param	preferredHeight
		 * 			is the preferredHeight of this ruler
		 */
		void setPreferredHeight( int preferredHeight ) {
			setPreferredSize( new Dimension( width, preferredHeight ) );
		}
		
		@Override
		protected void paintComponent( Graphics g ) {
			Rectangle rectBound = g.getClipBounds();
			
			// background
			g.setColor( EditorConstants.RULER_BACKGROUND_COLOR );
			g.fillRect( rectBound.x, rectBound.y, rectBound.width, rectBound.height );
			
			// labels and ticks
			g.setFont( 
					new Font( EditorConstants.RULER_LABELS_FONT, Font.PLAIN,
							EditorConstants.RULER_LABELS_FONT_SIZE ) );
			g.setColor( EditorConstants.RULER_LABELS_TICKS_COLOR );
			
			int startPos = 0, endPos = 0;
			
			// Calculate first and last tick location
			switch ( orientation ) {
				case HORIZONTAL:
					startPos = ( rectBound.x / increment ) * increment;
					endPos = ( ( ( rectBound.x + rectBound.width ) / increment ) + 1 )
								* increment;
					break;
					
				case VERTICAL:
					startPos = ( rectBound.y / increment ) * increment;
					endPos = ( ( ( rectBound.y + rectBound.height ) / increment ) + 1)
			                  	* increment;
					break;
			}
			
			int tickLength = EditorConstants.RULER_TICK_LENGTH;
			int unitCount;
			int unitLength = orientation == RulerOrientation.HORIZONTAL ? width : height;
			
			// ticks and labels
	        for (int i = startPos; i < endPos; i += increment) {
	            unitCount = i / unitLength + 1;
	            
	            // TASK: hard code here, very bad
	            switch ( orientation ) {
	            	case HORIZONTAL:
	            		if ( displayTick )
	            			g.drawLine( i, height - 1, i, height - tickLength - 3 );
	            		int xHor = unitCount < 10 ? i + unitLength / 2 - 3 : i + unitLength / 2 - 7;
	            		g.drawString( "" + unitCount, xHor, 21 );
	            		break;
	            	case VERTICAL:
	            		if ( displayTick )
	            			g.drawLine( width - 1, i, width - tickLength - 1, i );
	            		int xVer = unitCount < 10 ? 12 : 9;
	            		g.drawString( "" + unitCount, xVer, i + unitLength / 2 + 4 );
	            		break;
	            }
	        }
		}
		
	}
	
	
	
	/** Direction of the scrolling */
	static private enum ScrollDirection {
		NO_DIRECTION, LEFT, RIGHT, UP, DOWN
	}
	
	
	
	/** The componenet inside this scroll */	 
	private Component view;
	/** The thumbnail of this scroll, if any */
	private Thumbnail thumbnail;
	/**
	 * The listener to changes in viewport
	 * to update the thumbnail accordingly
	 */
	private ChangeListener viewportChangeListener;
	/**
	 * Flag to indicate whether vertical ruler is displayed
	 * in this scrollPane or not 
	 */
	private boolean showVerticalRuler;
	/**
	 * Flag to indicate whether horizontal ruler is displayed
	 * in this scrollPane or not
	 */
	private boolean showHorizontalRuler;
	/** Auto scroll timer */
	private Timer autoScrollTimer;
	/** Auto scroll timer event listener */
	private ActionListener autoScrollTimerActionListener;
	/** Current scroll directions */
	private ScrollDirection horizontalScrollDirection;
	private ScrollDirection verticalScrollDirection;
	/** Rulers */
	private Ruler horizontalRuler;
	private Ruler verticalRuler;
	
	
	
	/**
	 * Default constructor
	 * 
	 * @param	view
	 * 			is the component to show inside this scroller	
	 */
	CustomScrollPane( Component view ) {
		super( view );
		this.view = view;
		if (view instanceof Resizable)
			((Resizable)view).addResizeObserver( this );
		this.showVerticalRuler = false;
		this.showHorizontalRuler = false;
		horizontalScrollDirection = ScrollDirection.NO_DIRECTION;
		verticalScrollDirection = ScrollDirection.NO_DIRECTION;
		getVerticalScrollBar().setUnitIncrement( EditorConstants.SCROLL_UNIT_INCREMENT );
		getHorizontalScrollBar().setUnitIncrement( EditorConstants.SCROLL_UNIT_INCREMENT );
	}
	
	/**
	 * Default constructor
	 * 
	 * @param	view
	 * 			is the component to show inside this scroller
	 * 
	 * @param	vsbPolicy
	 * 			is the policy of vertical scroll bar
	 * 			is either JScrollPane.VERTICAL_SCROLLBAR_ALWAYS
	 * 			or JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED
	 * 
	 * @param	hsbPolicy
	 * 			is the policy of horizontal scroll bar
	 * 			is either JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS
	 * 			or JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED
	 */
	CustomScrollPane( Component view, int vsbPolicy, int hsbPolicy ) {
		this( view );
		this.setVerticalScrollBarPolicy( vsbPolicy );
		this.setHorizontalScrollBarPolicy( hsbPolicy );
	}
	
	/**
	 * Get the view inside this scroller
	 * 
	 * @return	the view inside this scroller
	 */
	Component getView() {
		return view;
	}
	
	/**
	 * Auto scroll this based on the current position of the mouse on this
	 * 
	 * @param	mouseX
	 * 			is the x position of the mouse relative to this scroll pane
	 * 
	 * @param	mouseY
	 * 			is the y position of the mouse relative to this scroll pane
	 */
	void autoScroll( int mouseX, int mouseY ) {
		getAutoScrollTimer().stop();
		
		int width = this.getWidth() - this.getVerticalScrollBar().getWidth();
		int height = this.getHeight() - this.getHorizontalScrollBar().getHeight();
		
		int verticalRulerWidth = showVerticalRuler ? this.getRowHeader().getWidth() : 0;
		int horizontalRulerHeight = showHorizontalRuler ? this.getColumnHeader().getHeight() : 0;
		
		horizontalScrollDirection = ScrollDirection.NO_DIRECTION;
		verticalScrollDirection = ScrollDirection.NO_DIRECTION;
		
		if ( mouseX <= verticalRulerWidth + EditorConstants.AUTO_SCROLL_AREA_WIDTH )
			horizontalScrollDirection = ScrollDirection.LEFT;
		if (  width - verticalRulerWidth - EditorConstants.AUTO_SCROLL_AREA_WIDTH <= mouseX )
			horizontalScrollDirection = ScrollDirection.RIGHT;
		
		if ( mouseY <= horizontalRulerHeight + EditorConstants.AUTO_SCROLL_AREA_HEIGHT )
			verticalScrollDirection = ScrollDirection.UP;
		if ( height - horizontalRulerHeight - EditorConstants.AUTO_SCROLL_AREA_HEIGHT <= mouseY )
			verticalScrollDirection = ScrollDirection.DOWN;
		
		if ( horizontalScrollDirection != ScrollDirection.NO_DIRECTION
				|| verticalScrollDirection != ScrollDirection.NO_DIRECTION )
			getAutoScrollTimer().start();
	}
	
	/**
	 * Stop the auto scroll
	 */
	void stopAutoScroll() {
		getAutoScrollTimer().stop();
		horizontalScrollDirection = ScrollDirection.NO_DIRECTION;
		verticalScrollDirection = ScrollDirection.NO_DIRECTION;
	}
	
	/**
	 * Get the auto scroll timer to automatically scroll
	 * when mouse is at the edges of this scroll pane
	 * 
	 * @return	the auto scroll timer to automatically scroll
	 * when mouse is at the edges of this scroll pane
	 */
	private Timer getAutoScrollTimer() {
		if ( autoScrollTimer == null ) {
			autoScrollTimer = 
				new Timer( EditorConstants.AUTO_SCROLL_DELAY, 
						getAutoScrollTimerActionListener() );
			autoScrollTimer.setInitialDelay( EditorConstants.AUTO_SCROLL_INITIAL_DELAY );
			autoScrollTimer.setRepeats( true );
		}
		return autoScrollTimer;
	}
	
	/**
	 * Get the action listener to automatically scroll timer
	 * to actually perform the scrolling
	 * 
	 * @return	the action listener to automatically scroll timer
	 * to actually perform the scrolling
	 */
	private ActionListener getAutoScrollTimerActionListener() {
		if ( autoScrollTimerActionListener == null ) {
			autoScrollTimerActionListener = new ActionListener() {
				@Override
				public void actionPerformed( ActionEvent e ) {
					autoScroll();
				}
			};
		}
		return autoScrollTimerActionListener;
	}
	
	/**
	 * Auto scroll based on the preset direction
	 */
	private void autoScroll() {
		int width = this.getWidth() - this.getVerticalScrollBar().getWidth();
		int height = this.getHeight() - this.getHorizontalScrollBar().getHeight();
		
		JViewport viewport = this.getViewport();
		Point currentViewPosition = viewport.getViewPosition();
		
		int newViewX = currentViewPosition.x;
		int newViewY = currentViewPosition.y;
		
		int unitIncrement = EditorConstants.SCROLL_UNIT_INCREMENT;
		switch ( horizontalScrollDirection ) {
			case LEFT: newViewX -= unitIncrement; break;
			case RIGHT: newViewX += unitIncrement; break;
		}
		switch ( verticalScrollDirection ) {
			case UP: newViewY -= unitIncrement; break;
			case DOWN: newViewY += unitIncrement; break;
		}
		
		newViewX = Math.min( newViewX, this.view.getWidth() - width );
		newViewY = Math.min( newViewY, this.view.getHeight() - height );
		newViewX = Math.max( newViewX, 0 );
		newViewY = Math.max( newViewY, 0 );
		
		viewport.setViewPosition( new Point( newViewX, newViewY ) );
		fireAutoScrollEvent( new ScrollEvent( this ) );
	}
	
	/**
	 * Show the vertical ruler
	 * 
	 * @param	unitHeight
	 * 			is the height of each unit of the ruler
	 */
	void showVerticalRuler( int unitHeight ) {
		showHorizontalRuler( EditorConstants.RULER_DEFAULT_SIZE.width, unitHeight );
	}
	
	/**
	 * Show the horizontal ruler
	 * 
	 * @param	unitWidth
	 * 			is the width of the ruler
	 * 
	 * @param	unitHeight
	 * 			is the height of each unit of the ruler
	 */
	void showVerticalRuler( int width, int unitHeight ) {
		showRuler( Ruler.RulerOrientation.VERTICAL, width, unitHeight );
	}
	
	/**
	 * Show the horizontal ruler
	 * 
	 * @param	unitWidth
	 * 			is the width of each unit of the ruler
	 */
	void showHorizontalRuler( int unitWidth ) {
		showHorizontalRuler( unitWidth, EditorConstants.RULER_DEFAULT_SIZE.height );
	}
	
	/**
	 * Show the horizontal ruler
	 * 
	 * @param	unitWidth
	 * 			is the width of each unit of the ruler
	 * 
	 * @param	height
	 * 			is the height of the ruler
	 */
	void showHorizontalRuler( int unitWidth, int height ) {
		showRuler( Ruler.RulerOrientation.HORIZONTAL, unitWidth, height );
	}
	
	/**
	 * Show the ruler
	 * 
	 * @param	orientation
	 * 			is the orientation of the ruler
	 * 
	 * @param	width
	 * 			is the width of the ruler if orientation is vertical
	 * 			is the unit with of the ruler if orientation is horizontal
	 * 
	 * @param	height
	 * 			is the height of the ruler if orientation is horizontal
	 * 			is the unit height or the ruler if orientation is vertical
	 */
	private void showRuler( Ruler.RulerOrientation orientation, int width, int height ) {
		int unitCount = 0;
		boolean rulerExist = true;
		
		Ruler ruler = null;
		switch ( orientation ) {
			case HORIZONTAL:
//				if ( horizontalRuler == null ) {
					rulerExist = false;
					horizontalRuler = new Ruler( orientation, width, height );
//				} else 
//					horizontalRuler.resetSize( width, height );
				ruler = horizontalRuler;
				break;
			case VERTICAL:
//				if ( verticalRuler == null ) {
					rulerExist = false;
					verticalRuler = new Ruler( orientation, width, height );
//				} else 
//					verticalRuler.resetSize( width, height );
				ruler = verticalRuler;
				break;
		}
		
		if ( view instanceof Map ) {
			Map map = ( Map ) view;
			Point mapSizeInGrid = map.getMapSizeInGrid();
			int mapColsCount = mapSizeInGrid.x;
			int mapRowsCount = mapSizeInGrid.y;
			unitCount = orientation == Ruler.RulerOrientation.VERTICAL ? mapRowsCount : mapColsCount;
			ruler.setDisplayTick( false );
		}
		ruler.setPreferredSizeByUnitCount( unitCount );
		
		if ( ! rulerExist ) {
			switch ( orientation ) {
				case VERTICAL:
					this.setRowHeaderView( ruler );
					showVerticalRuler = true;
					break;
				case HORIZONTAL:
					this.setColumnHeaderView( ruler );
					showHorizontalRuler = true;
					break;
			}
		} else
			ruler.revalidate();
	}
	
	/**
	 * Set display tick on rulers
	 * 
	 * @param	displayTick
	 * 			indicates whether to display tick on rulers or not
	 * 
	 * @throw	IllegalArgumentException
	 * 			if there is no rulers displayed
	 */
	void setRulerDisplayTick( boolean displayTick ) {
		setHorizontalRulerDisplayTick( displayTick );
		setVerticalRulerDisplayTick( displayTick );
	}
	
	/**
	 * Set display tick on horizontal ruler
	 * 
	 * @param	displayTick
	 * 			indicates whether to display tick on horizontal ruler or not
	 * 
	 * @throw	IllegalArgumentException
	 * 			if there is no horizontal ruler displayed
	 */
	void setHorizontalRulerDisplayTick( boolean displayTick ) {
		setRulerDisplayTick( Ruler.RulerOrientation.HORIZONTAL, displayTick );
	}
	
	/**
	 * Set display tick on vertical ruler
	 * 
	 * @param	displayTick
	 * 			indicates whether to display tick on vertical ruler or not
	 * 
	 * @throw	IllegalArgumentException
	 * 			if there is no vertical ruler displayed
	 */
	void setVerticalRulerDisplayTick( boolean displayTick ) {
		setRulerDisplayTick( Ruler.RulerOrientation.VERTICAL, displayTick );
	}
	
	/**
	 * Set display tick on ruler
	 * 
	 * @param	rulerOrientation
	 * 			indicates whether the ruler is the horizontal or the vertical one
	 * 
	 * @param	displayTick
	 * 			indicates whether to display tick on the ruler or not
	 * 
	 * @throw	IllegalArguments=Exception
	 * 			if there is no ruler displayed
	 */
	private void setRulerDisplayTick( Ruler.RulerOrientation rulerOrientation, boolean displayTick )
		throws IllegalArgumentException {
		Ruler ruler = null;
		switch ( rulerOrientation ) {
			case HORIZONTAL:
				if ( ! showHorizontalRuler )
					throw new IllegalArgumentException();
				ruler = ( Ruler ) getColumnHeader().getView();
				break;
			case VERTICAL:
				if ( ! showVerticalRuler )
					throw new IllegalArgumentException();
				ruler = ( Ruler ) getRowHeader().getView();
				break;
		}
		ruler.setDisplayTick( displayTick );
	}
	
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
    Component getComponentAtLocation( Point location ) {
    	int x = location.x;
    	int y = location.y;
    	if ( showVerticalRuler )
    		x -= this.getRowHeader().getWidth();
    	if ( showHorizontalRuler )
    		y -= this.getColumnHeader().getHeight();
    	
    	Component component = null;
    	if ( view instanceof Map && x >= view.getX() && y >= view.getY() ) {
    		component =
    			( ( Map ) view ).getTransparentGridAt( 
    					new Point( x - view.getX(), y - view.getY() ) );
    	}
    	return component;
    }
	
	@Override
	public void addThumbnail( Thumbnail thumbnail ) throws IllegalArgumentException {
		if ( thumbnail == null )
			throw new IllegalArgumentException();
		
		this.thumbnail = thumbnail;
		JViewport viewport = getViewport();
		viewport.addChangeListener( getViewportChangeListener() );
	}
	
	@Override
	public void removeThumbnails() {
		thumbnail = null;
	}
	
	@Override
	public void updateThumbnail() {
		if ( thumbnail != null )
			thumbnail.updateViewLocation();
	}
	
	@Override
	public void scrollRectToVisible( Rectangle aRect ) {
		super.scrollRectToVisible( aRect );
		updateThumbnail();
	}
	
	@Override
	public void updateViewLocation() {
		Point thumbnailViewLocation = thumbnail.getViewLocation();
		JViewport viewport = getViewport();
		Point viewPosition = new Point(
				Math.max( 0, ( int ) ( thumbnailViewLocation.x / thumbnail.getXScale() )),
				Math.max( 0, ( int ) ( thumbnailViewLocation.y / thumbnail.getYScale() )));
		viewport.setViewPosition( viewPosition );
	}
	
	/**
	 * Return the listener to changes in viewport
	 * to update the thumbnail accordingly
	 * 
	 * @return	the listener to changes in viewport
	 * to update the thumbnail accordingly
	 */
	private ChangeListener getViewportChangeListener() {
		if ( viewportChangeListener == null )
			viewportChangeListener = new ChangeListener() {
				@Override
				public void stateChanged( ChangeEvent e ) {
					updateThumbnail();
				}
			};
		return viewportChangeListener;
	}

	/**
	 * Notified that the object has been resized
	 */
	@Override
	public void resizableObjectResized() {
		Dimension gridSize = EditorConstants.GRID_SIZE;
		showHorizontalRuler( (int)(gridSize.width * EditorConstants.SCALE),
	        		EditorConstants.RULER_DEFAULT_SIZE.height );
	    showVerticalRuler( EditorConstants.RULER_DEFAULT_SIZE.width,
	        		(int)(gridSize.height * EditorConstants.SCALE));
	}

}
