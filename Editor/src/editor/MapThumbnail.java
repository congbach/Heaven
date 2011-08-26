package editor;

import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JViewport;

import constants.EditorConstants;

/**
 * Thumbnail class
 * 
 * @author Ken
 * 
 * Show the image as a resized version
 *
 */
public class MapThumbnail extends JPanel implements Thumbnail, ResizeObserver {

	private static final long serialVersionUID = 1L;
	
//	/**
//	 * Rectangle which indicates which area is currently shown on the screen
//	 */
//	private static class ZoomRectangle extends JPanel {
//
//		private static final long serialVersionUID = 1L;
//		
//		/** The zoom rectangle, i.e. graphics presentation of this */
//		private Rectangle zoomRectangle;
//		
//		/**
//		 * Default constructor
//		 */
//		ZoomRectangle() {
//			zoomRectangle = new Rectangle();
//		}
//		
//		@Override
//		public void setSize( int width, int height ) {
//			super.setSize( width + 1, height + 1 );
//			zoomRectangle.setSize( width , height );
//		}
//		
//		@Override
//		public void setSize( Dimension size ) {
//			setSize( size.width, size.height );
//		}
//		
//		@Override
//		public void paint( Graphics g ) {
//			g.setColor( EditorConstants.MAP_THUMBNAIL_ZOOM_RECTANGLE_COLOR );
//			g.drawRect( zoomRectangle.x, zoomRectangle.y, zoomRectangle.width, zoomRectangle.height );
//		}
//	}
	
	/** Reference to this, to call inside event listener function */
	private MapThumbnail self;
	/** The map this thumbnail represents */
	private Map map;
	/** Flag indicates whether to remain the ratio of the original map or not */
	private boolean remainRatio;
	/** The map scroller which contains the map */
	private CustomScrollPane mapScroller;
	/** The scale ratio */
	private double xScale;
	private double yScale;
	/** Margin of this thumbnail relative to the allocated space */
	private Dimension margin;
	/** The background of the map (i.e. the grids */
	private BufferedImage backgroundImage;
	/** The JLabel which contains the background image of the map */
//	private JLabel backgroundImageContainer;
	/** Current image of the map, resized already */
	private BufferedImage mapImage;
	/** The JLabel which contains the image of the map */
//	private JLabel mapImageContainer;
	/** See whether display background grids or not */
	private boolean areGridsVisible;
	/** The zoom rectangle */
//	private ZoomRectangle zoomRectangle;
	private Rectangle zoomRectangle;
	
	/**
	 * Listener to mouse drag in zoom rectangle
	 * to update the position of the map scroller
	 * according to mouse dragging of zoom rectangle
	 */
	private MouseAdapter zoomRectangleMouseListener;
	
	/**
	 * Default constructor
	 * 
	 * @param	mapScroller
	 * 			is the map scroller containing the map which this thumbnail represents
	 * 
	 * @param	remainRatio
	 * 			indicates whether to remain the ratio of the map
	 * 
	 * @param	visibleSize
	 * 			indicates the size of the visible area on the map scroller
	 */
	MapThumbnail( CustomScrollPane mapScroller, boolean remainRatio ) {
		self = this;
		this.mapScroller = mapScroller;
		this.map = ( Map ) mapScroller.getView();
		this.remainRatio = remainRatio;
//		zoomRectangle = new ZoomRectangle();
//		zoomRectangle.addMouseMotionListener( getZoomRectangleMouseListener() );
//		zoomRectangle.addMouseListener( getZoomRectangleMouseListener() );
		zoomRectangle = new Rectangle();
		EventsListenersAdderRemover.addEventListener( this, getMouseListener() );
		
		setLayout( null );
		setBackground( EditorConstants.MAP_BACKGROUND_COLOR );
//		mapImageContainer = new JLabel();
//		mapImageContainer.setBackground( EditorConstants.MAP_BACKGROUND_COLOR );
//		backgroundImageContainer = new JLabel();
//		backgroundImageContainer.setBackground( EditorConstants.MAP_BACKGROUND_COLOR );
//		this.add(mapImageContainer);
//		this.add(backgroundImageContainer);

		map.addMapThumbnail( this );
		map.addResizeObserver( this );
		
		initializeMap();
		initializeScroller();
		
		updateBackground();
	}
	
	@Override
	public void paint( Graphics g ) {
		super.paint( g );
//		if ( areGridsVisible )
//			g.drawImage( backgroundImage, 0, 0, null );
		g.drawImage( mapImage, 0, 0, null );
		
		if ( zoomRectangle.getWidth() <= getWidth() || zoomRectangle.getHeight() <= getHeight() ) {
			g.setColor( EditorConstants.MAP_THUMBNAIL_ZOOM_RECTANGLE_COLOR );
			g.drawRect( zoomRectangle.x, zoomRectangle.y, zoomRectangle.width, zoomRectangle.height );
		}
	}

	/**
	 * Update the image of the map (not include the back ground)
	 */
	void updateMap() {
		mapImage = Library.getScaleBufferedImage( map.getMap(),
				xScale * EditorConstants.SCALE, yScale * EditorConstants.SCALE);
		repaint();
//		mapImageContainer.setIcon(new ImageIcon(mapImage));
//		mapImageContainer.setSize( new Dimension( mapImage.getWidth(), mapImage.getHeight() ) );
	}
	
	/**
	 * Update the background image of the map
	 */
	void updateBackground() {
		backgroundImage =
			Library.getScaleBufferedImage( map.getGridsBackground(), xScale, yScale );
//		backgroundImageContainer.setIcon(new ImageIcon(backgroundImage));
//		backgroundImageContainer.setSize( 
//				new Dimension( backgroundImage.getWidth(), backgroundImage.getHeight() ) );
//		backgroundImageContainer.setVisible( map.areGridsVisible() );
		areGridsVisible = map.areGridsVisible();
		repaint();
	}
	
	/**
	 * The map has been changed completely
	 * update the map and re-calculate the size and location
	 * i.e. initialize from scratch
	 */
	void initializeMap() {
		Dimension size = EditorConstants.MAP_THUMBNAIL_MAX_SIZE;
		int maxWidth = size.width;
		int maxHeight = size.height;

		Dimension mapSize = map.getPreferredSize();
//		int mapWidth = ( int ) Math.max( map.getWidth(), mapSize.width );
//		int mapHeight = ( int ) Math.max( map.getHeight(), mapSize.height );
		int mapWidth = mapSize.width;
		int mapHeight = mapSize.height;
		double xScale = ( ( double ) maxWidth ) / ( ( double ) mapWidth );
		double yScale = ( ( double ) maxHeight ) / ( ( double ) mapHeight );
		
		if ( remainRatio ) {
			xScale = Math.min( xScale, yScale );
			yScale = xScale;
		}
		this.xScale = xScale;
		this.yScale = yScale;
		
		int width = ( int ) ( xScale * mapWidth );
		int height = ( int ) ( yScale * mapHeight );
		this.setSize( new Dimension( width, height ) );

		Point defaultLocation = EditorConstants.MAP_THUMBNAIL_DEFAULT_LOCATION;
		Point location = this.getX() != 0 || this.getY() != 0
				? this.getLocation() : defaultLocation;
		int x = location.x;
		int y = defaultLocation.y;		
		if ( margin != null ) {
			x -= margin.width;
			y -= margin.height;
		}
		margin = new Dimension( maxWidth / 2 - width / 2, maxHeight / 2 - height / 2 );
		x += margin.width;
		y += margin.height;
		setLocation( x, y );
		
		updateMap();
	}
	
	/**
	 * Initialize the map scroller
	 */
	void initializeScroller() {
//		remove( zoomRectangle );
		Rectangle visibleSize = mapScroller.getViewportBorderBounds();
		int rectWidth = ( int ) ( xScale * visibleSize.width );
		int rectHeight = ( int ) ( yScale * visibleSize.height );
		zoomRectangle.setSize( rectWidth, rectHeight );
		
//		if ( rectWidth < this.getWidth() && rectHeight < this.getHeight() )
//			add( zoomRectangle );
				
		
	}
	
	/**
	 * Get the xScale of this map thumbnail to the real map
	 * 
	 * @return	the xScale of this map thumbnail relative to the real map
	 */
	@Override
	public double getXScale() {
		return xScale;
	}
	
	/**
	 * Get the yScale of this map thumbnail to the real map
	 * 
	 * @return	the yScale of this map thumbnail relative to the real map
	 */
	@Override
	public double getYScale() {
		return yScale;
	}
	
	@Override
	public void updateViewLocation() {
		JViewport viewport = mapScroller.getViewport();
		Point currentViewPosition = viewport.getViewPosition();
		int x = ( int ) ( xScale * currentViewPosition.x );
		int y = ( int ) ( yScale * currentViewPosition.y );
		zoomRectangle.setLocation( x, y );
		repaint();
	}
	
	@Override
	public Point getViewLocation() {
		return zoomRectangle.getLocation();
	}
	
//	/**
//	 * Return the listener to mouse drag in zoom rectangle
//	 * to update the position of the map scroller
//	 * according to mouse dragging of zoom rectangle
//	 * 
//	 * @return	the listener to mouse drag in zoom rectangle
//	 * to update the position of the map scroller
//	 * according to mouse dragging of zoom rectangle
//	 */
//	private MouseAdapter getZoomRectangleMouseListener() {
//		if ( zoomRectangleMouseListener == null )
//			zoomRectangleMouseListener = new MouseAdapter() {
//				Point originalMousePos;
//				
//				@Override
//				public void mouseDragged( MouseEvent e ) {
//					ZoomRectangle zoomRectangle = ( ZoomRectangle ) e.getSource();
//					int x = zoomRectangle.getX() + e.getX() - originalMousePos.x;
//					int y = zoomRectangle.getY() + e.getY() - originalMousePos.y;
//					x = ( int ) Math.max( x, 0 );
//					y = ( int ) Math.max( y, 0 );
//					x = ( int ) Math.min( x, self.getWidth() - zoomRectangle.getWidth() );
//					y = ( int ) Math.min( y, self.getHeight() - zoomRectangle.getHeight() );
//					
//					zoomRectangle.setLocation( x, y );
//					repaint();
//					
//					mapScroller.updateViewLocation();
//				}
//				
//				@Override
//				public void mousePressed( MouseEvent e ) {
//					originalMousePos = new Point( e.getX(), e.getY() );
//				}
//				
//				@Override
//				public void mouseReleased( MouseEvent e ) {
//					originalMousePos = null;
//				}
//			};
//		return zoomRectangleMouseListener;
//	}
	
	/**
	 * Return the listener to mouse drag in this one to
	 * actually drag the zoom rectangle around, and then
	 * update the position of the map scroller
	 * according to mouse dragging of zoom rectangle
	 * 
	 * @return	the listener to mouse drag in this one to
	 * actually drag the zoom rectangle around, and then
	 * update the position of the map scroller
	 * according to mouse dragging of zoom rectangle
	 */
	private MouseAdapter getMouseListener() {
		if ( zoomRectangleMouseListener == null )
			zoomRectangleMouseListener = new MouseAdapter() {
				
				@Override
				public void mouseDragged( MouseEvent e ) {
					Point sourceCoordinate = Library.getRealCoordinate( ( Container ) e.getSource(), self );
					int x = ( int ) ( sourceCoordinate.x + e.getX() - zoomRectangle.getWidth() / 2 );
					int y = ( int ) ( sourceCoordinate.y + e.getY() - zoomRectangle.getHeight() / 2 );
					x = ( int ) Math.max( x, 0 );
					y = ( int ) Math.max( y, 0 );
					x = ( int ) Math.min( x, self.getWidth() - zoomRectangle.getWidth() );
					y = ( int ) Math.min( y, self.getHeight() - zoomRectangle.getHeight() );
					x = ( int ) Math.max( x, 0 );
					y = ( int ) Math.max( y, 0 );
					
					zoomRectangle.setLocation( x, y );
					repaint();
					
					mapScroller.updateViewLocation();
				}
				
				@Override
				public void mousePressed( MouseEvent e ) {
					Point sourceCoordinate = Library.getRealCoordinate( ( Container ) e.getSource(), self );
					int x = ( int ) ( sourceCoordinate.x + e.getX() - zoomRectangle.getWidth() / 2 );
					int y = ( int ) ( sourceCoordinate.y + e.getY() - zoomRectangle.getHeight() / 2 );
					x = ( int ) Math.max( x, 0 );
					y = ( int ) Math.max( y, 0 );
					x = ( int ) Math.min( x, self.getWidth() - zoomRectangle.getWidth() );
					y = ( int ) Math.min( y, self.getHeight() - zoomRectangle.getHeight() );
					x = ( int ) Math.max( x, 0 );
					y = ( int ) Math.max( y, 0 );
					
					zoomRectangle.setLocation( x, y );
					repaint();
					
					mapScroller.updateViewLocation();
				}
				
				@Override
				public void mouseReleased( MouseEvent e ) {
				}
			};
		return zoomRectangleMouseListener;
	}
	
	/**
	 * Return the margin of this thumbnail
	 * relative to the allocated space
	 */
	Dimension getMargin() {
		return margin;
	}

	/**
	 * Notified that the object has been resized
	 */
	@Override
	public void resizableObjectResized() {
		initializeMap();
    	initializeScroller();
	}
	

}
