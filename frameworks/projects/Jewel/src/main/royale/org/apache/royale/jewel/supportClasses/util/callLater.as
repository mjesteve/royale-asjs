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
package org.apache.royale.jewel.supportClasses.util
{
    COMPILE::SWF
    {
        import flash.utils.setTimeout;
    }
    
    public function callLater(fn:Function, args:Array = null, thisArg:Object = null):void
    {
        var calls:Array = [ {thisArg: thisArg, fn: fn, args: args } ];
        setTimeout(makeCalls, 0);
        function makeCalls():void
        {
            var list:Array = calls;
            var n:int = list.length;
            for (var i:int = 0; i < n; i++)
            {
                var call:Object = list.shift();
                var fn:Function = call.fn;
                fn.apply(call.thisArg, call.args);
            }
        }
    }
}