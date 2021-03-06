package orichalcum.animation 
{
	
	public class Init implements IInstance
	{
		
		private var _target:Object;
		private var _properties:Object;
		
		public function Init(target:Object, properties:Object) 
		{
			_target = target;
			_properties = properties;
		}
		
		public function forward():void 
		{
			setProperties();
		}
		
		public function backward():void
		{
			setProperties();
		}
		
		private function setProperties():void
		{
			for (var propertyName:String in _properties)
			{
				/*
					May want to throw more informational error
					than flashes cryptic one if this goes wrong.
				 */
				_target[propertyName] = _properties[propertyName];
			}
		}
	}

}