package be.swan.superjumper.sprites 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Stéphane Wantiez
	 */
	public class Bullet extends FlxSprite 
	{
		[Embed(source = '../../../../../art/bullet.png')]
		private var m_sprite : Class ;	
		
		public function Bullet() 
		{
			loadSprite();
			resetBullet();
		}
		
		private function resetBullet () : void
		{
			alive = false;
			exists = false;
			solid = false;
		}
		
		private function loadSprite() : void
		{
			loadGraphic(m_sprite, true, true);
		}
		
		override public function update () : void
		{
			if (alive)
			{
				if ( touching )
				{
					kill(); // if the bullet is touching anything solid, kill it
				}
				else if (( getScreenXY().x <= -64 ) || ( FlxG.width + 64 <= getScreenXY().x ))
				{
					kill();  // If the bullet makes it 64 pixels off the side of the screen, kill it
				}
			}
		}
		
		public function shoot( posX : Number, posY : Number, speedX : Number, speedY : Number ) : void
		{
			reset(posX, posY);
			solid = true;
			velocity.x = speedX;
			velocity.y = speedY;
		}
		
		override public function kill () : void
		{
			super.kill();
			resetBullet();
		}
		
	}

}