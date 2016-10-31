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
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * The <code>Document</code> class is the root class used to parse raw data and rebuild dislaylists.
	 * @see http://ue.qcenzo.com
	 * @productversion 1.0.0
	 */
	public class Document extends Sprite
	{
		private static var _bitmapDataPool:Vector.<BitmapData>; 
		// component enums
	 	private static const SPRITE:uint = 0;
		private static const GROUP:uint = 1;
		private static const VSCROLLBAR:uint = 2;
		private static const SLIDER:uint = 3;
		private static const BUTTON:uint = 4;
		private static const BITMAPX:uint = 5;
		private static const BITMAP:uint = 6;
		private static const BUTTON_STATE_OUT:uint = 7;
		private static const BUTTON_STATE_OVER:uint = 8;
		private static const BUTTON_STATE_DOWN:uint = 9;
		private static const BUTTON_STATE_DISABLED:uint = 10; 
		private static const TEXTINPUT:uint = 11;
		private static const TEXTAREA:uint = 12;
		private static const TEXTFIELD:uint = 13;
		private static const LOADER:uint = 14;
		private static const VIDEO:uint = 15;
		// text alignment enums
		private static const LEFT:uint = 0;
		private static const CENTER:uint = 1;
		private static const RIGHT:uint = 2;
		// text style enums
		private static const ITALIC:uint = 1;
		private static const BOLD:uint = 2;
		private static const ITALIC_BOLD:uint = 3;
		
		public function Document(bytes:ByteArray)
		{
			bytes.uncompress("lzma");
			
			var displaylist:Dictionary = new Dictionary();
			displaylist[-1] = this;
			
			var numchildren:uint = bytes.readUnsignedShort();
			var type:uint;
			var obj:Object;
			var rIdx:int;
			var pxls:ByteArray;
			var tlCorner:BitmapData; 
			var blCorner:BitmapData;
			var namelen:uint;
			var varname:String;
			var tfmt:TextFormat;
			
			for (var i:uint = 0; i < numchildren; ++i)
			{
				type = bytes.readUnsignedByte();
				switch (type)
				{
					case SPRITE:
					case GROUP:
					case BUTTON: 
					case VSCROLLBAR: 
					case SLIDER:	

						switch (type)
						{
							case SPRITE:		obj = new Sprite();			break;
							case GROUP:			obj = new Group();			break;
							case BUTTON: 		obj = new Button();			break;
							case VSCROLLBAR:	obj = new VScrollBar();		break;
							case SLIDER:
								obj = bytes.readUnsignedByte() == 0 ? new HSlider() : new VSlider(); 
								break;	 
						}
						if (bytes.readUnsignedByte() == 1)
							obj.scrollRect = new Rectangle(0, 0, bytes.readUnsignedShort(), bytes.readUnsignedShort());
						displaylist[bytes.readUnsignedShort()] = obj; 
						break;
					
					case BITMAPX:
						
						rIdx = bytes.readByte();
						if (rIdx >= 0)
							tlCorner = _bitmapDataPool[rIdx];
						else
						{
							tlCorner = new BitmapData(bytes.readUnsignedShort(), bytes.readUnsignedShort(), true, 0);
							if (pxls == null)
								pxls = new ByteArray();
							else
								pxls.clear();
							bytes.readBytes(pxls, 0, bytes.readUnsignedInt());	
							tlCorner.setPixels(tlCorner.rect, pxls);
						}
						
						blCorner = null;
						if (bytes.readUnsignedByte() == 1)
						{
							rIdx = bytes.readByte();
							if (rIdx >= 0)
								blCorner = _bitmapDataPool[rIdx];
							else
							{
								blCorner = new BitmapData(bytes.readUnsignedShort(), bytes.readUnsignedShort(), true, 0);
								pxls.clear();
								bytes.readBytes(pxls, 0, bytes.readUnsignedInt());	
								blCorner.setPixels(blCorner.rect, pxls);
							}
						}
						
						obj = new BitmapX(bytes.readUnsignedShort(), bytes.readUnsignedShort());
						obj.setCorners(tlCorner, blCorner);	  
						break;
					
					case BUTTON_STATE_OUT:
					case BUTTON_STATE_OVER:	
					case BUTTON_STATE_DOWN:	
					case BUTTON_STATE_DISABLED:	
					case BITMAP:
						
						rIdx = bytes.readByte();
						if(rIdx >= 0)
							obj = _bitmapDataPool[rIdx]; 
						else
						{
							obj = new BitmapData(bytes.readUnsignedShort(), bytes.readUnsignedShort(), true, 0);
							if (pxls == null)
								pxls = new ByteArray();
							else
								pxls.clear();
							bytes.readBytes(pxls, 0, bytes.readUnsignedInt());	
							obj.setPixels(obj.rect, pxls);
						}
						
						switch (type)
						{
							case BUTTON_STATE_OUT:		displaylist[bytes.readShort()].outState = obj;		continue;
							case BUTTON_STATE_OVER:		displaylist[bytes.readShort()].overState = obj;		continue;
							case BUTTON_STATE_DOWN:		displaylist[bytes.readShort()].downState = obj;		continue;
							case BUTTON_STATE_DISABLED:	displaylist[bytes.readShort()].disabledState = obj;	continue;
								
							default:
								obj = new Bitmap(obj as BitmapData);
						}
						break;
						
					case TEXTINPUT:
					case TEXTAREA:
					case TEXTFIELD:
						
						tfmt = new TextFormat();
						tfmt.font = bytes.readMultiByte(bytes.readUnsignedByte(), "cn-gb");
						switch (bytes.readUnsignedByte())
						{
							case ITALIC:
								tfmt.italic = true;
								break;
							case BOLD:
								tfmt.bold = true;
								break;
							case ITALIC_BOLD:
								tfmt.italic = true;
								tfmt.bold = true;
								break;
						}
						tfmt.size = bytes.readUnsignedShort();
						tfmt.color = bytes.readUnsignedInt();
						switch (bytes.readUnsignedByte())
						{
							case LEFT:
								tfmt.align = "left";
								break;
							case CENTER:
								tfmt.align = "center";
								break;
							case RIGHT:
								tfmt.align = "right";
								break;
						}
						
						switch (type)
						{
							case TEXTINPUT:		obj = new TextInput(); 		break;
							case TEXTAREA:		obj = new TextArea();		break;
							
							default:
								obj = new TextField();
								obj.selectable = false;
						}
						obj.defaultTextFormat = tfmt;		
						obj.width = bytes.readUnsignedShort();
						obj.height = bytes.readUnsignedShort();
						break;
					
					case LOADER:
						obj = new SimpleLoader(); 
						obj.width = bytes.readUnsignedShort();
						obj.height = bytes.readUnsignedShort();
						break;
					
					case VIDEO:
						obj = new Video(bytes.readUnsignedShort(), bytes.readUnsignedShort()); 
						break;
				}
				
				namelen = bytes.readUnsignedByte();
				if (namelen > 0)
				{
					varname = bytes.readUTFBytes(namelen); 
					obj.name = varname;
					if (hasOwnProperty(varname))
						this[varname] = obj;
				}
				 
				obj.x = bytes.readShort();
				obj.y = bytes.readShort();   
				displaylist[bytes.readShort()].addChildAt(obj, bytes.readByte());
			}
		}
	
		public static function initPublicBitmapDataPool(bytes:ByteArray):void
		{
			bytes.uncompress("lzma");
			 
			var n:int = bytes.readUnsignedShort();
			var p:ByteArray = new ByteArray();
			var b:BitmapData;
			 
			_bitmapDataPool = new Vector.<BitmapData>(n, true);
			for (var i:int = 0; i < n; i++)
			{
				b = new BitmapData(bytes.readUnsignedShort(), bytes.readUnsignedShort(), true, 0);
				p.clear();
				bytes.readBytes(p, 0, bytes.readUnsignedInt());
				b.setPixels(b.rect, p);
				
				_bitmapDataPool[i] = b;
			}
		}
	}
}