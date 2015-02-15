package orichalcum.animation 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import orichalcum.animation.factory.call;
	import orichalcum.animation.plugin.IPlugin;
	
	public class Tween extends TransformableInterval
	{
		internal static const __pluginsByProperty:Dictionary = new Dictionary;
		
		//internal var _previousPosition:Number = 0;
		//internal var _position:Number = 0;
		//internal var _duration:Number = 0;
		//internal var _iterations:int = 1;
		//internal var _wave:Boolean;
		internal var _integrator:Function;
		
		internal var _target:Object;
		internal var _to:Object;
		internal var _from:Object;
		
		//internal var _isPlaying:Boolean;
		internal var _ease:Function = Ease.linear;
		//internal var _delay:Number = 0;
		//internal var _postDelay:Number = 0;
		//internal var _timeScale:Number = 1;
		//internal var _step:Number = 1;
		//internal var _frames:Boolean;
		
		//internal var _started:Call = Call.EMPTY;
		//internal var _changing:Call = Call.EMPTY;
		//internal var _changed:Call = Call.EMPTY;
		//internal var _repeated:Call = Call.EMPTY;
		//internal var _reversed:Call = Call.EMPTY;
		//internal var _completed:Call = Call.EMPTY;
		
		// could cache for performance boost
		//internal var _currentSpan:int;
		//internal var _previousSpan:int;
		internal var _initialized:Boolean;
		
		internal function get _pluginsByProperty():Dictionary
		{
			return __pluginsByProperty;
		}
		
		//private function copyProperties(a:Object, b:Object)
		//{
			//const properties:Object = {};
			//for (var n:String in a)
			//{
				//properties[n] = b[n];
			//}
			//return properties;
		//}
		
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
			_integrator(this);
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