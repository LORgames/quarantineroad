package GameCom.Helpers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import LORgames.Engine.Stats;
	/**
	 * ...
	 * @author ...
	 */
	public class StatsScreen extends Sprite {
		
		private var titleScoresTF:TextField = new TextField();
		private var highScoresTF:TextField = new TextField();
		private var totalScoresTF:TextField = new TextField();
		
		public function StatsScreen() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			InsertTF(titleScoresTF, 0);
			InsertTF(highScoresTF, 120);
			InsertTF(totalScoresTF, 210);
			
			AddRow("", "HIGHEST", "TOTAL");
			
			//General stats
			AddRow("Score", Stats.GetString("HighestScore"), Stats.GetString("TotalScore"));
			AddRow("Distance", Stats.GetString("HighestDistance"), Stats.GetString("TotalDistance"));
			AddRow("Time", Stats.GetInt("LongestTime")/100.0 + "s", Stats.GetInt("TotalTime")/100.0 + "s");
			AddRow(); //Intended Blank
			
			//Weapons
			AddRow("WEAPON KILLS", "", "");
			AddRow("Pistol", Stats.GetString("PistolKillsHigh"), Stats.GetString("PistolKillsTotal"));
			AddRow("Tesla Rifle", Stats.GetString("LightningKillsHigh"), Stats.GetString("LightningKillsTotal"));
			AddRow("Flamethrower", Stats.GetString("FireKillsHigh"), Stats.GetString("FireKillsTotal"));
			AddRow("Laser", Stats.GetString("LaserKillsHigh"), Stats.GetString("LaserKillsTotal"));
			AddRow("Rocket Launcher", Stats.GetString("RocketKillsHigh"), Stats.GetString("RocketKillsTotal"));
			AddRow("Shotgun", Stats.GetString("ShotgunKillsHigh"), Stats.GetString("ShotgunKillsTotal"));
			AddRow("SMG", Stats.GetString("SMGKillsHigh"), Stats.GetString("SMGKillsTotal"));
			AddRow("Sniper", Stats.GetString("SniperKillsHigh"), Stats.GetString("SniperKillsTotal"));
			AddRow(); //Intended Blank
			
			//Zombies
			AddRow("ZOMBIE DEATHS", "", "");
			AddRow("Slow", Stats.GetString("SlowKillsHigh"), Stats.GetString("SlowKillsTotal"));
			AddRow("Limping", Stats.GetString("LimpKillsHigh"), Stats.GetString("LimpKillsTotal"));
			AddRow("Tanky (Blue)", Stats.GetString("BlueKillsHigh"), Stats.GetString("BlueKillsTotal"));
			AddRow("Speedy (Red)", Stats.GetString("RedKillsHigh"), Stats.GetString("RedKillsTotal"));
			AddRow("Hulk", Stats.GetString("HulkKillsHigh"), Stats.GetString("HulkKillsTotal"));
			AddRow("Sick (Vomiting)", Stats.GetString("ThrowUpKillsHigh"), Stats.GetString("ThrowUpKillsTotal"));
			AddRow("Bloat (Explosive)", Stats.GetString("ExplosiveKillsHigh"), Stats.GetString("ExplosiveKillsTotal"));
			AddRow(); //Intended Blank
			
			//Blank Template Row
			AddRow();
		}
		
		private function Update(e:Event):void {
			
		}
		
		private function InsertTF(tf:TextField, _x:int):void {
			tf.embedFonts = true;
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat("Visitor", 12, 0xFFFFFF);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = "";
			
			tf.x = _x;
			
			this.addChild(tf);
		}
		
		private function AddRow(title:String = "", high:String = "", total:String = ""):void {
			titleScoresTF.appendText(title + "\n");
			highScoresTF.appendText(high + "\n");
			totalScoresTF.appendText(total + "\n");
		}
		
	}

}