package orichalcum.animation
{
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import orichalcum.animation.factory.call;
	import orichalcum.animation.factory.timeline;
	import orichalcum.animation.factory.wait;
	import orichalcum.animation.Timeline;
	import orichalcum.animation.Mathematics;
	
	public class TimelineTest 
	{
		
		private function oneIterationWavelessTimeline(s:Array):Timeline
		{
			/*
				Library can only guarantee stability on non Float numbers
			 */
			const i:Number = 50;
			return timeline(
				call(fw(s, 'start'), bw(s, 'start')),
				wait(i),
				call(fw(s, 'mid'), bw(s, 'mid')),
				wait(i),
				call(fw(s, 'end'), bw(s, 'end'))
			);
		}
		
		private function f(position:*):String { return 'fw_' + position; }
		private function b(position:*):String { return 'bw_' + position; }
		private const fs:String =  f('start');
		private const fm:String = f('mid');
		private const fe:String = f('end');
		private const bs:String = b('start');
		private const bm:String = b('mid');
		private const be:String = b('end');
		
		private function fw(state:Array, position:String):Function {
			return function():void { state.push(f(position)); };
		}
		
		private function bw(state:Array, position:String):Function {
			return function():void { state.push(b(position)); };
		}
		
		[Test]
		public function testConstructor():void
		{
			timeline();
		}
		
		[Test]
		public function i1wF_jump():void
		{
			jumpTest([0, 50, 100], 1);
		}
		
		[Test]
		public function i1wT_jump():void
		{
			const s:Array = [];
			jump(s, oneIterationWavelessTimeline(s).iterations(1).wave(true), [
				{c:100, e:[fs, fm, fe, be, bm, bs] },
				{c:000, e:[fs, fm, fe, be, bm, bs, fs, fm, fe, be, bm, bs] }
			]);
		}
		
		[Test]
		public function i2wF_jump():void
		{
			const s:Array = [];
			jump(s, oneIterationWavelessTimeline(s).iterations(2).wave(false), [
				{c:200, e:[fs, fm, fe, fs, fm, fe] },
				{c:000, e:[fs, fm, fe, fs, fm, fe, be, bm, bs, be, bm, bs] }
			]);
		}
		
		[Test]
		public function i2wT_jump():void
		{
			const s:Array = [];
			jump(s, oneIterationWavelessTimeline(s).iterations(2).wave(true), [
				{c:200, e:[fs, fm, fe, be, bm, bs, fs, fm, fe, be, bm, bs] },
				{c:000, e:[fs, fm, fe, be, bm, bs, fs, fm, fe, be, bm, bs, fs, fm, fe, be, bm, bs, fs, fm, fe, be, bm, bs] }
			]);
		}
		
		[Test]
		public function i1wF_sweep():void
		{
			const s:Array = [];
			const t:Timeline = oneIterationWavelessTimeline(s)
				.iterations(1).wave(false);
			const e:Array = [fs, fm, fe, be, bm, bs];
			sweepTest(s, t, e);
		}
		
		[Test]
		public function i1wT_sweep():void
		{
			const s:Array = [];
			const t:Timeline = oneIterationWavelessTimeline(s)
				.iterations(1).wave(true);
			var e:Array = [fs, fm, fe, be, bm, bs];
			e = e.concat(e);
			sweepTest(s, t, e);
		}
		
		[Test]
		public function i2wF_sweep():void
		{
			const s:Array = [];
			const t:Timeline = oneIterationWavelessTimeline(s)
				.iterations(2).wave(false);
			const e:Array = [fs, fm, fe, fs, fm, fe, be, bm, bs, be, bm, bs];
			sweepTest(s, t, e);
		}
		
		[Test]
		public function i2wT_sweep():void
		{
			const s:Array = [];
			const t:Timeline = oneIterationWavelessTimeline(s)
				.iterations(2).wave(true);
			var e:Array = [fs, fm, fe, be, bm, bs, fs, fm, fe, be, bm, bs];
			e = e.concat(e);
			sweepTest(s, t, e);
		}
		
		/*
			In order to fully automate it must generate
			the "e" expected values
		 */
		private function jumpTest(cs:Array, n:Number = 1):void
		{
			var s:Array = []; // the state
			const t:Timeline = timeline();
			const fw:Function = function(c:*, state:Array):Function {
				return function():void {
					trace(f(c));
					state.push(f(c)); };
			};
			const bw:Function = function(c:*, state:Array):Function {
				return function():void {
					trace(b(c));
					state.push(b(c)); };
			};
			const fs:String = f(cs[0]);
			const fm:String = f(cs[1]);
			const fe:String = f(cs[2]);
			const bs:String = b(cs[0]);
			const bm:String = b(cs[1]);
			const be:String = b(cs[2]);
			
			var p:Number = 0;
			for each(var c:Number in cs) {
				t.add(wait(c - p));
				t.add(call(fw(c, s), bw(c, s)));
				p += c;
			}
			
			var e1:Array = [
				{c:cs[0], e:[] },
				{c:cs[2], e:[fs, fm, fe] },
				{c:cs[0], e:[fs, fm, fe, be, bm, bs] }
			];
			
			var e2:Array = [
				{c:cs[0], e:[] },
				{c:cs[1], e:[fs, fm] },
				{c:cs[2], e:[fs, fm, fe] },
				{c:cs[1], e:[fs, fm, fe, be, bm] },
				{c:cs[0], e:[fs, fm, fe, be, bm, bs] }
			];
			
			var e3:Array = [
				{c:cs[0] + 0, e:[] },
				{c:cs[0] + n, e:[fs] },
				
				{c:cs[1] - n, e:[fs] },
				{c:cs[1] + 0, e:[fs, fm] },
				{c:cs[1] + n, e:[fs, fm] },
				
				{c:cs[2] - n, e:[fs, fm] },
				{c:cs[2] + 0, e:[fs, fm, fe] },
				{c:cs[2] - n, e:[fs, fm, fe, be] },
				
				{c:cs[1] + n, e:[fs, fm, fe, be] },
				{c:cs[1] + 0, e:[fs, fm, fe, be, bm] },
				{c:cs[1] - n, e:[fs, fm, fe, be, bm] },
				
				{c:cs[0] + n, e:[fs, fm, fe, be, bm] },
				{c:cs[0] + 0, e:[fs, fm, fe, be, bm, bs] }
			];
			
			jump(s, t, e1);
			jump(s, t, e2);
			jump(s, t, e3);
		}
		
		private function jump(s:Array, t:Timeline, iterations:Array):void
		{
			t.position(0);
			s.length = 0;
			for each(var i:Object in iterations)
			{
				//trace('b', t.dump());
				t.position(i.c);
				//trace(i.c, i.e, s);
				//trace('a', t.dump());
				assertThat('Position: ' + i.c ,s, equalTo(i.e));
			}
		}
		
		private function sweepTest(s:Array, t:Timeline, e:Array):void
		{
			const L:Number = t.length();
			const k:Number = 1;
			for (var i:Number = -k; i <= L + k; i += k)
			{
				t.position(i);
				verifySweepState(e, s, i, 'forward');
			}
			for (; i >= -k; i -= k)
			{
				t.position(i);
				verifySweepState(e, s, i, 'backward');
			}
		}
		
		private function verifySweepState(e:Array, s:Array, i:Number, direction:String):void
		{
			const message:String = 'State became invalid at position (' + i.toString() + ') while sweeping ' + direction + '.';
			assertThat(message, s, equalTo(e.slice(0, s.length)));
		}
		
		/*
			return;
			
			var s:Array = [];
			const n:Number = 1;
			const c1:Number = 0;
			const c2:Number = 50; 
			const c3:Number = 100;
			const t:Timeline = timeline(
				wait(c1),
				call(fw(s, 'start'), bw(s, 'start')),
				wait(c2 - c1),
				call(fw(s, 'mid'), bw(s, 'mid')),
				wait(c3 - c2 - c1),
				call(fw(s, 'end'), bw(s, 'end'))
			);
			
			// full steps
			t.position(c1); s.length = 0;
			t.position(c3); assertThat(s, equalTo([fs, fm, fe]));
			t.position(c1); assertThat(s, equalTo([fs, fm, fe, be, bm, bs]));
			
			// half steps
			t.position(c1); s.length = 0;
			t.position(c2); assertThat(s, equalTo([fs, fm]));
			t.position(c3); assertThat(s, equalTo([fs, fm, fe]));
			t.position(c2); assertThat(s, equalTo([fs, fm, fe, be, bm]));
			t.position(c1); assertThat(s, equalTo([fs, fm, fe, be, bm, bs]));
			
			// slow steps
			t.position(c1); s.length = 0;
			t.position(c1 + n); assertThat(s, equalTo([fs]));
			t.position(c2 - n); assertThat(s, equalTo([fs]));
			t.position(c2); assertThat(s, equalTo([fs, fm]));
			t.position(c2 + n); assertThat(s, equalTo([fs, fm]));
			t.position(c3 - n); assertThat(s, equalTo([fs, fm]));
			t.position(c3); assertThat(s, equalTo([fs, fm, fe]));
			t.position(c3 - n); assertThat(s, equalTo([fs, fm, fe, be]));
			t.position(c2 + n); assertThat(s, equalTo([fs, fm, fe, be]));
			t.position(c2); assertThat(s, equalTo([fs, fm, fe, be, bm]));
			t.position(c1 + n); assertThat(s, equalTo([fs, fm, fe, be, bm]));
			t.position(c1); assertThat(s, equalTo([fs, fm, fe, be, bm, bs]));
		 */
		
	}

}