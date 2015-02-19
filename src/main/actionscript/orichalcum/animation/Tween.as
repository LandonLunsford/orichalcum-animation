package orichalcum.animation 
{
	import orichalcum.animation.plugin.IPlugin;
	import orichalcum.animation.PluginRepository;
	
	public class Tween extends TransformableInterval
	{
		
		/*
		 * Stateful static - bad practice but terribly convenient
		 */
		internal static const plugins:PluginRepository = new PluginRepository;
		internal var _initialized:Boolean;
		internal var _target:Object;
		internal var _to:Object;
		internal var _from:Object;
		internal var _ease:Function = Ease.linear;
		internal var _pluginProperties:Object;
		internal var _integration:Function;
		
		public function Tween(target:Object)
		{
			_integration = Integration.getOptimalIntegrationStrategy(this);
			_target = target;
		}
		
		internal function get pluginProperties():Object
		{
			return _pluginProperties ||= {};
		}
		
		public function target(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _target;
			}
			_target = target;
			return this;
		}
		
		public function to(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _to ||= {};
			}
			_to = value;
			return this;
		}
		
		public function from(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _from ||= {};
			}
			_from = value;
			return this;
		}
		
		public function ease(value:* = undefined):*
		{
			if (arguments.length == 0)
			{
				return _ease as Function;
			}
			_ease = value;
			return this;
		}
		
		override public function iterations(value:* = undefined):*
		{
			const result:* = super.iterations.apply(this, arguments);
			if (arguments.length != 0)
			{
				_integration = Integration.getOptimalIntegrationStrategy(this);
			}
			return result;
		}
		
		override public function wave(value:* = undefined):*
		{
			const result:* = super.wave.apply(this, arguments);
			if (arguments.length != 0)
			{
				_integration = Integration.getOptimalIntegrationStrategy(this);
			}
			return result;
		}
		
		override internal function integrate():void 
		{
			Integration.integrate(this, _integration);
		}
		
		internal function initialize():void
		{
			if (_initialized
			|| (_to == null && _from == null))
				return;
			
			_initialized = true;
			
			var a:*, b:*,
				valueCandidate:*,
				value:*,
				property:String,
				values:Object = _to ? _to : _from;
				
			_from ||= {};
			_to ||= {};
			
			for (property in values)
			{
				a = (_from[property] ||= (property in _target ? _target[property] : undefined));
				b = (_to[property] ||= (property in _target ? _target[property] : undefined));
				
				value = a;
				for each(var plugin:IPlugin in plugins.pluginsByProperty[property])
				{
					if (!plugin.supports(target))
						continue;
					
					valueCandidate = plugin.init(this, property, a);
					if (valueCandidate !== undefined) value = valueCandidate;
				}
				if (property in target && value !== undefined) _target[property] = value;
			}
		}
		
		public function invalidate():void
		{
			_initialized = false;
		}
		
	}

}