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

import editor.Character;
import editor.ExceptionHandler;
import editor.Unit;
import editor.UnitFactory;

/**
 * CharactersConstants class
 * 
 * @author Ken
 * 
 * This class load all designed constants regarding characters
 * Specifically, those constants are characters' names, codes and image URL
 * 
 */
public class CharactersConstants {
    
    /**
     * Hash table which contains all information regarding characters in the game
     * Map from String (name of the character) to character information
     */
    static private Hashtable< String, Character > charactersConstants = 
        new Hashtable< String, Character >();
    /**
     * Hash table which map characters' codes to characters' names
     */
    static private Hashtable< Integer, String > charactersCodes =
    	new Hashtable< Integer, String >();
    
    /**
     * Read all characters codes from external design file
     */
    static void loadConstants() {
        try {
            Hashtable< String, Integer > charactersCodes = loadCharactersCodes();
            
            File charactersConstantsFile = new File( URLs.CHARACTERS_CONSTANTS_URL );
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse( charactersConstantsFile );
            doc.getDocumentElement().normalize();
            
            Node charactersNode = doc.getElementsByTagName( "characters" ).item( 0 );
            Element charactersElements = ( Element ) charactersNode;
            NodeList characters = charactersElements.getChildNodes();
            
            for ( int i = 0; i < characters.getLength(); i++ ) {
                Node characterNode = characters.item( i );
                
                if ( characterNode.getNodeType() == Node.ELEMENT_NODE ) {
                    Element characterElement = ( Element ) characterNode;
                    
                    NodeList imageUrlElementList = characterElement.getElementsByTagName( "imageUrl" );
                    Element imageUrlElement = ( Element ) imageUrlElementList.item( 0 );
                    NodeList imageUrl = imageUrlElement.getChildNodes();
                    String characterImageUrl = 
                    	( ( Node ) imageUrl.item( 0 ) ).getNodeValue().split("/", 2)[1];
                    
                    NodeList physicsElementList = characterElement.getElementsByTagName( "physics" );
                    Element physicsElement = ( Element ) physicsElementList.item( 0 );
                    NodeList offsetElementList = physicsElement.getElementsByTagName( "offset" );
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
                    
                    String characterName = characterElement.getNodeName();
                    int characterCode = charactersCodes.get( characterName );
                    Point characterOffset = new Point( x, y );
                    Dimension characterOffsetSize = new Dimension( width, height );
                    Character character = new Character(
                            characterName, characterCode, characterImageUrl,
                            characterOffset, characterOffsetSize );
                    charactersConstants.put( characterName, character );
                    CharactersConstants.charactersCodes.put( characterCode, characterName );
                }
            }
            
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
        }
    }
    
    /**
     * Load the characters codes from external file
     */
    static private Hashtable< String, Integer > loadCharactersCodes() {
        try {
            File charactersCodesFile = new File( URLs.UNITS_CODES_URL );
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse( charactersCodesFile );
            doc.getDocumentElement().normalize();
            
            Hashtable< String, Integer > charactersCodes = new Hashtable< String, Integer >();
            NodeList charactersList = doc.getElementsByTagName( "character" );
            
            for ( int i = 0; i < charactersList.getLength(); i++ ) {
                Node characterNode = charactersList.item( i );
                
                if ( characterNode.getNodeType() == Node.ELEMENT_NODE ) {
                    Element characterElement = ( Element ) characterNode;
                    
                    NodeList nameElementList = characterElement.getElementsByTagName( "name" );
                    Element nameElement = ( Element ) nameElementList.item( 0 );
                    NodeList name = nameElement.getChildNodes();
                    String characterName = ( ( Node ) name.item( 0 ) ).getNodeValue();
                    
                    NodeList codeElementList = characterElement.getElementsByTagName( "code" );
                    Element codeElement = ( Element ) codeElementList.item( 0 );
                    NodeList code = codeElement.getChildNodes();
                    int characterCode = Integer.parseInt( ( ( Node ) code.item( 0 ) ).getNodeValue() );
                    
                    charactersCodes.put( characterName, characterCode );
                }
            }
            return charactersCodes;
        } catch ( Exception e ) {
//            e.printStackTrace();
        	ExceptionHandler.handleException(e);
            return null;
        }
    }
    
    /**
     * Get all the characters contants
     * note the the return value is only the clone of the constants here
     * so the the constants are all safe (not modified from outside)
     * 
     * @return  all the characters constants
     */
    static public ArrayList< Unit > getAllCharactersConstants() {
        Enumeration< Character > characters = charactersConstants.elements();
        ArrayList< Unit > charactersClones = new ArrayList< Unit >();
        while ( characters.hasMoreElements() ) {
        	Unit characterClone = characters.nextElement().clone();
        	if (characterClone.getCode() == EditorConstants.PLAYER_CODE &&
        			charactersClones.size() > 0) {
        		Unit first = charactersClones.get(0);
        		charactersClones.set( 0, characterClone );
        		charactersClones.add( first );
        	} else 
        		charactersClones.add( characterClone );
        }
        return charactersClones;
    }
    
    /**
     * Get the character based on its unit Code
     * 
     * @param	unitCode
     * 			is the unit code of the character
     * 
     * @return	the character with the given unitCode
     * 
     * @throw	IllegalArgumentException
     * 			if the unitCode does not match any actual character
     */
    static public Character getCharacter( int unitCode ) throws IllegalArgumentException {
    	if ( ! charactersCodes.containsKey( unitCode ) )
    		throw new IllegalArgumentException( "Undefined character unit code: " + unitCode );
    	Character character = charactersConstants.get( charactersCodes.get( unitCode ) );
    	return ( Character ) UnitFactory.clone( character );
    }
}
