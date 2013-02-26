package GameCom.Managers 
{
	import Box2D.Dynamics.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Miles
	 */
	
	public class BGManager {
		private var layer:Sprite;
		
		// tile size in pixels
		private const TILESIZEX:int = 146;
		private const TILESIZEY:int = 146;
		
		// Extra area around viewarea
		private const VIEW_OFFSET:Number = TILESIZEX * 1.5;
		
		// max number of tiles
		private var maxTilesX:int;
		private var maxTilesY:int;
		
		// number of visible tiles
		private var numTilesX:int;
		private var numTilesY:int;
		
		/* map data loaded as a 2D array from the map file
		 * data loaded in will be an int referencing the tile to load for that coordinate
		 * 
		 * mapdata =	{{ int tilenumber, int tilenumber, int tilenumber, ... },
		 *				 { int tilenumber, int tilenumber, int tilenumber, ... },
		 *				 { int tilenumber, int tilenumber, int tilenumber, ... },
		 * 				 ... 
		 * 				}
		 */
		private var mapdata:Array = new Array(); //TODO: VECTORIZE WITH 1D Number (60% faster)
		
		// view rect
		private var view:Rectangle = new Rectangle();
		private var oldView:Rectangle = new Rectangle();
		
		private var first:Boolean = true;
		
		//private var toLoad:Array = new Array();
		
		public function BGManager(worldSpr:Sprite) {
			this.layer = worldSpr;
		}
		
		public function Update():void {
			if (layer.stage == null) return;
			
            /*var LeftEdge : int = Math.floor(Math.abs(player.x-layer.stage.stageWidth/2-VIEW_OFFSET) / TILESIZEX);
            var TopEdge : int = Math.floor(Math.abs(player.y-layer.stage.stageWidth/2-VIEW_OFFSET) / TILESIZEY);

            var RightEdge : int = Math.ceil(Math.abs(player.x+layer.stage.stageWidth/2+VIEW_OFFSET) / TILESIZEX);
            var BottomEdge : int = Math.ceil(Math.abs(player.y+layer.stage.stageWidth/2+VIEW_OFFSET) / TILESIZEY);

			layer.graphics.clear();
			
            for (var i:int = LeftEdge; i < RightEdge; i++) {
                for (var j:int = TopEdge; j < BottomEdge; j++) {
                    var f:uint = mapdata[i][j];
					
                    if (f != 0) {
						layer.graphics.beginBitmapFill(ThemeManager.Get("Tiles/" + f + ".png"));
						layer.graphics.drawRect(i * TILESIZEX, j * TILESIZEY, TILESIZEX, TILESIZEY);
						layer.graphics.endFill();
                    }
                }
            }*/
		}
		
		public function Redraw(w:int, h:int) : void {
			view.width = w + VIEW_OFFSET * 2;
			view.height = h + VIEW_OFFSET * 2;
			oldView.width = w + VIEW_OFFSET * 2;
			oldView.height = h + VIEW_OFFSET * 2;
		}
	}

}