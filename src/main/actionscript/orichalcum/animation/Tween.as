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
		//internal var _integrator:Function;
		internal var _initialized:Boolean;
		internal var _pluginProperties:Object = {};
		
		public function Tween(target:Object)
		{
			Preconditions.assert(target != null, 'Argument "target" must not be null.');
			_target = target;
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
		
		override protected function integrate():void 
		{
			Integration2.integrate(this, Integration2.tweenIntegration);
		}
		
		internal function get pluginProperties():Object
		{
			return _pluginProperties;
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
				for each(var plugin:IPlugin in _pluginsByProperty[property])
				{
					valueCandidate = plugin.init(this, property, a);
					if (valueCandidate !== undefined) value = valueCandidate;
				}
				if (value !== undefined) _target[property] = value;
			}
		}
		
		public function invalidate():void
		{
			_initialized = false;
		}
		
		internal function get _pluginsByProperty():Dictionary
		{
			return __pluginsByProperty;
		}
		
		//private function _assume(a:Object, b:Object):void
		//{
			//for (var property:String in b)
			//{
				//a[property] = _target[property];
			//}
		//}
		
	}

}