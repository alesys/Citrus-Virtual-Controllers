Citrus Virtual Controllers
==========================

Usage:

Virtual Joystick will use the left side of the screen. Whenever the user touches the left side of the screen it will draw a Virutal Joystick in that location.
These parameters are required:
@param container The DisplayObject where the joystick will be placed. It can be your current state. 
@param viewknob A DisplayObject containing the art of the Knob. 
@param viewback A DisplayObject containing the art of the back of the Knob. 
@param radius The radius 

```actionscript
joystick = new VJoystick('joystick',{
            container:this,
            viewknob: new Image(assets.getTexture('knob')),
            viewback: new Image(assets.getTexture('knobback')),
            radius: 64
        });

// Allways destroy it before changing states
joystick.destroy();
```

TapButton will use the right side of the screen. Whenever the user touches the right side of the screen it will call triggerOn, and triggerOff on release. 
The only required parameter is:
@param trigger A string containing the name of the action to be triggered. 
```actionscript
touchControl = new TapButton('touchControl',{trigger:'jump'});

// Allways destroy it before changing state
touchControl.destroy();
```

It is required to enable multitouch before creating the Starling instance

```actionscript
Starling.multitouchEnabled = true;
```