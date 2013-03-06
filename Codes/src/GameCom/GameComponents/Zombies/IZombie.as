package GameCom.GameComponents.Zombies {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameCom.GameComponents.IHit;
	import GameCom.GameComponents.PlayerCharacter;
	
	/**
	 * ...
	 * @author Paul
	 */
	public interface IZombie extends IHit {
		function Update(dt:Number):void;
		function HitPlayer(player:PlayerCharacter):Number;
		
		function OutsideScene():Boolean;
		
		function AddToScene(position:b2Vec2, layer0:Sprite, layer1:Sprite):void;
		function RemoveFromScene(layer0:Sprite, layer1:Sprite):void;
		
		function GetPixelLocation():Point;
	}

}