//
//  OverlaySheetView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

enum OverlayHeight {
    case top
    case middle
}

fileprivate struct OverlaySheetUX {
    static let cornerRadius: CGFloat = 24
    static let shadowRadius: CGFloat = 14
    static let shadowOpacity: CGFloat = 0.1
    static let topPadding: CGFloat = 20
}

struct OverlaySheetView<Content: View>: View {
    let content: Content
    
    @State var position: OverlayHeight = .middle
    @State var viewHeight: CGFloat = 0
    @State var dragOffset: CGFloat = 0
    
    var spacerHeight: CGFloat {
        var height: CGFloat = 0
        
        switch position {
        case .top:
            height = OverlaySheetUX.topPadding
        case .middle:
            height = viewHeight / 2
        }
        
        return max(height + dragOffset, OverlaySheetUX.topPadding)
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: spacerHeight)
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: OverlaySheetUX.cornerRadius)
                    .foregroundColor(Color(uiColor: UIColor.systemGroupedBackground))
                    .ignoresSafeArea()
                    .shadow(
                        color: .black.opacity(OverlaySheetUX.shadowOpacity),
                        radius: OverlaySheetUX.shadowRadius,
                        x: 0, y: -OverlaySheetUX.shadowRadius)
                
                VStack {
                    Capsule()
                        .frame(width: 28, height: 6)
                        .foregroundColor(.secondary)
                    
                    content
                }.padding()
            }.highPriorityGesture(
                DragGesture()
                    .onChanged { value in
                        self.dragOffset += value.translation.height
                    }.onEnded { value in
                        if spacerHeight < viewHeight / 3 {
                            position = .top
                        } else {
                            position = .middle
                        }
                        
                        self.dragOffset = 0
                    }
                )
        }.background(
            GeometryReader { geom in
                Color.clear.useEffect(deps: geom.size) { _ in
                    viewHeight = geom.size.height
                }
            }
        )
    }
    
    init(content: () -> Content) {
        self.content = content()
    }
}

struct OverlaySheetView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            OverlaySheetView() {
                Text("Blank")
            }
        }
    }
}
