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
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	[Event(name="complete", type="flash.events.Event")]
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	public class SimpleLoader extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _loader:Loader;
		private var _urlRequest:URLRequest;

		public function SimpleLoader()
		{
			_loader = new Loader();
			_urlRequest = new URLRequest();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get url():String
		{
			return _urlRequest.url;
		}
		
		public function set url(value:String):void
		{
			removeChildren();
			
			_urlRequest.url = value;
			
			if (!_loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
			{
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}

			_loader.load(_urlRequest);
		}
		
		public function unloadAndStop(gc:Boolean = true):void
		{
			_loader.unloadAndStop(gc);
		}
		
		private function setScaleX(contentWidth:Number):void
		{
			if (_width == _width)
				scaleX = _width / contentWidth;
		}
		
		private function setScaleY(contentHeight:Number):void
		{
			if (_height == _height)
				scaleY = _height / contentHeight;
		}
		
		private function onComplete(event:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			var content:DisplayObject = _loader.contentLoaderInfo.content;
			setScaleX(content.width);
			setScaleY(content.height);
			addChild(content);
			
			dispatchEvent(event);
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
	}
}