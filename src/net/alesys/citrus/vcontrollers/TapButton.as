/**
 * Created by Rolf on 11/3/14.
 */
package net.alesys.citrus.vcontrollers {
import citrus.input.InputController;

import starling.core.Starling;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TapButton extends InputController {
    public function TapButton(name:String, params:Object = null) {
        super(name, params);
        Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private var id:int = -1;

    private var _trigger:String;

    public function get trigger():String {
        return _trigger;
    }

    public function set trigger(value:String):void {
        _trigger = value;
    }

    override public function destroy():void {
        Starling.current.stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
        super.destroy();
    }

    private function handleTouch(event:TouchEvent):void {
        var began:Touch;
        var ended:Touch;

        began = event.getTouch(Starling.current.stage, TouchPhase.BEGAN);
        ended = event.getTouch(Starling.current.stage, TouchPhase.ENDED, id);

        if (began && began.globalX > Starling.current.stage.stageWidth >> 1) {
            id = began.id;
            triggerON(_trigger);
        }
        else if (ended && id != -1 && ended.id == id) {
            id = -1;
            triggerOFF(_trigger);
        }
    }
}
}
