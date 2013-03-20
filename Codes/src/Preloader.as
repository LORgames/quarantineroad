package {
	import flash.display.Sprite;
	import GameCom.GameComponents.Zombies.ZombieHand;
	import GameCom.Helpers.SpriteHelper;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import mochi.as3.MochiAd;
	
	/**
	 * ...
	 * @author P. Fox
	 */
	public class Preloader extends MovieClip {
		[Embed(source="../lib/visitor1.ttf", fontName="Visitor", embedAsCFF=false)]
		public static var fontName:Class;
		
		[Embed(source="../lib/EmbeddedArt/WalkingAnimation.swf", symbol="LORgames.ZombieWalkClass")]
		public static var WalkingZombie:Class;
		
		private const AD_SIZE_X:int = 800;
		private const AD_SIZE_Y:int = 600;
		
		private var Zombie:MovieClip = new MovieClip();
		private var DisplayText:TextField = new TextField();
		private var PercentageText:TextField = new TextField();
		
		private var adContainer:MovieClip = new MovieClip();
		
		private var isAdFinished:Boolean = false;
		private var isLoadingFinished:Boolean = false;
		
		public function Preloader() {
			if (stage) Init();
			else this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:*= null):void {
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			stage.addEventListener(Event.RESIZE, resize);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// Show the Loader
			PercentageText.embedFonts = true;
			PercentageText.selectable = false;
			PercentageText.defaultTextFormat = new TextFormat("Visitor", 40, 0xFFFFFF);
			PercentageText.autoSize = TextFieldAutoSize.CENTER;
			PercentageText.text = "0.00%";
			this.addChild(PercentageText);
			
			DisplayText.embedFonts = true;
			DisplayText.defaultTextFormat = new TextFormat("Visitor", 16, 0xFFFFFF);
			DisplayText.autoSize = TextFieldAutoSize.CENTER;
			DisplayText.selectable = false;
			this.addChild(DisplayText);
			
			Zombie = new WalkingZombie() as MovieClip;
			this.addChild(Zombie);
			
			//TODO: ENABLE ADS
			//isAdFinished = true;
			this.addChild(adContainer);
			MochiAd.showPreGameAd({clip:adContainer, id:"5a3aaf31eb62a90e", res:stage.stageWidth+"x"+stage.stageHeight, ad_finished:fAdFinished, no_progress_bar:true});
			
			resize(null);
		}
		
		public function fAdFinished():void {
			this.removeChild(adContainer);
			isAdFinished = true;
			
			CleanUp();
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			var totalBytes:int = e.bytesTotal;
			var approx:Boolean = false;
			
			if (e.bytesTotal == 0) {
				totalBytes = 5856704;
				approx = true;
			}
			
			// Update the GUI
			if (e.bytesLoaded != totalBytes) {
				PercentageText.text = (approx?"~":"") + Number(e.bytesLoaded / totalBytes * 100.0).toFixed(1) + "%";
				DisplayText.text = "Downloading.";
			} else {
				DisplayText.text = "Unpacking.";
			}
		}
		
		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function resize(e:Event):void {
			// Show the Loader
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			var mat:Matrix = new Matrix(1, 0, 0, 1, stage.stageWidth / 2, stage.stageHeight / 2);
			
			PercentageText.x = mat.tx - PercentageText.width / 2;
			PercentageText.y = mat.ty + 100;
			
			DisplayText.x = mat.tx - DisplayText.width / 2;
			DisplayText.y = mat.ty + 60;
			
			Zombie.x = mat.tx;
			Zombie.y = mat.ty;
		}
		
		private function loadingFinished():void {
			isLoadingFinished = true;
			
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			PercentageText.text = "";
			DisplayText.text = "Waiting for advertising network.";
			
			CleanUp();
		}
		
		public function CleanUp():void {
			if (!isLoadingFinished || !isAdFinished) return;
			
			stage.removeEventListener(Event.RESIZE, resize);
			
			// Hide the loader
			this.removeChild(DisplayText);
			this.removeChild(PercentageText);
			
			this.graphics.clear();
			startup();
		}
		
		private function startup():void {
			var mainClass:Class = null;
			
			try {
				mainClass = getDefinitionByName("Wrapper") as Class;
			} catch (ex:Error) {
				mainClass = null;
			}
			
			if (mainClass == null) mainClass = getDefinitionByName("Main") as Class;
			
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}