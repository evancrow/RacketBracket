//
//  ProgressBar.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

fileprivate struct ProgressBarUX {
    static let backgroundOpacity: CGFloat = 0.3
    static let height: CGFloat = 24
}

struct ProgressBar: View {
    var progress: Double
    var showOpposingProgress = false
    
    var body: some View {
        GeometryReader { geom in
            ZStack() {
                Rectangle()
                    .foregroundColor(.blue.opacity(ProgressBarUX.backgroundOpacity))
                
                HStack {
                    Rectangle()
                        .frame(width: geom.size.width * CGFloat(progress), height: ProgressBarUX.height)
                        .foregroundColor(.mint)
                    
                    Spacer()
                        .frame(minWidth: 0)
                }
                
                if showOpposingProgress {
                    HStack {
                        Spacer()
                            .frame(minWidth: 0)
                        
                        Rectangle()
                            .frame(width: geom.size.width * CGFloat(1-progress), height: ProgressBarUX.height)
                            .foregroundColor(.red)
                    }
                }
            }.clipShape(RoundedRectangle(cornerRadius: ProgressBarUX.height/2))
        }.frame(height: ProgressBarUX.height)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProgressBar(progress: 0.5)
            ProgressBar(progress: 0.3, showOpposingProgress: true)
            ProgressBar(progress: 1, showOpposingProgress: true)
        }.padding()
    }
}
