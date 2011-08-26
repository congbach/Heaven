package editor;

import java.io.File;

import javax.swing.filechooser.FileFilter;

import constants.EditorConstants;

/**
 * MapImageFileFilter class
 * 
 * @author Ken
 * 
 * Only accept some certain file types
 * as image in save map as image function
 *
 */
public class MapImageFileFilter extends FileFilter {
    
	/**
	 * Default construcctor
	 */
	MapImageFileFilter() {
		super();
	}
	
	@Override
	public String getDescription() {
		return EditorConstants.MAP_IMAGE_FILE_TYPE;
	}
	
	@Override
	public boolean accept( File f ) {
		if ( f.isDirectory() )
            return true;
		
        String extension = Library.getExtension( f );
        if ( extension != null ) {
            if ( extension.equalsIgnoreCase( EditorConstants.MAP_IMAGE_FILE_TYPE ) )
                    return true;
            else
                return false;
        }

        return false;
	}
	
	
}
