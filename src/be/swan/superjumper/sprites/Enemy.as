package be.swan.superjumper.sprites 
{
	import org.flixel.*;
	import be.swan.superjumper.utils.*;
	
	/**
	 * ...
	 * @author Stéphane Wantiez
	 */
	public class Enemy extends FlxSprite 
	{
		private static const GRAVITY : int = 0 ;
		private static const RUN_SPEED : int = 80 ;
		private static const JUMP_SPEED : int = 250 ;
		private static const DETECT_DIST_TILES : int = 10 ;
		private static const DETECT_DIST_PIX : int = DETECT_DIST_TILES * 16 ;
		private static const DETECT_DIST_PIX_SQUARED : int = DETECT_DIST_PIX * DETECT_DIST_PIX ;
		
		private static const ANIM_IDLE : String = "idle" ;
		private static const ANIM_WALK : String = "walk" ;
		
		[Embed(source = '../../../../../art/monsta.png')]
		private var m_sprite : Class ;
		[Embed(source = '../../../../../art/death.mp3')]
		private var m_soundDeath : Class ;
		private var m_player : Player ;
		private var m_gibsEmitter : FlxEmitter ;
		
		public function Enemy( X:Number, Y:Number, player:Player, gibsEmitter : FlxEmitter ) 
		{
			super(X, Y);
			
			m_player = player;
			m_gibsEmitter = gibsEmitter ;
			
			health = 1 ;
			
			loadSprite();
			setupPhysics();
		}
		
		private function loadSprite() : void
		{
			loadGraphic(m_sprite, true, true);
			addAnimation(ANIM_IDLE, [0]);
			addAnimation(ANIM_WALK, [0,1], 10, true);
		}
		
		private function setupPhysics() : void
		{
			drag.x = RUN_SPEED * 7 ; // deceleration
			drag.y = JUMP_SPEED * 7 ; // deceleration
			acceleration.y = GRAVITY ; // gravity
			maxVelocity.x = RUN_SPEED ;
			maxVelocity.y = JUMP_SPEED ;
		}
		
		override public function update () : void
		{
			updateEnemyAI();
			updateEnemyAnimation();
			super.update();
		}
		
		private function updateEnemyAI () : void
		{
			var squaredDistToPlayer : Number = MathUtils.getSquaredDistanceBetweenSprites(this, m_player);
			
			if ( squaredDistToPlayer <= DETECT_DIST_PIX_SQUARED )
			{
				chasePlayer();
			}
		}
		
		private function chasePlayer () : void
		{
			if ( m_player.x < x )
			{
				facing = RIGHT ;
				acceleration.x = -drag.x ;
			}
			else if ( m_player.x > x )
			{
				facing = LEFT ;
				acceleration.x = drag.x ;
			}
			
			if ( m_player.y < y )
			{
				acceleration.y = -drag.y ;
			}
			else if ( m_player.y > y )
			{
				acceleration.y = drag.y ;
			}
		}
		
		private function updateEnemyAnimation () : void
		{
			play( velocity.x || velocity.y ? ANIM_WALK : ANIM_IDLE );
		}
		
		public function hitByBullet () : void
		{
			hurt(1);
		}
		
		override public function kill () : void
		{
			if (!alive) return;
			super.kill();
			
			FlxG.play(m_soundDeath, 1.2);
			
			m_gibsEmitter.at(this);
			m_gibsEmitter.start(true, 1);
		}
		
	}

}