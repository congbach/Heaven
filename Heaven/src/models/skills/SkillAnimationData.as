package models.skills {
	import org.flixel.data.FlxAnim;

	/**
	 * SkillData class
	 * 
	 * Contains information about animation of a skill.
	 * 
	 * @author Ken
	 */
	public class SkillAnimationData {
		
		/** URL to the image of the skill */
		private var _imageUrl:String;
		/** The width of each frame image of the skill */
		private var _width:Number;
		/** The height of each frame image of the skill */
		private var _height:Number;
		/** The data needed for physics calculation of the skill */
		private var _physicsData:SkillPhysicsModel;
		/** The data for animation of the skill */
		private var _animationsData:Vector.< FlxAnim >;
		
		/**
		 * Default constructor
		 * 
		 * @param	imageUrl
		 * 			is the url to the image of the skill
		 * @param	width
		 * 			is the width of each frame image of the skill
		 * @param	height
		 * 			is the height of each frame image of the skill
		 * @param	physicsData
		 * 			is the data needed for physics calculation of the skill
		 * @param	animationData
		 * 			is the data for animation of the skill
		 * @param	model
		 * 			is the model model of the skill
		 */
		public function SkillAnimationData( imageUrl:String, width:Number, height:Number,
									   physicsData:SkillPhysicsModel, animationsData:Vector.< FlxAnim >) {
			_imageUrl = imageUrl;
			_width = width;
			_height = height;
			_physicsData = physicsData;
			_animationsData = animationsData;
		}
		
		/** Get the URL to the image of this skill */
		public function get imageUrl():String {
			return _imageUrl;
		}
		
		/** Get the width of each frame image of the skill */
		public function get width():Number {
			return _width;
		}
		
		/** Get the height of each frame image of the skill */
		public function get height():Number {
			return _height;
		}
		
		/** Get the data needed for physics calculation of the skill */
		public function get physicsData():SkillPhysicsModel {
			return _physicsData;
		}
		
		/** Get the data for animation of the skill */
		public function get animations():Vector.< FlxAnim > {
			return _animationsData;
		}
	}
}
