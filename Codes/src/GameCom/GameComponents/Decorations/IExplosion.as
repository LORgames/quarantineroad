package GameCom.GameComponents.Decorations {
	/**
	 * ...
	 * @author Paul
	 */
	public interface IExplosion extends IDecoration {
		function Reset():void;
		function IsFinished():Boolean;
	}

}