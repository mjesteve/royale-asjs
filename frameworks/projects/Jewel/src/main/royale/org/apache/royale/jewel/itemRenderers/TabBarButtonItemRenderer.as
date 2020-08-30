////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.jewel.itemRenderers
{
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.core.StyledMXMLItemRenderer;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.jewel.supportClasses.INavigationRenderer;
    
	/**
	 *  The TabBarButtonItemRenderer defines the basic Item Renderer for a Jewel 
     *  TabBar List Component. It handles Objects with "label" and "href" data.
	 *  Extend this (you can do it in MXML) to support more data like for example: icon data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TabBarButtonItemRenderer extends StyledMXMLItemRenderer implements INavigationRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TabBarButtonItemRenderer()
		{
			super();

			typeNames = "jewel tabbarbutton";
		}

		private var _text:String = "";

		[Bindable(event="textChange")]
        /**
         *  The text of the navigation link
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
            if(value != _text) {
				_text = value;
				COMPILE::JS
				{
				if(MXMLDescriptor == null)
				{
					element.innerHTML = _text;
				}
				}
				dispatchEvent(new Event('textChange'));
			}
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function set data(value:Object):void
		{
			text = getLabelFromData(this, value);
            super.data = value;
		}

		COMPILE::JS
		public var span:HTMLSpanElement;
		
		COMPILE::JS
		public var indicator:HTMLSpanElement;
		
		COMPILE::JS
		public var indicator_content:HTMLSpanElement;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLSpanElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			//element (span.content)
            span = addElementToWrapper(this, 'span') as HTMLSpanElement;
			span.className = "content";
			
			//postioner (button)
			positioner = document.createElement('button') as WrappedHTMLElement;

			indicator = document.createElement('span') as HTMLSpanElement;
			indicator.className = "indicator";
			addIndicator();
			
			indicator_content = document.createElement('span') as HTMLSpanElement;
			indicator_content.className = "indicatorContent";
			indicator.appendChild(indicator_content);

            return element;
        }

		/**
		 * Adding indicator to positioner makes the indicator fill all available space
		 * Override this function in TabBarButtonItemRenderer subclasses.
		 * Check TabBarButtonInidicatorRestrictedToContentItemRenderer for a "restricted to content" indicator
		 * @see org.apache.royale.jewel.itemRenderers. TabBarButtonInidicatorRestrictedToContentItemRenderer
		 */
		COMPILE::JS
		protected function addIndicator():void
		{
			positioner.appendChild(indicator);
		}

		COMPILE::JS
		public function get getBoundingBox():ClientRect
		{
			return indicator.getBoundingClientRect();
		}

		COMPILE::JS
		public function animateIndicator(positionDiff:Number, widthDiff:Number, duration:int, easingFunction:String):void
		{
			indicator_content["animate"](
				[
					{
						transform: "translateX(" + positionDiff + "px) scaleX(" + widthDiff + ")"
					},
					{
						transform: "none"
					}
				]
				, 
				{
					duration: duration,
					easing: easingFunction,
					fill: 'both'
				}
			);
		}
		
		COMPILE::JS
		private var _positioner:WrappedHTMLElement;

		COMPILE::JS
		override public function get positioner():WrappedHTMLElement
		{
			return _positioner;
		}

		COMPILE::JS
		override public function set positioner(value:WrappedHTMLElement):void
		{
			_positioner = value;
            _positioner.royale_wrapper = this;
			_positioner.appendChild(element);
		}
	}
}
