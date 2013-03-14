package GameCom.SystemComponents 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import GameCom.Helpers.TrophyHelper;
	import LORgames.Components.Tooltip;
	/**
	 * ...
	 * @author Paul
	 */
	public class TrophyMenu extends Sprite {
		
		private var tooltip:Tooltip = null;
		
		public function TrophyMenu(tooltip:Tooltip) {
			this.tooltip = tooltip;
			
			var totalTrophies:int = TrophyHelper.TotalTrophies();
			
			var mat:Matrix = new Matrix();
			
			for (var i:int = 0; i < totalTrophies; i++) {
				mat.tx = (i % 6) * 57 + 69 + (int(i / 3) % 2 == 0?0:35);
				mat.ty = Math.floor(i / 6) * 53 + 70;
				
				var bmpd:BitmapData = ThemeManager.Get(TrophyHelper.GetTrophyPictureName(i));
				
				if (!TrophyHelper.HasTrophy(i)) {
					trace("No has trophy: " + i);
					bmpd = bmpd.clone();
					bmpd.colorTransform(new Rectangle(0, 0, 44, 44), new ColorTransform(0.3, 0.3, 0.3, 0.5));
				} else {
					trace("Has trophy: " + i);
				}
				
				this.graphics.beginBitmapFill(bmpd, mat);
				this.graphics.drawRect(mat.tx, mat.ty, 44, 44);
				this.graphics.endFill();
			}
		}
		
	}

}