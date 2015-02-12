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
		
		/*
		 * Probably needs plugin data too, just a guess
		 */
		public function invoke(forward:Boolean):* 
		{
			for (var propertyName:String in _properties)
			{
				/*
					May want to throw more informational error
					than flashes cryptic one if this goes wrong.
				 */
				target[propertyName] = _properties[propertyName];
			}
		}
	}

}