package com.qcenzo.light.components
{
	internal interface IVScrollable
	{
		function get vscrollBar():VScrollBar;
		function set vscrollBar(value:VScrollBar):void;
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
	}
}