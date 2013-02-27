package  {
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class Global {
		//The name of the game
		public static const GAME_NAME:String = "ZombieHell";
		
		// Quality Settings
		public static var HIGH_QUALITY:Boolean = true;
		
		// Physics things
		public static const PHYSICS_SCALE:Number = 20.0; //pixels per meter
		public static const SCREEN_WIDTH:int = 438;
		public static const DRAW_PHYSICS_ALWAYS:Boolean = false;
		
		public static const PHYSCAT_WALLS:int = 1;
		public static const PHYSCAT_PLAYER:int = 2;
		public static const PHYSCAT_ZOMBIES:int = 4;
		
		//Seconds between steps
		public static const TIME_STEP:Number = 1.0 / 30.0;
		public static const INV_TIME_STEP:Number = 1 / TIME_STEP;
		
		//Number of iterations for things
		public static const VELOCITY_ITERATIONS:int = 1;
		public static const POSITION_ITERATIONS:int = 1;
		
		//Storage things
		public static const StorageRevision:int = 1;
		public static const WipeStorageBelowRevision:int = 0;
	}

}