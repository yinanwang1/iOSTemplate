function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

function setUpYNJSBridge(callback) {
    window.YNJSBridge = {
        pushViewWithUrlAndTitle : function pushViewWithUrlAndTitle(url, title, callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('pushViewWithUrlAndTitle', {'url': url, 'title':title}, callback);
            }
        },
        
        setNavigationButton : function setNavigationButton(button) {
            if(window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('setNavigationButton', button,
                                                    function(response) {
                                                    })
            }
        },
        
        closeCurrentView : function closeCurrentView(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('closeCurrentView', {}, callback);
            }
        },
        
        getPlatformInfo: function getPlatformInfo(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('getPlatformInfo', {}, callback);
            }
        },
        
        setTabBarHidden: function setTabBarHidden(param, callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('setTabBarHidden', param, callback);
            }
        },
        
        setNavigationBarHidden: function setNavigationBarHidden(param, callback) {
           if (window.WebViewJavascriptBridge) {
               WebViewJavascriptBridge.callHandler('setNavigationBarHidden', param, callback);
           }
        },
        
        setNavigationBarBackButtonHidden: function setNavigationBarBackButtonHidden(param, callback) {
          if (window.WebViewJavascriptBridge) {
              WebViewJavascriptBridge.callHandler('setNavigationBarBackButtonHidden', param, callback);
          }
        },
        
        setNavigationBarTitle: function setNavigationBarTitle(param, callback) {
          if (window.WebViewJavascriptBridge) {
              WebViewJavascriptBridge.callHandler('setNavigationBarTitle', param, callback);
          }
        },
        
        setLogin: function setLogin(param, callback) {
          if (window.WebViewJavascriptBridge) {
              WebViewJavascriptBridge.callHandler('setLogin', param, callback);
          }
        },
        
        setLogout: function setLogout(callback) {
          if (window.WebViewJavascriptBridge) {
              WebViewJavascriptBridge.callHandler('setLogout', {}, callback);
          }
        },
        
        isLogin: function isLogin(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('isLogin', {}, callback);
            }
        },
    };
    
    callback(YNJSBridge);
}

setupWebViewJavascriptBridge(function(bridge) {})

setUpYNJSBridge(function(jsbridge){})
