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
	COMPILE::JS{
	import org.apache.royale.externsjs.inspiretree.beads.models.InspireTreeModel;
	import org.apache.royale.externsjs.inspiretree.beads.models.InspireTreeModelExt;
	import org.apache.royale.externsjs.inspiretree.supportClasses.IInspireTree;
	import org.apache.royale.externsjs.inspiretree.vos.NormalizedDataItem;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	}
    COMPILE::JS
	public class InspireTreeCheckBoxModeBeadExt  extends InspireTreeCheckBoxModeBead
	{

		public function InspireTreeCheckBoxModeBeadExt()
		{
			super();
		}

		override protected function get treeModel():InspireTreeModel
		{
			if(strand && !_treeModel)
			{
				_treeModel = (strand as IStrandWithModel).model as InspireTreeModelExt;
			}
			return _treeModel as InspireTreeModelExt;
		}
		
		override public function set checkboxFunction(value:Function):void
		{ 
			super.checkboxFunction = value;
			if(treeModel)
				InspireTreeModelExt(treeModel).checkboxFunction = value;
		}

		override protected function init(event:Event):void
		{
			(strand as IEventDispatcher).removeEventListener("initComplete", init);

			if(treeModel)
			{
				(strand as IEventDispatcher).removeEventListener("creationComplete", updateHost);
				if(_showCheckboxes && _revertIcon)
				{
					treeModel.renderingNeededDataChange = true;
					(strand as IEventDispatcher).addEventListener("creationComplete", updateHost);
				}

				treeModel.showCheckboxes = showCheckboxes;
				treeModel.checkedIsSelected = checkedIsSelected;
				if(showCheckboxes)
				{
					if(!InspireTreeModelExt(treeModel).checkboxFunction && _checkboxFunction)
						InspireTreeModelExt(treeModel).checkboxFunction = _checkboxFunction;
				}
				if(treeModel.checkboxMode && treeModel.treeData)
				{
					completeTreeData(null,null);
					if( readOnly )
						onReadOnlyChange(null);
				}
			}
		}
		
		override protected function completeTreeData(event:Event, revertTreeData:Array = null):Array
		{
			if( !treeModel) return null;
			if(revertTreeData)
				return revertTreeData;
			else
				return treeModel.treeData;
		}

		override public function itemChildChecked(itemTreeData:Object, itemDataProv:Object):Boolean
		{
			if(!itemTreeData || !itemDataProv || !checkboxField)
				return false;

			if( itemDataProv[checkboxField] == null )
				return false;

			if( itemDataProv[checkboxField] is Number )
				return Number(itemDataProv[checkboxField])>0 ? true:false;

			if( itemDataProv[checkboxField] is Boolean )
				return itemDataProv[checkboxField] as Boolean;

			return false;
		}

		//node:ItemTreeNode
		override public function onClickHandler(event:*, node:Object):void
		{
			
			var wParent:Number = (strand as StyledUIBase).width;
			var wItem:Number = Number( node.itree.ref.clientWidth ? node.itree.ref.clientWidth:0 );
			var wScroll:Number = (wParent-wItem);
			var wIcon:Number = 20;
			if( Number(event["offsetX"]) >= wParent - (wIcon + wScroll) )
			{
				//Only folder node
				if( node.children.length>0 && node.itree.state.selectable){
					if(isVisibleRevertNode(node.id))
						revertStateNode(node);
				}
			}
		}

		//node:TreeNode
		public function revertStateNode(node:Object):void
		{
			inEditAll = true; ////trace("inEditAll", inEditAll);
			var arOrg:Array = treeModel.dataProviderTree;
			var idxGen:int = 0;
			//No utilizamos jsTree.forEach porque no podemos salirnos del bucle una vez encontrado el nodo que queremos deshacer.
			//We do not use jsTree.forEach because we cannot exit the loop once we have found the node we want to undo.
			//(strand as IInspireTree).jsTree.forEach(function(treenode:Object):void
			var lenar:int = arOrg.length;

			for (var idxnode:int=0; idxnode < lenar; idxnode++)
			{
				var treenode:Object = (strand as IInspireTree).jsTree.model[idxnode];
				var itreal:NormalizedDataItem;

				if(treenode.hasChildren())
				{
					if( treenode.id == node.id)
					{
						var lench:int = treenode.children.length;						
						for (var idxChild:int=0; idxChild < lench; idxChild++)
						{
							itreal = (arOrg[idxGen] as NormalizedDataItem).children[idxChild] as NormalizedDataItem;
							if(itreal.marked && InspireTreeModelExt(treeModel).markIsDisabled)
								continue;
							var itemch:Object = treenode.children[idxChild];							
							if(itreal.checked)
								(strand as IInspireTree).jsTree.node(itemch.id).check(true);
							else{
								(strand as IInspireTree).jsTree.node(itemch.id).uncheck(true);
								(strand as IInspireTree).jsTree.node(itemch.id).itree.state.indeterminate = itreal.indeterminate;
							}
							(strand as IInspireTree).jsTree.node(itemch.id).itree.state.selectable = itreal.enabled;
						}
						
						itreal = arOrg[idxGen] as NormalizedDataItem;
						if(itreal.checked)
							(strand as IInspireTree).jsTree.node(treenode.id).check(true);
						else{
							(strand as IInspireTree).jsTree.node(treenode.id).uncheck(true);
							(strand as IInspireTree).jsTree.node(treenode.id).itree.state.indeterminate = itreal.indeterminate;
						}
						(strand as IInspireTree).jsTree.node(treenode.id).itree.state.selectable = itreal.enabled;
						InspireTreeModelExt(treeModel).revertNode = arOrg[idxGen];
						
						setVisibleRevertNode(treenode.id,false);
						inEditAll = false; ////trace("inEditAll", inEditAll);
						return;
					}
					idxGen++;
				}
			}
			inEditAll = false; ////trace("inEditAll", inEditAll);
		}

		/**
		 * Check/Uncheck all nodes 
		 * @param valueChecked [true|false] true Check all nodes
		 */
		override public function checkAllNode(valueChecked:Boolean):void
		{
			inEditAll = true; ////trace("inEditAll", inEditAll);
			var arOrg:Array = treeModel.dataProviderTree;
			var idxGen:int = 0;
			var nMark:int = 0;
			var nCheck:int = 0;
			var nUnCheck:int = 0;
			
			(strand as IInspireTree).jsTree.forEach(function(treenode:Object):void
			{
				var itreal:NormalizedDataItem;
				if(treenode.hasChildren() && ( (arOrg[idxGen] as NormalizedDataItem).enabled || !InspireTreeModelExt(treeModel).markIsDisabled) )
				{
					var edited:Boolean = false;
					var lench:int = treenode.children.length;
					for (var idxChild:int=0; idxChild < lench; idxChild++)
					{
						itreal = (arOrg[idxGen] as NormalizedDataItem).children[idxChild];
						var itemch:Object = treenode.children[idxChild];
						
						if( !itreal.marked || !InspireTreeModelExt(treeModel).markIsDisabled )
						{
							if(!valueChecked) {
								if(itemch.itree.state.checked)
									(strand as IInspireTree).jsTree.node(itemch.id).uncheck(true);
								nUnCheck++;
							}else{ 
								if(!itemch.itree.state.checked)
									(strand as IInspireTree).jsTree.node(itemch.id).check(true);
								nCheck++;
							}
						}else{
							nMark++;
							if(itemch.itree.state.checked)
								nCheck++;
							else if(!itemch.itree.state.indeterminate)
								nUnCheck++;
						}
						if(!edited)
							edited = valueChecked == itreal.checked?false:true;
					}

					setVisibleRevertNode(treenode.id,edited);
					
					itreal = arOrg[idxGen] as NormalizedDataItem;
					if(nCheck == lench && !itreal.checked)
						(strand as IInspireTree).jsTree.node(treenode.id).check(true);
					else if(nCheck == lench && itreal.checked)
						(strand as IInspireTree).jsTree.node(treenode.id).uncheck(true);
					else
						(strand as IInspireTree).jsTree.node(treenode.id).itree.state.indeterminate = itreal.indeterminate;
					
					(strand as IInspireTree).jsTree.node(treenode.id).itree.state.selectable = itreal.enabled;
				}
				
				idxGen++;
			});
			inEditAll = false; ////trace("inEditAll", inEditAll);

		}

		override public function reviewVisibleRevertNodeFromChild(pIDNodeChild:String=null, revertTreeData:Array = null):void
		{
			var arOrg:Array;
			if(revertTreeData == null)
				arOrg = treeModel.dataProviderTree;
			else
				arOrg = revertTreeData;
			
			var lenar:int = arOrg.length;

			for (var idxnode:int=0; idxnode < lenar; idxnode++)
			{
				var it:Object = arOrg[idxnode]; //var it:ItemTreeNode;
				var itreal:Object = (strand as IInspireTree).jsTree.model[idxnode]; //var itreal:TreeNode //jsTree.node(it.id)
				if(!itreal)
					break;
				var itemrealch:Object;
				var itemch:Object;
				
				var idparent:String = '';
				var edited:Boolean = false;

				var lench:int = it.children.length;
				var idxnch:int=0
				for (idxnch=0; idxnch < lench; idxnch++)
				{
					itemrealch = itreal.children[idxnch];
					if( pIDNodeChild == null || (itemrealch.id == pIDNodeChild || itemrealch.text == pIDNodeChild) )
					{
						itemch = it.children[idxnch];
						edited = itemrealch.itree.state.checked == itemch.checked?false:true;
						//trace("edited ["+itemrealch.id+"]", edited,"valorBack:",itemch.checked, "valorReal:",itemrealch.itree.state.checked);
						idparent = itreal.id;
						break;
					}
				}
				if(idparent!='') //Es el nodo que queremos verificar.
				{
					//Si el nodo hijo comprobado se ha reestablecido a su valor original tendremos que comprobar
					//nuevamente los demás hijos.
					//Si el nodo hijo comprobado se ha modificado, seguro que hay que activar el "revert", por tanto
					//no haremos ninguna comprobación adicional.
					if(!edited)
					{
						for (idxnch=0; idxnch < lench; idxnch++)
						{
							itemrealch = itreal.children[idxnch];
							itemch = it.children[idxnch];
							edited = itemrealch.itree.state.checked == itemch.checked?false:true;
							//trace("edited ["+itemrealch.id+"]", edited,"valorBack:",itemch.checked, "valorReal:",itemrealch.itree.state.checked);
							if(edited)
								break;
						}
					}
					setVisibleRevertNode(itreal.id,edited);
					if(pIDNodeChild != null)
						break;
				}
			}
		}

	}

    COMPILE::SWF
	public class InspireTreeCheckBoxModeBeadExt
	{
    }
}
