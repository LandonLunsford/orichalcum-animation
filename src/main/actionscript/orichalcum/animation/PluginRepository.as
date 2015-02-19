package orichalcum.animation
{
	import flash.utils.Dictionary;
	import orichalcum.animation.plugin.IPlugin;
	
	public class PluginRepository 
	{
		
		private var _pluginsByProperty:Dictionary = new Dictionary;
		
		internal function get pluginsByProperty():Dictionary 
		{
			return _pluginsByProperty;
		}
		
		public function add(...plugins:Array):void
		{
			if (plugins.length && plugins[0] is Array)
			{
				add.apply(this, Array);
			}
			else
			{
				for each(var plugin:IPlugin in plugins)
				{
					for each(var property:String in plugin.properties)
					{
						(_pluginsByProperty[property] ||= []).push(plugin);
					}
				}
			}
		}
		
	}

}