//
//  BodyText.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/21/25.
//

import SwiftUI

struct BodyText: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(Stylesheet.Fonts.body)
            .foregroundColor(Stylesheet.Colors.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
    }
}

struct Heading2Text: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(Stylesheet.Fonts.heading2)
            .foregroundColor(Stylesheet.Colors.heading2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            .padding(.horizontal, 20)
    }
}

struct Heading3Text: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(Stylesheet.Fonts.heading3)
            .foregroundColor(Stylesheet.Colors.heading2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        
    }
}

struct Heading1NoTabsText: View {
    var text: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(Stylesheet.Colors.background)
            Text(text)
                .font(Stylesheet.Fonts.heading2)
                .foregroundColor(Stylesheet.Colors.background)
        }
        .padding()
        .padding(.top, 60)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Stylesheet.Colors.heading1)
    }
}

struct Heading1TabsText: View {
    var text: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(Stylesheet.Colors.background)
            Text(text)
                .font(Stylesheet.Fonts.heading2)
                .foregroundColor(Stylesheet.Colors.background)
        }
        .padding()
//        .padding(.top, 60)
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Stylesheet.Colors.heading1)
    }
}

struct ScrollView1<Content: View>: View {
    var content: () -> Content
    var height: CGFloat = 80
    
    var body: some View {
        ScrollView {
            VStack {
                content()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .background(Stylesheet.Colors.altBackground2)
        .foregroundColor(Stylesheet.Colors.body)
        .frame(height: height)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ScrollText: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(Stylesheet.Fonts.body)
            .foregroundColor(Stylesheet.Colors.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            //.padding(.bottom, 10)
            //.padding(.horizontal, 20)
    }
}
