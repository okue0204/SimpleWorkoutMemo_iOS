//
//  MailView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/13.
//

import Foundation
import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    static let mailAddress = "okuehidetaka0204@gmail.com"
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = context.coordinator
        mailViewController.setToRecipients([Self.mailAddress])
        mailViewController.setSubject("お問い合わせ")
        mailViewController.setMessageBody("", isHTML: false)
        return mailViewController
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

extension MailView {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
