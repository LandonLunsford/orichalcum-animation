package orichalcum.animation.plugin 
{
	import flash.display.MovieClip;
	
	public class AbstractMovieClipPlugin extends AbstractPlugin
	{
		
		public function AbstractMovieClipPlugin(properties:Array) 
		{
			super(properties);
		}
		
		override public function supports(target:Object):Boolean 
		{
			return target is MovieClip;
		}
		
	}

}