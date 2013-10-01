package be.swan.superjumper.loader 
{
	import org.flixel.system.FlxPreloader;
	
	/**
	 * ...
	 * @author Stéphane Wantiez
	 */
	public class Preloader extends FlxPreloader 
	{
		
		public function Preloader() 
		{
			className = "be.swan.superjumper.Jumper";
			super();
		}
		
	}

}