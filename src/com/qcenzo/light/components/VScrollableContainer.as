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
	import flash.geom.Rectangle;
	
	internal class VScrollableContainer extends Sprite implements IVScrollable
	{
		private var _scrollRect:Rectangle;
		private var _stepSize:Number;
		private var _yRatio:Number;
		private var _tempRatio:Number;
		private var _heightRatio:Number;
		private var _maxScrollY:Number;
		private var _vscrollBar:VScrollBar;
		
		public function VScrollableContainer()
		{
			super();
		}
		
		override public function set scrollRect(value:Rectangle):void
		{
			if (_scrollRect != value)
			{
				_scrollRect = value;
				_maxScrollY = height - _scrollRect.height;
			}
			
			super.scrollRect = _scrollRect;
		}
		
		override public function get scrollRect():Rectangle
		{
			return _scrollRect;
		}
		
		public function set vscrollBar(value:VScrollBar):void
		{
			if (_yRatio == _yRatio)
				_heightRatio = NaN;
			else
				_yRatio = 0;
			
			_vscrollBar = value;
			_vscrollBar.setViewportCallbacks(scrollUp, scrollTo, scrollDown, getYRatio);
			
			dispatchChange();
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
		
		protected final function dispatchChange():void
		{
			if (_vscrollBar == null)
				return; 
			
			_tempRatio = _scrollRect.height / height;
			if (_tempRatio >= 1)
			{
				_vscrollBar.resize(1);
				return;
			}
			
			if (_heightRatio == _tempRatio)
				return;
				
			_heightRatio = _tempRatio;
			_vscrollBar.resize(_heightRatio); 
			
			_maxScrollY = height - _scrollRect.height;
			if (_scrollRect.y > _maxScrollY)
			{
				_scrollRect.y = _maxScrollY;
				scrollRect = _scrollRect;
				_yRatio = 1;
			}
		}
		
		private function scrollUp():Boolean
		{
			if (_scrollRect.y - _stepSize < 0)
				return false;
				
			_scrollRect.y -= _stepSize;
			scrollRect = _scrollRect;
			_yRatio = _scrollRect.y / _maxScrollY;
			
			return true; 
		}
		
		private function scrollTo(yRatio:Number):Boolean
		{
			if (_yRatio == yRatio)
				return false;
				
			_yRatio = yRatio;
			_scrollRect.y = _maxScrollY * _yRatio;
			scrollRect = _scrollRect;
			
			return true;
		}
		
		private function scrollDown():Boolean
		{
			if (_scrollRect.y + _stepSize > _maxScrollY)
				return false;
				
			_scrollRect.y +=_stepSize;
			scrollRect = _scrollRect;
			_yRatio = _scrollRect.y / _maxScrollY;
			
			return true;
		}
		
		private function getYRatio():Number
		{
			return _yRatio;
		}
	}
}