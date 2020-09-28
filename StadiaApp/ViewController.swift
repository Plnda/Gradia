//
//  ViewController.swift
//  StadiaApp
//
//  Created by Jason Meulenhoff on 11/09/2020.
//

import UIKit
import WebKit

class ViewController: UIViewController {

	private var webview: WKWebView!
	private var controller: WebController = WebController()

	override func viewDidLoad() {
		super.viewDidLoad()

		let configuration = WKWebViewConfiguration()
		configuration.allowsInlineMediaPlayback = false
		configuration.mediaTypesRequiringUserActionForPlayback = []
		configuration.applicationNameForUserAgent = "Version/13.0.1 Safari/605.1.15"
		configuration.userContentController.addScriptMessageHandler(controller, contentWorld: WKContentWorld.page, name: "controller")

		webview = WKWebView(frame: view.bounds, configuration: configuration)
		webview.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(webview)

		webview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		webview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		webview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		webview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		webview.navigationDelegate = self
		webview.load(URLRequest(url: URL(string: "http://accounts.google.com/")!))
	}

	@objc private func goToStadia()
	{
		webview.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36"
		webview.load(URLRequest(url: URL(string: "https://stadia.google.com")!))
	}
}

extension ViewController: WKNavigationDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

		controller.setup(webview: webview)
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

		if let url = navigationAction.request.url?.absoluteString
		{
			if url == "https://myaccount.google.com/"
			{
				decisionHandler(.cancel)
				goToStadia()
				return
			}
		}

		decisionHandler(.allow)
	}
}

