//
//  Settings.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/14/25.
//

import SwiftUI

struct Settings: View {
    
    @State private var isChecked: Bool = !SettingManager.shared.fetchSafetyCheckSetting()
    
    var body: some View {
        Heading1TabsText(text: "Settings", iconName: "gear")
        
        VStack {
            VStack {
                VStack {
                    Form {
                        Section(header: Text("SAFETY")) {
                            Toggle("Show Safety Screen on Startup", isOn: $isChecked)
                        }
                    }
                    .onChange(of: isChecked) { newValue in
                        if newValue {
                            SettingManager.shared.showSafetyCheck()
                        } else {
                            SettingManager.shared.hideSafetyCheck()
                        }
                    }
                    .padding(.top, -8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }

    }
}
    
