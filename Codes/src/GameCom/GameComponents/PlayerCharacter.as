package GameCom.GameComponents 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import GameCom.GameComponents.Decorations.Grenade;
	import GameCom.GameComponents.Loot.LootDrop;
	import GameCom.GameComponents.Weapons.BasicGun;
	import GameCom.GameComponents.Weapons.ChainLightningGun;
	import GameCom.GameComponents.Weapons.Flamethrower;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.GameComponents.Weapons.LaserGun;
	import GameCom.GameComponents.Weapons.RocketLauncher;
	import GameCom.GameComponents.Weapons.Shotgun;
	import GameCom.GameComponents.Weapons.SMG;
	import GameCom.GameComponents.Weapons.Sniper;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Helpers.GrenadeHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.WorldManager;
	import GameCom.States.GameScreen;
	import LORgames.Engine.Keys;
	import LORgames.Engine.MessageBox;
	/**
	 * ...
	 * @author Paul
	 */
	public class PlayerCharacter extends Sprite implements IHit {
		public var body:b2Body;
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		private var MOVEMENT_SPEED:Number = 3.6;
		
		private var weapons:Vector.<IWeapon> = new Vector.<IWeapon>();
		private var activeWeapon:int = 0;
		
		private var myHP:int = 10;
		
		private var time:int = -1;
		private var startTime:int = 0;
		
		private var immunityTime:int = 0;
		private const IMMUNITY_TIME:int = 750;
		
		private var weaponsLayer:Sprite;
		private var top:Sprite = new Sprite();
		
		public function PlayerCharacter(weaponsLayer:Sprite) {
			this.weaponsLayer = weaponsLayer;
			
			if (this.stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addChild(SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("Player/player shadow.png")));
			this.getChildAt(0).y = 7;
			
			animation.AddFrame(ThemeManager.Get("Player/Legs/0_0.png"));
			animation.AddFrame(ThemeManager.Get("Player/Legs/0_1.png"));
			animation.AddFrame(ThemeManager.Get("Player/Legs/0_2.png"));
			animation.AddFrame(ThemeManager.Get("Player/Legs/0_3.png"));
			animation.AddFrame(ThemeManager.Get("Player/Legs/0_4.png"));
			animation.AddFrame(ThemeManager.Get("Player/Legs/0_5.png"));
			animation.ChangePlayback(0.1, 0, 6);
			animation.Update(0);
			
			this.addChild(animation);
			
			body = BodyHelper.GetGenericCircle(0.6, Global.PHYSICS_CATEGORY_PLAYER, this);
			body.SetFixedRotation(true);
			body.SetLinearDamping(0.5);
			
			weapons.push(new BasicGun(body));
			weapons.push(new SMG(body));
			weapons.push(new Shotgun(body));
			weapons.push(new Sniper(body));
			weapons.push(new LaserGun(body, weaponsLayer));
			weapons.push(new ChainLightningGun(body, weaponsLayer));
			weapons.push(new Flamethrower(body));
			weapons.push(new RocketLauncher(body));
			
			weapons[activeWeapon].Activate();
			GUIManager.I.AddWeapons(weapons);
			
			this.addChild(top);
			top.x = -10;
			top.y = -50;
			
			top.graphics.clear();
			top.graphics.beginBitmapFill(weapons[activeWeapon].GetPlayerBody());
			top.graphics.drawRect(0, 0, 21, 38);
			top.graphics.endFill();
			
			startTime = getTimer();
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			WorldManager.WorldTargetX = this.x;
			WorldManager.WorldTargetY = this.y;
			
			WorldManager.WorldScrollSpeed = ((stage.stageHeight - this.y) / stage.stageHeight) * 4 + 1;
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.6 * Global.PHYSICS_SCALE;
			
			var newEquipedWeapon:int = activeWeapon;
			
			if (activeWeapon == -1) activeWeapon = 0;
			
			if (Keys.isKeyDown(Keyboard.NUMBER_1)) {
				newEquipedWeapon = 0; // Pistols
			} else if (Keys.isKeyDown(Keyboard.NUMBER_2)) {
				newEquipedWeapon = 1; // SMGs
			} else if (Keys.isKeyDown(Keyboard.NUMBER_3)) {
				newEquipedWeapon = 2; // Shotguns
			} else if (Keys.isKeyDown(Keyboard.NUMBER_4)) {
				newEquipedWeapon = 3; // Sniper
			} else if (Keys.isKeyDown(Keyboard.NUMBER_5)) {
				newEquipedWeapon = 4; // Laser
			} else if (Keys.isKeyDown(Keyboard.NUMBER_6)) {
				newEquipedWeapon = 5; // Chain Lightning
			} else if (Keys.isKeyDown(Keyboard.NUMBER_7)) {
				newEquipedWeapon = 6; // Flamethrower
			} else if (Keys.isKeyDown(Keyboard.NUMBER_8)) {
				newEquipedWeapon = 7; // Rocket Launcher
			} /*else if (Keys.isKeyDown(Keyboard.SPACE)) {
				GrenadeHelper.I.SpawnGrenade(this.x, this.y);
			}*/
			
			if (newEquipedWeapon != activeWeapon) {
				weapons[activeWeapon].Deactivate();
				activeWeapon = newEquipedWeapon;
				weapons[activeWeapon].Activate();
				
				GUIManager.I.RedrawWeapons();
				
				top.graphics.clear();
				top.graphics.beginBitmapFill(weapons[activeWeapon].GetPlayerBody());
				top.graphics.drawRect(0, 0, 21, 38);
				top.graphics.endFill();
			}
			
			weapons[activeWeapon].Update(dt, new b2Vec2(0.3 + body.GetPosition().x, -1 + body.GetPosition().y));
			
			var xSpeed:Number = 0;
			var ySpeed:Number = 0;
			
			if (Keys.isKeyDown(Keyboard.W) || Keys.isKeyDown(Keyboard.UP)) {
				ySpeed = -1.5;
			} else if (Keys.isKeyDown(Keyboard.S) || Keys.isKeyDown(Keyboard.DOWN)) {
				ySpeed = 0.75;
			}
			
			if (Keys.isKeyDown(Keyboard.A) || Keys.isKeyDown(Keyboard.LEFT)) {
				xSpeed = -5;
			} else if (Keys.isKeyDown(Keyboard.D) || Keys.isKeyDown(Keyboard.RIGHT)) {
				xSpeed = 5;
			}
			
			if (xSpeed != 0 || ySpeed != 0) {
				animation.Update(dt);
			}
			
			if (getTimer() < immunityTime) {
				animation.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2)];
				top.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2)];
			} else {
				animation.filters = [];
				top.filters = [];
			}
			
			body.SetLinearVelocity(new b2Vec2(xSpeed * MOVEMENT_SPEED, ySpeed * MOVEMENT_SPEED + WorldManager.WorldScrollSpeed));
			
			var contact:b2ContactEdge = body.GetContactList();
			
			while (contact != null) {
				if(contact.contact.IsTouching()) {
					if (contact.other.GetUserData() is LootDrop) {
						(contact.other.GetUserData() as LootDrop).Pickup(weapons, this);
					} else if (contact.other.GetUserData() is IZombie) {
						Hit((contact.other.GetUserData() as IZombie).HitPlayer(this));
					}
				}
				
				contact = contact.next;
			}
		}
		
		public function Hit(damage:Number):Boolean {
			if (damage < 0) { //Heal
				if (myHP == 1) {
					TrophyHelper.GotTrophyByName("Close Call");
				}
				
				myHP -= damage
				myHP = Math.min(myHP, 10);
				
				GUIManager.I.Hearts.SetHealth(myHP);
			} else if(getTimer() > immunityTime) {
				myHP -= damage;
				GUIManager.I.Hearts.SetHealth(myHP);
				
				if (myHP <= 0 && time == -1) {
					time = 1;
					GameScreen.EndOfTheLine_TerminateASAP = true;
				}
				
				//Immune if you got hurt
				if(damage > 0) immunityTime = getTimer() + IMMUNITY_TIME;
			}
			
			return false;
		}
		
	}

}