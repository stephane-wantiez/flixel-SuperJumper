package be.swan.superjumper 
{
	import be.swan.superjumper.sprites.Bullet;
	import be.swan.superjumper.sprites.Enemy;
	import be.swan.superjumper.sprites.Player;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Stéphane Wantiez
	 */
	public class PlayerState extends FlxState 
	{
		private static const NEW_GAME_DELAY : int = 3 ;
		
		[Embed(source = '../../../../levels/mapCSV_Group1_Back.csv', mimeType = 'application/octet-stream')]
		private var m_levelBackCsv : Class ;
		[Embed(source = '../../../../levels/mapCSV_Group1_Map.csv', mimeType = 'application/octet-stream')]
		private var m_levelMapCsv : Class ;		
		[Embed(source = '../../../../art/area02_level_tiles2.png')]
		private var m_levelTiles : Class ;		
		[Embed(source = '../../../../art/music_caverns.mp3')]
		private var m_musicCaverns : Class ;
		
		private var m_levelTileMap : FlxTilemap = new FlxTilemap;
		private var m_backTileMap : FlxTilemap = new FlxTilemap;
		
		private var m_player : Player;
		private var m_bullets : FlxGroup;
		private var m_enemies : FlxGroup;
		private var m_gibsEmitter : FlxEmitter;
		private var m_timeSinceDeath : Number = 0 ;
		
		override public function create () : void
		{
			loadMap();
			loadPlayer();
			addEnemies();
			initCamera();
			loadMusic();
			
			super.create();
		}
		
		private function loadMap() : void
		{
			m_levelTileMap.loadMap(new m_levelMapCsv,  m_levelTiles, 16, 16);
			 m_backTileMap.loadMap(new m_levelBackCsv, m_levelTiles, 16, 16, FlxTilemap.OFF, 0, 1, 999);
			
			add(m_levelTileMap);
			add( m_backTileMap);
		}
		
		private function loadPlayer() : void
		{
			m_player = new Player(10, 500);
			add(m_player);
			
			m_gibsEmitter = new FlxEmitter();
			m_player.setGibsEmitter(m_gibsEmitter);
			add(m_gibsEmitter);
			
			m_bullets = new FlxGroup();
			m_player.setBulletsGroup(m_bullets);
			add(m_bullets);
		}
		
		private function addEnemies() : void
		{
			m_enemies = new FlxGroup();
			m_enemies.add(new Enemy(700, 650, m_player, m_gibsEmitter));
			m_enemies.add(new Enemy(500, 650, m_player, m_gibsEmitter));
			m_enemies.add(new Enemy(600, 600, m_player, m_gibsEmitter));
			m_enemies.add(new Enemy(800, 700, m_player, m_gibsEmitter));
			add(m_enemies);
		}
		
		private function initCamera() : void
		{
			FlxG.camera.follow(m_player);
			FlxG.worldBounds.x = 0 ;
			FlxG.worldBounds.y = 0 ;
			FlxG.worldBounds.width = 1600;
			FlxG.worldBounds.height = 800;
			FlxG.bgColor = 0xFFBBE3EC;
		}
		
		private function loadMusic() : void
		{
			FlxG.playMusic(m_musicCaverns, 0.5);
		}
		
		override public function update () : void
		{
			checkCollisions();
			checkPlayer();
			super.update();
		}
		
		private function checkCollisions () : void
		{
			FlxG.collide(m_player, m_levelTileMap);
			FlxG.collide(m_bullets, m_levelTileMap);
			FlxG.collide(m_player, m_enemies, playerHitByEnemy);
			FlxG.collide(m_enemies, m_bullets, enemyHitByBullet);
		}
		
		private function playerHitByEnemy ( player : Player, enemy : Enemy ) : void
		{
			player.touchedByEnemy(enemy);
		}
		
		private function enemyHitByBullet ( enemy : Enemy, bullet : Bullet ) : void
		{
			enemy.hitByBullet();
		}
		
		private function checkPlayer() : void
		{
			if (!m_player.alive)
			{
				m_timeSinceDeath += FlxG.elapsed;
				
				if (m_timeSinceDeath >= NEW_GAME_DELAY)
				{
					FlxG.resetGame();
				}
			}
			else
			{
				m_timeSinceDeath = 0;
			}
		}
	}

}