//
//  ToastView.swift
//  MeallApp
//
//  Created by Marcus Titton on 06/07/25.
//

import SwiftUI

struct ToastView: View {
    var message: String
    var isError: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isError ? "xmark.octagon.fill" : "checkmark.seal.fill")
                .foregroundColor(.white)
                .imageScale(.large)

            Text(message)
                .foregroundColor(.white)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(isError ? Color.red.opacity(0.95) : Color.green.opacity(0.95))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 30)
    }
}
