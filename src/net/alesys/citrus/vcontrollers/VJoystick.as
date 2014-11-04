package net.alesys.citrus.vcontrollers {
import citrus.input.InputController;

import flash.geom.Point;

import starling.core.Starling;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class VJoystick extends InputController {
    public function VJoystick(name:String, params:Object = null) {
        super(name, params);
        this.init();
    }

    protected var view:Sprite;
    protected var pointA:Point = new Point();
    protected var pointB:Point = new Point();
    protected var touch_id:int = -1;

    private var _container:Sprite;

    public function get container():Sprite {
        return _container;
    }

    public function set container(value:Sprite):void {
        _container = value;
    }

    private var _viewknob:Image;

    public function get viewknob():Image {
        return _viewknob;
    }

    public function set viewknob(value:Image):void {
        _viewknob = value;
    }

    private var _viewback:Image;

    public function get viewback():Image {
        return _viewback;
    }

    public function set viewback(value:Image):void {
        _viewback = value;
    }

    private var _radius:Number;

    public function get radius():Number {
        return _radius;
    }

    public function set radius(value:Number):void {
        _radius = value;
    }

    protected function init():void {
        this.draw();
        Starling.current.stage.addEventListener(TouchEvent.TOUCH, touch_handler);
    }

    protected function eval_axis(x:Number, y:Number):void {
        if (x < -this._radius / 4) {
            this.triggerOFF('right');
            this.triggerON('left');
        }
        else if (x > this._radius / 4) {
            this.triggerOFF('left');
            this.triggerON('right');
        }
        else {
            this.triggerOFF('right');
            this.triggerOFF('left');
        }
    }

    private function draw():void {
        this.view = new Sprite();
        if (this._viewback) {
            this._viewback.pivotX = this._viewback.width >> 1;
            this._viewback.pivotY = this._viewback.height >> 1;
            this.view.addChild(this._viewback);
        }
        if (this._viewknob) {
            this._viewknob.pivotX = this._viewknob.width >> 1;
            this._viewknob.pivotY = this._viewknob.height >> 1;
            this.view.addChild(this._viewknob);
        }
        this._container.addChild(this.view);
        this.view.visible = false;
    }

    private function touch_handler(event:TouchEvent):void {
        var began:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.BEGAN);
        var moved:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.MOVED, this.touch_id);
        var ended:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED, this.touch_id);
        var difX:Number, difY:Number;
        if (began) {
            if (began.globalX < this._container.stage.stageWidth >> 1) {
                this.pointA.x = began.globalX;
                this.pointA.y = began.globalY;
                this.touch_id = began.id;
                this.view.visible = true;
                this.view.x = began.globalX;
                this.view.y = began.globalY;
                this._viewknob.x = 0;
                this._viewknob.y = 0;
            }
        }
        if (moved && moved.id == this.touch_id) {
            this.pointB.x = moved.globalX;
            this.pointB.y = moved.globalY;
            difX = this.pointB.x - this.pointA.x;
            difY = this.pointB.y - this.pointA.y;
            if (difX > this._radius) difX = this._radius;
            if (difX < -this._radius) difX = -this._radius;
            if (difY > this._radius) difY = this._radius;
            if (difY < -this._radius) difY = -this._radius;
            this._viewknob.x = difX;
            this._viewknob.y = difY;
            this.eval_axis(difX, difY);
        }
        if (ended && ended.id == this.touch_id) {
            this.view.visible = false;
            this.touch_id = -1;
            this.triggerOFF('right');
            this.triggerOFF('left');
        }
    }

    override public function destroy():void {
        if(this.view.parent)this.view.removeFromParent(true);
        else if (this.view)this.view.dispose();
        container = null;
        viewknob = null;
        viewback = null;
        Starling.current.stage.removeEventListener(TouchEvent.TOUCH, touch_handler);
        super.destroy();
    }
}
}