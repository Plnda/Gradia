var emulatedGamepad = null;

navigator.getGamepads = function() {

	window.webkit.messageHandlers.controller.postMessage({}).then((controllerData) => {

		try {

			var data = JSON.parse(controllerData);

			emulatedGamepad = {
				id: "Emulated iOS Controller",
				index: 0,
				connected: true,
				timestamp: 0,
				mapping: "standard",
				axes: [0, 0, 0, 0],
				buttons: new Array(17).fill().map(m => ({pressed: false, touched: false, value: 0}))
			}

			// Set received controller data
			emulatedGamepad.id = data.id;
			emulatedGamepad.mapping = data.mapping;
			emulatedGamepad.connected = data.connected;
			emulatedGamepad.timestamp = data.timestamp;
			emulatedGamepad.index = data.index;

			for(let i = 0; i < data.buttons.length; i++) {
				emulatedGamepad.buttons[i].pressed = data.buttons[i].pressed;
				emulatedGamepad.buttons[i].value = data.buttons[i].value;
			}

			for(let i = 0; i < data.axes.length; i++) {
				emulatedGamepad.axes[i] = data.axes[i]
			}

		} catch(e) {

			// Assume there is no controller connected because JSON.parse errored out
			emulatedGamepad = null;
		}
	});

	return [emulatedGamepad, null, null, null];
};

enhanced_changeGridSize(4)

function enhanced_changeGridSize(size) {
	switch (size) {
		case 4:
		enhanced_addGlobalStyle('.E3eEyc.H3tvrc { padding-left: 0.2rem !important; padding-right: 0.2rem !important; grid-template-columns: repeat(1,auto) !important; }');
		enhanced_addGlobalStyle('.GqLi4d.qu6XL { width: 98% !important; height: calc(21.75rem * 0.5) !important; }');
		enhanced_addGlobalStyle('.a1l9D { margin: 0.2rem 0.2rem 0.2rem 0.2rem !important; }');
		enhanced_addGlobalStyle('.E3eEyc { width: 375px !important; grid-gap: 1rem !important; }');
		enhanced_addGlobalStyle('.jMSKXe { min-width: 0px !important; }');
		enhanced_addGlobalStyle('.zUpxGe { width: 375px !important; }');
		break;
	}
}

var credits = document.createElement("a");
credits.className = "bl2XYB";
credits.id = "credits_id";

credits.href = "https://twitter.com/ThatSwiftDev";
credits.innerHTML = "@ThatSwiftDev";
credits.style.textAlign = "left";
credits.style.paddingLeft = "3rem";
credits.style.marginRight = "20px";


if (document.querySelectorAll(".YNlByb")[0] !== undefined) {
	document.querySelectorAll(".YNlByb")[0].prepend(credits);
}

// Main Loop
setInterval(function() {

	// Visibility: Homescreen-only
	if (document.location.href.indexOf("/home") != -1) {
		enhanced_Grid.style.display = "flex";
	} else {
		enhanced_Grid.style.display = "none";
	}

	// Visibility: Store-only
	if (document.location.href.indexOf("/store") != -1) {
		enhanced_StoreSearch.style.display = "flex";
		enhanced_StoreDropdown.style.display = "flex";
	} else {
		enhanced_StoreSearch.style.display = "none";
		enhanced_StoreDropdown.style.display = "none";
	}

}, 1000);

function enhanced_addGlobalStyle(css) {
	var head, style;
	head = document.getElementsByTagName('head')[0];
	if (!head) {
		return;
	}
	style = document.createElement('style');
	style.type = 'text/css';
	style.innerHTML = css;
	head.appendChild(style);
}

function embed(fn) {
	const script = document.createElement("script");
	script.text = `(${fn.toString()})();`;
	document.documentElement.appendChild(script);
}
