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
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * The <code>BitmapX</code> class represents display objects that represent centrosymmetric or zygomorphous bitmap images, 
	 * these can be used as the background image of some panels and grids.
	 */
	public class BitmapX extends Bitmap  
	{
		private var _minWidth:int;
		private var _minHeight:int;
		private var _width:int;
		private var _height:int;
		private var _tlCorner:BitmapData;
		private var _blCorner:BitmapData;
		private var _smoothing:Boolean;
		
		public function BitmapX(width:int, height:int)
		{
			_width = width;
			_height = height;
		}
		
		override public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		override public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}
		
		override public function set width(value:Number):void
		{
			if (value != value || value == _width)
				return;
			
			if (value < _minWidth)
			{
				bitmapData.dispose();
				return;
			}
			
			_width = value;
			
			draw();
		}
		
		override public function set height(value:Number):void
		{
			if (value != value || value == _height)
				return;
			
			if (value < _minHeight)
			{
				bitmapData.dispose();
				return;
			}
			
			_height = value;
			
			draw();
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			if (_width == newWidth && _height == newHeight)
				return;
			
			if (newWidth < _minWidth || newHeight < _minHeight)
			{
				bitmapData.dispose();
				return;
			}
			
			_width = newWidth;
			_height = newHeight;
			
			draw();
		}
		
		public function clone():BitmapX
		{
			var clone:BitmapX = new BitmapX(_width, _height);
			clone.smoothing = _smoothing;
			clone.setCorners(_tlCorner, _blCorner);
			return clone;
		}
		
		internal function setCorners(topLeftCorner:BitmapData, bottomLeftCorner:BitmapData = null):void
		{
			_tlCorner = topLeftCorner;
			_blCorner = bottomLeftCorner;
			
			if (_blCorner == null)
			{
				_minWidth = _tlCorner.width + 1 << 1;
				_minHeight = _tlCorner.height + 1 << 1;
			}
			else
			{
				_minWidth = _tlCorner.width > _blCorner.width ? _tlCorner.width : _blCorner.width;
				_minWidth = _minWidth + 1 << 1;
				
				_minHeight = _tlCorner.height > _blCorner.height ? _tlCorner.height : _blCorner.height;
				_minHeight = _minHeight + 1 << 1;
			}
			
			draw(); 
		}
		
		private function draw():void
		{
			if (bitmapData != null)
				bitmapData.dispose();
			
			bitmapData = new BitmapData(_width, _height, true, 0);
			
			var w:int = _tlCorner.width;
			var h:int = _tlCorner.height;
			var o:int = _blCorner == null ? h << 1 : h + _blCorner.height;
			var r:Rectangle = new Rectangle();
			var m:Matrix = new Matrix();
			var b:BitmapData;
			
			// top left
			bitmapData.draw(_tlCorner);
			// top right
			m.scale(-1, 1);
			m.translate(_width, 0);
			bitmapData.draw(_tlCorner, m);
			// left
			b = new BitmapData(w, 1, true, 0);
			m.identity();
			m.translate(0, -h + 1);
			b.draw(_tlCorner, m);
			m.identity();
			m.scale(1, _height - o);
			m.translate(0, h);
			bitmapData.draw(b, m);
			// right
			m.scale(-1, 1);
			m.translate(_width, 0);
			bitmapData.draw(b, m);
			b.dispose();
			// center
			bitmapData.fillRect(new Rectangle(w, h, _width - (w << 1), _height - o), _tlCorner.getPixel32(w - 1, h - 1));
			// top middle
			b = new BitmapData(1, h, true, 0);
			m.identity();
			m.translate(-w + 1, 0);
			b.draw(_tlCorner, m);
			m.identity();
			m.scale(_width - (w << 1), 1);
			m.translate(w, 0);
			bitmapData.draw(b, m);
			
			if (_blCorner == null)
			{
				// bottom middle
				m.scale(1, -1);
				m.translate(0, _height);
				bitmapData.draw(b, m);
				b.dispose();
				// bottom left
				m.identity();
				m.scale(1, -1);
				m.translate(0, _height);
				bitmapData.draw(_tlCorner, m);
				// bottom right
				m.identity();
				m.scale(-1, -1);
				m.translate(_width, _height);
				bitmapData.draw(_tlCorner, m);
			}
			else
			{
				b.dispose();
				w = _blCorner.width;
				h = _blCorner.height;
				
				// bottom left
				m.identity();
				m.translate(0, _height - h);
				bitmapData.draw(_blCorner, m);
				// bottom right
				m.scale(-1, 1);
				m.translate(_width, 0);
				bitmapData.draw(_blCorner, m);
				// bottom
				b = new BitmapData(1, h, true, 0);
				m.identity();
				m.translate(-w + 1, 0);
				b.draw(_blCorner, m);
				m.identity();
				m.scale(_width - (w << 1), 1);
				m.translate(w, _height - h);
				bitmapData.draw(b, m);
				b.dispose();
			}
			
			super.smoothing = _smoothing;
		}
	}
}