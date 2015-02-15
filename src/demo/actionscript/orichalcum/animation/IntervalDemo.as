package orichalcum.animation 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import orichalcum.animation.factory.call;
	import orichalcum.animation.factory.init;
	import orichalcum.animation.factory.parallel;
	import orichalcum.animation.factory.sequence;
	import orichalcum.animation.factory.stagger;
	import orichalcum.animation.factory.timeline;
	import orichalcum.animation.factory.tween;
	import orichalcum.animation.factory.wait;
	import orichalcum.ui.Button;
	import orichalcum.ui.Slider;
	
	public class IntervalDemo extends Sprite
	{
		
		private var interval:IInterval;
		private var slider:Slider = new Slider;
		private var dragTarget:Sprite;
		private var playRate:Number = 0.025;
		private var target:Button = new Button;
		
		public function IntervalDemo() 
		{
			//var i:int = 9;
			var i:int = 1;
			var w:Boolean = false;
			//var w:Boolean = true;
			
			//interval = timeline(
				//init(target, {x: 300, y:300}),
				//call(fw('start'), bw('start')),
				//wait(300),
				//init(target, {x: 400, y:400}),
				//call(fw('middle'), bw('middle')),
				//wait(300),
				//init(target, {x: 500, y:500}),
				//call(fw('end'), bw('end'))
			//)
			//.iterations(i)
			//.wave(w)
			
			//interval = tween(target)
				//.to( {
					//x: stage.stageWidth * 0.75,
					//y: stage.stageHeight * 0.75
				//})
				//.duration(600)
				//.started(fw('started'), bw('started'))
				////.changing(fw('changing'), bw('changing'))
				////.changed(fw('changed'), bw('changed'))
				//.repeated(fw('repeated'), bw('repeated'))
				//.reversed(fw('reversed'), bw('reversed'))
				//.completed(fw('completed'), bw('completed'))
				//.ease(Ease.quadInOut)
				//.iterations(i)
				//.wave(w)
				//;
				
			interval = timeline(
				init(target, {x: 200, y: 200}),
				//wait(50),
				sequence(
					tween(target)
						.to( { x: 500 } )
						.duration(500)
						.completed(fw('1'), bw('1')),
					tween(target)
						.to( { y: 500 } )
						.duration(500)
						.completed(fw('2'), bw('2')),
					tween(target)
						.to( { x: 200 } )
						.duration(500)
						.completed(fw('3'), bw('3')),
					tween(target)
						.to( { y: 200 } )
						.duration(500)
						.completed(fw('4'), bw('4'))
				),
				call(fw('parent'))
			)
			.iterations(i)
			.wave(w)
				
			slider.x = 100;
			slider.y = 100;
			slider.value = 0;
			slider.minimum = 0;
			slider.maximum = 600;
			addChild(slider);
			buttons([
				0,
				Mathematics.EPSILON,
				150 * i,
				300 * i - Mathematics.EPSILON,
				300 * i,
				300 * i + Mathematics.EPSILON,
				450 * i,
				600 * i - Mathematics.EPSILON,
				600 * i
			]);
			
			const playButton:Button = new Button();
			playButton.x = slider.x;
			playButton.y = 400;
			playButton.name = 'playButton';
			addChild(playButton);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
			stage.addEventListener(MouseEvent.CLICK, stage_click);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
			
			addChild(target);
			
			target.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 128);
			
		}
		
		private function buttons(positions:Array):void
		{
			for (var i:int = 0; i < positions.length; i++)
			{
				var position:Number = positions[i];
				var button:Button = new Button;
				button.value = position;
				button.x = slider.x + button.width * 1.5 * i;
				button.y = slider.y + slider.height + button.height * 1.5;
				var text:TextField = new TextField;
				text.defaultTextFormat = new TextFormat('arial', 14, 0xffffff);
				text.text = String(position);
				button.addChild(text);
				button.mouseChildren = false;
				addChild(button);
			}
		}
		
		private function stage_click(event:MouseEvent):void 
		{
			if (event.target.name == 'playButton')
			{
				trace('[playing forward]');
				stage.addEventListener(Event.ENTER_FRAME, playForward);
			}
			else if (event.target is Button)
			{
				const position:Number = event.target.value;
				trace('[button:', position, ']');
				slider.progress = position / interval.length();
				interval.position(position);
			}
		}
		
		private function playForward(event:Event):void 
		{
			interval.progress(interval.progress() + playRate);
			slider.progress = interval.progress();
			
			if (interval.progress() == 1)
			{
				stage.removeEventListener(Event.ENTER_FRAME, playForward);
				stage.addEventListener(Event.ENTER_FRAME, playBackward);
				trace('[playing backward]');
			}
		}
		
		private function playBackward(event:Event):void 
		{
			interval.progress(interval.progress() - playRate);
			slider.progress = interval.progress();
			
			if (interval.progress() == 0)
			{
				stage.removeEventListener(Event.ENTER_FRAME, playBackward);
				trace('[playing completed]');
			}
		}
		
		private function stage_mouseDown(event:MouseEvent):void 
		{
			if (event.target.name == 'slider.dot')
			{
				dragTarget = event.target as Sprite;
				dragTarget.startDrag();
			}
		}
		
		private function stage_mouseUp(event:MouseEvent):void 
		{
			if (dragTarget)
			{
				dragTarget.stopDrag();
				dragTarget = null;
			}
		}
		
		private function stage_mouseMove(event:MouseEvent):void 
		{
			if (dragTarget)
			{
				const progress:Number = slider.mouseX / slider.length;
				slider.progress = progress;
				interval.progress(progress);
			}
		}
		
		private function fw(position:*):Function
		{
			return function():void { trace(' fw', position); };
		}
		
		private function bw(position:*):Function
		{
			return function():void { trace(' bw', position); };
		}
		
	}

}