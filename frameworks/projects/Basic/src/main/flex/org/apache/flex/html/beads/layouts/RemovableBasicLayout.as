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
package org.apache.flex.html.beads.layouts {
import org.apache.flex.core.IStrand;
import org.apache.flex.core.IBeadLayout;
import org.apache.flex.core.ILayoutChild;
import org.apache.flex.events.IEventDispatcher;

/**
 *  The RemovableBasicLayout class is a simple layout
 *  bead.  It takes the set of children and lays them out
 *  as specified by CSS properties like left, right, top
 *  and bottom. It correctly handles removal and replacement between
 *  different strands, and null strand assignment
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class RemovableBasicLayout extends BasicLayout implements IBeadLayout {

    /**
     *  @copy org.apache.flex.core.IBead#strand
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     *
     * @royaleignorecoercion org.apache.flex.core.ILayoutChild
     * @royaleignorecoercion org.apache.flex.events.IEventDispatcher
     */
    override public function set strand(value:IStrand):void {
        var newHost:ILayoutChild = value as ILayoutChild;
        var oldHost:ILayoutChild = host;
        if (newHost != oldHost) {
            var sizeChange:Function = handleSizeChange;
            var childrenAdded:Function = handleChildrenAdded;
            var initComplete:Function = handleInitComplete;
            var layoutNeeded:Function = handleLayoutNeeded;
            if (oldHost) {
                IEventDispatcher(oldHost).removeEventListener("widthChanged", sizeChange);
                IEventDispatcher(oldHost).removeEventListener("heightChanged", sizeChange);
                IEventDispatcher(oldHost).removeEventListener("sizeChanged", sizeChange);
                IEventDispatcher(oldHost).removeEventListener("childrenAdded", childrenAdded);
                IEventDispatcher(oldHost).removeEventListener("initComplete", initComplete);
                IEventDispatcher(oldHost).removeEventListener("layoutNeeded", layoutNeeded);
            }

            host = newHost;
            if (newHost) {
                //note, could call super.strand = newHost here, to avoid DRY
                //but not doing so, because it will be slower with the repeated closure lookups in js
                IEventDispatcher(newHost).addEventListener("widthChanged", sizeChange);
                IEventDispatcher(newHost).addEventListener("heightChanged", sizeChange);
                IEventDispatcher(newHost).addEventListener("sizeChanged", sizeChange);
                IEventDispatcher(newHost).addEventListener("childrenAdded", childrenAdded);
                IEventDispatcher(newHost).addEventListener("initComplete", initComplete);
                IEventDispatcher(newHost).addEventListener("layoutNeeded", layoutNeeded);
            }
        }
    }
}
}
