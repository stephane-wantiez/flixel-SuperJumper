package be.swan.superjumper.sprites 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Stéphane Wantiez
	 */
	public class Player extends FlxSprite 
	{
		private static const GRAVITY : int = 420 ;
		private static const RUN_SPEED : int = 80 ;
		private static const JUMP_SPEED : int = 250 ;
		private static const BULLET_SPEED : int = 200 ;
		private static const NB_BULLETS : int = 4 ;
		private static const FIRE_DELAY_SEC : int = 1 ;
		private static const SHOOTING_ANIM_DELAY : int = 1 ;
		
		private static const ANIM_IDLE : String = "idle" ;
		private static const ANIM_WALK : String = "walk" ;
		private static const ANIM_SHOOT : String = "shoot" ;
		
		[Embed(source = '../../../../../art/helmutguy.png')]
		private var m_sprite : Class ;
		[Embed(source = '../../../../../art/gibs.png')]
		private var m_gibsSprite : Class ;
		
		[Embed(source = '../../../../../art/jump.mp3')]
		private var m_soundJump : Class ;
		[Embed(source = '../../../../../art/shoot.mp3')]
		private var m_soundShoot : Class ;
		[Embed(source = '../../../../../art/death.mp3')]
		private var m_soundDeath : Class ;
		
		private var m_gibsEmitter : FlxEmitter ;
		private var m_bulletsGroup : FlxGroup ;
		
		private var m_timeSinceLastShootSec : Number = FIRE_DELAY_SEC ;
		private var m_justShooted : Boolean = false;
		
		public function Player(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			
			loadSprites();
			setupPhysics();
		}
		
		private function loadSprites() : void
		{
			loadGraphic(m_sprite, true, true);
			
			addAnimation(ANIM_IDLE, [0]);
			addAnimation(ANIM_SHOOT, [1]);
			addAnimation(ANIM_WALK, [1, 2], 12, true);
		}
		
		private function setupPhysics() : void
		{
			drag.x = RUN_SPEED * 8 ; // deceleration
			acceleration.y = GRAVITY ; // gravity
			maxVelocity.x = RUN_SPEED ;
			maxVelocity.y = JUMP_SPEED ;
		}
		
		public function setGibsEmitter ( gibsEmitter : FlxEmitter ) : void
		{
			m_gibsEmitter = gibsEmitter ;
			m_gibsEmitter.lifespan = 1 ;
			m_gibsEmitter.setXSpeed( -100, 100);
			m_gibsEmitter.setYSpeed( -100, 0 );
			m_gibsEmitter.setRotation( -720, 720 );
			m_gibsEmitter.gravity = GRAVITY / 2 ;
			m_gibsEmitter.makeParticles( m_gibsSprite, 50, 15, true, 0.5);
			m_gibsEmitter.bounce = 0.65;
		}
		
		public function setBulletsGroup ( bulletsGroup : FlxGroup ) : void
		{
			m_bulletsGroup = bulletsGroup ;
			
			for ( var i : int = 0 ; i < NB_BULLETS ; ++i )
			{
				m_bulletsGroup.add(new Bullet());
			}
		}
		
		override public function update () : void
		{
			m_timeSinceLastShootSec += FlxG.elapsed;
			m_justShooted = m_timeSinceLastShootSec < SHOOTING_ANIM_DELAY ;
			
			handleInputs();
			updatePlayerAnimation();
			super.update();
		}
		
		private function handleInputs () : void
		{			
			if (FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x = -drag.x;
			}
			else if (FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x = drag.x;
			}
			else
			{
				acceleration.x = 0 ;
			}
			
			if (FlxG.keys.UP && !velocity.y)
			{
				jump();
			}
			
			if (FlxG.keys.CONTROL)
			{
				shoot();
			}
		}
		
		private function jump () : void
		{
			velocity.y = -JUMP_SPEED;
			FlxG.play(m_soundJump);
		}
		
		private function shoot():void 
		{
			if ( canShoot() )
			{
				var bullet : Bullet = m_bulletsGroup.getFirstAvailable() as Bullet ;
				
				if (bullet)
				{
					shootBullet(bullet);
				}
			}
		}
		
		private function canShoot() : Boolean
		{
			return m_timeSinceLastShootSec >= FIRE_DELAY_SEC ;
		}
		
		private function shootBullet( bullet : Bullet ) : void
		{
			var bulletPosX : Number = facing == LEFT ? x-4 : x+4 ;
			var bulletPosY : Number = y + 4 ;
			var bulletSpeedX : Number = facing == LEFT ? -BULLET_SPEED : BULLET_SPEED ;
			var bulletSpeedY : Number = 0 ;
			bullet.shoot( bulletPosX, bulletPosY, bulletSpeedX, bulletSpeedY );
			
			m_timeSinceLastShootSec = 0;
			m_justShooted = true;
			
			FlxG.play(m_soundShoot);
		}
		
		private function updatePlayerAnimation () : void
		{
			if ( velocity.x || velocity.y )
			{
				play( ANIM_WALK );
			}
			else if ( m_justShooted )
			{
				play( ANIM_SHOOT );
			}
			else
			{
				play( ANIM_IDLE );
			}
		}
		
		public function touchedByEnemy ( enemy : Enemy ) : void
		{
			kill();
		}
		
		override public function kill () : void
		{
			if (!alive) return;
			super.kill();
			
			FlxG.shake();
			FlxG.flash(0xffDB3624, .35);
			
			FlxG.play(m_soundDeath, 1.2);
			
			m_gibsEmitter.at(this);
			m_gibsEmitter.start(true, 1);
		}
	}
}