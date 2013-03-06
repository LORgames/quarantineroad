package GameCom.GameComponents.Decorations  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Paul Fox
	 */
	public class Lightning extends Sprite {
		//Lightning Settings
		private var lightningOffset:Number = 10;
		private var lightningFrequency:Number = 3;
		private var lightningWidth:Number = 1;
		//private var lightningColor:uint = 0x5C98EF;
		private var lightningColor:uint = 0xEEEEFF;
		private var lightningAlpha:Number = 75;
		private var lightningBranches:Number = 2;

		//Spark Settings
		private var sparkNumber:Number = 2;
		private var sparkDistance:Number = 50;
		private var sparkSize:Number = 100;

		//Speed Settings
		private var clearSpeed:Number = 0.1; //how long a bolt is displayed for in seconds
		private var drawDelay:Number = 0.002; //time (in seconds) between each segment being drawn
		
		//the drawing pane
		private var effectHolder:Sprite = new Sprite();
		
		//Really poor memory management drawing lightning... probably will lag too
		private var lines:Array = new Array();
		
		public function Lightning() {			
			this.addChild(effectHolder);
			this.addEventListener(Event.REMOVED_FROM_STAGE, Removed, false, 0, true);
		}
		
		private function Removed(e:Event):void {
			this.removeChild(effectHolder);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, Removed);
		}

		//clears timers & clears everything we were drawing on _root
		private function ClearScreen():void {
			effectHolder.graphics.clear();
		}
		
		public function DrawPoints(pts:Vector.<Point>):void {
			for (var i:int = 1; i < pts.length; i++) {
				lines.push(new Array(pts[i - 1], pts[i], clearSpeed-(drawDelay*i), drawDelay*i));
			}
		}
		
		public function Update(dt:Number):void {
			ClearScreen();
			
			for (var i:int = 0; i < lines.length; i++) {
				lines[i][3] -= dt;
				if (lines[i][3] <= 0) {
					Draw(lines[i][0], lines[i][1]);
					lines[i][2] -= dt;
					if (lines[i][2] <= 0) {
						lines.splice(i, 1);
						i--;
					}
				}
			}
		}
		
		private function Draw(start:Point, end:Point):void {
			var xStart:int = start.x;
			var yStart:int = start.y;
			var xEnd:int = end.x;
			var yEnd:int = end.y;
			
			//set the line style
			effectHolder.graphics.lineStyle(lightningWidth, lightningColor, lightningAlpha, true);
			
			//calculate the distance between our fire point and target point
			var distanceX:Number = xStart-xEnd;
			var distanceY:Number = yStart-yEnd;
			var distanceTotal:Number = Math.sqrt(distanceX*distanceX+distanceY*distanceY);
			
			//calculate the number of steps the lightning bolt will make
			var numberOfSteps:Number = distanceTotal/lightningFrequency;
			
			//calculate the angle in radians
			var angle:Number = Math.atan2(yStart-yEnd, xStart-xEnd);
			
			//calculate the distance of each step in pixels
			var stepInPixels:Number = distanceTotal/numberOfSteps;
			
			//run a loop to create lightning bolts based on lightningBranches
			for (var j:int = 0; j < lightningBranches; j++) {
				//run a loop to repeat line drawing based on numberOfSteps needed
				for (var i:int = 0; i<(numberOfSteps+1); i++) {
					//calculate the current step position based on number of steps taken
					var currentStepPosition:Number = stepInPixels*i;
					
					//calculate random offset number
					var randomOffset:Number = Math.random()*(lightningOffset-lightningOffset/2);
					
					//calculate x & y positions of where to draw the line for this step
					var xStepPosition:Number = xStart-Math.cos(angle)*currentStepPosition+Math.cos(angle+1.55)*randomOffset;
					var yStepPosition:Number = yStart-Math.sin(angle)*currentStepPosition+Math.sin(angle+1.55)*randomOffset;
					
					//draw line to this position
					if(i > 0){
						effectHolder.graphics.lineTo(xStepPosition, yStepPosition);
					} else {
						effectHolder.graphics.moveTo(xStepPosition, yStepPosition);
					}
				}
			}
		}
	}
	
	

}