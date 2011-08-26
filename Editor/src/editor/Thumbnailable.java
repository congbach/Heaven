package editor;

/**
 * Thumbnailable interface
 * 
 * @author Ken
 * 
 * Represents a jpanel which can be (actually, should be)
 * shown as a thumbnail version
 */
interface Thumbnailable {
	
	/**
	 * Add a thumbnail to represents this
	 * 
	 * @param	thumbnail
	 * 			is the thumbnail which keeps track of this jpanel
	 * 
	 * @throws	IllegalArgumentException
	 * 			if the given thumbnail is null
	 */
	void addThumbnail( Thumbnail thumbnail ) throws IllegalArgumentException;
	/**
	 * Remove all thumbnails that represent this
	 */
	void removeThumbnails();
	/**
	 * Update the thumbnail accordingly
	 * and tell all the thumbnails to update themselves
	 */
	void updateThumbnail();
	/**
	 * Update the view location accordingly
	 * and tell all the thumbnails to update themselves
	 */
	void updateViewLocation();

}
