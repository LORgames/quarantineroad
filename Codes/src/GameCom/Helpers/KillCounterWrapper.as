package GameCom.Helpers 
{
	import GameCom.Managers.WorldManager;
	import mochi.as3.MochiDigits;
	/**
	 * ...
	 * @author Paul
	 */
	public class KillCounterWrapper {
		public static const KILLS:int = 0;
		public static const DISTANCE:int = 1;
		public static const TIME:int = 2;
		public static const TOTAL:int = 3;
		public static const SCORE:int = 4;
		public static const SHAKEY_KILLS:int = 5;
		
		//private var _val:MochiDigits = new MochiDigits();
		public var Value:Number = 0;
		
		private var type:int = KILLS;
		
		public function KillCounterWrapper(type:int = KILLS) {
			this.type = type;
		}
		
		//public function get Value():Number {
		//	return _val.value;
		//	return number;
		//}
		
		public function AddValue(val:Number):void {
			//_val.addValue(val);
			Value += val;
			
			if (type == KILLS) {
				ScoreHelper.AllKills.AddValue(val);
			} else if (type == TIME) {
				if (Value > 180) TrophyHelper.GotTrophyByName("Time");
				if (Value > 360) TrophyHelper.GotTrophyByName("Man vs Zombie");
			} else if (type == TOTAL) {
				if (WorldManager.WorldShake >= 0.3) ScoreHelper.ShakeyKills.AddValue(val);
				if (Value > 100) TrophyHelper.GotTrophyByName("Piece of Cake");
				if (Value > 500) TrophyHelper.GotTrophyByName("Zombie");
				if (Value > 1000) TrophyHelper.GotTrophyByName("Project Alice");
			} else if (type == SHAKEY_KILLS) {
				if (Value > 20) TrophyHelper.GotTrophyByName("Harlem Shake");
			}
		}
		
		public function SetValue(value:Number):void {
			//_val.setValue(value);
			Value = value;
			
			if (type == DISTANCE) {
				if (Value > 200 && ScoreHelper.AllKills.Value == 0) TrophyHelper.GotTrophyByName("Pacifist");
				if (Value > 100) TrophyHelper.GotTrophyByName("100m Run");
				if (Value > 500) TrophyHelper.GotTrophyByName("500m Run");
				if (Value > 1000) TrophyHelper.GotTrophyByName("1000m Run");
			}
		}
	}

}