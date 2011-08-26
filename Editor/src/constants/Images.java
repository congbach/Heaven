package constants;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Hashtable;

import javax.imageio.ImageIO;

import editor.ExceptionHandler;

/**
 * Images class
 * @author Ken
 * 
 * Manage images in an effective way
 * reduce load time in exchange for more resources
 * Remember image every time it is loaded
 * so that next time just retrieve that image
 * from the memory (which is a hash table)
 */
public class Images {
    
    /**
     * Hash table which maps image url with the image rendered
     */
    static private Hashtable< String, BufferedImage > images = new Hashtable< String, BufferedImage >();
    /**
     * Hash table which maps terrain code with its image
     */
    static private Hashtable< Integer, BufferedImage > terrainsImages = new Hashtable< Integer, BufferedImage >();
    
    /**
     * Load the terrains images and split it into images of each terrain
     */
    static void loadTerrainsImages() {
        try {
            BufferedImage image = ImageIO.read( new File( URLs.TILES_IMAGES_URL ) );
            Point terrainsImagesRowsCols = EditorConstants.TERRAINS_IMAGES_COLS_X_ROWS_SIZE;
            int cols = terrainsImagesRowsCols.x;
            int rows = terrainsImagesRowsCols.y;
            int width = image.getWidth() / cols;
            int height = image.getHeight() / rows;
            int terrainsIndex = 0;
            for ( int rowIndex = 0; rowIndex < rows; rowIndex++ ) {
                for ( int colIndex = 0; colIndex < cols; colIndex++ ) {
                    BufferedImage oneImageFrame = new BufferedImage( width, height, BufferedImage.TYPE_INT_ARGB );
                    Graphics2D g = oneImageFrame.createGraphics();
                    g.drawImage( image, 0, 0, width, height, width * colIndex, height * rowIndex,
                            width * colIndex + width, height * rowIndex + height, null );
                    terrainsImages.put( terrainsIndex++, oneImageFrame );
                }
            }
           
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
        }
    }
    
    /**
     * Get the image of the terrain based on its code
     * 
     * @param   terrainCode
     *          is the code of the terrain to obtain the image
     * 
     * @return  the image according to the given terrain code
     */
    static public BufferedImage getTerrainImage( int terrainCode ) throws IllegalArgumentException {
//       BufferedImage terrainImage = terrainsImages.get( -terrainCode );
       BufferedImage terrainImage = terrainsImages.get( terrainCode );
       if ( terrainImage == null )
           throw new IllegalArgumentException( "Undefined terrain code: " + terrainCode );
       return terrainImage;
    }
    
    /**
     * Get the numbers of terrains
     */
    @Deprecated
    static public int getTerrainsCount() {
        return terrainsImages.size();
    }
    
    /**
     * Get image from the url
     * Note that the image may contain multiple frames, but this function will
     * cut the image and return the first frame only
     * 
     * @param   imageUrl
     *          url to the image
     *          
     * @return  BufferedImage which contains only the first frame of the image
     * @throws  FileNotFoundException if there is no image at the given url 
     */
    static public BufferedImage getCharacterImage( String imageUrl ) throws FileNotFoundException {
//        Image image = images.get( imageUrl );
//        if ( image == null ) {
//            image = Toolkit.getDefaultToolkit().createImage( imageUrl );
//            ImageIcon icon = new ImageIcon( image );
//            if ( icon.getIconWidth() <= 0 || icon.getIconHeight() <= 0 )
//                throw new FileNotFoundException( imageUrl );
//            images.put( imageUrl, image );
//        }
//        return image;
    	if (imageUrl.startsWith("../"))
    		imageUrl = imageUrl.substring(3);
    	imageUrl = URLs.ROOT_URL() + imageUrl;
    	Point characterImagesFramesSize = EditorConstants.CHARACTERS_IMAGES_FRAMES_SIZE;
        BufferedImage image = images.get( imageUrl );
        if ( image == null ) {
            image = splitImage( 
                    imageUrl, characterImagesFramesSize.x, characterImagesFramesSize.y );
            images.put( imageUrl, image );
        }
        return image;
    }
    
    /**
     * Get image from the url
     * Note that the image may contain multiple frames, but this function will
     * cut the image and return the first frame only
     * 
     * @param   imageUrl
     *          url to the image
     *          
     * @return  BufferedImage which contains only the first frame of the image
     * @throws  FileNotFoundException if there is no image at the given url 
     */
    static public BufferedImage getItemImage( String imageUrl ) throws FileNotFoundException {
//        Image image = images.get( imageUrl );
//        if ( image == null ) {
//            image = Toolkit.getDefaultToolkit().createImage( imageUrl );
//            ImageIcon icon = new ImageIcon( image );
//            if ( icon.getIconWidth() <= 0 || icon.getIconHeight() <= 0 )
//                throw new FileNotFoundException( imageUrl );
//            images.put( imageUrl, image );
//        }
//        return image;
    	if (imageUrl.startsWith("../"))
    		imageUrl = imageUrl.substring(3);
    	imageUrl = URLs.ROOT_URL() + imageUrl;
    	BufferedImage image = images.get( imageUrl );
        if ( image == null ) {
        	try {
                image = ImageIO.read( new File( imageUrl ) );
            } catch ( Exception e ) {
//                e.printStackTrace();
            	ExceptionHandler.handleException(e);
                return null;
            }
            images.put( imageUrl, image );
        }
        return image;
    }
    
    /**
     * Split the image and return the first frame of the image only
     * first frame of the image if the fraction at the top left hand corner
     * 
     * @param   url
     *          is the url to the image
     *          
     * @param   cols
     *          indicates how many columns frames the image contains
     *          
     * @param   rows
     *          indicates how many rows frame the image contains
     *          
     * @return  the top left hand corner fraction of the image
     */
    static private BufferedImage splitImage( String url, int cols, int rows ) {
        try {
            BufferedImage image = ImageIO.read( new File( url ) );
            int width = image.getWidth() / cols;
            int height = image.getHeight() / rows;
            BufferedImage oneImageFrame = new BufferedImage( width, height, BufferedImage.TYPE_INT_ARGB );
            Graphics2D g = oneImageFrame.createGraphics();
            g.drawImage( image, 0, 0, width, height, 0, 0, width, height, null );
            return oneImageFrame;
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
            return null;
        }
    }
}
