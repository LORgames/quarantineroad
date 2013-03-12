package GameCom.Helpers 
{
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
		
		private var _val:MochiDigits = new MochiDigits();
		private var type:int = KILLS;
		
		public function KillCounterWrapper(type:int = KILLS) {
			this.type = type;
		}
		
		public function get value():Number {
			return _val.value;
		}
		
		public function addValue(val:Number):void {
			_val.addValue(val);
			
			if (type == DISTANCE) {
				if (value > 200 && ScoreHelper.AllKills.value == 0) TrophyHelper.GotTrophyByName("Pacifist");
				if (value > 100) TrophyHelper.GotTrophyByName("100m Run");
				if (value > 500) TrophyHelper.GotTrophyByName("500m Run");
				if (value > 1000) TrophyHelper.GotTrophyByName("1000m Run");
			} else if (type == KILLS) {
				ScoreHelper.AllKills.addValue(val);
			} else if (type == TIME) {
				if (value > 180) TrophyHelper.GotTrophyByName("Time");
				if (value > 360) TrophyHelper.GotTrophyByName("Man vs Zombie");
			}
		}
	}

}