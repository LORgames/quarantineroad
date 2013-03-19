package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import GameCom.Helpers.AudioStore;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Miles
	 */
	
	public class BGManager {
		public static var I:BGManager;
		
		private var layer:Sprite;
		
		private var piece0:Sprite = new Sprite();
		private var piece1:Sprite = new Sprite();
		private var piece2:Sprite = new Sprite();
		
		private var DEBUGER:Sprite = new Sprite();
		
		private var previousScroll:Number = 0;
		
		public function BGManager(worldSpr:Sprite) {
			I = this;
			
			this.layer = worldSpr;
			
			ResetPiece(piece0);
			ResetPiece(piece1);
			ResetPiece(piece2);
			
			layer.addChild(piece0);
			layer.addChild(piece1);
			layer.addChild(piece2);
			
			piece0.cacheAsBitmap = true;
			piece1.cacheAsBitmap = true;
			piece2.cacheAsBitmap = true;
			
			piece0.y = 300;
			piece1.y = -300;
			piece2.y = -900;
		}
		
		public function Update():void {
			if (layer.stage == null) return;
			
			var deltaScroll:Number = WorldManager.WorldScrolled - previousScroll;
			
			piece0.y += deltaScroll;
			piece1.y += deltaScroll;
			piece2.y += deltaScroll;
			
			if (piece0.y > layer.stage.stageHeight) {
				ResetPiece(piece0);
				piece0.y = piece2.y - 600;
				layer.swapChildrenAt(0, 1); layer.swapChildrenAt(1, 2);
			} else if (piece1.y > layer.stage.stageHeight) {
				ResetPiece(piece1);
				piece1.y = piece0.y - 600;
				layer.swapChildrenAt(0, 1); layer.swapChildrenAt(1, 2);
			} else if (piece2.y > layer.stage.stageHeight) {
				ResetPiece(piece2);
				piece2.y = piece1.y - 600;
				layer.swapChildrenAt(0, 1); layer.swapChildrenAt(1, 2);
			}
			
			previousScroll = WorldManager.WorldScrolled;
		}
		
		public function ResetPiece(piece:Sprite):void {
			piece.graphics.clear();
			
			piece.graphics.beginBitmapFill(ThemeManager.Get("Terrain/Road.png"));
			piece.graphics.drawRect(0, 0, Global.SCREEN_WIDTH, 600);
			piece.graphics.endFill();
			
			piece.x = -Global.SCREEN_WIDTH / 2;
			
			AddRandomTrash(piece);
		}
		
		public function AddBloodSplatter(locationX:Number, locationY:Number, isRed:Boolean):void {
			var bmpd:BitmapData = ThemeManager.Get("Blood/splat"+int(Math.random()*15 + (isRed?0:15))+".png");
			
			var flipX:Boolean = Math.random() < 0.5;
			
			//Select the best piece for it
			var piece:Sprite = piece0;
			
			if (piece1.y < 0 && piece1.y > - 600) {
				piece = piece1;
			} else if (piece2.y < 0 && piece2.y > - 600) {
				piece = piece2;
			}
			
			locationX += Global.SCREEN_WIDTH / 2;
			locationY -= piece.y;
			
			piece.graphics.beginBitmapFill(bmpd, new Matrix(flipX?-1:1, 0, 0, 1, locationX-(flipX?-bmpd.width/2:bmpd.width/2), locationY-bmpd.height/2), false, true);
			piece.graphics.drawRect(locationX-bmpd.width/2, locationY-bmpd.height/2, bmpd.width, bmpd.height);
			piece.graphics.endFill();
			
			AudioController.PlaySound(AudioStore.GetZombieDeath());
		}
		
		public function AddRandomTrash(piece:Sprite):void {
			var randomItemsCount:int = Math.random() * 50;
			
			var items:Array = ThemeManager.GetFilenamesByWildcard("Trash/");
			
			for (var i:int = 0; i < randomItemsCount; i++) {
				var item:String = items[int(items.length * Math.random())];
				
				if(item != "Trash/") {
					var bmpd:BitmapData = ThemeManager.Get(item);
					
					var flipX:Boolean = Math.random() < 0.5;
					var flipY:Boolean = false;
					
					var x:int = Math.random() * (Global.SCREEN_WIDTH - bmpd.width) + (flipX?bmpd.width:0);
					var y:int = Math.random() * 600;
					
					piece.graphics.beginBitmapFill(bmpd, new Matrix(flipX?-1:1, 0, 0, 1, x, y), false, true);
					piece.graphics.drawRect(flipX?x-bmpd.width:x, y, bmpd.width, bmpd.height);
					piece.graphics.endFill();
				} else {
					i--;
				}
			}
		}
	}

}