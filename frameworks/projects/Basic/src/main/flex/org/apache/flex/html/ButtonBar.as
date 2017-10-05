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
package org.apache.flex.html
{
	import org.apache.flex.html.beads.models.ButtonBarModel;
	
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.util.addElementToWrapper;
    }

	/**
	 *  The ButtonBar class is a component that displays a set of Buttons. The ButtonBar
	 *  is actually a List with a default horizontal layout and an itemRenderer that
	 *  produces Buttons. The ButtonBar uses the following beads:
	 *
	 *  org.apache.flex.core.IBeadModel: the data model for the ButtonBar, including the dataProvider.
	 *  org.apache.flex.core.IBeadView: constructs the parts of the component.
	 *  org.apache.flex.core.IBeadController: handles input events.
	 *  org.apache.flex.core.IBeadLayout: sizes and positions the component parts.
	 *  org.apache.flex.core.IDataProviderItemRendererMapper: produces itemRenderers.
	 *  org.apache.flex.core.IItemRenderer: the class or class factory to use.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ButtonBar extends List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ButtonBar()
		{
			super();
		}
		
		public function get buttonWidths():Array
		{
			return ButtonBarModel(model).buttonWidths;
		}
		public function set buttonWidths(value:Array):void
		{
			ButtonBarModel(model).buttonWidths = value;
		}
		
		public function get widthType():Number
		{
			return ButtonBarModel(model).widthType;
		}
		public function set widthType(value:Number):void
		{
			ButtonBarModel(model).widthType = value;
		}

        /**
         * @royaleignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'div');
        }
	}
}
