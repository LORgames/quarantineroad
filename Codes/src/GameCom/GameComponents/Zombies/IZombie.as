package GameCom.GameComponents.Zombies {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import GameCom.GameComponents.IHit;
	
	/**
	 * ...
	 * @author Paul
	 */
	public interface IZombie extends IHit {
		function Update(dt:Number):void;
		
		function OutsideScene():Boolean;
		
		function AddToScene(position:b2Vec2, layer0:Sprite, layer1:Sprite):void;
		function RemoveFromScene(layer0:Sprite, layer1:Sprite):void;
	}

}