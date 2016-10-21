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
	internal class HSlider extends Slider 
	{
		public function HSlider()
		{
			super();
		}
		
		override public function set value(value:Number):void
		{
			super.value = value;
			if (_p == _p)
				thumb.x = _p - _offset;
		}
		
		override protected function initVars():void
		{
			_p0 = track.x;
			_distance = track.width;
			_offset = thumb.width * 0.5;
			if (_inside)
			{
				_p0 += _offset;
				_distance -= thumb.width;
			}
			_p1 = _p0 + _distance;
		}
		
		override protected function jumpTo():void
		{
			_p = thumb.x + thumb.mouseX;
			if (_p < _p0)
				_p = _p0;
			else if (_p > _p1)
				_p = _p1;
			
			thumb.x = _p - _offset;
		}
		
		override protected function dragTo():void
		{
			if (mouseX < _p0)
				_p = _p0;
			else if (mouseX > _p1)
				_p = _p1;
			else
				_p = mouseX;
			
			thumb.x = _p - _offset;
		}
	}
}