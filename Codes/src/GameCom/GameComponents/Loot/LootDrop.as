package GameCom.GameComponents.Loot 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class LootDrop extends Sprite {
		private var body:b2Body;
		private var speed:b2Vec2 = new b2Vec2();
		
		protected var pickedUP:Boolean = false;
		
		protected var back:Bitmap;
		protected var item:Sprite = new Sprite();
		protected var anim:AnimatedSprite;
		
		private var updateTime:Number = 0;
		
		public function LootDrop() {
			body = BodyHelper.GetGenericCircle(0.75, Global.PHYSICS_CATEGORY_LOOT, this);
			body.GetFixtureList().SetSensor(true);
			body.SetActive(false);
			
			back = new Bitmap(ThemeManager.Get("Loot/under.png"));
			anim = LootDrop.GetAnimatedOverlay()
			
			back.x = -43;
			back.y = -71;
			
			anim.x = -43;
			anim.y = -71;
			
			this.addChild(back);
			this.addChild(item);
			this.addChild(anim);
		}
		
		public function Update(dt:Number):void {
			speed.y = WorldManager.WorldScrollSpeed;
			body.SetLinearVelocity(speed);
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			anim.Update(dt);
			
			updateTime += dt;
			item.y = -5 * Math.sin(updateTime*2) - 5;
		}
		
		public function Reassign(location:b2Vec2):void {
			body.SetPosition(location);
			body.SetActive(true);
			
			pickedUP = false;
			
			Update(0);
		}
		
		public function Deactivate():void {
			body.SetActive(false);
			body.SetPositionAndAngleXY( -50, 0, 0);
		}
		
		public function ShouldDeactivate():Boolean {
			if (pickedUP) return true;
			return (this.y > stage.stageHeight + 50);
		}
		
		public function Pickup(equipment:Vector.<IWeapon>, player:PlayerCharacter):void {
			pickedUP = true;
		}
		
		protected static function GetAnimatedOverlay():AnimatedSprite {
			var animation:AnimatedSprite = new AnimatedSprite();
			
			animation.AddFrame(ThemeManager.Get("Loot/over00.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over01.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over02.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over03.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over04.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over05.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over06.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over07.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over08.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over09.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over10.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over11.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over12.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over13.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over14.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over15.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over16.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over17.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over18.png"));
			animation.AddFrame(ThemeManager.Get("Loot/over19.png"));
			
			animation.ChangePlayback(0.05, 0, 20);
			animation.Update(0);
			
			return animation;
		}
	}

}