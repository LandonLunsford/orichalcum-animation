package orichalcum.animation 
{
	
	public class Timeline extends TransformableInterval
	{
		
		internal var _insertionPosition:Number = 0;
		internal var _children:Array = [];
		internal var _integration:Function;
		
		public function Timeline(...instancesAndIntervalsAndDirectives) 
		{
			_integration = Integration.getOptimalIntegrationStrategy(this);
			add.apply(this, instancesAndIntervalsAndDirectives);
		}
		
		public function add(...args):void
		{
			if (args.length == 0) return;
			
			for each(var x:* in args)
			{
				var p:Number = args[0] is Number ? args[0] : insertionPosition;
				if (x is IInterval)
				{
					_children.push(new TimelineEntry(p, x));
					insertionPosition = Math.max(insertionPosition, p + x.length());
				}
				else if (x is IInstance)
				{
					_children.push(new TimelineEntry(p, x));
				}
				else if (x is IDirective)
				{
					(x as IDirective).apply(this);
				}
				else if (x is String)
				{
					positionsByLabel[x] = insertionPosition;
				}
				else if ('length' in x)
				{
					add.apply(this, x);
				}
			}
		}
		
		internal function get insertionPosition():Number
		{
			return _insertionPosition;
		}
		
		internal function set insertionPosition(value:Number):void
		{
			value = Math.max(0, (isNaN(value) ? 0 : value));
			if (_insertionPosition >= value) return;
			_insertionPosition = value;
			if (_duration < value)
			{
				_duration = value;
			}
		}
		
		public function get children():Array 
		{
			return _children;
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
		
	}

}