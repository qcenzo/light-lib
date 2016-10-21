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
	import flash.events.Event;

	public class TextArea extends TextInput
	{
		private var _yRatio:Number;
		private var _stepSize:Number;
		private var _vscrollBar:VScrollBar;
		
		public function TextArea()
		{
			_multiline = true;
			_wordWrap = true; 
			super(); 
			super.mouseWheelEnabled = false;
		}
		
		[Deprecated]
		override public function set mouseWheelEnabled(value:Boolean):void {}
		
		public function set vscrollBar(value:VScrollBar):void
		{
			_yRatio ||= 0;
			_stepSize ||= 1;
			
			_vscrollBar = value;
			_vscrollBar.setViewportCallbacks(scrollUp, scrollTo, scrollDown, getYRatio);

			if (!hasEventListener(Event.CHANGE))
				addEventListener(Event.CHANGE, onChange);
			
			onChange(null);
		}
		
		public function get vscrollBar():VScrollBar
		{
			return _vscrollBar;
		}
		
		public function set stepSize(value:Number):void
		{
			if (value != value || value <= 0)
				return;
			_stepSize = value;
		}
		
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		private function scrollUp():Boolean
		{
			if (scrollV - _stepSize < 1)
				return false;
			scrollV -= _stepSize;
			_yRatio = (scrollV - 1) / (maxScrollV - 1);
			return true;
		}
		
		private function scrollTo(yRatio:Number):Boolean
		{
			if (_yRatio == yRatio)
				return false;
			_yRatio = yRatio;
			scrollV = (maxScrollV - 1) * _yRatio + 1;
			return true;
		}
		
		private function scrollDown():Boolean
		{
			if (scrollV + _stepSize > maxScrollV)
				return false;
			scrollV += _stepSize;
			_yRatio = (scrollV - 1) / (maxScrollV - 1);
			return true;
		}
		
		private function getYRatio():Number
		{
			return _yRatio;
		}
		
		private function onChange(event:Event):void
		{
			_vscrollBar.resize((bottomScrollV - scrollV + 1) / numLines); 
		}
	}
}