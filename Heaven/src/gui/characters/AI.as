package gui.characters {
	
	import gui.states.PlayState;
	import data.GameConstants;
	import data.UnitsConstants;
	
	import enums.Action;
	import enums.Direction;
	
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	
	/**
	 * AI class
	 * @author Ken
	 * controls NPC
	 */
	public class AI {
		
		/** The npc this AI controls */
		private var _npc:NonPlayableCharacter;
		/**
		 * The x position of the left and right bounds
		 * which the npc should (must?) not pass
		 * normally it is where the current ground ends
		 * or when there is obstace obstructing the way
		 */
		private var _leftXBound:Number;
		private var _rightXBound:Number;
		
		/**
		 * Default constructor
		 * 
		 * @param	npc
		 * 			is the npc this AI controls
		 * @param	xCoor
		 * 			is the initial(current) x coordinate of the grid whic this npc is on
		 * @param	yCoor
		 * 			is the initial(current) y coordinate of the grid whic this npc is on
		 * @param	tileMap
		 * 			is the current map
		 */
		public function AI( npc:NonPlayableCharacter, xCoor:int, yCoor:int, tileMap:Array ) {
			resetAI(npc, xCoor, yCoor, tileMap);
		}
		
		/**
		 * Reset this AI to new character
		 * 
		 * @param	npc
		 * 			is the npc this AI controls
		 * @param	xCoor
		 * 			is the initial(current) x coordinate of the grid whic this npc is on
		 * @param	yCoor
		 * 			is the initial(current) y coordinate of the grid whic this npc is on
		 * @param	tileMap
		 * 			is the current map
		 */
		public function resetAI(npc:NonPlayableCharacter, xCoor:int, yCoor:int, tileMap:Array):void {
			_npc = npc;
			
			// Calculate the coordinate of the ground under the npc
			var yGroundCoor:int = yCoor + 1;
			while ( yGroundCoor < tileMap.length - 1 && tileMap[ yGroundCoor ][ xCoor ] == UnitsConstants.BLANK )
				yGroundCoor++;
			
			// Calculate the coordinate of the left bound of the floor under the npc
			var leftXGroundBoundCoor:int = xCoor;
			while ( leftXGroundBoundCoor > 0
						&& tileMap[ yGroundCoor ][ leftXGroundBoundCoor - 1 ] != UnitsConstants.BLANK )
				leftXGroundBoundCoor--;
			
			// Calculate the coordinate of the nearest tile to the left of the npc
			var leftXSameRowBoundCoor:int = xCoor;
			while ( leftXSameRowBoundCoor > 0
				&& tileMap[ yGroundCoor - 1 ][ leftXSameRowBoundCoor - 1 ] == UnitsConstants.BLANK )
				leftXSameRowBoundCoor--;
			
			// Calculate the coordinate of the right bound of the floor under the npc
			var rightXGroundBoundCoor:int = xCoor;
			while ( rightXGroundBoundCoor < (tileMap[ yGroundCoor ] as Array).length - 1
				&& tileMap[ yGroundCoor ][ rightXGroundBoundCoor + 1 ] != UnitsConstants.BLANK )
				rightXGroundBoundCoor++;
			
			// Calculate the coordinate of the nearest tile to the right of the npc
			var rightXSameRowBoundCoor:int = xCoor;
			while ( rightXSameRowBoundCoor < (tileMap[ yGroundCoor ] as Array).length - 1
				&& tileMap[ yGroundCoor - 1 ][ rightXSameRowBoundCoor + 1 ] == UnitsConstants.BLANK )
				rightXSameRowBoundCoor++;
			
			// The left x bound is the nearest tile to the left or the left most ground tile,
			// whichever is nearer
			_leftXBound = GameConstants.TILE_WIDTH * Math.max( leftXGroundBoundCoor, leftXSameRowBoundCoor )
				- _npc.offset.x;
			// The right x bound is the nearest tile to the right or the right most ground tile,
			// whichever is nearer
			_rightXBound = GameConstants.TILE_WIDTH *
				( Math.min( rightXGroundBoundCoor, rightXSameRowBoundCoor ) ) + _npc.offset.x;
		}
		
		/**
		 * Control the NPC
		 * to be called every time NPC.update() is called
		 */
		public function controls():void {
			// Reset the attacking if necessary
			if (_npc.action == Action.ATTACKING && _npc.finished)
				_npc.action = Action.NORMAL;
			
			// Terminate if currently attacking
			if (_npc.action == Action.ATTACKING) return;
			
			// Reverse direction if approaching boundary already
			
			// If the npc goes beyond the left bound if keep moving left?
			if (_npc.facing == FlxSprite.LEFT && _npc.x + _npc.velocity.x * FlxG.elapsed <= _leftXBound) {
				// Reverse moving direction
				_npc.move( Direction.RIGHT );					
					
			// If the npc goes beyond the right bound if keep moving right?
			} else if ( _npc.facing == FlxSprite.RIGHT && _npc.x + _npc.velocity.x * FlxG.elapsed >= _rightXBound ) {
					// Yes
					// Reverse moving direction
					_npc.move( Direction.LEFT );
			} else {
			
				// Try to detect the player
				// Rectangles which contain player and npc's image
				var playerRect:FlxRect = PlayState.getInstance().playerRect;
				var npcRect:FlxRect = new FlxRect(_npc.x - _npc.offset.x,
												  _npc.y - _npc.offset.y,
												  _npc.frameWidth,
												  _npc.frameHeight);
				
				var xDetectingRange:Number = _npc.model.detectingRange.x;
				var yDetectingRange:Number = _npc.model.detectingRange.y;
				
				// If the player is within detecting range
				// If the player is within the left detecting range
				if (((playerRect.right < npcRect.right &&
					  npcRect.left - xDetectingRange < playerRect.right) ||
					// If the player is within the right detecting range
					(playerRect.left > npcRect.left &&
					 npcRect.right + xDetectingRange > playerRect.left)) &&
					// If the player is within up detecting range
					((playerRect.bottom < npcRect.bottom && playerRect.bottom > npcRect.top - yDetectingRange) ||
					 // If the player is within down detecting range
					 (playerRect.top > npcRect.top && playerRect.top < npcRect.bottom + yDetectingRange))) {
					
					// Attacking the player if possible
					var xAttackingRange:Number = _npc.model.attackingRange.x;
					var yAttackingRange:Number = _npc.model.attackingRange.y;
					
					// Offset of npc and player, converted to world's coordinate
					var npcOffset:FlxRect = new FlxRect(_npc.x,
														_npc.y,
														_npc.width, _npc.height);
					var playerOffset:FlxRect = PlayState.getInstance().playerOffset;
					
					// Is npc facing the player and the player is within the attacking
					// range
					if ((_npc.facing == FlxSprite.LEFT &&
						npcOffset.right - playerOffset.right > 0 &&
						npcOffset.left - playerOffset.right < xAttackingRange) ||
						(_npc.facing == FlxSprite.RIGHT &&
							playerOffset.left - npcOffset.left > 0 &&
							playerOffset.left - npcOffset.right < xAttackingRange)) {
						// Yes
						// Then stop moving and attack
						if (_npc.action != Action.ATTACKING)
							_npc.attack();
					} else {
						// No
						// Tracing the player
						
						// Is the player to the left of npc?
						if (playerRect.left < _npc.left)
							// Yes
							_npc.move(Direction.LEFT);
						else
							// No
							_npc.move(Direction.RIGHT);
					}
					
				// Else keep moving
				} else
					if ( _npc.facing == FlxSprite.LEFT ) {
//					// Will the npc goes beyond the left bound if keep moving left?
//					if ( _npc.x + _npc.velocity.x * FlxG.elapsed <= _leftXBound )
//						// Yes
//						// Reverse moving direction
//						_npc.move( Direction.RIGHT );
//					else
//						// No
						// Continue in the same direction
						_npc.move( Direction.LEFT );
				} else if ( _npc.facing == FlxSprite.RIGHT ) {
//					// Will the npc goes beyond the right bound if keep moving left?
//					if ( _npc.x + _npc.velocity.x * FlxG.elapsed >= _rightXBound )
//						// Yes
//						// Reverse moving direction
//						_npc.move( Direction.LEFT );
//					else
//						// No
						// Continue in the same direction
						_npc.move( Direction.RIGHT );
				}
			}
		}
	}
}