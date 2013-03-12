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
		public static const SCREEN_WIDTH:int = 500;
		public static const DRAW_PHYSICS_ALWAYS:Boolean = false;
		
		public static const PHYSICS_CATEGORY_DEFAULT:int = 1;
		public static const PHYSICS_CATEGORY_WALLS:int = 2;
		public static const PHYSICS_CATEGORY_PLAYER:int = 4;
		public static const PHYSICS_CATEGORY_ZOMBIES:int = 8;
		public static const PHYSICS_CATEGORY_LOOT:int = 16;
		public static const PHYSICS_CATEGORY_BULLETS:int = 32;
		public static const PHYSICS_CATEGORY_VOMIT:int = 64;
		
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