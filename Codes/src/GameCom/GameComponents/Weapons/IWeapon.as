package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	/**
	 * ...
	 * @author Paul
	 */
	public interface IWeapon {
		function Update(dt:Number, location:b2Vec2):void;
		function IsEmpty():Boolean;
		function AddAmmo():void;
		
		function AddSafe(body:b2Body):void;
		function IsSafe(fixture:b2Body):Boolean;
	}
	
}