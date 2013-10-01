package be.swan.superjumper.utils 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Stéphane Wantiez
	 */
	public class MathUtils 
	{
		public static function getSquaredDistanceBetweenObjects(object1X:Number, object1Y:Number, object2X:Number, object2Y:Number ) : Number
		{
			var xPart : Number = object2X - object1X ;
			var yPart : Number = object2Y - object1Y ;
			return xPart * xPart + yPart * yPart;
		}
		
		public static function getDistanceBetweenObjects(object1X:Number, object1Y:Number, object2X:Number, object2Y:Number ) : Number
		{
			var squaredDistBetweenObjects : Number = getSquaredDistanceBetweenObjects(object1X, object1Y, object2X, object2Y);
			return Math.sqrt(squaredDistBetweenObjects);
		}
		
		public static function getSquaredDistanceBetweenSprites(object1:FlxSprite, object2:FlxSprite) : Number
		{
			return getSquaredDistanceBetweenObjects(object1.x, object1.y, object2.x, object2.y);
		}
		
		public static function getDistanceBetweenSprites(object1:FlxSprite, object2:FlxSprite) : Number
		{
			return getDistanceBetweenObjects(object1.x, object1.y, object2.x, object2.y);
		}
	}

}