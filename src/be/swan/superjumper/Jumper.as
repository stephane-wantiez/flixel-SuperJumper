package be.swan.superjumper 
{
	import org.flixel.*;
	
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	[Frame(factoryClass="be.swan.superjumper.loader.Preloader")]
	
	/**
	 * ...
	 * @author Stéphane Wantiez
	 */
	public class Jumper extends FlxGame 
	{
		
		public function Jumper() 
		{
			super(640, 480, PlayerState, 1);
		}
		
	}

}