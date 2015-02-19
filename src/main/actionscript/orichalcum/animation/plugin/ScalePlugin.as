package orichalcum.animation.plugin 
{
	import flash.display.DisplayObject;
	import orichalcum.animation.Tween;
	
	public class ScalePlugin extends AbstractDisplayObjectPlugin
	{
		
		public function ScalePlugin() 
		{
			super(['scale']);
		}
		
		override public function init(tween:Tween, property:String, value:*):void 
		{
			const target:Object = tween.target();
			tween.to().scale ||= target.scaleX;
			tween.from().scale ||= target.scaleX;
			
			trace('ScalePlugin.init()', tween.to().scale, tween.from().scale);
		}
		
		// value, start & end are really extra & can be gotten from tween.to()/from() & ratio - also they only apply to bool/num
		override public function tween(tween:Tween, property:String, value:*, startValue:*, endValue:*, ratio:Number, completed:Boolean):* 
		{
			const target:Object = tween.target();
			//const value:Number = startValue + (endValue - startValue) * ratio;
			target.scaleX = target.scaleY = value;
		}
		
	}

}