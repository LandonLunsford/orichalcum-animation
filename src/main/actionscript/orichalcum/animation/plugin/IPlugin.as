package orichalcum.animation.plugin
{
	import orichalcum.animation.Tween;
	
	public interface IPlugin 
	{
		function get properties():Array;
		function init(tween:Tween, property:String, value:*):void;
		function tween(tween:Tween, property:String, value:*, startValue:*, endValue:*, ratio:Number, completed:Boolean):*;
	}
	
}