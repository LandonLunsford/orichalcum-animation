package orichalcum.animation.plugin 
{
	import flash.display.DisplayObject;
	
	public class AbstractDisplayObjectPlugin extends AbstractPlugin
	{
		
		public function AbstractDisplayObjectPlugin(properties:Array) 
		{
			super(properties);
		}
		
		override public function supports(target:Object):Boolean 
		{
			return target is DisplayObject;
		}
		
	}

}