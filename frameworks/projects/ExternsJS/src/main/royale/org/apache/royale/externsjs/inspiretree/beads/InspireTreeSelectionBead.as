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
package org.apache.royale.externsjs.inspiretree.beads
{

	/**
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
    import org.apache.royale.externsjs.inspiretree.vos.ItemTreeNode;
	import org.apache.royale.externsjs.inspiretree.supportClasses.IInspireTree;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.Strand;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IStrandWithModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.core.ISelectionModel;
    import org.apache.royale.externsjs.inspiretree.controls.InspireTreeBasicControlExt;
    import org.apache.royale.core.IDataProviderModel;

    [Event(name = "selectionChanged", type = "org.apache.royale.events.Event")]

    COMPILE::JS
	public class InspireTreeSelectionBead  extends Strand implements IBead
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */

		public function InspireTreeSelectionBead()
		{
			super();
		}
        private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get strand():IStrand
        {
            return _strand;
        }

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */

		public function set strand(value:IStrand):void
		{
            _strand = value;
			host = InspireTreeBasicControlExt(value);
			(host as IEventDispatcher).addEventListener("beforeCreation", removeListeners);
		}

		protected var _treeModel:ISelectionModel; //InspireTreeModel;
		protected function get treeModel():ISelectionModel{
			if(host && !_treeModel)
			{
				if( !(_strand as IStrandWithModel).model )
					return null;
				_treeModel = ISelectionModel((_strand as IStrandWithModel).model);
			}
			return _treeModel;
		}

		protected var host:InspireTreeBasicControlExt;

		private function removeListeners():void
		{

			host.removeEventListener("beforeCreation", removeListeners);
			host.addEventListener("creationComplete", createListeners);

			if( (_strand as IInspireTree).jsTree )
				(_strand as IInspireTree).jsTree.off('node.selected', onSelectedNodeHandler);

			if( (_strand as IStrandWithModel).model )
				IEventDispatcher(host.model).removeEventListener("selectedIndexChanged", onSelectionChangedHandler);
				
		}

		private function createListeners():void
		{
			host.removeEventListener("creationComplete", createListeners);
			host.addEventListener("beforeCreation", removeListeners);

			if( (_strand as IInspireTree).jsTree )
				(_strand as IInspireTree).jsTree.on('node.selected', onSelectedNodeHandler);

			if( treeModel )
				treeModel.addEventListener("selectedIndexChanged", onSelectionChangedHandler);

		}

		protected var fromModel:Boolean=false;
		protected var fromTree:Boolean = false;
		/**
		 * jsTree node.selected
		 */
		public function onSelectedNodeHandler(treeNode:Object, isLoadEvent:Boolean, handler:Function):void
		{
			//Se debe diferenciar entre una selección de ratón o una selección valuecommit (si lo tratásemos estaríamos duplicando)
			if( fromModel ) //Se ha actualizado el modelo desde set selectedIndex
				return;

            if(!(_strand as IInspireTree).jsTree.node(treeNode.id).hasChildren())
            {
				var idx:int = host.selectedIndexNode(new ItemTreeNode(treeNode));
				if( idx != treeModel.selectedIndex)
				{
					fromTree = true;
					treeModel.selectedIndex = idx;
					dispatchEvent(new Event("selectionChanged"));
					fromTree = false;
					
				}
            }
		}

		/**
		 * Model selectedIndex Change
		 * (valuecommit)
		 */
		public function onSelectionChangedHandler(event:Event):void
		{
			if( !treeModel || fromTree || fromModel)
				return;
			
			fromModel = true;
			updateHost(null);
			dispatchEvent(new Event("selectionChanged"));
			fromModel = false;
		}

        [Bindable("selectionChanged")]
		public function get selectedIndex():int
		{
			return treeModel.selectedIndex;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedIndex(value:int):void
		{
			if( !treeModel )
				return;
			if(value<0 && value!=-1)
				value = -1;
			if( treeModel.selectedIndex != value)
				treeModel.selectedIndex = value;
		}

		public function get selectedItem():Object
		{
			return treeModel.selectedItem;
		}

		protected function updateHost(event:Event = null):void
		{
			if(!host)
				return;

			if(!host.dataProvider)
				return;

			if( treeModel.selectedIndex < 0)
			{
				//Funcionan los 3.
				//stateDeep hace que la selección sea recursiva.
				//host.jsTree.selected(true).stateDeep('selected',false);
				//host.jsTree.model.stateDeep('selected',false);
				host.jsTree.selected(true).state('selected',false);
				return;
			}

			var modelDada:Array = IDataProviderModel(host.model).dataProvider.source;
			var idxGen:int = 0;
			var idxChild:int=0;
			var markselected:Boolean=false;

			host.jsTree.forEach(function(treenode:Object):void
			{
				if( treenode.children!=null && !markselected)
				{
					for (idxChild=0; idxChild < treenode.children.length; idxChild++)
					{
						if( idxGen < modelDada.length)
						{
							if(idxGen == treeModel.selectedIndex ){
								treenode.children[idxChild].select();
								markselected = true;
								break;
							}
						}
						idxGen++;
						if(markselected)
							break;
					}
				}
			});

		}

	}

    COMPILE::SWF
	public class InspireTreeSelectionBead
	{
    }
}
