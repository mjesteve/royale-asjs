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
package org.apache.royale.html.beads {

    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;

    import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.core.IImage;
    import org.apache.royale.core.IImageModel;
  
  /**
	 *  The ErrorImage class is a bead that can be used to 
     *  display an alternate image, in the event that the specified image 
     *  cannot be loaded.
     * 
     *  It will be supported by controls that load the ImageModel bead and 
     *  implement the IImage interface
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */

    public class ErrorImage implements IBead {

        protected var _strand:IStrand;

        public function ErrorImage() {            
        }

        private var _src:String;
		/**
		 *  The source of the image
		 */
        public function get src():String {
            return _src;
        }

        public function set src(value:String):void {
            _src = value;
        }
        
		COMPILE::JS{
        private var _hostElement:HTMLImageElement;
		protected function get hostElement():HTMLImageElement
		{
			return _hostElement;
		}
        }
        protected function get hostModel():IImageModel
        {             
            return _strand.getBeadByType(IImageModel) as IImageModel;
        }

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function set strand(value:IStrand):void 
        {
            _strand = value;

	        COMPILE::JS {

                if(_strand is IImage)
                {
                    _hostElement = (_strand as IImage).imageElement as HTMLImageElement;
                    if(_hostElement){
                        
                        _hostElement.addEventListener('error', errorHandler);

                        if(_emptyIsError)
                        {
                            (_strand as EventDispatcher).addEventListener("beadsAdded", beadsAddedHandler);
                        }
                    }   
                }
            }
        }

		COMPILE::JS
        private function beadsAddedHandler(event:Event):void
        {
            (_strand as EventDispatcher).removeEventListener("beadsAdded", beadsAddedHandler);

            if(hostModel)
                hostModel.addEventListener("urlChanged",srcChangedHandler);
            srcChangedHandler(null);
        }

        private var _emptyIsError:Boolean = false;
        public function get emptyIsError():Boolean {
            return _emptyIsError;
        }
        public function set emptyIsError(value:Boolean):void {
            _emptyIsError = value;
        }

		COMPILE::JS
        private function errorHandler(event:Event):void {
        
            if (hostElement.src != _src)
            {
                hostElement.src = _src;
            }
        }
		
        private function srcChangedHandler(event:Event):void
        {
            if(hostModel && !hostModel.url){
                
                COMPILE::JS {
                    // Op1: Updating the model (It causes a double assignment that we must control)
                    if(hostModel.hasEventListener("urlChanged")){
                        hostModel.removeEventListener("urlChanged",srcChangedHandler);
                        hostModel.url = src;
                        hostModel.addEventListener("urlChanged",srcChangedHandler);                    
                    }
                    // Op2: Direct assignment to element
                    //(hostElement as Object).src = src;
                }                    
            }
            
        }

    }
}

