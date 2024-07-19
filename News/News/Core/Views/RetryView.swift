//
//  RetryView.swift
//  News
//
//  Created by Alina Vlasenko on 20.06.2024.
//

import SwiftUI

struct RetryView: View {
    
    let text: String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: Constant.retryMainVStackSpacing) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text(Constant.retryBtnText)
            }
        }
    }
}

#Preview {
    RetryView(text: Constant.generalError) {}
}
