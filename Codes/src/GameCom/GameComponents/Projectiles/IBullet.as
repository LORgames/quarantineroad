package GameCom.GameComponents.Projectiles {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.Sprite;
	import GameCom.GameComponents.Weapons.IWeapon;
	/**
	 * ...
	 * @author Paul
	 */
	public interface IBullet {
		function GetDamage():Number;
		function GetOwner():IWeapon;
		
		function Update(dt:Number):void;
		
		function ShouldRemove():Boolean;
		function SetLocationAndActivate(newLocation:b2Vec2, newOwner:IWeapon, layer:Sprite, angle:Number = 0, distance:Number = 0, damage:Number = 0):void;
		function Deactivate(layer:Sprite):void;
	}

}