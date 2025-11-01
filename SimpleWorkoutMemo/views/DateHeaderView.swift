//
//  DateHeaderView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/05.
//

import SwiftUI

struct DateHeaderView: View {
    
    @Binding var selectedDate: Date?
    
    var body: some View {
        HStack {
            Text(DateFormatter.dateToString(selectedDate ?? Date()))
                .font(.regular(size: 18))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    DateHeaderView(selectedDate: $selectedDate)
}
