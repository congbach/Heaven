package embeded {
	/**
	 * EmbededConstants class
	 * @author Ken
	 * contains all the constants files
	 */
	public class EmbededConstants {
		/** File which contains all the general constants */
		[Embed( source="/../design/config/constants.xml", mimeType="application/octet-stream" )]
		static public const GeneralsConstants:Class;
		
		/** File which contains all the designed statistics for characters */
		[Embed( source="/../design/config/charactersConstants.xml", mimeType="application/octet-stream" )]
		static public const CharactersConstants:Class;
		
		/** File which contains all the designed statistics for items */
		[Embed( source="/../design/config/itemsConstants.xml", mimeType="application/octet-stream" )]
		static public const ItemsConstants:Class;
		
		/** File which contains all the designed statistics for skills */
		[Embed( source="/../design/config/skillsConstants.xml", mimeType="application/octet-stream" )]
		static public const SkillsConstants:Class;
		
		
		/** File which contains the mapping of code to characters' names, items' names, skills' name */
		[Embed( source="/../design/config/unitsCodes.xml", mimeType="application/octet-stream" )]
		static public const UnitsCodes:Class;
		
	}
}