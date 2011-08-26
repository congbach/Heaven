package editor;

import java.awt.Container;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.swing.JPanel;

/**
 * Library class
 * 
 * @author Ken
 * 
 *         Contains very general and miscellaneous methos
 * 
 */
public class Library {

	/**
	 * Get extension of a file
	 * 
	 * @param file
	 *            is the file to get the extension
	 * 
	 * @return the extension of the file given
	 */
	static String getExtension( File file ) {
		String ext = null;
		String name = file.getName();
		int i = name.lastIndexOf( '.' );

		if ( i > 0 && i < name.length() - 1 )
			ext = name.substring( i + 1 ).toLowerCase();
		return ext;
	}

	/**
	 * Get the real coordinate of the container object i.e. the coordinate
	 * relative to the game screen not relative to the container object's parent
	 * given the parent bound, i.e. stop if parent is the parent bound
	 * 
	 * @param container
	 *            is the container to get coordinate
	 * 
	 * @param parent
	 *            is the upper parent bound if parent == null, then return the
	 *            coordinate relative to the root (i.e. JContentPane) else
	 *            return the coordinate relative to the parent (if found)
	 * 
	 * @return coordinate of the container relative to the parent
	 */
	static Point getRealCoordinate( Container container,
			Container parentUpperBound ) {
		if ( container == null )
			return null;
		
		int currentX = 0;
		int currentY = 0;
		Container current = container;
		Container parent = container.getParent();
		while ( parent != null && current != parentUpperBound ) {
			currentX += current.getX();
			currentY += current.getY();
			current = parent;
			parent = parent.getParent();
		}
		return new Point( currentX, currentY );
	}

	/**
	 * Get the buffered image of a JPanel
	 * 
	 * @param panel
	 *            is the JPanel to get the bufferedImage
	 * 
	 * @return the image of the given panel
	 */
	static BufferedImage getBufferedImage( JPanel panel ) {
		return getScaleBufferedImage( panel, 1, 1 );
	}

	/**
	 * Get the buffered image of a JPanel and scale it to the given ratio
	 * 
	 * @param panel
	 *            is the JPanel to get the bufferedImage
	 * 
	 * @param xScale
	 *            is the ratio to scale the width of the panel
	 * 
	 * @param yScale
	 *            is the ratio to scale the height of the panel
	 * 
	 * @return the scale image of the given panel
	 */
	static BufferedImage getScaleBufferedImage( JPanel panel, double xScale,
			double yScale ) {
		int width = Math.max( panel.getPreferredSize().width, panel.getWidth() );
		int height = Math.max( panel.getPreferredSize().height, panel.getHeight() );
		BufferedImage src = new BufferedImage( width, height,
				BufferedImage.TYPE_INT_ARGB );
		Graphics2D srcG = src.createGraphics();
		panel.paint( srcG );
		BufferedImage scale = new BufferedImage( ( int ) ( xScale * width ),
				( int ) ( yScale * height ), BufferedImage.TYPE_INT_ARGB );
		Graphics2D g = scale.createGraphics();
		AffineTransform at = AffineTransform.getScaleInstance( xScale, yScale );
		g.drawRenderedImage( src, at );
		return scale;
	}
}
