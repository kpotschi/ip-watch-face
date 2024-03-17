import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

class IpView extends WatchUi.WatchFace {
	var screenWidth as Number?;
	var screenHeight as Number?;
	var _screenShape as ScreenShape;
	var app as Application.AppBase;
	// private var _screenCenterPoint as Array<Number>?;

	function initialize() {
		WatchFace.initialize();
		app = Application.getApp();
		// screenWidth = 1;
		// screenHeight = 1;
		_screenShape = System.getDeviceSettings().screenShape;
	}

	public function onLayout(dc as Dc) as Void {
		screenWidth = dc.getWidth();
		screenHeight = dc.getHeight();
		setLayout(Rez.Layouts.MainLayout(dc));
		// var offscreenBufferOptions = {
		// 	:width => dc.getWidth(),
		// 	:height => dc.getHeight(),
		// 	:palette => [
		// 		Graphics.COLOR_DK_GRAY,
		// 		Graphics.COLOR_LT_GRAY,
		// 		Graphics.COLOR_BLACK,
		// 		Graphics.COLOR_WHITE,
		// 	],
		// };
		// _screenCenterPoint = [dc.getWidth() / 2, dc.getHeight() / 2];
	}

	public function onUpdate(dc as Dc) as Void {
		WatchFace.onUpdate(dc);
		// dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

		// dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		// System.println(app.getProperty("displayBattery"));
		drawCircle(dc);
		drawHoursMinutes(dc);
		drawClock(dc);
		if (app.getProperty("displayBattery") == true) {
			drawBattery(dc);
		}
	}

	private function drawCircle(dc as Dc) as Void {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_RED);
		var strokeWidth = 3;
		dc.setPenWidth(strokeWidth);

		dc.drawCircle(
			screenWidth / 2,
			screenHeight / 2,
			screenWidth / 2 - strokeWidth / 2
		);
	}
	private function drawClock(dc as Dc) as Void {
		var displayHeight = dc.getHeight();
		var displayWidth = dc.getWidth();
		var strokeWidth = 3;

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_RED);
		dc.setPenWidth(strokeWidth);

		dc.drawCircle(
			displayWidth / 2,
			displayHeight / 2,
			displayWidth / 2 - strokeWidth / 2
		);

		var clockTime = System.getClockTime();

		// mins
		var min = clockTime.min;
		var minHandInset = 20;
		var minHandWidth = 0.02;

		var minRadians = 6 * min * (Math.PI / 180) - Math.PI / 2;

		var minX1 =
			Math.cos(minRadians) * (displayWidth / 2 - minHandInset) +
			displayWidth / 2;
		var minY1 =
			Math.sin(minRadians) * (displayHeight / 2 - minHandInset) +
			displayWidth / 2;

		var minX2 =
			Math.cos(minRadians - minHandWidth) * (displayWidth / 2) +
			displayWidth / 2;
		var minY2 =
			Math.sin(minRadians - minHandWidth) * (displayHeight / 2) +
			displayWidth / 2;

		var minX3 =
			Math.cos(minRadians + minHandWidth) * (displayWidth / 2) +
			displayWidth / 2;
		var minY3 =
			Math.sin(minRadians + minHandWidth) * (displayHeight / 2) +
			displayWidth / 2;
		dc.fillPolygon([
			[minX1, minY1],
			[minX2, minY2],
			[minX3, minY3],
		]);

		// hour
		var hour = clockTime.hour % 12;
		var hourHandInset = 10;
		var hoursHandWidth = 0.04;

		var hourDeg = 30 * hour;
		var minDeg = min * 0.5;
		var hourRadians = (hourDeg + minDeg) * (Math.PI / 180) - Math.PI / 2;

		var hourX1 =
			Math.cos(hourRadians) * (displayWidth / 2 - hourHandInset) +
			displayWidth / 2;
		var hourY1 =
			Math.sin(hourRadians) * (displayHeight / 2 - hourHandInset) +
			displayWidth / 2;

		var hourX2 =
			Math.cos(hourRadians - hoursHandWidth) * (displayWidth / 2) +
			displayWidth / 2;
		var hourY2 =
			Math.sin(hourRadians - hoursHandWidth) * (displayHeight / 2) +
			displayWidth / 2;

		var hourX3 =
			Math.cos(hourRadians + hoursHandWidth) * (displayWidth / 2) +
			displayWidth / 2;
		var hourY3 =
			Math.sin(hourRadians + hoursHandWidth) * (displayHeight / 2) +
			displayWidth / 2;
		dc.fillPolygon([
			[hourX1, hourY1],
			[hourX2, hourY2],
			[hourX3, hourY3],
		]);
	}

	private function drawHoursMinutes(dc as Dc) as Void {
		var clockTime = System.getClockTime();
		var hours = clockTime.hour.format("%02d");
		var minutes = clockTime.min.format("%02d");
		var x = dc.getWidth() / 2;
		var y = dc.getHeight() * 0.8;
		var yOffset = 2;
		var xSpread = 1;

		// Draw hours
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
			x - xSpread, // The x coordinate
			y - yOffset, // The y coordinate
			Graphics.FONT_NUMBER_MILD, // Using the default font with medium size
			hours, // The text to draw
			Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER // Justify to center both horizonatally and vertically using bitmap mask
		);

		dc.drawText(
			x + xSpread, // The x coordinate
			y + yOffset, // The y coordinate
			Graphics.FONT_NUMBER_MILD, // Using the default font with medium size
			minutes, // The text to draw
			Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER // Justify to center both horizonatally and vertically using bitmap mask
		);
	}

	private function drawBattery(dc as Dc) as Void {
		var battery = System.getSystemStats().battery;

		var height = 12;
		var width = 18;
		var x = screenWidth / 2 - width / 2;
		var y = screenHeight * 0.15;

		dc.setPenWidth(2);
		dc.setColor(
			battery <= 20 ? Graphics.COLOR_RED : Graphics.COLOR_WHITE,
			Graphics.COLOR_TRANSPARENT
		);
		dc.drawRoundedRectangle(x, y, width, height, 2);
		dc.drawLine(x + width + 1, y + 3, x + width + 1, y + height - 3);
		dc.fillRectangle(x + 1, y, ((width - 2) * battery) / 100, height);
	}
}
