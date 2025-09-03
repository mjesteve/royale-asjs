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
package org.apache.royale.externsjs.inspiretree.beads.models
{
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.events.Event;
	import org.apache.royale.externsjs.inspiretree.supportClasses.IInspireTree;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.externsjs.inspiretree.vos.NormalizedDataItem;

	//COMPILE::JS
	public class InspireTreeModelExt extends InspireTreeModel
	{
		/**
		 *  Constructor.
		 */
		public function InspireTreeModelExt()
		{
			super();
			isExtends = true;
		}

		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.collections.IArrayList
		 */
		override public function set dataProvider(value:Object):void
		{
			if( value == null)
				value = [];

			var tmpdata:Array;
			if(value is IArrayList)
			{
				tmpdata = normalizeDataProvider(IArrayList(value).source);
			}else{
				tmpdata = normalizeDataProvider(value as Array);
			}
			//tmpdata 			--> flat, normalized
			//_dataProviderTree --> tree, normalized
			//treeData 			--> tree, itemTreeNode (* jsTree)
			var arOut:Array = (_strand as IInspireTree).prepareTreeDataFromArray(tmpdata);
			treeData = arOut[0] as Array;
			_dataProviderTree = arOut[1] as Array;

			super.dataProvider = new ArrayList(tmpdata);

			(_strand as IEventDispatcher).dispatchEvent(new Event("prepareTreeDataComplete"));
		}
		/**
		 * tree, normalized
		 */
		override public function get dataProviderTree():Array
		{
			return _dataProviderTree;
		}

		private var _revertNode:Object;
		public function get revertNode():Object{ return _revertNode; }
		public function set revertNode(value:Object):void
		{ 
			_revertNode = value; 
			(_strand as IEventDispatcher).dispatchEvent(new Event("revertNodeChanged"));
		}

		private function normalizeDataProvider(ar:Array):Array
		{	
			if(!ar)
				return null;
			var arnor:Array = new Array();
			var len:int = ar.length;
			for(var index:int = 0; index < len; index++)
			{
				arnor.push( new NormalizedDataItem(ar[index]) );
			}
			return arnor;
		}
		
		public var checkboxFunction:Function;
		public var markDOMFunction:Function;

		public var markIsDisabled:Boolean = true;
		
		//"unchecked" and "same" do not correspond to any "state" of InspireTree, they are for convenience.
        [Inspectable(category="General", enumeration="checked,unchecked,indeterminate,same,selectable")]
		public var markToState:String = "same";

		override public function get selectedItem():Object
		{
			var item:Object = super.selectedItem;
			if(item)
				return NormalizedDataItem(item).data;

			return item;
		}
		
	}

}
