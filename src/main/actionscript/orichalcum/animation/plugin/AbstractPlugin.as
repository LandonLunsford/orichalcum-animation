package orichalcum.animation.plugin 
{
	import orichalcum.animation.Tween;
	
	public class AbstractPlugin implements IPlugin
	{
		
		private var _properties:Array;
		
		public function AbstractPlugin(properties:Array) 
		{
			_properties = properties;
		}
		
		public function get properties():Array 
		{
			return _properties;
		}
		
		public function supports(target:Object):Boolean 
		{
			return true;
		}
		
		public function init(tween:Tween, property:String, value:*):void 
		{
			
		}
		
		public function tween(tween:Tween, property:String, value:*, startValue:*, endValue:*, ratio:Number, completed:Boolean):* 
		{
			//return interpolateNumber(startValue, endValue, ratio);
			return value;
		}
		
		protected function interpolateNumber(a:Number, b:Number, p:Number):Number
		{
			return a + (b - a) * p;
		}
		
		protected function interpolateBoolean(a:Boolean, b:Boolean, p:Number):Boolean
		{
			return p == 1 ? b : a;
		}
		
	}

}