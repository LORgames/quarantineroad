package GameCom.Managers 
{
	import Box2D.Dynamics.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Miles
	 */
	
	public class BGManager {
		private var layer:Sprite;
		
		public function BGManager(worldSpr:Sprite) {
			this.layer = worldSpr;
		}
		
		public function Update():void {
			if (layer.stage == null) return;
			
            layer.graphics.clear();
			layer.graphics.beginBitmapFill(ThemeManager.Get("Terrain/Road.png"), new Matrix(1, 0, 0, 1, -Global.SCREEN_WIDTH/2, WorldManager.WorldScrolled));
			layer.graphics.drawRect( -Global.SCREEN_WIDTH / 2, 0, Global.SCREEN_WIDTH, layer.stage.stageHeight);
			layer.graphics.endFill();
		}
	}

}