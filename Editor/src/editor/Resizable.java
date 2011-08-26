package editor;

/**
 * Resizable interface
 * 
 * Represents resizable object so that observer of this
 * (scroll pane) can listen to the resize event
 * 
 * @author Ken
 */
public interface Resizable {
	
	/**
	 * Add a thumbnail to represents this
	 * 
	 * @param	thumbnail
	 * 			is the thumbnail which keeps track of this jpanel
	 * 
	 * @throws	IllegalArgumentException
	 * 			if the given thumbnail is null
	 */
	void addResizeObserver( ResizeObserver observer ) throws IllegalArgumentException;
	/**
	 * Remove all thumbnails that represent this
	 */
	void removeResizeObservers();
	/**
	 * Notify the observer to take action
	 */
	void notifyResizeObservers();
}
