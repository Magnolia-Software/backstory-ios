import SwiftUI

enum ExploreRoute {
    case menu
    case flashbacks
    case triggers
}

struct MenuItemView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(Stylesheet.Fonts.body)
                .foregroundColor(Stylesheet.Colors.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
        }
    }
}

struct SubMenuView: View {
    var title: String
    
    var body: some View {
        List {
            ForEach(1..<6) { index in
                Text("\(title) Submenu Item \(index)")
                    .padding(10)
            }
        }
        .background(Stylesheet.Colors.altBackground2)
        .listStyle(.inset)
        .padding(.top, -5)
        .navigationTitle(title)
    }
}


struct Explore: View {
    @State private var showNav: Bool = false
    @State private var currentRoute: ExploreRoute = .menu
    
    private var data  = Array(1...20)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    private let menuItems: [[String: Any]] = [
        ["title": "Flashbacks", "route": ExploreRoute.flashbacks, "icon": "clock.arrow.trianglehead.counterclockwise.rotate.90"],
        ["title": "Triggers", "route": ExploreRoute.triggers, "icon": "bolt"]
    ]
    
    var body: some View {
        VStack {
            // Heading
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(Stylesheet.Colors.background)
                Text("Explore")
                    .font(Stylesheet.Fonts.heading2)
                    .foregroundColor(Stylesheet.Colors.background)
                Spacer()
                Button(action: {
                    toggleMenu()
                }) {
                    if showNav {
                        Image(systemName: "chevron.up")
                            .foregroundColor(Stylesheet.Colors.background)
                    } else {
                        Image(systemName: "chevron.down")
                            .foregroundColor(Stylesheet.Colors.background)
                    }
                }
                .padding(.trailing, 10)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Stylesheet.Colors.heading1)
            

            ZStack {
                switch currentRoute {
                case .flashbacks:
                    FlashbacksView()
                case .triggers:
                    TriggersView()
                case .menu:
                    ScrollView {
                        Heading3Text(text: "Text-Based Journaling Tools")
                        BodyText(text: "Text-based journaling happens here.  You can create and manage your trauma-related items manually.  Click on the items below to get started.")
                        LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                            
                            ForEach(menuItems.indices, id: \.self) { index in
                                let item = menuItems[index]
                                let title = item["title"] as? String ?? "Unknown"
                                let icon = item["icon"] as? String ?? "questionmark"
                                let route = item["route"] as? ExploreRoute ?? .menu
                                
                                Button(action: {
                                    currentRoute = route
                                }) {
                                    VStack {
                                        Spacer()
                                        Image(systemName: icon)
                                            .resizable()
                                            .foregroundColor(Color.black)
                                            .scaledToFit()
                                            .frame(width: 65, height: 65)
                                            .padding(.bottom, 10)
                                        Text(title)
                                            .font(Stylesheet.Fonts.heading3)
                                            .foregroundColor(Stylesheet.Colors.heading2)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 10)
                                    }
                                    .frame(width: 155)
                                    .padding(10)
                                    .background(Stylesheet.Colors.altBackground2)
                                    .cornerRadius(20)
                                }
                                
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
                
                if showNav {
                    NavigationStack {
                        List {
                            Button(action: {
                                currentRoute = .menu
                                showNav = false
                            }) {
                                MenuItemView(title: "Explore Home")
                            }
                            
                            Button(action: {
                                currentRoute = .flashbacks
                                showNav = false
                            }) {
                                MenuItemView(title: "Flashbacks")
                            }
                            
                            Button(action: {
                                currentRoute = .flashbacks
                                showNav = false
                            }) {
                                MenuItemView(title: "Triggers")
                            }
                        }
                        .listStyle(.inset)
                        .padding(.top, -5)
                        Spacer()
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut, value: showNav)
                    .background(Color.red)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
    
    private func toggleMenu() {
        withAnimation {
            showNav.toggle()
        }
    }
}

struct Explore_Previews: PreviewProvider {
    static var previews: some View {
        Explore()
    }
}
