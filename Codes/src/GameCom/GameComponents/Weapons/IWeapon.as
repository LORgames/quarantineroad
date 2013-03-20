package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.BitmapData;
	import GameCom.GameComponents.PlayerCharacter;
	/**
	 * ...
	 * @author Paul
	 */
	public interface IWeapon {
		function Update(dt:Number, location:b2Vec2, player:PlayerCharacter):Boolean;
		
		function Upgrade():void;
		
		function AddAmmo():void;
		function GetAmmoReadout():String;
		function IsMaxAmmo():Boolean;
		
		function Activate():void;
		function Deactivate():void;
		function IsActive():Boolean;
		
		function AddSafe(body:b2Body):void;
		function IsSafe(fixture:b2Body):Boolean;
		
		function GetIcon():BitmapData;
		function GetPlayerBody():BitmapData;
		function GetUpgradeIcon():BitmapData;
		
		function ReportKills(newKills:int):void;
		function ReportStatistics():void;
	}
	
}