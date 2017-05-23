package com.qcenzo.light.components
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class Toast
	{
		private static var _v:Boolean;
		private static var _t:Toast;
		
		private var _b:Sprite;
		private var _l:TextField;
		private var _m:Timer;
		private var _r:Sprite;

		public function Toast()
		{
			if (!_v)
				throw new Error();
			_b = new Sprite();
			_b.mouseChildren = _b.mouseEnabled = false;
			_l = new TextField();
			_b.addChild(_l);
			_m = new Timer(3000); 
		}
		
		public function set root(r:Sprite):void
		{
			_r = r;
		}
		
		public static function get me():Toast
		{
			if (_t == null)
			{
				_v = true;
				_t = new Toast();
			}
			return _t;
		}
		
		public function show(message:String, duration:int = 3000):void
		{
			_l.htmlText = "<p align='center'><font color='#FFFFFF' size='12' face='Microsoft Yahei'>" + message + "</font></p>";
			_l.width = _l.textWidth + 4;
			_l.height = _l.textHeight + 4;
			_l.x = 8;
			_l.y = 4;
			
			_b.graphics.clear();
			_b.graphics.beginFill(0, 0.6);
			_b.graphics.drawRoundRect(0, 0, _l.width + 16, _l.height + 8, 12, 12);
			_b.graphics.endFill();
			
			_b.x = _r.stage.stageWidth - _b.width >> 1;
			_b.y = _r.stage.stageHeight * 0.6;
			_r.addChild(_b);
			
			if (_m.running)
				_m.reset();
			else
				_m.addEventListener(TimerEvent.TIMER, onTimer);
			_m.delay = duration;
			_m.start();
		}
		
		public function clear():void
		{
			_m.running && onTimer(null);
		}
		
		private function onTimer(event:TimerEvent):void
		{
			_m.removeEventListener(TimerEvent.TIMER, onTimer);
			_m.stop();
			_r.removeChild(_b);
		}
	}
}