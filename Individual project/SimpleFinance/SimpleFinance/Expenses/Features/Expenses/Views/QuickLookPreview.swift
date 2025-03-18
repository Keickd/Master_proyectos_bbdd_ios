//
//  QuickLookPreview.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import QuickLook
import SwiftUI

struct QuickLookPreview: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context: Context) -> QLPreviewController {
    let controller = QLPreviewController()
    controller.dataSource = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(url: url)
  }

  class Coordinator: NSObject, QLPreviewControllerDataSource {
    let url: URL

    init(url: URL) {
      self.url = url
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
      return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
      return url as QLPreviewItem
    }
  }
}
