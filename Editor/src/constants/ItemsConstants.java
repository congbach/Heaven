package constants;

import java.awt.Dimension;
import java.awt.Point;
import java.io.File;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;


import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import editor.ExceptionHandler;
import editor.Item;
import editor.Unit;
import editor.UnitFactory;

/**
 * itemsConstants class
 * 
 * @author Ken
 * 
 * This class load all designed constants regarding items
 * Specifically, those constants are items' names, codes and image URL
 * 
 */
public class ItemsConstants {
    
    /**
     * Hash table which contains all information regarding items in the game
     * Map from String (name of the item) to item information
     */
    static private Hashtable< String, Item > itemsConstants = 
        new Hashtable< String, Item >();
    /**
     * Hash table which map items' codes to items' names
     */
    static private Hashtable< Integer, String > itemsCodes =
    	new Hashtable< Integer, String >();
    
    /**
     * Read all items codes from external design file
     */
    static void loadConstants() {
        try {
            Hashtable< String, Integer > itemsCodes = loadItemsCodes();
            
            File unitsConstantsFile = new File( URLs.ITEMS_CONSTANTS_URL );
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse( unitsConstantsFile );
            doc.getDocumentElement().normalize();
            
            Node itemsNode = doc.getElementsByTagName( "items" ).item( 0 );
            Element itemsElements = ( Element ) itemsNode;
            NodeList items = itemsElements.getChildNodes();
            
            for ( int i = 0; i < items.getLength(); i++ ) {
                Node itemNode = items.item( i );
                
                if ( itemNode.getNodeType() == Node.ELEMENT_NODE ) {
                    Element itemElement = ( Element ) itemNode;
                    
                    NodeList imageUrlElementList = itemElement.getElementsByTagName( "imageUrl" );
                    Element imageUrlElement = ( Element ) imageUrlElementList.item( 0 );
                    NodeList imageUrl = imageUrlElement.getChildNodes();
                    String itemImageUrl = 
                    	( ( Node ) imageUrl.item( 0 ) ).getNodeValue().split("/", 2)[1];
                    
                    NodeList offsetElementList = itemElement.getElementsByTagName( "offset" );
                    Element offsetElement = ( Element ) offsetElementList.item( 0 );
                    
                    int x = Integer.parseInt(
                            ( ( Node ) ( ( Element ) offsetElement.getElementsByTagName( "x" ).item( 0 ) )
                            .getChildNodes().item( 0 ) ).getNodeValue() );
                    int y = Integer.parseInt(
                            ( ( Node ) ( ( Element ) offsetElement.getElementsByTagName( "y" ).item( 0 ) )
                            .getChildNodes().item( 0 ) ).getNodeValue() );
                    int width = Integer.parseInt(
                            ( ( Node ) ( ( Element ) offsetElement.getElementsByTagName( "width" ).item( 0 ) )
                            .getChildNodes().item( 0 ) ).getNodeValue() );
                    int height = Integer.parseInt(
                            ( ( Node ) ( ( Element ) offsetElement.getElementsByTagName( "height" ).item( 0 ) )
                            .getChildNodes().item( 0 ) ).getNodeValue() );
                    
                    NodeList nameElementList = itemElement.getElementsByTagName( "name" );
                    Element nameElement = ( Element ) nameElementList.item( 0 );
                    NodeList name = nameElement.getChildNodes();
                    String itemName = ( ( Node ) name.item( 0 ) ).getNodeValue();
                    int itemCode = itemsCodes.get( itemName );
                    Point itemOffset = new Point( x, y );
                    Dimension itemOffsetSize = new Dimension( width, height );
                    Item item = new Item(
                            itemName, itemCode, itemImageUrl,
                            itemOffset, itemOffsetSize );
                    itemsConstants.put( itemName, item );
                    ItemsConstants.itemsCodes.put( itemCode, itemName );
                }
            }
            
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
        }
    }
    
    /**
     * Load the items codes from external file
     */
    static private Hashtable< String, Integer > loadItemsCodes() {
        try {
            File itemsCodesFile = new File( URLs.UNITS_CODES_URL );
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse( itemsCodesFile );
            doc.getDocumentElement().normalize();
            
            Hashtable< String, Integer > itemsCodes = new Hashtable< String, Integer >();
            NodeList itemList = doc.getElementsByTagName( "item" );
            
            for ( int i = 0; i < itemList.getLength(); i++ ) {
                Node itemNode = itemList.item( i );
                
                if ( itemNode.getNodeType() == Node.ELEMENT_NODE ) {
                    Element itemElement = ( Element ) itemNode;
                    
                    NodeList nameElementList = itemElement.getElementsByTagName( "name" );
                    Element nameElement = ( Element ) nameElementList.item( 0 );
                    NodeList name = nameElement.getChildNodes();
                    String itemName = ( ( Node ) name.item( 0 ) ).getNodeValue();
                    
                    NodeList codeElementList = itemElement.getElementsByTagName( "code" );
                    Element codeElement = ( Element ) codeElementList.item( 0 );
                    NodeList code = codeElement.getChildNodes();
                    int itemCode = Integer.parseInt( ( ( Node ) code.item( 0 ) ).getNodeValue() );
                    
                    itemsCodes.put( itemName, itemCode );
                }
            }
            return itemsCodes;
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
            return null;
        }
    }
    
    /**
     * Get all the items constants
     * note the the return value is only the clone of the constants here
     * so the the constants are all safe (not modified from outside)
     * 
     * @return  all the items constants
     */
    static public ArrayList< Unit > getAllItemsConstants() {
        Enumeration< Item > items = itemsConstants.elements();
        ArrayList< Unit > itemsClones = new ArrayList< Unit >();
        while ( items.hasMoreElements() )
        	itemsClones.add( items.nextElement().clone() );
        return itemsClones;
    }
    
    /**
     * Get the item based on its unit Code
     * 
     * @param	unitCode
     * 			is the unit code of the item
     * 
     * @return	the item with the given unitCode
     * 
     * @throw	IllegalArgumentException
     * 			if the unitCode does not match any actual item
     */
    static public Item getItem( int unitCode ) throws IllegalArgumentException {
    	if ( ! itemsCodes.containsKey( unitCode ) )
    		throw new IllegalArgumentException( "Undefined item unit code: " + unitCode );
    	Item item = itemsConstants.get( itemsCodes.get( unitCode ) );
    	return ( Item ) UnitFactory.clone( item );
    }
}
