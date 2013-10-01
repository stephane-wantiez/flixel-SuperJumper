//Code generated with DAME. http://www.dambots.com

package be.swan.superjumper
{
	import org.flixel.*;
	public class Level_ extends BaseLevel
	{
		//Embedded media...
		[Embed(source="mapCSV_Group1_Map1.csv", mimeType="application/octet-stream")] public var CSV_Group1Map1:Class;
		[Embed(source="../art/area02_level_tiles2.png")] public var Img_Group1Map1:Class;
		[Embed(source="mapCSV_Group1_Map1(2).csv", mimeType="application/octet-stream")] public var CSV_Group1Map1(2):Class;
		[Embed(source="../art/area02_level_tiles2.png")] public var Img_Group1Map1(2):Class;

		//Tilemaps
		public var layerGroup1Map1:FlxTilemap;
		public var layerGroup1Map1(2):FlxTilemap;

		//Sprites


		public function Level_(addToStage:Boolean = true, onAddSpritesCallback:Function = null)
		{
			// Generate maps.
			layerGroup1Map1 = new FlxTilemap;
			layerGroup1Map1.loadMap( new CSV_Group1Map1, Img_Group1Map1, 16,16, FlxTilemap.OFF, 0, 1, 1 );
			layerGroup1Map1.x = 0.000000;
			layerGroup1Map1.y = 0.000000;
			layerGroup1Map1.scrollFactor.x = 1.000000;
			layerGroup1Map1.scrollFactor.y = 1.000000;
			layerGroup1Map1(2) = new FlxTilemap;
			layerGroup1Map1(2).loadMap( new CSV_Group1Map1(2), Img_Group1Map1(2), 16,16, FlxTilemap.OFF, 0, 1, 1 );
			layerGroup1Map1(2).x = 0.000000;
			layerGroup1Map1(2).y = 0.000000;
			layerGroup1Map1(2).scrollFactor.x = 1.000000;
			layerGroup1Map1(2).scrollFactor.y = 1.000000;

			//Add layers to the master group in correct order.
			masterLayer.add(layerGroup1Map1);
			masterLayer.add(layerGroup1Map1(2));


			if ( addToStage )
			{
				FlxG.state.add(masterLayer);
			}

			mainLayer = layer;

			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 1600;
			boundsMaxY = 800;

		}


	}
}
