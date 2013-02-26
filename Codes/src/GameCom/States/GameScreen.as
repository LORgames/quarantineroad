package GameCom.States {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.WorldManager;
	import GameCom.SystemMain;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import GameCom.Managers.BGManager;
	import LORgames.Engine.Logger;
	import LORgames.Engine.MessageBox;
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
		
		private var bgManager:BGManager;
		private var explosionManager:ExplosionManager;
		
		private var gui:GUIManager;
		
		private var player:PlayerCharacter;
		
		private var lastUpdate:int = 0;
		
		//olol toggle bool for mute
		private var mDown:Boolean = false;
		
		public static var EndOfTheLine_TerminateASAP:Boolean = false;
		
		public function GameScreen() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:* = null):void {
			EndOfTheLine_TerminateASAP = false;
			
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			stage.focus = stage;
			
			//Clear out all the dead bodies
			WorldManager.CleanupDynamics();
			
			this.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			stage.addEventListener(Event.RESIZE, Resize, false, 0, true);
			
			this.addChild(worldSpr);
			
			worldSpr.addChild(groundLayer);
			worldSpr.addChild(objectLayer);
			
			worldSpr.addChild(WorldManager.debugDrawLayer);
			
			// player is added to objectLayer
			player = new PlayerCharacter();
			objectLayer.addChild(player);
			
			// bgManager (ground) is added to groundLayer
			bgManager = new BGManager(groundLayer);
			
			gui = new GUIManager(Pause, MockUpdate);
			this.addChild(gui);
			
			explosionManager = new ExplosionManager(objectLayer);
			
			//player.Respawn();
			
			simulating = true;
			MockUpdate();
			
			Resize();
		}
		
		private function Update(e:Event):void {
			if (simulating) {
				WorldManager.World.Step(Global.TIME_STEP, Global.VELOCITY_ITERATIONS, Global.POSITION_ITERATIONS);
				WorldManager.World.ClearForces();
				
				//Update the objects
				player.Update(Global.TIME_STEP);
				
				explosionManager.Update();
				
				if(stage) {
					worldSpr.x = Math.floor(WorldManager.WorldX + stage.stageWidth / 2);
					worldSpr.y = Math.floor(WorldManager.WorldY + stage.stageHeight / 2);
				}
			}
			
			//Update the things that draw
			bgManager.Update();
			
			gui.Update();
			
			if(Global.DRAW_PHYSICS_ALWAYS || (Keys.isKeyDown(Keyboard.B) && Keys.isKeyDown(Keyboard.U) && Keys.isKeyDown(Keyboard.G))) {
				WorldManager.World.DrawDebugData();
			} else {
				WorldManager.debugDrawLayer.graphics.clear();
			}
			
			if (mDown && !Keys.isKeyDown(Keyboard.Q)) {
				AudioController.SetMuted(!AudioController.GetMuted());
			}
			mDown = Keys.isKeyDown(Keyboard.Q);
			
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0, 0, (stage.stageWidth - Global.SCREEN_WIDTH) / 2, stage.stageHeight);
			this.graphics.drawRect((stage.stageWidth + Global.SCREEN_WIDTH) / 2, 0, (stage.stageWidth - Global.SCREEN_WIDTH) / 2, stage.stageHeight);
			this.graphics.endFill();
			
			if (EndOfTheLine_TerminateASAP) {
				Cleanup();
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
		
		private function Pause():void {
			simulating = !simulating;
		}
		
		private function Cleanup():void {
			worldSpr = null;
			
			groundLayer = null;
			objectLayer = null;
			
			bgManager = null;
			
			gui = null;
			
			player = null;
			
			simulating = false;
			
			this.removeEventListener(Event.ENTER_FRAME, Update);
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		private function Resize(e:Event = null):void {
			trace(stage.stageHeight);
			WorldManager.WorldY = -stage.stageHeight / 2;
			WorldManager.UpdateWalls(stage.stage);
		}
	}
}