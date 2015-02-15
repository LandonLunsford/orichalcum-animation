package orichalcum.animation 
{
	import orichalcum.animation.factory.call;
	
	public class ListenableInterval extends Interval
	{
		
		internal var _started:CompoundCall;
		internal var _changing:CompoundCall;
		internal var _changed:CompoundCall;
		internal var _repeated:CompoundCall;
		internal var _reversed:CompoundCall;
		internal var _completed:CompoundCall;
		
		public function started(forwardCallback:Function, backwardCallback:Function = undefined):*
		{
			(_started ||= new CompoundCall)
				.add(call(forwardCallback, backwardCallback));
			return this;
		}
		
		public function changing(forwardCallback:Function, backwardCallback:Function = undefined):*
		{
			(_changing ||= new CompoundCall)
				.add(call(forwardCallback, backwardCallback));
			return this;
		}
		
		public function changed(forwardCallback:Function, backwardCallback:Function = undefined):*
		{
			(_changed ||= new CompoundCall)
				.add(call(forwardCallback, backwardCallback));
			return this;
		}
		
		public function repeated(forwardCallback:Function, backwardCallback:Function = undefined):*
		{
			(_repeated ||= new CompoundCall)
				.add(call(forwardCallback, backwardCallback));
			return this;
		}
		
		public function reversed(forwardCallback:Function, backwardCallback:Function = undefined):*
		{
			(_reversed ||= new CompoundCall)
				.add(call(forwardCallback, backwardCallback));
			return this;
		}
		
		public function completed(forwardCallback:Function, backwardCallback:Function = undefined):*
		{
			(_completed ||= new CompoundCall)
				.add(call(forwardCallback, backwardCallback));
			return this;
		}
		
	}

}