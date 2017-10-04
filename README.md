# Discovering WKWebView Example Code. 

This repo goes with a conference talk called "Discovering WKWebView" first given at MODS 2017 in Bangalore in October 2017.

## What the example does. 

This application loads an html page from its own bundle using a custom url-scheme `dr-bundle-file`. 
The page also contains an image that will get loaded through the custom scheme. 
The scheme is registered in the `ViewController` in `setUpSchemes(config: WKWebViewConfiguration)` (called from `viewDidLoad`)
and handled in `ViewController+WKURLSchemeHandler.swift` which implements `WKURLSchemeHandler`.

If the html page fires a Javascript alert the application will intercept this and use a native UIAlert instead. 
This can be seen in `ViewController+WKUIDelegate.swift`

If one of the links to wikipedia is clicked in the html page the application will re-route the page load to the default browser and leave the WKWebView as is. 
This can be seen in `ViewController+WKNavigationDelegate.swift`

In the the  `ViewController`, `loadScripts(config: WKWebViewConfiguration)` (called from `viewDidLoad`) sets up the `WKWebViewConfiguration` with the contents of two script files also in the bundle. 

`custom-css.js` changes the colors of entries in the HTML table. 

`filterTowns.js` filters then content of the html table based on a passed in parameter. 

This script also uses a webkit message to send messages to the application. 
These messages are received in `ViewController+WKScriptMessageHandler.swift`

When the user types in the applications search bar, the application calls the injected Javascript functions in the html page.
You can see this in `ViewController+UISearchBarDelegate.swift`.



