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
	
	public class Group extends VScrollableContainer
	{
		private var _rowCount:int;
		private var _columnCount:int;
		private var _rowSpacing:int;
		private var _columnSpacing:int;
		private var _gridWidth:int;
		private var _gridHeight:int; 
		
		public function Group()
		{
			super();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(needRealign() ? setXY(child) : child);
			dispatchChange();
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			needRealign() ? super.addChild(setXY(child)) : super.addChildAt(child, index);
			dispatchChange();
			return child;
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void 
		{
			if (!needRealign())
				super.setChildIndex(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (needRealign())
				resetXY(getChildIndex(child));
			super.removeChild(child);
			dispatchChange();
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			if (needRealign())
				resetXY(index);
			var child:DisplayObject = super.removeChildAt(index);
			dispatchChange();
			return child;
		}
		
		override public function removeChildren(beginIndex:int=0, endIndex:int=2147483647):void
		{
			if (beginIndex == endIndex)
				removeChildAt(beginIndex);
			else
			{
				if (needRealign() && endIndex < numChildren - 1)
					resetXY(endIndex, endIndex - beginIndex + 1);

				super.removeChildren(beginIndex, endIndex);
			}
			dispatchChange();
		}
		
		override public function get width():Number
		{
			if (numChildren == 0)
				return 0;
			return (numChildren < _columnCount ? numChildren : _columnCount) * _gridWidth - _columnSpacing;
		}
		
		override public function get height():Number
		{
			if (numChildren == 0)
				return 0;
			return numChildren <= _columnCount ? (_gridHeight - _rowSpacing)
				: (Math.ceil(numChildren / _columnCount) * _gridHeight - _rowSpacing);
		}
		
		public function get rowCount():int
		{
			return _rowCount;
		}
		
		public function set rowCount(value:int):void
		{
			if (value > 1)
				_rowCount = value;
		}
		
		public function get columnCount():int
		{
			return _columnCount;
		}
		
		public function set columnCount(value:int):void
		{
			if (value > 1)
				_columnCount = value;
		}
		
		public function get rowSpacing():int
		{
			return _rowSpacing;
		}
		
		public function set rowSpacing(value:int):void
		{
			_rowSpacing = value;
		}
		
		public function get columnSpacing():int
		{
			return _columnSpacing;
		}
		
		public function set columnSpacing(value:int):void
		{
			_columnSpacing = value;
		}
		
		private function needRealign():Boolean
		{
			return _rowCount > 1 || _columnCount > 1;
		}
		
		private function setXY(child:DisplayObject):DisplayObject
		{
			if (numChildren > 0)
			{
				if (numChildren > _columnCount)
				{
					child.x = numChildren % _columnCount * _gridWidth;
					child.y = int(numChildren / _columnCount) * _gridHeight;
				}
				else
				{
					var lastChild:DisplayObject = getChildAt(numChildren - 1);
					if (numChildren == _columnCount)
						child.y = _gridHeight;
					else
					{
						if (numChildren == 1)
							child.x = _gridWidth;
						else
							child.x = lastChild.x + _gridWidth;
					}
				}
			}
			else
			{
				_gridWidth = child.width + _columnSpacing;
				_gridHeight = child.height + _rowSpacing;
				
				stepSize = _gridHeight; 
			}
			return child;
		}
		
		private function resetXY(index:int, spanLength:int = 1):void
		{
			var child1:DisplayObject;
			var child2:DisplayObject;
			for (var i:int = numChildren - 1; i > index; --i)
			{
				child1 = getChildAt(i);
				child2 = getChildAt(i - spanLength);
				child1.x = child2.x;
				child1.y = child2.y;
			}
		}
	}
}