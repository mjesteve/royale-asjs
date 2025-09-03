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
package org.apache.royale.externsjs.inspiretree
{
	//COMPILE::JS
    //{
        import org.apache.royale.externsjs.inspiretree.InspireTree;
        import org.apache.royale.externsjs.inspiretree.vos.ConfigDOM;
    //}

	[JSIncludeScript(source="../../../../../../assembly/third-party/lodash/4.17.21/lodash.min.js")]
	[JSIncludeCSS(source="../../../../../../assembly/third-party/inspiretree/7.0.16/inspire-tree-community.min.css")]
	[JSIncludeScript(source="../../../../../../assembly/third-party/inspiretree/7.0.16/inspire-tree-dom-royale.min.js")]
	/**
	 * @externs
	 */
	COMPILE::JS
	public class InspireTreeDOM{
		
        public function InspireTreeDOM(tree:InspireTree, opts:ConfigDOM=null){
		}
        public var config:ConfigDOM;

        /*public function on(type:String, listener:Function):void {};
        public function off(type:String, listener:Function):void {};*/

		/**
		 * Get a tree instance based on an ID.
		 *
		 * @param {string} id Tree ID.
		 * @return {InspireTree} Tree instance.
		 */
		public static function getTreeById(id:String):InspireTree{ return null; }
	}

	COMPILE::SWF
	public class InspireTreeDOM{
		
        public function InspireTreeDOM(tree:InspireTree, opts:ConfigDOM=null){
		}
	}
}