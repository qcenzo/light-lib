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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Dispatched when <code>value</code> property is changing.
	 * 
	 */
	[Event(name="change", type="flash.events.Event")]
	
	public class Slider extends Range
	{
		private static const _EVENT_CHANGE:Event = new Event(Event.CHANGE);
		protected var _liveDragging:Boolean;
		protected var _inside:Boolean;
		protected var _p:Number;
		protected var _p0:Number;
		protected var _p1:Number;
		protected var _distance:Number;
		protected var _offset:Number;
		
		public var thumb:Button;
		public var track:Sprite; 
		
		public function Slider()
		{
			super();
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if (index < 0)
			{
				switch (index)
				{
					case -1:
						thumb = super.addChildAt(child, 0) as Button;
						break;
					case -2:
						track = super.addChildAt(child, 0) as Sprite;
						break;
				}
				
				if (thumb != null && track != null)
					addEventListener(Event.ADDED_TO_STAGE, init);
				
				return child;
			}
			return super.addChildAt(child, index);
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			super.mouseEnabled = enabled;
			mouseChildren = enabled;
			if (thumb != null)
				thumb.mouseEnabled = enabled;
		}
		
		override public function set value(value:Number):void
		{
			if (stage == null)
			{
				_value = value;
				return;
			}
			
			if (_p == _p && value == _value)
			{
				_p = NaN;
				return;
			}
			
			if (value != value || value <= _minimum)
			{
				_value = _minimum;
				_p = _p0;
			}
			else if (value >= _maximum)
			{
				_value = _maximum;
				_p = _p1;
			}
			else
			{
				_value = value;
				_p = _p0 + _distance * (_value - _minimum) / length;
			}
		}
		
		public function inside():void
		{
			_inside = true;
		}
		
		public function get liveDragging():Boolean
		{
			return _liveDragging;
		}
		
		public function set liveDragging(value:Boolean):void
		{
			_liveDragging = value;
		}
	 
		protected function initListeners():void
		{
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			track.addEventListener(MouseEvent.CLICK, onClickTrack);
		}
		
		protected function updateValue():void
		{
			_value = _minimum + length * (_p - _p0) / _distance;
			dispatchEvent(_EVENT_CHANGE);
		}
		
		protected function initVars():void 
		{
		}
		
		protected function jumpTo():void 
		{
		}
		
		protected function dragTo():void
		{
		}
		
		private function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initVars();
			initListeners();
			
			if (_value == _value)
				value = _value;
		}
		
		private function startDragHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler); 
			stage.addEventListener("releaseOutside", stopDragHandler);
		}
		
		private function doDrag(event:MouseEvent):void
		{
			dragTo();
			if (_liveDragging)
				updateValue();
		}
		
		private function stopDragHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			stage.removeEventListener("releaseOutside", stopDragHandler);
			
			if (!_liveDragging)
				updateValue(); 
		}
		
		private function onClickTrack(event:MouseEvent):void
		{
			jumpTo();
			updateValue();
		}
	}
}