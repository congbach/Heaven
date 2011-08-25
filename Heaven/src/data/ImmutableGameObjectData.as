package data {
	import org.flixel.data.FlxSize;
	import models.stats.Stats;
	import models.ImmutablePhysicsModel;
	
	import org.flixel.data.FlxAnim;

	/**
	 * Character Data class
	 * @author Ken
	 * contains all data of one character
	 * normally, it is one kind of npc
	 * Not only contains the model but information
	 * about the view as well
	 */
	public class ImmutableGameObjectData {
		
		/** URL to the image of the game object */
		private var _imageUrl:String;
		/** The frame size of this game object */
		private var _frameSize:FlxSize;
		/** The width of each frame image of the game object */
//		private var _width:Number;
		/** The height of each frame image of the game object */
//		private var _height:Number;
		/** The data needed for physics calculation of the game object */
		private var _physicsData:ImmutablePhysicsModel;
		/** The data for animation of the game object */
		private var _animationsData:Vector.< FlxAnim >;
		/** The model of the game object */
		private var _model:GameObjectModel;
		
		
		/**
		 * Default constructor
		 * 
		 * @param	imageUrl
		 * 			is the url to the image of the game object
		 * @param	width
		 * 			is the width of each frame image of the game object
		 * @param	height
		 * 			is the height of each frame image of the game object
		 * @param	physicsData
		 * 			is the data needed for physics calculation of the game object
		 * @param	animationData
		 * 			is the data for animation of the game object
		 * @param	model
		 * 			is the model model of the game object
		 */
		public function ImmutableGameObjectData( imageUrl:String, width:Number, height:Number,
									   physicsData:ImmutablePhysicsModel, animationsData:Vector.< FlxAnim >,
									   model:GameObjectModel) {
			_imageUrl = imageUrl;
//			_width = width;
//			_height = height;
			_frameSize = new FlxSize(width, height);
			_physicsData = physicsData;
			if (animationsData == null) _animationsData = new Vector.<FlxAnim>();
			else _animationsData = animationsData;
			_model = model;
		}
		
		/** Get the URL to the image of this game object */
		public function get imageUrl():String {
			return _imageUrl;
		}
		
		/** Get the frame size of this game object */
		public function get frameSize():FlxSize {
			return new FlxSize(_frameSize.width, _frameSize.height);
		}
		
//		/** Get the width of each frame image of the game object */
//		public function get width():Number {
//			return _width;
//		}
//		
//		/** Get the height of each frame image of the game object */
//		public function get height():Number {
//			return _height;
//		}
		
		/** Get the data needed for physics calculation of the game object */
		public function get physicsData():ImmutablePhysicsModel {
			return _physicsData;
		}
		
		/** Get the data for animation of the game object */
		public function get animations():Vector.< FlxAnim > {
			return _animationsData.slice();
		}
		
		/** Get the model of the game object */
		public function get model():GameObjectModel {
			return _model.clone();
		}
		
		/** Get the base stats of the game object only */
		public function get baseStats():Stats {
			return _model.baseStats.clone();
		}
		
	}
}