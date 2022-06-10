//
//  PrefsView.swift
//  CCLComms
//
//  Created by Felipe on 5/28/22.
//

import SwiftUI

struct PrefsView: View {
    @State private var isLoading = true
    
    var body: some View {
        Text("Test 123 abc def")
            .font(.title)
            .padding(35)
            .background(
                LinearGradient(
                    colors: [.orange, .red],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(starOverlay, alignment: .topTrailing)
            .overlay(loadingOverlay)
            .foregroundColor(.white)
            .cornerRadius(20)
    }

    private var starOverlay: some View {
        Image(systemName: "star")
            .padding([.top, .trailing], 5)
    }

    @ViewBuilder private var loadingOverlay: some View {
        if isLoading {
            ProgressView()
        }
    }
}

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView()
    }
}
