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
	import flash.display.Sprite;
	
	/**
	 * The <code>Range</code> class holds a <code>value</code> and an allowed range for that <code>value</code>, 
	 * defined by <code>minimum</code>(default=0) and <code>maximum</code>(default=100) properties.
	 * 
	 */
	internal class Range extends Sprite
	{
		private var _length:Number;
		private var _lengthChanged:Boolean;
		
		protected var _minimum:Number;
		protected var _maximum:Number;
		protected var _value:Number;
		
		public function Range()
		{
			_minimum = _value = 0;
			_length = _maximum = 100;
		}
		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			if (value != value)
				return;
			_minimum = value;
			_lengthChanged ||= true;
		}
		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			if (value != value)
				return;
			_maximum = value;
			_lengthChanged ||= true;
		}
		
		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = value;
		}
		
		public function get length():Number
		{
			if (_lengthChanged)
			{
				_length = _maximum - _minimum;
				_lengthChanged = false;
			}
			return _length;
		}
	}
}