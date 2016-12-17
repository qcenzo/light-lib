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
	import flash.events.MouseEvent;

	public class VScrollBar extends VSlider
	{
		private var _hasListened:Boolean;
		private var _autoHide:Boolean;
		private var _viewportScrollUp:Function;
		private var _viewportScrollTo:Function;
		private var _viewportScrollDown:Function;
		private var _viewportYRatio:Function;

		public var top:Button;
		public var up:Button;
		public var down:Button;
		public var end:Button;
		
		public function VScrollBar()
		{
			_inside = true;
			_liveDragging = true; 
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if (index < -2)
			{
				switch (index)
				{
					case -3:
						top = super.addChildAt(child, 0) as Button;
						break;
					case -4:
						up = super.addChildAt(child, 0) as Button;
						break;
					case -5:
						down = super.addChildAt(child, 0) as Button;
						break;
					case -6:
						end = super.addChildAt(child, 0) as Button;
						break;
				}
				
				return child;
			}
			
			return super.addChildAt(child, index);
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			super.mouseEnabled = enabled;
			
			if (top != null)
				top.mouseEnabled = enabled;
			if (up != null)
				up.mouseEnabled = enabled;
			if (down != null)
				down.mouseEnabled = enabled;
			if (end != null)
				end.mouseEnabled = enabled; 
		}
		
		[Deprecated]
		override public function inside():void {}
		
		[Deprecated]
		override public function set liveDragging(value:Boolean):void {}
		
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
		}
		
		override protected function initListeners():void
		{
			if (_viewportYRatio == null)
				return;
			
			super.initListeners();
			
			if (top != null)
				top.addEventListener(MouseEvent.CLICK, scrollToTop);
			if (up != null)
				up.addEventListener(MouseEvent.CLICK, scrollUp);
			if (down != null)
				down.addEventListener(MouseEvent.CLICK, scrollDown);
			if (end != null)
				end.addEventListener(MouseEvent.CLICK, scrollToEnd);
			
			_hasListened = true;
		}
		
		override protected function updateValue():void
		{
			_viewportScrollTo((_p - _p0) / _distance); 
		}
		
		internal function setViewportCallbacks(viewportScrollUp:Function, viewportScrollTo:Function, viewportScrollDown:Function, viewportYRatio:Function):void
		{
			_viewportScrollUp = viewportScrollUp;
			_viewportScrollTo = viewportScrollTo;
			_viewportScrollDown = viewportScrollDown;
			_viewportYRatio = viewportYRatio;
			
			if (!_hasListened)
				initListeners();
			
			thumb.y = _p0 + _distance * _viewportYRatio() - _offset;
		}
		
		internal function resize(heightRatio:Number):void
		{
			if (heightRatio == 1)
			{
				if (_autoHide)
					visible &&= false;
				else
				{
					mouseEnabled &&= false;
					thumb.visible &&= false;
				}
				return;
			}
			
			visible ||= true;
			mouseEnabled ||= true;
			thumb.visible ||= true;
			
			thumb.height = track.height * heightRatio;
			initVars();
			
			thumb.y = _p0 + _distance * _viewportYRatio() - _offset;
		}
		
		private function scrollToTop(event:MouseEvent):void
		{
			if (_viewportScrollTo(0))
				thumb.y = _p0 - _offset;
		}
		
		private function scrollUp(event:MouseEvent):void
		{
			if (_viewportScrollUp())
				thumb.y = _p0 + _distance * _viewportYRatio() - _offset;
			else
				scrollToTop(null);
		}
		
		private function scrollDown(event:MouseEvent):void
		{
			if (_viewportScrollDown())
				thumb.y = _p0 + _distance * _viewportYRatio() - _offset;
			else
				scrollToEnd(null);
		}
		
		private function scrollToEnd(event:MouseEvent):void
		{
			if (_viewportScrollTo(1))
				thumb.y = _p1 - _offset;
		}
	}
}