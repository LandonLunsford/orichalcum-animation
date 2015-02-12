package orichalcum.ui {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Slider extends Sprite
	{
		
		private var _value:Number = 0;
		private var _minimum:Number = 0;
		private var _maximum:Number = 1;
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			if (_value == value) return;
			_value = value;
			_change();
		}
		
		public function get minimum():Number 
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void 
		{
			if (_minimum == value) return;
			_minimum = value;
			_change();
		}
		
		public function get maximum():Number 
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void 
		{
			if (_maximum == value) return;
			_maximum = value;
			_change();
		}
		
		public function get length():Number
		{
			return Math.abs(_maximum - _minimum);
		}
		
		public function get progress():Number
		{
			const length:Number = this.length;
			return length == 0 ? 0 : _value / length;
		}
		
		public function set progress(value:Number):void
		{
			this.value = Math.min(Math.max(value, 0), 1) * length;
		}
		
		private function _change():void 
		{
			while (numChildren)
				removeChildAt(0);
				
			if (isNaN(value)
			|| isNaN(minimum)
			|| isNaN(maximum))
				return;
				
			const bar:Sprite = new Sprite;
			bar.graphics.beginFill(0xe8e8e8);
			bar.graphics.drawRect(0, 0, length, length * 0.1);
			bar.graphics.endFill();
			bar.name = 'slider.bar';
			addChild(bar);
			
			const dot:Sprite = new Sprite;
			dot.graphics.beginFill(0xabcdef);
			dot.graphics.drawRect(0, 0, length * 0.1, length * 0.1);
			dot.graphics.endFill();
			dot.name = 'slider.dot';
			addChild(dot);
			
			dot.x = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}
