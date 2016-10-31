package com.qcenzo.light.components
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	[Event(name="complete", type="flash.events.Event")]
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	public class SimpleLoader extends Loader
	{
		private static const _COMPLETE_EVENT:Event = new Event("complete");
		private static const _PROGRESS_EVENT:ProgressEvent = new ProgressEvent("progress");

		private var _width:Number;
		private var _height:Number;
		private var _urlRequest:URLRequest;
		private var _percent:Number;

		public function SimpleLoader()
		{
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
			_urlRequest.url = value;
			
			if (!contentLoaderInfo.hasEventListener(Event.COMPLETE))
			{
				contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			}

			_percent = 0;
			
			load(_urlRequest);
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			_percent = event.bytesLoaded / event.bytesTotal;
			dispatchEvent(_PROGRESS_EVENT);
		}
		
		private function onComplete(event:Event):void
		{
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			
			var content:DisplayObject = contentLoaderInfo.content;
			scaleX = _width / content.width;
			scaleY = _height / content.height;
			
			dispatchEvent(_COMPLETE_EVENT);
		}
	}
}