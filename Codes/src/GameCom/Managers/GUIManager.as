package GameCom.Managers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.SystemComponents.PopupInfo;
	import LORgames.Components.Button;
	import LORgames.Components.Tooltip;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Mousey;
	/**
	 * ...
	 * @author Paul
	 */
	public class GUIManager extends Sprite {
		
		public static var I:GUIManager;
		
		private var PopupSprite:Sprite = new Sprite();
		private var Overlay:Sprite = new Sprite();
		
		private var popupMessages:Vector.<PopupInfo> = new Vector.<PopupInfo>();
		private var popupCloseMessage:TextField = new TextField();
		private var popupText:TextField = new TextField();
		private var popupAlpha:Number = 0;
		private var popupFadeIn:Boolean = false;
		private var popupFadeOut:Boolean = false;
		
		private var tooltips:Vector.<Tooltip> = new Vector.<Tooltip>();
		private var currentFrameTooltipIndex:int = 0;
		
		private var MuteButton:Button = new Button("Mute", 20, 20, 6);
		
		private var Pause:Function;
		private var MockUpdateWorld:Function;
		
		public function GUIManager(pauseLoopback:Function, mockupdate:Function) {
			I = this;
			
			this.addChild(Overlay);
			this.addChild(PopupSprite);
			
			popupText.selectable = false;
			popupText.defaultTextFormat = new TextFormat("Verdana", 24, 0xFFFFFF);
			popupText.wordWrap = true;
			
			//Good text field max size
			popupText.x = PopupSprite.x + 115;
			popupText.y = PopupSprite.y + 400;
			popupText.width = 411;
			popupText.height = 191;
			
			if(Global.HIGH_QUALITY) popupText.filters = new Array(new GlowFilter(0x337C8C, 1, 7, 7, 3));
			PopupSprite.addChild(popupText);
			PopupSprite.addChild(popupCloseMessage);
			
			popupCloseMessage.selectable = false;
			popupCloseMessage.defaultTextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
			popupCloseMessage.autoSize = TextFieldAutoSize.LEFT;
			popupCloseMessage.text = "Press Enter, Space or Left Click to continue.";
			if(Global.HIGH_QUALITY) popupCloseMessage.filters = new Array(new GlowFilter(0x337C8C, 1, 7, 7, 3));
			popupCloseMessage.alpha = 0;
			
			this.addChild(MuteButton);
			MuteButton.addEventListener(MouseEvent.CLICK, MuteClicked, false, 0, true);
			MuteButton.alpha = 0;
		}
		
		public function Update() : void {
			if (stage == null) return;
			
			if (popupAlpha > 0) {
				if (popupFadeOut) {
					popupAlpha -= 0.08;
					if (popupAlpha <= 0) {
						popupText.alpha = 0;
						popupText.text = "";
						
						popupCloseMessage.alpha = 0;
						
						popupMessages.splice(0, 1);
						ShowNextPopup();
					}
				} else {
					if (popupFadeIn) {
						popupAlpha += 0.08;
						if (popupAlpha >= 1) {
							popupText.alpha = 1;
							popupCloseMessage.alpha = 1;
							
							popupFadeIn = false;
							
							//Need 1 frame of update if the popup is a blackout to allow respawn to work
							if(popupMessages[0].blackOut) MockUpdateWorld.call();
						}
					}
					
					if(!popupFadeIn && !popupFadeOut && (Keys.isKeyDown(Keyboard.ENTER) || Mousey.IsClicking() || Keys.isKeyDown(Keyboard.SPACE))) {
						popupFadeOut = true;
					}
				}
				
				popupText.alpha = popupAlpha;
				popupCloseMessage.alpha = popupAlpha;
				
				if (popupMessages.length > 0) {
					PopupSprite.graphics.clear();
					
					var m:Matrix = new Matrix();
					m.createBox(1, 1, 0, (stage.stageWidth - 665) / 2, stage.stageHeight - 240);
					
					if (popupMessages[0].blackOut) {
						PopupSprite.graphics.beginFill(0x0);
						PopupSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
						PopupSprite.graphics.endFill();
					}
					
					PopupSprite.graphics.beginBitmapFill(ThemeManager.Get("GUI/Message board.png"), m, false);
					PopupSprite.graphics.drawRect((stage.stageWidth - 665) / 2, stage.stageHeight - 240, 665, 240);
					PopupSprite.graphics.endFill();
					
					popupText.x = stage.stageWidth / 2 - 285; // PopupSprite.x + 115;
					popupText.y = stage.stageHeight - 200;// PopupSprite.y + 400;
					
					popupCloseMessage.x = stage.stageWidth / 2 - 300;
					popupCloseMessage.y = stage.stageHeight - 30;
					
					if (popupMessages[0].npcNumber != -1) {
						m.createBox(1, 1, 0, stage.stageWidth/2 + 100, stage.stageHeight - 354);
						PopupSprite.graphics.beginBitmapFill(ThemeManager.Get("People/"+popupMessages[0].npcNumber+"_"+popupMessages[0].npcImgIndex+".png"), m, false);
						PopupSprite.graphics.drawRect(stage.stageWidth/2 + 100, stage.stageHeight - 354, 315, 354);
						PopupSprite.graphics.endFill();
					}
				}
				
				PopupSprite.alpha = popupAlpha;
			}
			
			for (var i:int = currentFrameTooltipIndex; i < tooltips.length; i++) {
				tooltips[i].visible = false;
			}
			
			currentFrameTooltipIndex = 0;
		}
		
		private function ShowNextPopup():void {
			if (popupMessages.length > 0) {
				popupText.text = popupMessages[0].message;
				
				popupAlpha = 0.1;
				popupFadeIn = true;
				popupFadeOut = false;
			} else {
				Pause.call();
			}
		}
		
		public function Popup(msg:String, npc:int = 0, npcImageIndex:int = 0, blackout:Boolean = false) :void {
			
			//Message needs to be split up, but this will do for now
			var messages:Array = msg.split("@NB:");
			
			for (var i:int = 0; i < messages.length; i++) {
				var message:String = messages[i];
				var t_blackout:Boolean = blackout;
				
				if (message.length < 3) continue;
				
				var popupData:PopupInfo = new PopupInfo();
				
				var npcID:int = npc;
				var npcII:int = npcImageIndex;
				
				var sI:int = message.indexOf("_");
				
				if (sI < 3 && sI > -1) {
					npcID = parseInt(message.substr(0, sI));
					npcII = parseInt(message.substr(sI + 1, message.indexOf(" ") - sI));
					message = message.substr(message.indexOf(" ") + 1);
				}
				
				if (message.indexOf("@BLACK") > -1) {
					message = message.split("@BLACK").join("");
					t_blackout = true;
				}
				
				popupData.message = message;
				popupData.npcImgIndex = npcII;
				popupData.npcNumber = npcID;
				popupData.blackOut = t_blackout;
				
				popupMessages.push(popupData);
				
				if (popupMessages.length == 1) {
					ShowNextPopup();
					Pause.call();
				}
			}
		}
		
		public function ShowTooltipAt(worldX:int, worldY:int, message:String):void {
			if (tooltips.length == currentFrameTooltipIndex) {
				tooltips.push(new Tooltip("", Tooltip.UP, 25, 200, 0.85));
				Overlay.addChild(tooltips[currentFrameTooltipIndex]);
			}
			
			tooltips[currentFrameTooltipIndex].visible = true;
			tooltips[currentFrameTooltipIndex].SetText(message);
			tooltips[currentFrameTooltipIndex].x = worldX + WorldManager.WorldX + stage.stageWidth / 2;
			tooltips[currentFrameTooltipIndex].y = worldY + WorldManager.WorldY + stage.stageHeight / 2;
			
			currentFrameTooltipIndex++;
		}
		
		private function MuteClicked(me:MouseEvent):void {
			AudioController.SetMuted(!AudioController.GetMuted());
		}
		
	}

}