import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Weather;

class PixelWatchFaceView extends WatchUi.WatchFace {

    // See setColonDisplay for details.
    private var showColon;

    function initialize() {
        WatchFace.initialize();
        showColon = false;
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void {
        setHourDisplay();
        setColonDisplay();
        setMinuteDisplay();
        
        setDateDisplay();
        setTemperatureDisplay();
        
        setBatteryDisplay();
        setHeartRateDisplay();
        
        View.onUpdate(dc);
    }
    
    // Sets the date display.    
    function setDateDisplay() {
        var view = View.findDrawableById("DateDisplay") as Text;
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format(
            "$1$ $2$",
            [
                today.day_of_week,
                today.day
            ]
        ).toUpper();
        view.setText(dateString);
    }
    
    // Sets the temperature display.
    function setTemperatureDisplay() {
        var view = View.findDrawableById("TemperatureDisplay") as Text;
        var currentConditions = Weather.getCurrentConditions();
        var temperature;
        if (currentConditions == null) {
            temperature = "--";
        } else {
            temperature = currentConditions.temperature.toString();
        }
        var temperatureString = temperature + "'C";
        view.setText(temperatureString);
    }
    
    // Sets the hour display.
    function setHourDisplay() {
        var view = View.findDrawableById("HourDisplay") as Text;
        var clockTime = System.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour.format("%02d")]);
        view.setText(hourString);
    }
    
    // Sets the colon display.
    // Enables the colon between the hour and the minute display to blink periodically.
    function setColonDisplay() {
        var view = View.findDrawableById("ColonDisplay") as Text;
        if (showColon) {
            view.setText(":");
            showColon = false;
        } else {
            view.setText("");
            showColon = true;
        }
    }
    
    // Sets the minute display.
    function setMinuteDisplay() {
        var view = View.findDrawableById("MinuteDisplay") as Text;
        var clockTime = System.getClockTime();
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        view.setText(minuteString);
    }
    
    // Sets the battery display.
    function setBatteryDisplay() {
        var view = View.findDrawableById("BatteryDisplay") as Text;
        var systemStats = System.getSystemStats();
        var batteryString = Lang.format("$1$%", [systemStats.battery.format("%.2d")]);
        view.setText(batteryString);
    }
    
    // Sets the heart rate display.
    function setHeartRateDisplay() {
        var view = View.findDrawableById("HeartRateDisplay") as Text;
        var heartRate = Activity.getActivityInfo().currentHeartRate;
        if (heartRate == null) {
            var hrIterator = ActivityMonitor.getHeartRateHistory(null, true);
            var sample = hrIterator.next();
            if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                heartRate = sample.heartRate;
            } else {
                heartRate = "--";
            }   
        }
        var heartRateString = "HR " + heartRate;
        view.setText(heartRateString);
    }
}
