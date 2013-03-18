package GameCom.SystemComponents 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
				mat.tx = (i % 6) * 45 + 69;
				mat.ty = Math.floor(i / 6) * 45 + 70;
				
				var bmpd:BitmapData = ThemeManager.Get(TrophyHelper.GetTrophyPictureName(i));
				
				if (!TrophyHelper.HasTrophy(i)) {
					bmpd = bmpd.clone();
					bmpd.colorTransform(new Rectangle(0, 0, 44, 44), new ColorTransform(0.3, 0.3, 0.3, 0.5));
				}
				
				this.graphics.beginBitmapFill(bmpd, mat);
				this.graphics.drawRect(mat.tx, mat.ty, 44, 44);
				this.graphics.endFill();
			}
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut, false, 0, true);
		}
		
		public function rollOver(me:MouseEvent):void {
			
			var eX:int = (me.localX-69) / 45;
			var eY:int = (me.localY-70) / 45;
			
			var matTX:int = eX * 45 + 69;
			var matTY:int = eY * 45 + 70 + 22;
			
			tooltip.SetText(TrophyHelper.GetTrophyName(eY * 6 + eX) + " (" + (TrophyHelper.HasTrophy(eY*6+eX)?"Unl":"L") +"ocked)\n\n" + TrophyHelper.GetTrophyDescription(eY * 6 + eX));
			
			if (eX < 3) {
				tooltip.ChangeDirection(Tooltip.RIGHT);
			} else {
				tooltip.ChangeDirection(Tooltip.LEFT);
			}
			
			tooltip.visible = true;
			tooltip.x = matTX + this.x;
			tooltip.y = matTY + this.y;
		}
		
		public function rollOut(me:MouseEvent):void {
			tooltip.visible = false;
		}
		
	}

}