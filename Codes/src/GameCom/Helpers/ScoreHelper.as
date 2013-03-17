package GameCom.Helpers 
{
	import mochi.as3.MochiDigits;
	/**
	 * ...
	 * @author Paul
	 */
	public class ScoreHelper {
		//Score systems
		public static var Score:KillCounterWrapper;
		public static var Distance:KillCounterWrapper;
		public static var Time:KillCounterWrapper;
		
		//Zombie kill stats
		public static var AllKills:KillCounterWrapper;
		
		public static var MeleeKills:KillCounterWrapper;
		public static var ShakeyKills:KillCounterWrapper;
		
		public static var SlowKills:KillCounterWrapper;
		public static var LimpKills:KillCounterWrapper;
		public static var RedKills:KillCounterWrapper;
		public static var BlueKills:KillCounterWrapper;
		public static var ThrowUpKills:KillCounterWrapper;
		public static var ExplosiveKills:KillCounterWrapper;
		public static var HulkKills:KillCounterWrapper;
		
		public static var TotalUpgrades:KillCounterWrapper;
		
		public static function Reset():void {
			Score = new KillCounterWrapper(KillCounterWrapper.OTHER_MISC);
			Distance = new KillCounterWrapper(KillCounterWrapper.DISTANCE);
			Time = new KillCounterWrapper(KillCounterWrapper.TIME);
			
			TotalUpgrades = new KillCounterWrapper(KillCounterWrapper.OTHER_MISC);
			
			//KILL TYPES
			AllKills = new KillCounterWrapper(KillCounterWrapper.TOTAL);
			
			MeleeKills = new KillCounterWrapper(KillCounterWrapper.OTHER_MISC);
			ShakeyKills = new KillCounterWrapper(KillCounterWrapper.OTHER_SHAKEY);
			
			SlowKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			LimpKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			RedKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			BlueKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			ThrowUpKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			ExplosiveKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			HulkKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
		}
		
		
	}

}