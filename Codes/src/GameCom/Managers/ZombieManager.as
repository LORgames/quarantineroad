package GameCom.Managers {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Zombies.BlueZombie;
	import GameCom.GameComponents.Zombies.ExplosionZombie;
	import GameCom.GameComponents.Zombies.HulkZombie;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.GameComponents.Zombies.LimpZombie;
	import GameCom.GameComponents.Zombies.RedZombie;
	import GameCom.GameComponents.Zombies.SlowZombie;
	import GameCom.GameComponents.Zombies.ThrowUpZombie;
	import GameCom.GameComponents.Zombies.ZombieHand;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.ScoreHelper;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Paul
	 */
	public class ZombieManager {
		private var SPAWN_TIMEOUT:Number = 0.3333; // How many seconds before a zombie is added to the screen
		private var SPAWN_AVAILABLE:Number = 5.0; // How many seconds before a zombie is added to the available spawn list
		
		private var UsedZombies:Vector.<IZombie> = new Vector.<IZombie>();
		private var UnusedZombies:Vector.<IZombie> = new Vector.<IZombie>();
		
		private var ZombieTypes:Vector.<Class> = new Vector.<Class>();
		
		private var Players:Vector.<PlayerCharacter> = new Vector.<PlayerCharacter>();
		
		private var SpawnList:Array = new Array();
		
		private const TOTAL_ZOMBIES_ONSCREEN:int = 100;
		
		private var layer0:Sprite;
		private var layer1:Sprite;
		
		private var spawnTimeout:Number = 0;
		
		private const HAND_DELAY:Number = 2.5;
		private var handTimeout:Number = 0;
		
		private var surviveTime:int = 0;
		private var previousUpdate:int = 0;
		
		private var recycledSpawnLocation:b2Vec2 = new b2Vec2();
		
		public function ZombieManager(layer0:Sprite, layer1:Sprite) {
			this.layer0 = layer0;
			this.layer1 = layer1;
			
			SpawnList = SpawnList.concat(ZombieSpawns.Spawns);
			
			for (var i:int = 0; i < 20; i++) {
				UnusedZombies.push(new SlowZombie());
			}
			
			ZombieTypes.push(BlueZombie);
			ZombieTypes.push(ExplosionZombie);
			ZombieTypes.push(HulkZombie);
			ZombieTypes.push(LimpZombie);
			ZombieTypes.push(RedZombie);
			ZombieTypes.push(SlowZombie);
			ZombieTypes.push(ThrowUpZombie);
			
			surviveTime = getTimer();
		}
		
		public function AddPlayer(plr:PlayerCharacter):void {
			Players.push(plr);
		}
		
		public function Update(dt:Number):void {
			var totalTime:int = getTimer() - surviveTime;
			var i:int;
			var cls:Class;
			
			SPAWN_TIMEOUT -= dt * 7 / 15000;
			if (SPAWN_TIMEOUT < 0.1) SPAWN_TIMEOUT = 0.1;
			
			if (Math.random() < 0.015) {
				AudioController.PlaySound(AudioStore.GetZombieSound());
			}
			
			if (handTimeout > 0) {
				handTimeout -= dt;
			}
			
			if (totalTime > previousUpdate + SPAWN_AVAILABLE*1000) {
				if (SpawnList.length == 0) {
					//Spawning a random one
					if(UnusedZombies.length < 100) {
						cls = ZombieTypes[int(ZombieTypes.length * Math.random())];
					}
				} else {
					//Spawn from the list
					cls = (SpawnList.pop() as Class);
				}
				
				UnusedZombies.push(new cls());
				previousUpdate = totalTime;
			}
			
			while (UsedZombies.length < TOTAL_ZOMBIES_ONSCREEN && UnusedZombies.length > 0 && spawnTimeout <= 0) {
				var zombie:IZombie = UnusedZombies.splice(Math.random() * UnusedZombies.length, 1)[0];
				
				if (zombie is ZombieHand) {
					if (handTimeout > 0) {
						break;
					}
					
					(zombie as ZombieHand).SetPlayer(Players[int(Players.length * Math.random())]);
					handTimeout = HAND_DELAY;
				}
				
				recycledSpawnLocation.x = (Math.random() - 0.5) * Global.SCREEN_WIDTH / Global.PHYSICS_SCALE * 0.8;
				recycledSpawnLocation.y = Math.random() * -5 - 2;
				zombie.AddToScene(recycledSpawnLocation, layer0, layer1);
				
				UsedZombies.push(zombie);
				
				spawnTimeout = SPAWN_TIMEOUT;
				
				break;
			}
			
			for (i = 0; i < UsedZombies.length; i++) {
				UsedZombies[i].Update(dt);
				
				if (UsedZombies[i].OutsideScene()) {
					UsedZombies[i].RemoveFromScene(layer0, layer1);
					UnusedZombies.push(UsedZombies.splice(i, 1)[0]);
					i--;
				}
			}
			
			spawnTimeout -= dt;
		}
		
	}

}