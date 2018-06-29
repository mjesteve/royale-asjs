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
package org.apache.royale.jewel
{
    import org.apache.royale.utils.ClassSelectorList;
    import org.apache.royale.core.ITextModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.IIconSupport;
    import org.apache.royale.core.IIcon;
    import org.apache.royale.events.IEventDispatcher;

    COMPILE::SWF
    {
    	import org.apache.royale.core.UIButtonBase;
    }

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.core.StyledUIBase;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user clicks on a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

    /**
     *  Set a different class for rollOver events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="rollOver", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for rollOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="rollOut", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseDown events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseDown", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseUp events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseUp", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseMove events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseMove", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    [Event(name="mouseOut", type="org.apache.royale.events.MouseEvent")]
    
	/**
	 *  Set a different class for mouseOver events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	[Event(name="mouseOver", type="org.apache.royale.events.MouseEvent")]
	/**
	 *  Set a different class for mouseWheel events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	[Event(name="mouseWheel", type="org.apache.royale.events.MouseEvent")]
	
	/**
	 *  Set a different class for doubleClick events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	[Event(name="doubleClick", type="org.apache.royale.events.MouseEvent")]


    [DefaultProperty("text")]

    /**
     *  The ButtonBase class is the base class for Button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    COMPILE::SWF
	public class Button extends UIButtonBase implements IStrand, IEventDispatcher, IUIBase, IIconSupport
	{
        public static const PRIMARY:String = "primary";
        public static const SECONDARY:String = "secondary";
        public static const EMPHASIZED:String = "emphasized";

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function Button()
		{
			super();

            classSelectorList = new ClassSelectorList(this);
            typeNames = "jewel button";
		}

        protected var classSelectorList:ClassSelectorList;

        /**
         *  @copy org.apache.royale.html.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get text():String
		{
            return ITextModel(model).text;
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
            ITextModel(model).text = value;
		}

        /**
         *  @copy org.apache.royale.html.Label#html
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get html():String
		{
            return ITextModel(model).html;
		}

        /**
         *  @private
         */
		public function set html(value:String):void
		{
            ITextModel(model).html = value;
		}

        private var _emphasis:String;

        /**
		 *  Activate "emphasis" effect selector. Applies emphasis color display effect.
         *  Possible values are constants (PRIMARY, SECONDARY, EMPHASIZED)
         *  Colors are defined in royale-jewel.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get emphasis():String
        {
            return _emphasis;
        }

        public function set emphasis(value:String):void
        {
            if (_emphasis != value)
            {
                if(_emphasis)
                {
                    classSelectorList.toggle(_emphasis, false);
                }
                _emphasis = value;

                classSelectorList.toggle(_emphasis, value);
            }
        }

        private var _icon:IIcon;
        /**
		 *  The icon to use with the button.
         *  Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get icon():IIcon
        {
            return _icon;
        }
        public function set icon(value:IIcon):void
        {
            _icon = value;

            classSelectorList.toggle("icon", (_icon != null));
            // todo set up icon on swf
        }
    }

    /**
     *  The Button class that should show text.  This is the lightest weight
     *  button used for non-text buttons like the arrow buttons
     *  in a Scrollbar or NumericStepper.
     * 
     *  The most common view for this button is CSSButtonView that
     *  allows you to specify a backgroundImage in CSS that defines
     *  the look of the button.
     * 
     *  However, when used in ScrollBar and when composed in many
     *  other components, it is more common to assign a custom view
     *  to the button.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    COMPILE::JS
    public class Button extends StyledUIBase implements IStrand, IEventDispatcher, IUIBase, IIconSupport
    {
        public static const PRIMARY:String = "primary";
        public static const SECONDARY:String = "secondary";
        public static const EMPHASIZED:String = "emphasized";

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function Button()
		{
			super();
            typeNames = "jewel button";
		}

        /**
         *  @copy org.apache.royale.html.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get text():String
		{
            return element.innerHTML;
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
            this.element.innerHTML = value;
            this.dispatchEvent('textChange');
		}

        /**
         *  @copy org.apache.royale.html.Label#html
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get html():String
		{
            return element.innerHTML;
		}

        /**
         *  @private
         */
		public function set html(value:String):void
		{
            this.element.innerHTML = value;
            this.dispatchEvent('textChange');
		}

        private var _emphasis:String;

        /**
		 *  Activate "emphasis" effect selector. Applies emphasis color display effect.
         *  Possible values are constants (PRIMARY, SECONDARY, EMPHASIZED)
         *  Colors are defined in royale-jewel.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get emphasis():String
        {
            return _emphasis;
        }

        public function set emphasis(value:String):void
        {
            if (_emphasis != value)
            {
                if(_emphasis)
                {
                    toggleClass(_emphasis, false);
                }
                _emphasis = value;

                toggleClass(_emphasis, value);
            }
        }

        private var _icon:IIcon;
        /**
		 *  The icon to use with the button.
         *  Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get icon():IIcon
        {
            return _icon;
        }
        public function set icon(value:IIcon):void
        {
            _icon = value;

            toggleClass("icon", (_icon != null));
            
            COMPILE::JS
            {
                // insert the icon before the text
                addElementAt(_icon, 0);
            }
        }

        /**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'button');
            element.setAttribute('type', 'button');
            /* AJH comment out until we figure out why it is needed
            if (org.apache.royale.core.ValuesManager.valuesImpl.getValue) {
                var impl:Object = org.apache.royale.core.ValuesManager.valuesImpl.
                    getValue(this, 'iStatesImpl');
            }*/
            positioner = element;


            return element;
        }
	}
}