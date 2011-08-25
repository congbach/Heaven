package gui {
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	
	/**
	 * GameSpriteGroup
	 * @author Ken
	 * 
	 * Represents a group of sprites in game
	 */
	public class GameGroup extends FlxGroup {
		
		override public function add(object:FlxObject, shareScroll:Boolean = false):FlxObject {
			var index:int = members.indexOf(object);
			if (members.indexOf(object) < 0) {
				members[members.length] = object;
				object.reset(object.x + x, object.y + y);
			} else {
				for (var i:int = index; i < members.length - 1; i++)
					members[i] = members[i + 1];
				members[members.length - 1] = object;
			}
			
			if(shareScroll)
				object.scrollFactor = scrollFactor;
			
			if (object is GameSprite)
				add((object as GameSprite).attachedGroup, shareScroll);
			
			return object;
		} 
	}
}