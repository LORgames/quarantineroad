package GameCom.Managers {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Zombies.ExplosionZombie;
	import GameCom.GameComponents.Zombies.HulkZombie;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.GameComponents.Zombies.LimpZombie;
	import GameCom.GameComponents.Zombies.SlowZombie;
	import GameCom.GameComponents.Zombies.ThrowUpZombie;
	import GameCom.GameComponents.Zombies.ZombieHand;
	import GameCom.Helpers.AudioStore;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Paul
	 */
	public class ZombieManager {
		private var UsedZombies:Vector.<IZombie> = new Vector.<IZombie>();
		private var UnusedZombies:Vector.<IZombie> = new Vector.<IZombie>();
		
		private var ZombieTypes:Vector.<Class> = new Vector.<Class>();
		
		private var Players:Vector.<PlayerCharacter> = new Vector.<PlayerCharacter>();
		
		private const TOTAL_ZOMBIES_ONSCREEN:int = 100;
		
		private var layer0:Sprite;
		private var layer1:Sprite;
		
		private var spawnTimeout:int = 0;
		
		private var surviveTime:int = 0;
		private var previousUpdate:int = 0;
		
		public function ZombieManager(layer0:Sprite, layer1:Sprite) {
			this.layer0 = layer0;
			this.layer1 = layer1;
			
			for (var i:int = 0; i < 1; i++) {
				UnusedZombies.push(new HulkZombie());
			}
			
			ZombieTypes.push(SlowZombie);
			ZombieTypes.push(LimpZombie);
			ZombieTypes.push(ExplosionZombie);
			ZombieTypes.push(ExplosionZombie);
			ZombieTypes.push(ExplosionZombie);
			ZombieTypes.push(ExplosionZombie);
			ZombieTypes.push(HulkZombie);
			ZombieTypes.push(HulkZombie);
			ZombieTypes.push(ThrowUpZombie);
			ZombieTypes.push(ZombieHand);
			
			surviveTime = getTimer();
		}
		
		public function AddPlayer(plr:PlayerCharacter):void {
			Players.push(plr);
		}
		
		public function Update(dt:Number):void {
			var totalTime:int = getTimer() - surviveTime;
			var i:int;
			var cls:Class;
			
			if (Math.random() < 0.025) {
				AudioController.PlaySound(AudioStore.GetZombieSound());
			}
			
			if (totalTime > 6000 && previousUpdate < 6000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new LimpZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 12000 && previousUpdate < 12000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new SlowZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 18000 && previousUpdate < 18000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new LimpZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 24000 && previousUpdate < 24000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new SlowZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 30000 && previousUpdate < 30000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new LimpZombie());
				
				cls = ZombieTypes[int(ZombieTypes.length * Math.random())];
				UnusedZombies.push(new cls());
				
				previousUpdate = totalTime;
			} else if (totalTime > 36000 && previousUpdate < 36000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new SlowZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 42000 && previousUpdate < 42000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new LimpZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 48000 && previousUpdate < 48000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new SlowZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 54000 && previousUpdate < 54000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new LimpZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 60000 && previousUpdate < 60000) {
				for (i = 0; i < 9; i++) UnusedZombies.push(new SlowZombie());
				previousUpdate = totalTime;
			} else if (totalTime > 60000 && totalTime > previousUpdate + 5000) {
				cls = ZombieTypes[int(ZombieTypes.length * Math.random())];
				UnusedZombies.push(new cls());
				previousUpdate = totalTime;
			}
			
			if (UsedZombies.length < TOTAL_ZOMBIES_ONSCREEN && UnusedZombies.length > 0 && spawnTimeout <= 0) {
				var zombie:IZombie = UnusedZombies.splice(Math.random() * UnusedZombies.length, 1)[0];
				
				if (zombie is ZombieHand) {
					(zombie as ZombieHand).SetPlayer(Players[int(Players.length*Math.random())]);
				}
				
				zombie.AddToScene(new b2Vec2((Math.random() - 0.5) * Global.SCREEN_WIDTH / Global.PHYSICS_SCALE * 0.9, Math.random() * -20), layer0, layer1);
				
				UsedZombies.push(zombie);
				
				spawnTimeout = 3;
			}
			
			for (i = 0; i < UsedZombies.length; i++) {
				UsedZombies[i].Update(dt);
				
				if (UsedZombies[i].OutsideScene()) {
					UsedZombies[i].RemoveFromScene(layer0, layer1);
					
					UnusedZombies.push(UsedZombies.splice(i, 1)[0]);
					i--;
				}
			}
			
			spawnTimeout--;
		}
		
	}

}