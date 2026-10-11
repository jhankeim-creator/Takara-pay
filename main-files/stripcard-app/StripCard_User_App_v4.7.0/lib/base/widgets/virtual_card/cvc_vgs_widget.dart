import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VgsCVCIntegrationWidget extends StatefulWidget {
  final String token, cardId, environment;

  const VgsCVCIntegrationWidget({
    Key? key,
    required this.token,
    required this.cardId,
    required this.environment,
  }) : super(key: key);

  @override
  _VgsCVCIntegrationWidgetState createState() =>
      _VgsCVCIntegrationWidgetState();
}

class _VgsCVCIntegrationWidgetState extends State<VgsCVCIntegrationWidget> {
  InAppWebViewController? webView;

  @override
  Widget build(BuildContext context) {
    String vgsScriptUrl = widget.environment == "sandbox"
        ? "https://js.verygoodvault.com/vgs-show/1.5/ACiWvWF9tYAez4BitGpSE68f.js"
        : "https://js.verygoodvault.com/vgs-show/1.5/ACcHSbXEBmKzyoAT5fzzyLTu.js";

    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialData: InAppWebViewInitialData(
              data: '''
<!DOCTYPE html>
              <html>
              <head>
                  <meta charset="utf-8">
                  <title>VGS Integration</title>
                  <style>
                      html {
                          font-size: 80px !important;
                      }
                      iframe {
                          height: 30px;
                          width: 500px;
                          font-size: 80px !important;
                          transform: scale(2.8);
                          padding-left: 260px;
                      }
                    
                  </style>
              </head>
              <body>
                  

                  <div id="cvv2"></div>

                  <script type="text/javascript" src=$vgsScriptUrl></script>
                  <script type="text/javascript">
                      const show = VGSShow.create('tntbuyt0v9u');
                      const cardToken = "${widget.token}";
                      const cardId = "${widget.cardId}";

                      const cvv2iframe = show.request({
                          name: 'cvv-text',
                          method: 'GET',
                          path: '/cards/' + cardId + '/secure-data/cvv2',
                          headers: {
                              "Authorization": "Bearer " + cardToken
                          },
                          htmlWrapper: 'text',
                          jsonPathSelector: 'data.cvv2'
                      });
                      cvv2iframe.render('#cvv2');

                      

                      const pinIframe = show.request({
                          name: 'pin-text',
                          method: 'GET',
                          path: '/cards/' + cardId + '/secure-data/defaultPin',
                          headers: {
                              "Authorization": "Bearer " + cardToken
                          },
                          htmlWrapper: 'text',
                          jsonPathSelector: 'data.defaultPin'
                      });
                      pinIframe.render('#pin');
                  </script>
              </body>
              </html>

''',
            ),
            onWebViewCreated: (controller) {
              webView = controller;
            },
            onLoadStop: (controller, url) {
              // Perform actions when the page finishes loading, if needed
              print("Page loaded: $url");
            },
          ),
        ],
      ),
    );
  }
}
