import SwiftUI
import WebKit

struct BrowserViews: UIViewRepresentable {
    let pageURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: pageURL))
    }
}

struct RulesView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Game1Rules()
            }
//            .overlay(
//                ZStack {
//                    Image("close")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30)
//                        .position(x: geometry.size.width / 9, y: geometry.size.height / 9)
//                        .onTapGesture {
//                            NavGuard.shared.currentScreen = .MENU
//                        }
//                }
//            )
        }
    }
}

#Preview {
    RulesView()
}
