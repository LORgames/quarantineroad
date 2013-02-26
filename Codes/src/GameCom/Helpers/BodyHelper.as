package GameCom.Helpers 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class BodyHelper {
		
		public static function GetGenericCircle(radius:Number, category:int, userData:*, maskBit:int = 0xFFFF):b2Body {
			var body:b2Body;
			
			//Create the defintion
			var bDef:b2BodyDef = new b2BodyDef();
			bDef.type = b2Body.b2_dynamicBody;
			bDef.allowSleep = false;
			bDef.position = new b2Vec2(0, 500 / Global.PHYSICS_SCALE);
			bDef.userData = userData;
			
			var fDef:b2FixtureDef = new b2FixtureDef();
			fDef.restitution = 0;
			fDef.friction = 0;
			fDef.shape = new b2CircleShape(radius);
			fDef.density = 0.1;
			
			fDef.filter.categoryBits = category;
			fDef.filter.maskBits = maskBit;
			
			fDef.userData = userData;
			
			body = WorldManager.World.CreateBody(bDef);
			body.CreateFixture(fDef);
			
			return body;
		}
		
	}

}