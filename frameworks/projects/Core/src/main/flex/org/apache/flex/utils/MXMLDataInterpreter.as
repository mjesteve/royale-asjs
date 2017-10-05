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
package org.apache.flex.utils
{

COMPILE::SWF
{
    import flash.display.DisplayObject;
}

import org.apache.flex.core.IBead;
import org.apache.flex.core.IContainer;
import org.apache.flex.core.IDocument;
import org.apache.flex.core.IMXMLDocument;
import org.apache.flex.core.IParent;
import org.apache.flex.core.IStrand;
import org.apache.flex.events.Event;
import org.apache.flex.events.IEventDispatcher;
import org.apache.flex.core.IChild;        

COMPILE::JS
{
    import goog.bind;
}

/**
 *  The MXMLDataInterpreter class is the class that interprets the
 *  encoded information generated by the compiler that describes
 *  the contents of an MXML document.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 *  @royaleignoreimport goog.bind
 */
public class MXMLDataInterpreter
{
    /**
     *  Constructor.  All methods are static so should not be instantiated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function MXMLDataInterpreter()
    {
        super();
    }
    	
    
    /**
     *  Generates an object based on the encoded data.
     *  
     *  @param document The MXML document.  If the object has an id
     *  it will be assigned in this document in this method.
     *  @param data The encoded data.
     *  @return The object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static function generateMXMLObject(document:Object, data:Array):Object
    {
        var i:int = 0;
        var cls:Class = data[i++];
        var comp:Object = new cls();
        
        if (comp is IStrand)
            initializeStrandBasedObject(document, null, comp, data, i);
        else
        {
            var m:int;
            var j:int;
            var name:String;
            var simple:*;
            var value:Object;
            var id:String;
            
            m = data[i++]; // num props
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value as Array);
                else if (simple == false)
                    value = generateMXMLObject(document, value as Array);
                if (name == "id")
                    id = value as String;
                if (name == "document" && !comp.document)
                    comp.document = document;
                else if (name == "_id")
                    id = value as String; // and don't assign to comp
                else if (name == "id")
                {
                    // not all objects have to have their own id property
                    try {
                        comp["id"] = value;
                    } catch (e:Error)
                    {
                        
                    }
                }
                else
                    comp[name] = value;
            }
            if (id)
                document[id] = comp;

            if (comp is IDocument)
                comp.setDocument(document, id);
        }
        return comp;
    }
    
    /**
     *  Generates an Array of objects based on the encoded data.
     *  
     *  @param document The MXML document.  If the object has an id
     *  it will be assigned in this document in this method.
     *  @param parent The parent for any display objects encoded in the array.
     *  @param data The encoded data.
     *  @return The Array.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static function generateMXMLArray(document:Object, parent:IParent, data:Array):Array
    {
        var comps:Array = [];
        
        var n:int = data.length;
        var i:int = 0;
        while (i < n)
        {
            var cls:Class = data[i++];
            var comp:Object = new cls();

            i = initializeStrandBasedObject(document, parent, comp, data, i);
            
            comps.push(comp);
        }
        return comps;
    }
    
    /**
     * @royaleignorecoercion Function 
     * @royaleignorecoercion org.apache.flex.core.IChild 
     */
    private static function initializeStrandBasedObject(document:Object, parent:IParent, comp:Object, data:Array, i:int):int
    {
        var m:int;
        var j:int;
        var name:String;
        var simple:*;
        var value:Object;
        var id:String = null;
        
        m = data[i++]; // num props
        if (m > 0 && data[0] == "model")
        {
            m--;
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(document, parent, value as Array);
            else if (simple == false)
                value = generateMXMLObject(document, value as Array);
            comp[name] = value;
            if (value is IBead && comp is IStrand)
                IStrand(comp).addBead(value as IBead);
        }
        var beadOffset:int = i + (m - 1) * 3;
        //if (beadOffset >= -1)
        //    trace(beadOffset, data[beadOffset]);
        if (m > 0 && data[beadOffset] == "beads")
        {
            m--;
        }
        else
            beadOffset = -1;
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(document, null, value as Array);
            else if (simple == false)
                value = generateMXMLObject(document, value as Array);
            if (name == "id")
                id = value as String;
            if (name == "document" && !comp.document)
                comp.document = document;
            else if (name == "_id")
                id = value as String; // and don't assign to comp
            else if (name == "id")
            {
                // not all objects have to have their own id property
                try {
                    comp["id"] = value;
                } catch (e:Error)
                {
                    
                }
            }
            else
                comp[name] = value;
        }
        if (beadOffset > -1)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(document, null, value as Array);
            else if (simple == false)
                value = generateMXMLObject(document, value as Array);
            comp[name] = value;
        }
        m = data[i++]; // num styles
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(document, null, value as Array);
            else if (simple == false)
                value = generateMXMLObject(document, value as Array);
            comp.setStyle(name, value);
        }            
        
        COMPILE::SWF
        {
            // royale on the JS side won't have effects in here, they are regular properties
            // but falcon provides this set for SWFs for future compatibility with
            // the older flex-sdk.
            m = data[i++]; // num effects
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(document, null, value as Array);
                else if (simple == false)
                    value = generateMXMLObject(document, value as Array);
                comp.setStyle(name, value);
            }
        }
        
        m = data[i++]; // num events
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            value = data[i++];
            COMPILE::SWF
            {
                comp.addEventListener(name, value);
            }
            COMPILE::JS
            {
                comp.addEventListener(name, goog.bind(value as Function, document));
            }
        }
        
        var children:Array = data[i++];
        if (children && comp is IMXMLDocument)
        {
            comp.setMXMLDescriptor(document, children);                
        }
        COMPILE::SWF
        {
            if (parent && comp is IChild)
                parent.addElement(comp as IChild, !(parent is IContainer));
        }
        COMPILE::JS
        {
            if (parent && comp is IChild)
                parent.addElement(comp as IChild, !(parent is IContainer));
        }
        
        if (children)
        {
            if (!(comp is IMXMLDocument))
            {
                generateMXMLInstances(document, comp as IParent, children);
            }
        }
        
        if (id)
            document[id] = comp;
        
        if (comp is IDocument)
            comp.setDocument(document, id);
                
        return i;
    }
    
    /**
     *  Generates the instances of objects in an MXML document based on the encoded data.
     *  
     *  @param document The MXML document.  If the object has an id
     *  it will be assigned in this document in this method.
     *  @param parent The parent for any display objects encoded in the array.
     *  @param data The encoded data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static function generateMXMLInstances(document:Object, parent:IParent, data:Array):void
    {
		if (data != null) {
        	generateMXMLArray(document, parent, data);
		}
        // maybe we can remove this.  All IContainers should be IMXMLDocuments?
        if (parent is IContainer)
        {
            IContainer(parent).childrenAdded();
        }
    }
    
    /**
     *  Generates the properties of the top-level object in an MXML document 
     *  based on the encoded data.  This basically means setting the attributes
     *  found on the tag and child tags that aren't in the default property.
     *  
     *  @param host The MXML document.  If the object has an id
     *  it will be assigned in this document in this method.
     *  @param data The encoded data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royaleignorecoercion Function
     */
    public static function generateMXMLProperties(host:Object, data:Array):void
    {
		if (!data) return;
		
        var i:int = 0;
        var m:int;
        var j:int;
        var name:String;
        var simple:*;
        var value:Object;
        var id:String = null;
        
        m = data[i++]; // num props
        var beadOffset:int = i + (m - 1) * 3;
        //if (beadOffset >= -1)
        //      (beadOffset, data[beadOffset]);
        if (m > 0 && data[beadOffset] == "beads")
        {
            m--;
        }
        else
            beadOffset = -1;
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value as Array);
            else if (simple == false)
                value = generateMXMLObject(host, value as Array);
            if (name == "id")
                id = value as String;
            if (name == "_id")
                id = value as String; // and don't assign
            else
                host[name] = value;
        }
        if (beadOffset > -1)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value as Array);
            else if (simple == false)
                value = generateMXMLObject(host, value as Array);
            host[name] = value;
        }
        m = data[i++]; // num styles
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            simple = data[i++];
            value = data[i++];
            if (simple == null)
                value = generateMXMLArray(host, null, value as Array);
            else if (simple == false)
                value = generateMXMLObject(host, value as Array);
            host[name] = value;
        }
        
        COMPILE::SWF 
        {
            // royale on the JS side won't have effects in here, they are regular properties
            // but falcon provides this set for SWFs for future compatibility with
            // the older flex-sdk.
            m = data[i++]; // num effects
            for (j = 0; j < m; j++)
            {
                name = data[i++];
                simple = data[i++];
                value = data[i++];
                if (simple == null)
                    value = generateMXMLArray(host, null, value as Array);
                else if (simple == false)
                    value = generateMXMLObject(host, value as Array);
                host[name] = value;
            }
        }
        
        m = data[i++]; // num events
        for (j = 0; j < m; j++)
        {
            name = data[i++];
            value = data[i++];
            COMPILE::SWF
            {
                host.addEventListener(name, value as Function);
            }
            COMPILE::JS
            {
                host.addEventListener(name, goog.bind(value as Function, host));
            }
        }
        
    }
    
}
}
