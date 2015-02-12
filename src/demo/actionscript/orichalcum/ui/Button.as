package orichalcum.ui {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Button extends Sprite
	{
		
		private var _value:Number;
		
		public function Button() 
		{
			graphics.beginFill(0x998877);
			graphics.drawRect(0, 0, 48, 48);
			graphics.endFill();
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			if (_value == value) return;
			_value = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}