import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Time.Gregorian;

class GarminSwimMessageFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function getTime() as String {
        var timeFormat = "$1$:$2$";  
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            var amPm = " AM";
            if (hours > 12) {
                hours = hours - 12;
                amPm = " PM";
            } 
            return Lang.format("$1$:$2$$3$", [hours, clockTime.min.format("%02d"), amPm]);
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
            return Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        }
    }

    function getElapsedDistance() as String {
        var elapsedDistance = Activity.Info.elapsedDistance;
        return elapsedDistance == null ? "" : elapsedDistance.format("%0.2f");
    }

    function getDate() as String {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        return Lang.format("$1$ $2$", [today.month, today.day]);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var foregroundColor = getApp().getProperty("ForegroundColor") as Number;
        
        // Update the view
        var timeView = View.findDrawableById("TimeLabel") as Text;
        timeView.setColor(foregroundColor);
        timeView.setText(getTime());

        var dateView = View.findDrawableById("DateLabel") as Text;
        // dateView.setColor(foregroundColor);
        dateView.setText(getDate());

        var elapsedView = View.findDrawableById("ElapsedLabel") as Text;
        elapsedView.setText(getElapsedDistance());

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
