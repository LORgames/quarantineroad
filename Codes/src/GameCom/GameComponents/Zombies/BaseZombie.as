package GameCom.GameComponents.Zombies {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Paul
	 */
	public interface BaseZombie {
		function Update(dt:Number):void;
		function Move(newPosition:b2Vec2):void;
		
		function OutsideScene():Boolean;
		
		function AddToScene(layer0:Sprite, layer1:Sprite):void;
		function RemoveFromScene(layer0:Sprite, layer1:Sprite):void;
	}

}