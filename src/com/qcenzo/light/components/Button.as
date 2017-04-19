/*
MIT License

Copyright (c) 2016 Qcenzo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
package com.qcenzo.light.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Button extends Sprite	
	{
		private var _skin:Bitmap;
		private var _smoothing:Boolean;
		private var _outState:BitmapData;
		private var _overState:BitmapData;
		private var _downState:BitmapData;
		private var _disabledState:BitmapData;
		private var _pressed:Boolean;
		private var _listener:Function;

		public function Button()
		{
			_skin = new Bitmap();
			addChild(_skin);  

			super.mouseChildren = false;
		}
		
		[Deprecated]
		override public function set mouseChildren(enable:Boolean):void {}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			super.mouseEnabled = enabled;
			
			if (enabled)
				state(_outState);
			else
			{
				if (_disabledState != null)
					state(_disabledState);
			}
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return addChild(child);
		}
		
		override public function set height(value:Number):void
		{
			_skin.height = value;
			
			if (numChildren > 1)
			{
				var n:int = numChildren;
				var c:DisplayObject;
				
				while (n-- > 0)
				{
					c = getChildAt(n);
					if (c == _skin)
						continue;
					c.y = value - c.height >> 1;
				}
			}
		}
		
		override public function get height():Number
		{
			return _skin.height;
		}
		
		public function set onClick(listener:Function):void
		{
			_listener = listener; 
		}
		
		internal function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}
		
		internal function set outState(state:BitmapData):void
		{
			_outState = state;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener("releaseOutside", onMouseUpOutside);
			
			onMouseOut(null);
		}
		
		internal function set overState(state:BitmapData):void
		{
			_overState = state;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		internal function set downState(state:BitmapData):void
		{
			_downState = state; 
		}
		
		internal function set disabledState(state:BitmapData):void
		{
			_disabledState = state;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_pressed = true;
			if (_downState != null)
				state(_downState);
		}

		private function onMouseOut(event:MouseEvent):void
		{ 
			if (!_pressed)
				state(_outState);
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			if (!_pressed)
				state(_overState);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{ 
			if (_pressed && _listener != null)
				_listener.call();
			state(_overState != null ? _overState : _outState);
			_pressed = false;
		}
		
		private function onMouseUpOutside(event:MouseEvent):void
		{ 
			state(_outState);
			_pressed = false;
		}
		
		private function state(bitmapData:BitmapData):void
		{
			_skin.bitmapData = bitmapData;
			_skin.smoothing = _smoothing;
		}
	}
}