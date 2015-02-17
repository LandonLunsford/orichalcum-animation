package orichalcum.animation 
{
	
	internal class Functions 
	{
		
		static public const VOID:Function = function(...args):void { };
		
		static public function equalTo(object:*):Function
		{
			return function(item:*, index:int, items:*):Boolean {
				return item === object;
			}
		}
		
	}

}