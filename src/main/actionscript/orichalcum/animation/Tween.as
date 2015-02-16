package orichalcum.animation 
{
	import flash.utils.Dictionary;
	import orichalcum.animation.plugin.IPlugin;
	
	public class Tween extends TransformableInterval
	{
		internal static const __pluginsByProperty:Dictionary = new Dictionary;
		internal var _target:Object;
		internal var _to:Object;
		internal var _from:Object;
		internal var _ease:Function = Ease.linear;
		internal var _integrator:Function;
		internal var _initialized:Boolean;
		internal var _pluginProperties:Object = {};
		
		public function get pluginProperties():Object
		{
			return _pluginProperties;
		}
		
		internal function get _pluginsByProperty():Dictionary
		{
			return __pluginsByProperty;
		}
		
		private function _assume(a:Object, b:Object):void
		{
			for (var property:String in b)
			{
				a[property] = _target[property];
			}
		}
		
		internal function initialize():void
		{
			if (_initialized || (_to == null && _from == null))
				return;
			
			_initialized = true;
			_from ||= {};
			_to ||= {};
			
			var a:*,b:*,c:*,v:*,n:String,values:Object = _to ? _to : _from;
			
			for (n in values)
			{
				v = a = (_from[n] ||= _target[n]);
				b = (_to[n] ||= _target[n]);
				
				for each(var plugin:IPlugin in _pluginsByProperty[n])
				{
					c = plugin.init(this, n, a);
					if (c !== undefined) v = c;
				}
				if (v !== undefined) _target[n] = v;
			}
		}
		
		public function invalidate():void
		{
			_initialized = false;
		}
		
		public function Tween(target:Object)
		{
			//assertNotNull(target, 'Argument "target" must not be null.');
			_target = target;
			_determineOptimalIntegrationStrategy();
			//play();
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
				return _ease;
			}
			_ease = value;
			return this;
		}
		
		override protected function integrate():void 
		{
			//_integrator(this);
			Integration2.integrate(this, Integration2.tweenIntegration);
		}
		
		private function _determineOptimalIntegrationStrategy():void
		{
			_integrator = _iterations > 1
				? _wave ? Integration.tween_multiIteration_wave
					: Integration.tween_multiIteration_waveless
				: _wave ? Integration.tween_signleIteration_wave
					: Integration.tween_signleIteration_waveless;
		}
		
	}

}