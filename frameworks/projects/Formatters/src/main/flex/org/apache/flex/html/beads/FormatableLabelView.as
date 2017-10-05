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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.IFormatBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The FormatableLabelView class is a View bead that is capable of working
	 *  with a format bead to display a formatted value. When the format bead has
	 *  created a formatted string, it dispatches a formatChanged event that the
	 *  FormatableLabelView class intercepts and displays in the label.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class FormatableLabelView extends TextFieldView
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function FormatableLabelView()
		{
			super();
		}
		
		private var _formatter:IFormatBead;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			IEventDispatcher(value).addEventListener("beadsAdded",handleBeadsAdded);
		}
		
		/**
		 * @private
		 */
		private function handleBeadsAdded(event:Event):void
		{
			_formatter = _strand.getBeadByType(IFormatBead) as IFormatBead;
			_formatter.addEventListener("formatChanged",formatReadyHandler);
			
			// process any text set in the label at this moment
			text = _formatter.formattedString;
		}
		
		/**
		 * @private
		 */
		private function formatReadyHandler(event:Event):void
		{
			if (_formatter) {
				text = _formatter.formattedString;
			}
		}
	}
}
