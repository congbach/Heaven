package editor;

import java.awt.Point;

/**
 * Thumbnail interface
 * 
 * @author Ken
 * 
 * show the image of a jpanel as a resized version
 * if the jpanel is contained in a scroller
 * then the thumbnail has a rectangle inside to indicate
 * the portion of the jpanel which is currently shown
 * in the scroller
 */
interface Thumbnail {
	
	/**
	 * Update the position of the rectangle inside the thumbnail
	 * to indicate which part of the jpanel which is observed is currently
	 * shown on the scroller (if any)
	 */
	void updateViewLocation();
	/**
	 * Get the location of the rectangle inside the thumbnail
	 * to indicate which part the the jpanel is currently shown (or should
	 * be shown, in the case user drag the rectangle)
	 * 
	 * @return	the location of the rectangle inside the thumbnail
	 * to indicate which part the the jpanel is currently shown (or should
	 * be shown, in the case user drag the rectangle)
	 */
	Point getViewLocation();
	/**
	 * Get the scale ratio in x coordinate
	 * 
	 * @return	 the scale ratio in x coordinate
	 */
	double getXScale();
	/**
	 * Get the scale ratio in y coordinate
	 * 
	 * @return	the scale ratio in y coordinate
	 * @return
	 */
	double getYScale();

}
