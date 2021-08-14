import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class PixelWatchFaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // Returns the initial view of the application.
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new PixelWatchFaceView() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as PixelWatchFaceApp {
    return Application.getApp() as PixelWatchFaceApp;
}