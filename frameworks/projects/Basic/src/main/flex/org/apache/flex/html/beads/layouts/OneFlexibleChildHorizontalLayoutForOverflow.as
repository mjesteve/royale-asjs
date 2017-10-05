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
package org.apache.flex.html.beads.layouts
{
	import org.apache.flex.core.LayoutBase;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.utils.CSSContainerUtils;
	import org.apache.flex.utils.CSSUtils;

    /**
     *  The OneFlexibleChildHorizontalLayoutForOverflowis 
	 *  intended for building apps that clip
	 *  and/or scroll the overflow, especially in a 
	 *  3-pane view like the ASDoc examples.  It does not use
	 *  FlexBox because FlexBox wants to grow to the size
	 *  of the content without specifying width/height on
	 *  the flexible child.  But then the children in
	 *  the flexible child cannot use % sizing.
	 *  This layout presumes the parent is a known size.
	 *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class OneFlexibleChildHorizontalLayoutForOverflow extends LayoutBase implements IOneFlexibleChildLayout, IDocument
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function OneFlexibleChildHorizontalLayoutForOverflow()
		{
			super();
		}
		
        /**
         *  @royaleignorecoercion org.apache.flex.events.IEventDispatcher;
         */
		COMPILE::JS
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			(host.parent as IEventDispatcher).addEventListener("sizeChanged", parentSizeChangedHandler);
		}

		COMPILE::JS
		private function parentSizeChangedHandler(event:Event):void
		{
			performLayout();	
		}
		
        private var _flexibleChild:String;

        protected var actualChild:ILayoutChild;

        /**
         *  @private
         *  The document.
         */
        private var document:Object;

		/**
		 *  The id of the flexible child
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get flexibleChild():String
		{
			return _flexibleChild;
		}

		/**
		 * @private
		 */
		public function set flexibleChild(value:String):void
		{
			_flexibleChild = value;
		}

        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		COMPILE::JS
		override public function layout():Boolean
		{
			if (flexibleChild == null) return false;
			
			var contentView:ILayoutView = layoutView;

			actualChild = document[flexibleChild];

			var n:int = contentView.numElements;
			if (n == 0) return false;

			for(var i:int=0; i < n; i++) {
				var child:UIBase = contentView.getElementAt(i) as UIBase;
				if (child.element.style["display"] != "inline-flex" && child.element.style["display"] != "none")
					child.element.style["display"] = "inline-block";
			}

			var w:Number = host.width - 1;
			for(i=0; i < n; i++) {
				child = contentView.getElementAt(i) as UIBase;
				if (child != actualChild)
					w -= child.width;
			}
			actualChild.width = w;
					
			return true;
		}

		COMPILE::SWF
		override public function layout():Boolean
		{
			if (flexibleChild == null) return false;
			
			var contentView:ILayoutView = layoutView;
			actualChild = document.hasOwnProperty(flexibleChild) ? document[flexibleChild] : null;

			var n:Number = contentView.numElements;
			if (n == 0) return false;
			
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var hostSizedToContent:Boolean = host.isHeightSizedToContent();
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;

			var ilc:ILayoutChild;
			var data:Object;
			var canAdjust:Boolean = false;
			var margins:Object;

			var paddingMetrics:Rectangle = CSSContainerUtils.getPaddingMetrics(host);
			var borderMetrics:Rectangle = CSSContainerUtils.getBorderMetrics(host);
			
			// adjust the host's usable size by the metrics. If hostSizedToContent, then the
			// resulting adjusted value may be less than zero.
			hostWidth -= paddingMetrics.left + paddingMetrics.right + borderMetrics.left + borderMetrics.right;
			hostHeight -= paddingMetrics.top + paddingMetrics.bottom + borderMetrics.top + borderMetrics.bottom;

			var xpos:Number = borderMetrics.left + paddingMetrics.left;
			var ypos:Number = borderMetrics.top + paddingMetrics.top;
			var child:IUIBase;
			var childHeight:Number;
			var i:int;
			var childYpos:Number;
			var adjustLeft:Number = 0;
			var adjustRight:Number = hostWidth + borderMetrics.left + paddingMetrics.left;

			// first work from left to right
			for(i=0; i < n; i++)
			{
				child = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				if (child == actualChild) break;

				margins = childMargins(child, hostWidth, hostHeight);
				ilc = child as ILayoutChild;

				xpos += margins.left;

				childYpos = ypos + margins.top; // default y position

				childHeight = child.height;
				if (ilc != null)
				{
					if (!isNaN(ilc.percentHeight)) {
						childHeight = host.height * ilc.percentHeight/100.0;
					}
					else if (isNaN(ilc.explicitHeight)) {
						childHeight = host.height;
					}
					ilc.setHeight(childHeight);
				}

				if (ilc) {
					ilc.setX(xpos);
					ilc.setY(childYpos);

					if (!isNaN(ilc.percentWidth)) {
						ilc.setWidth(hostWidth * ilc.percentWidth / 100);
					}

				} else {
					child.x = xpos;
					child.y = childYpos;
				}

				xpos += child.width + margins.right;
				adjustLeft = xpos;
			}

			// then work from right to left
			xpos = hostWidth + borderMetrics.left + paddingMetrics.left;

			for(i=(n-1); actualChild != null && i >= 0; i--)
			{
				child = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) continue;
				if (child == actualChild) break;

				margins = childMargins(child, hostWidth, hostHeight);
				ilc = child as ILayoutChild;

				childYpos = ypos + margins.top; // default y position

				childHeight = child.height;
				if (ilc != null)
				{
					if (!isNaN(ilc.percentHeight)) {
						childHeight = host.height * ilc.percentHeight/100.0;
					}
					else if (isNaN(ilc.explicitHeight)) {
						childHeight = host.height;
					}
					ilc.setHeight(childHeight);
				}

				if (ilc) {
					if (!isNaN(ilc.percentWidth)) {
						ilc.setWidth(hostWidth * ilc.percentWidth / 100);
					}
				}

				xpos -= child.width + margins.right;

				if (ilc) {
					ilc.setX(xpos);
					ilc.setY(childYpos);
				} else {
					child.x = xpos;
					child.y = childYpos;
				}

				xpos -= margins.left;
				adjustRight = xpos;
			}

			// now adjust the actualChild to fill the space.
			if (actualChild != null) {
				margins = childMargins(actualChild, hostWidth, hostHeight);
				ilc = actualChild as ILayoutChild;
				childHeight = actualChild.height;
				if (ilc != null)
				{
					if (!isNaN(ilc.percentHeight)) {
						childHeight = host.height * ilc.percentHeight/100.0;
					}
					else if (isNaN(ilc.explicitHeight)) {
						childHeight = host.height;
					}
					ilc.setHeight(childHeight);
				}
				childYpos = ypos + margins.top;
				actualChild.x = adjustLeft + margins.left;
				actualChild.y = childYpos;
				if (ilc) {
					ilc.setWidth((adjustRight-margins.right) - (adjustLeft+margins.left));
				} else {
					actualChild.width = (adjustRight-margins.right) - (adjustLeft+margins.left);
				}
			}

            return true;
		}

        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;
        }

    }

}
