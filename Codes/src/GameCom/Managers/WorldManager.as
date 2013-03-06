package GameCom.Managers {
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.display.Stage;
	import GameCom.GameComponents.IHit;
	import GameCom.SystemComponents.WeaponUIPanel;
	/**
	 * ...
	 * @author Paul
	 */
	public class WorldManager {
		
		public static var World:b2World;
		public static var debugDrawLayer:Sprite = new Sprite();
		
		public static var WorldX:Number = 0;
		public static var WorldY:Number = 0;
		public static var WorldScrolled:Number = 0;
		
		public static var WorldTargetX:Number = 0;
		public static var WorldTargetY:Number = 0;
		
		public static var WorldShake:Number = 0;
		
		public static var WorldScrollSpeed:Number = 1; // 1m/s
		
		private static var roofBody:b2Body;
		private static var wallsBody:b2Body;
		private static var floorBody:b2Body;
		
		public static function Initialize():void {
			//Start the system
			World = new b2World(new b2Vec2(0, 0), true);
			
			CreatePlayerWalls();
			
			// set debug draw
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(debugDrawLayer);
			dbgDraw.SetDrawScale(Global.PHYSICS_SCALE);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			World.SetDebugDraw(dbgDraw);
		}
		
		//Ballsy expensive to call
		public static function CleanupDynamics():void {
			var body:b2Body = World.GetBodyList();
			
			while (body != null) {
				if (body.GetType() == b2Body.b2_dynamicBody || body.GetType() == b2Body.b2_kinematicBody) {
					World.DestroyBody(body);
				}
				
				body = body.GetNext();
			}
		}
		
		private static var bodies:Vector.<b2Fixture>
        private static function ExplosionSearch(fix:b2Fixture):Boolean {
            if (!fix.IsSensor() && fix.GetBody().GetType() == b2Body.b2_dynamicBody) {
                bodies.push(fix);
            }
			
            return true;
        }
		
		public static function Explode(position:b2Vec2, radius:Number, strength:Number):void {
			var aabb:b2AABB = new b2AABB();
			
			var vMin:b2Vec2 = position.Copy();
			vMin.Subtract(new b2Vec2(radius, radius));
			
			var vMax:b2Vec2 = position.Copy();
			vMax.Add(new b2Vec2(radius, radius));
			
			aabb.lowerBound = vMin;
			aabb.upperBound = vMax;
			
			bodies = new Vector.<b2Fixture>();
			World.QueryAABB(ExplosionSearch, aabb);
			
			var b:b2Body;
			var forceVec:b2Vec2;
			
			for (var i:int = 0; i < bodies.length; i++) {
				b = bodies[i].GetBody();
				
				forceVec = b.GetWorldCenter().Copy();
				
				forceVec.Subtract(position);
				
				forceVec.Normalize();
				forceVec.Multiply(strength);
				
				b.SetAwake(true);
				b.ApplyForce(forceVec, b.GetWorldCenter());
				
				if (b.GetUserData() is IHit) {
					(b.GetUserData() as IHit).Hit(1*strength/100);
				}
			}
		}
		
		public static function UpdateWalls(stage:Stage):void {
			floorBody.SetPosition(new b2Vec2(0, (stage.stageHeight-WeaponUIPanel.TILE_HEIGHT/2) / Global.PHYSICS_SCALE));
		}
		
		public static function CreatePlayerWalls():void {
			var bDef:b2BodyDef = new b2BodyDef();
			bDef.type = b2Body.b2_staticBody;
			
			var fDef:b2FixtureDef = new b2FixtureDef();
			
			trace(fDef.filter.categoryBits);
			fDef.filter.categoryBits = Global.PHYSICS_CATEGORY_WALLS;
			
			//ROOF
			roofBody = World.CreateBody(bDef);
			fDef.shape = b2PolygonShape.AsEdge(new b2Vec2( -Global.SCREEN_WIDTH / 2 / Global.PHYSICS_SCALE, 0), new b2Vec2( Global.SCREEN_WIDTH / 2 / Global.PHYSICS_SCALE, 0));
			roofBody.CreateFixture(fDef);
			
			//FLOOR
			floorBody = World.CreateBody(bDef);
			fDef.shape = b2PolygonShape.AsEdge(new b2Vec2( -Global.SCREEN_WIDTH / 2 / Global.PHYSICS_SCALE, 0), new b2Vec2( Global.SCREEN_WIDTH / 2 / Global.PHYSICS_SCALE, 0));
			floorBody.CreateFixture(fDef);
			
			//WALLS
			fDef.filter.categoryBits = 0x1;
			wallsBody = World.CreateBody(bDef);
			
			//Left wall
			fDef.shape = b2PolygonShape.AsEdge(new b2Vec2( -Global.SCREEN_WIDTH*0.9 / 2 / Global.PHYSICS_SCALE, 0), new b2Vec2( -Global.SCREEN_WIDTH*0.9 / 2 / Global.PHYSICS_SCALE, 500));
			wallsBody.CreateFixture(fDef);
			
			//Right wall
			fDef.shape = b2PolygonShape.AsEdge(new b2Vec2( Global.SCREEN_WIDTH*0.9 / 2 / Global.PHYSICS_SCALE, 0), new b2Vec2( Global.SCREEN_WIDTH*0.9 / 2 / Global.PHYSICS_SCALE, 500));
			wallsBody.CreateFixture(fDef);
			
			//Left Gutter
			fDef.shape = b2PolygonShape.AsEdge(new b2Vec2( -Global.SCREEN_WIDTH*1.5 / 2 / Global.PHYSICS_SCALE, -20), new b2Vec2( -Global.SCREEN_WIDTH*0.9 / 2 / Global.PHYSICS_SCALE, 0));
			wallsBody.CreateFixture(fDef);
			
			//Right Gutter
			fDef.shape = b2PolygonShape.AsEdge(new b2Vec2( Global.SCREEN_WIDTH*1.5 / 2 / Global.PHYSICS_SCALE, -20), new b2Vec2( Global.SCREEN_WIDTH*0.9 / 2 / Global.PHYSICS_SCALE, 0));
			wallsBody.CreateFixture(fDef);
		}
	}

}