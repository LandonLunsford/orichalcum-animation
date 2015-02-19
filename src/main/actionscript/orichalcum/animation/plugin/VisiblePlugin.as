package orichalcum.animation.plugin 
{
	import flash.display.DisplayObject;
	import orichalcum.animation.Tween;
	
	public class VisiblePlugin extends AbstractDisplayObjectPlugin
	{
		
		private var _invisibleAlphaThreshold;
		
		public function VisiblePlugin(invisibleAlphaThreshold:Number = 0.01) 
		{
			_invisibleAlphaThreshold = invisibleAlphaThreshold;
			super(['alpha']);
		}
		
		override public function tween(tween:Tween, property:String, value:*, startValue:*, endValue:*, ratio:Number, completed:Boolean):* 
		{
			tween.target().visible = tween.target().alpha > _invisibleAlphaThreshold;
		}
		
	}

}