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
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextInput extends TextField
	{
		private static const _REG_EMPTY_STRING:RegExp = /^\s*$/; 
		private static const _PROMPT_COLOR:uint = 0xADADAD;
		
		private static var _maskWords:Vector.<String>;
		
		private var _numMaskWords:int;
		private var _i:int;
		private var _index:int;
		private var _stars:String;
		private var _numStars:int;
		private var _textFormat:TextFormat;
		private var _promptColor:uint;
		private var _prompt:String;
		private var _color:uint;
		private var _reg_prompt:RegExp;
		private var _displayAspwd:Boolean;
		
		protected var _multiline:Boolean;
		protected var _wordWrap:Boolean;

		public function TextInput()
		{			
			super.type = "input"; 
			super.multiline = _multiline;
			super.wordWrap = _wordWrap;
		}
		
		[Deprecated]
		override public function set type(value:String):void {}
		
		[Deprecated]	
		override public function set multiline(value:Boolean):void {}
		
		[Deprecated]	
		override public function set wordWrap(value:Boolean):void {}
		
		override public function set displayAsPassword(value:Boolean):void
		{
			_displayAspwd = value;
		}
		
		override public function set defaultTextFormat(format:TextFormat):void
		{	
			super.defaultTextFormat = _textFormat = format;
		}
		
		override public function get defaultTextFormat():TextFormat
		{
			return _textFormat;  
		}
		
		public function set maskWords(words:Vector.<String>):void
		{
			if (words == null || words.length == 0)
				return;
				
			if (_maskWords != null)
			{
				addEventListener(Event.CHANGE, onChange);
				return;
			}
			
			_numMaskWords = words.length;
			_maskWords = new Vector.<String>(_numMaskWords, true);
			for (_i = 0; _i < _numMaskWords; ++_i)
				_maskWords[_i] = words[_i];
				
			addEventListener(Event.CHANGE, onChange);
		}
		
		public function set promptColor(color:uint):void
		{
			_promptColor = color;
		}
		
		public function set prompt(prompt:String):void
		{
			if (prompt == null || _REG_EMPTY_STRING.test(prompt) || (_reg_prompt != null && _reg_prompt.test(prompt)))
				return;
				
			if (_prompt == null)
			{
				addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
			
			_prompt = prompt;
			prompt = "^\\s*";
			for (var i:int = 0, n:int = _prompt.length; i < n; ++i)
				prompt += _prompt.charAt(i) + "\\s*";
			prompt += "\\s*$";			
			_reg_prompt = new RegExp(prompt); 
			
			_color = _textFormat == null ? 0 : uint(_textFormat.color); 
			_promptColor ||= _PROMPT_COLOR;	
			
			onFocusOut(null);
		}
		
		public function get isEmpty():Boolean
		{
			return (_reg_prompt != null && _reg_prompt.test(text)) || _REG_EMPTY_STRING.test(text);
		}
		
		private function onFocusIn(event:FocusEvent):void
		{
			if (_reg_prompt.test(text))
			{
				textColor = _color;
				super.text = "";
				super.displayAsPassword = _displayAspwd;
			}
		}
		
		private function onFocusOut(event:FocusEvent):void
		{
			if (_REG_EMPTY_STRING.test(text))
			{
				textColor = _promptColor;
				super.text = _prompt;
				super.displayAsPassword = false;
				
				if (event != null)
					event.stopImmediatePropagation();
			}
		}
		
		private function onChange(event:Event):void
		{
			for (_i = 0; _i < _numMaskWords; ++_i)
			{
				_index = text.indexOf(_maskWords[_i]);
				if (_index != -1)
				{
					_numStars = _maskWords[_i].length;
					_stars = "";
					for (_i = 0; _i < _numStars; ++_i)
						_stars += "*";
					replaceText(_index, _index + _numStars, _stars);
					break;
				}
			}
		}
	}
}