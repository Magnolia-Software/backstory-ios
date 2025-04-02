//
//  Page.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/31/25.
//

import SwiftUI

struct Breadcrumb {
    let title: String
    let action: () -> Void
}

struct BreadcrumbView: View {
    let breadcrumbs: [Breadcrumb]
    
    var body: some View {
        HStack {
            ForEach(0..<breadcrumbs.count, id: \.self) { index in
                Button(action: {
                    breadcrumbs[index].action()
                }) {
                    Text("< \(breadcrumbs[index].title)")
                        .foregroundColor(Stylesheet.Colors.action2)
                }
                .padding(.bottom, 5)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PageWrapperView<Content: View>: View {
    let title: String
    let breadcrumbs: [Breadcrumb]
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack {
            VStack {
                BreadcrumbView(breadcrumbs: breadcrumbs)
                HStack {
                    
                    Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        .font(Stylesheet.Fonts.heading3)
                        .foregroundColor(Stylesheet.Colors.heading2)
                    Text(title)
                        .font(Stylesheet.Fonts.heading3)
                        .foregroundColor(Stylesheet.Colors.heading2)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            
            VStack {
                content
            }
            Spacer()
        }
    }
}
