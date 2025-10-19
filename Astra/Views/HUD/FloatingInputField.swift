//
//  FloatingInputField.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct FloatingInputField: View {
    @ObservedObject var viewModel: InputFieldViewModel

    var body: some View {
        HStack(spacing: 12) {
            TextField("Capture a new idea…", text: $viewModel.text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3)

            Button {
                viewModel.submit()
            } label: {
                if viewModel.isSubmitting {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 16, y: 6)
    }
}
