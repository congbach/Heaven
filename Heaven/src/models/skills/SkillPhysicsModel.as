package models.skills {

	import models.ImmutablePhysicsModel;
	/**
	 * SkillPhysicsModel
	 * 
	 * Extends PhysicsModel
	 * Store additional information only applicable to skills
	 * such as travel range,...
	 * 
	 * @author Ken
	 */
	public class SkillPhysicsModel extends ImmutablePhysicsModel {
		
		/**
		 * The initial velocity of the skill
		 */
		private var _initialVelocity:Number;
		/**
		 * The initial velocity of the skill
		 */
		public function get initialVelocity():Number { return _initialVelocity; }
		/**
		 * The range of the skill
		 */
		private var _range:Number;
		/**
		 * The range of the skill
		 */
		public function get range():Number { return _range; }
		
		/**
		 * Default contructor
		 * 
		 * @param	offsetX
		 * 			is the x coordinate of the offset
		 * @param	offsetY
		 * 			is the y coordinate of the offset
		 * @param	offsetWidth
		 * 			is the width of the offset
		 * @param	offsetHeight
		 * 			is the height of the offset
		 * @param	initialVelocity
		 * 			is the initial velocity of the skill (x,y-axis direction will
		 * 			be calculated later based on the read direction of the skill)
		 * @param	range
		 * 			is the maximum distance the skill can travel
		 */
		public function SkillPhysicsModel(
			offsetX:Number, offsetY:Number, offsetWidth:Number, offsetHeight:Number,
			initialVelocity:Number, range:Number ) {
			super(offsetX, offsetY, offsetWidth, offsetHeight, 0, 0, 0, 0, 0, 0);
			_initialVelocity = initialVelocity;
			_range = range; 
		}
	}
}
