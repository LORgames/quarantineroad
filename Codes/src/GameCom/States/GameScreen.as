package GameCom.States {
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.Decorations.VomitPuddle;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.GrenadeHelper;
	import GameCom.Helpers.ScoreHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BGManager;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.LootManager;
	import GameCom.Managers.ScenicManager;
	import GameCom.Managers.WorldManager;
	import GameCom.Managers.ZombieManager;
	import GameCom.SystemComponents.PauseScreen;
	import GameCom.SystemMain;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Stats;
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class GameScreen extends Sprite {
		// Playing the world
		private var simulating:Boolean = true;
		
		// Sprites to draw in to
		// worldSpr contains the 3 layers
		// groundLayer contains images drawn on the ground layer
		// objectLayer contains images drawn on the ground layer
		// roofLayer contains images drawn on the ground layer
		private var worldSpr:Sprite = new Sprite();
		
		private var groundLayer:Sprite = new Sprite();
		private var objectLayer:Sprite = new Sprite();
		private var skyLayer:Sprite = new Sprite();
		private var eyeLayer:Sprite = new Sprite();
		
		private var bgManager:BGManager;
		private var explosionManager:ExplosionManager;
		private var scenicManager:ScenicManager;
		private var zombies:ZombieManager;
		private var loot:LootManager;
		
		private var pauseScreen:PauseScreen = new PauseScreen(Unpause);
		
		private var gui:GUIManager;
		
		private var player:PlayerCharacter;
		
		private var lastUpdate:Number = 0;
		private var lastScrolled:int = 0;
		
		private var sc:SoundChannel;
		
		//olol toggle bool for mute
		private var pDown:Boolean = false;
		
		public static var EndOfTheLine_TerminateASAP:Boolean = false;
		
		public function GameScreen() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init);
			
			sc = AudioController.PlayLoop(AudioStore.Music);
		}
		
		private function Init(e:* = null):void {
			EndOfTheLine_TerminateASAP = false;
			WorldManager.CleanupDynamics();
			WorldManager.WorldShake = 0;
			
			ScoreHelper.Reset();
			
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			stage.focus = stage;
			
			//Clear out all the dead bodies
			VomitPuddle.Reset();
			WorldManager.CleanupDynamics();
			
			this.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			stage.addEventListener(Event.RESIZE, Resize, false, 0, true);
			
			this.addChild(worldSpr);
			
			worldSpr.addChild(groundLayer);
			worldSpr.addChild(objectLayer);
			worldSpr.addChild(skyLayer);
			worldSpr.addChild(eyeLayer);
			
			worldSpr.addChild(WorldManager.debugDrawLayer);
			
			gui = new GUIManager(Unpause, MockUpdate);
			this.addChild(gui);
			
			// player is added to objectLayer
			player = new PlayerCharacter(skyLayer);
			objectLayer.addChild(player);
			
			// bgManager (ground) is added to groundLayer
			bgManager = new BGManager(groundLayer);
			
			explosionManager = new ExplosionManager(eyeLayer, groundLayer);
			
			scenicManager = new ScenicManager(objectLayer);
			
			new BulletManager(objectLayer);
			new GrenadeHelper(objectLayer);
			
			zombies = new ZombieManager(objectLayer, eyeLayer);
			zombies.AddPlayer(player);
			
			loot = new LootManager(groundLayer);
			
			simulating = true;
			MockUpdate();
			
			WorldManager.WorldScrolled = 0;
			
			Stats.StartLevel();
			if (Stats.GetInt("Gameplays") >= 28) TrophyHelper.GotTrophyByName("28 Plays Later");
			
			Resize();
		}
		
		private function Update(e:Event):void {
			if (simulating) {
				//Update the objects
				player.Update(Global.TIME_STEP);
				zombies.Update(Global.TIME_STEP);
				loot.Update(Global.TIME_STEP);
				
				WorldManager.WorldScrolled += WorldManager.WorldScrollSpeed * Global.PHYSICS_SCALE * Global.TIME_STEP;
				
				//Add 1pt for every metre travelled
				if (lastScrolled + 1 < WorldManager.WorldScrolled / Global.PHYSICS_SCALE) {
					ScoreHelper.Score.AddValue(1);
					lastScrolled += 1;
				}
				
				//Add 1pt for every second playing
				lastUpdate += Global.TIME_STEP;
				ScoreHelper.Time.AddValue(Global.TIME_STEP);
				ScoreHelper.Distance.SetValue(WorldManager.WorldScrolled / Global.PHYSICS_SCALE);
				
				if (lastUpdate > 1) {
					lastUpdate -= 1;
					ScoreHelper.Score.AddValue(1);
				}
				
				BulletManager.I.Update(Global.TIME_STEP);
				GrenadeHelper.I.Update(Global.TIME_STEP);
				
				explosionManager.Update(Global.TIME_STEP);
				scenicManager.Update(Global.TIME_STEP);
				
				//Update the world
				WorldManager.World.Step(Global.TIME_STEP, Global.VELOCITY_ITERATIONS, Global.POSITION_ITERATIONS);
				WorldManager.World.ClearForces();
				
				if(stage) {
					worldSpr.x = Math.floor(WorldManager.WorldX + stage.stageWidth / 2) + (Math.random()-0.5)*WorldManager.WorldShake;
					//worldSpr.x = Global.SCREEN_WIDTH/2 + (Math.random()-0.5)*WorldManager.WorldShake;
					worldSpr.y = Math.floor(WorldManager.WorldY + stage.stageHeight / 2) + (Math.random()-0.5)*WorldManager.WorldShake;
				}
			}
			
			//Update the things that draw
			bgManager.Update();
			gui.Update();
			
			for (var i:int = 1; i < objectLayer.numChildren-1; i++) {
				if (objectLayer.getChildAt(i).y > objectLayer.getChildAt(i + 1).y) {
					objectLayer.swapChildrenAt(i, i + 1);
				}
				
				if (objectLayer.getChildAt(i-1).y > objectLayer.getChildAt(i).y) {
					objectLayer.swapChildrenAt(i-1, i);
				}
			}
			
			if(Global.DRAW_PHYSICS_ALWAYS || (Keys.isKeyDown(Keyboard.B) && Keys.isKeyDown(Keyboard.U) && Keys.isKeyDown(Keyboard.G))) {
				WorldManager.World.DrawDebugData();
			} else {
				WorldManager.debugDrawLayer.graphics.clear();
			}
			
			//Pause/Unpause
			if (pDown && !Keys.isKeyDown(Keyboard.P)) {
				simulating = !simulating;
				
				if (simulating) {
					if (pauseScreen.parent == this) {
						this.removeChild(pauseScreen);
					}
				} else {
					this.addChild(pauseScreen);
				}
			}
			pDown = Keys.isKeyDown(Keyboard.P);
			
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0, 0, (stage.stageWidth - Global.SCREEN_WIDTH) / 2, stage.stageHeight);
			this.graphics.drawRect((stage.stageWidth + Global.SCREEN_WIDTH) / 2, 0, (stage.stageWidth - Global.SCREEN_WIDTH) / 2, stage.stageHeight);
			this.graphics.endFill();
			
			if (EndOfTheLine_TerminateASAP) {
				simulating = false;
				Cleanup();
				Stats.EndLevel();
				SystemMain.instance.StateTo(new EndGame());
			}
		}
		
		public function MockUpdate():void {
			WorldManager.World.Step(0, Global.VELOCITY_ITERATIONS, Global.POSITION_ITERATIONS);
			WorldManager.World.ClearForces();
			
			//Update the objects
			player.Update(0);
			
			worldSpr.x = Math.floor(WorldManager.WorldX + stage.stageWidth / 2);
			worldSpr.y = Math.floor(WorldManager.WorldY + stage.stageHeight / 2);
		}
		
		private function Cleanup():void {
			worldSpr = null;
			
			groundLayer = null;
			objectLayer = null;
			
			bgManager = null;
			
			gui = null;
			
			player = null;
			
			simulating = false;
			
			if(sc != null) sc.stop();
			
			this.removeEventListener(Event.ENTER_FRAME, Update);
			stage.removeEventListener(Event.RESIZE, Resize);
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		private function Resize(e:Event = null):void {
			WorldManager.WorldY = -stage.stageHeight / 2;
			WorldManager.UpdateWalls(stage.stage);
			
			worldSpr.x = Math.floor(WorldManager.WorldX + stage.stageWidth / 2);
			worldSpr.y = Math.floor(WorldManager.WorldY + stage.stageHeight / 2);
			
			var m:Matrix = new Matrix();
			m.createGradientBox(Global.SCREEN_WIDTH, stage.stageHeight / 3, Math.PI / 2, -Global.SCREEN_WIDTH / 2, 0);
			
			eyeLayer.graphics.clear();
			
			eyeLayer.graphics.beginFill(0x231722, 0.8);
			eyeLayer.graphics.drawRect( -Global.SCREEN_WIDTH / 2, -100, Global.SCREEN_WIDTH, 100);
			eyeLayer.graphics.endFill();
			
			eyeLayer.graphics.beginGradientFill(GradientType.LINEAR, [0x231722, 0x231722], [0.8, 0.0], [0, 255], m);
			eyeLayer.graphics.drawRect( -Global.SCREEN_WIDTH / 2, 0, Global.SCREEN_WIDTH, stage.stageHeight / 3);
			eyeLayer.graphics.endFill();
			
			m.createGradientBox(Global.SCREEN_WIDTH/2, stage.stageHeight, 0, -Global.SCREEN_WIDTH / 2, 0);
			eyeLayer.graphics.beginGradientFill(GradientType.LINEAR, [0x333366, 0x333366], [0.333, 0], [0, 255], m, "reflect");
			eyeLayer.graphics.drawRect( -Global.SCREEN_WIDTH / 2, 0, Global.SCREEN_WIDTH, stage.stageHeight);
			eyeLayer.graphics.endFill();
			
			GUIManager.I.Resize();
		}
		
		public function Unpause():void {
			this.removeChild(pauseScreen);
			stage.focus = this;
			simulating = true;
		}
	}
}