//
//  WKWebview+Controllers.swift
//  StadiaApp
//
//  Created by Jason Meulenhoff on 14/09/2020.
//

import Foundation
import GameController
import WebKit

extension WKWebView {
	override open var safeAreaInsets: UIEdgeInsets {
		return UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
	}
}

public struct Controller: Codable
{
	let axes: [Double]
	let buttons: [GamePadButton?]
	let connected: Bool
	let id: String
	let index: Int
	let mapping: String
	let timestamp: Double

	public var jsonString: String {

		guard let data = try? JSONEncoder().encode(self) else
		{
			return ""
		}

		return String(data: data, encoding: .utf8) ?? ""
	}
}

public struct GamePadButton: Codable
{
	public var pressed: Bool
	public var value: Double
}

public class WebController: NSObject
{
	@File(name: "gamepad", type: "js", decoder: { String(data: $0, encoding: .utf8) })
	var gamepadScript: String?

	public func setup(webview: WKWebView)
	{
		guard let script = gamepadScript else
		{
			return
		}

		webview.evaluateJavaScript(script, completionHandler: nil)
	}

	private var controllerData: String {

		guard let controller = GCController.controllers().first,
			  let gamepad = controller.extendedGamepad,
			  let buttonOptions = gamepad.buttonOptions,
			  let buttonHome = gamepad.buttonHome,
			  let leftThumbstickButton = gamepad.leftThumbstickButton,
			  let rightThumbstickButton = gamepad.rightThumbstickButton else {

			return ""
		}

		let customController = Controller(
			axes: [
				Double(gamepad.leftThumbstick.xAxis.value),
				Double(-1.0 * gamepad.leftThumbstick.yAxis.value),
				Double(gamepad.rightThumbstick.xAxis.value),
				Double(-1.0 * gamepad.rightThumbstick.yAxis.value)
			],
			buttons: [
				GamePadButton(pressed: gamepad.buttonA.isPressed, value: Double(gamepad.buttonA.value)),
				GamePadButton(pressed: gamepad.buttonB.isPressed, value: Double(gamepad.buttonB.value)),
				GamePadButton(pressed: gamepad.buttonX.isPressed, value: Double(gamepad.buttonX.value)),
				GamePadButton(pressed: gamepad.buttonY.isPressed, value: Double(gamepad.buttonY.value)),
				GamePadButton(pressed: gamepad.leftShoulder.isPressed, value: Double(gamepad.leftShoulder.value)),
				GamePadButton(pressed: gamepad.rightShoulder.isPressed, value: Double(gamepad.rightShoulder.value)),
				GamePadButton(pressed: gamepad.leftTrigger.isPressed, value: Double(gamepad.leftTrigger.value)),
				GamePadButton(pressed: gamepad.rightTrigger.isPressed, value: Double(gamepad.rightTrigger.value)),
				GamePadButton(pressed: buttonOptions.isPressed, value: Double(buttonOptions.value)),
				GamePadButton(pressed: gamepad.buttonMenu.isPressed, value: Double(gamepad.buttonMenu.value)),
				GamePadButton(pressed: leftThumbstickButton.isPressed, value: Double(leftThumbstickButton.value)),
				GamePadButton(pressed: rightThumbstickButton.isPressed, value: Double(rightThumbstickButton.value)),
				GamePadButton(pressed: gamepad.dpad.up.isPressed, value: Double(gamepad.dpad.up.value)),
				GamePadButton(pressed: gamepad.dpad.down.isPressed, value: Double(gamepad.dpad.down.value)),
				GamePadButton(pressed: gamepad.dpad.left.isPressed, value: Double(gamepad.dpad.left.value)),
				GamePadButton(pressed: gamepad.dpad.right.isPressed, value: Double(gamepad.dpad.right.value)),
				GamePadButton(pressed: buttonHome.isPressed, value: Double(buttonHome.value)),
			],
			connected: true,
			id: "Emulated iOS Controller",
			index: 0,
			mapping: "standard",
			timestamp: 0)

		return customController.jsonString
	}
}

extension WebController: WKScriptMessageHandlerWithReply
{
	public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
		replyHandler(controllerData, nil)
	}
}
