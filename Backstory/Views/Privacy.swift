//
//  Privacy.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/14/25.
//

import SwiftUI
import os
import CoreLocation
import Speech

struct Privacy: View {
    @EnvironmentObject var router: Router
    @State private var isAccepted = false
    
    let logger = Logger(subsystem: "io.pyramidata.backstory", category: "networking")
    
    let userAgreement = """
    Lorem ipsum odor amet, consectetuer adipiscing elit. Finibus tortor egestas ante magnis massa rhoncus. Lobortis orci ultrices magna quis ut volutpat. Dui at dictumst maximus; orci aliquam nunc eleifend. Adipiscing ac turpis suspendisse posuere sapien congue? Parturient euismod erat at; ultrices dui nec. Sociosqu mollis nascetur justo potenti malesuada metus. Rutrum dictum urna montes risus mi ultricies dictumst. At lacus lacinia netus purus purus; mauris taciti.
    
    Morbi metus velit tempus blandit fermentum id parturient sodales. Maecenas nunc donec dapibus parturient turpis rhoncus magna torquent a. Metus ultricies imperdiet neque enim vehicula sed et libero. At faucibus eget feugiat condimentum hendrerit primis facilisi gravida. Interdum vel convallis aptent; proin ad nisl ut tempor. Congue laoreet eget amet mi quis sem. Ridiculus blandit accumsan dis libero id phasellus imperdiet. Felis taciti lobortis tempus cras euismod quisque.
    
    Nostra fringilla fringilla dis sapien mauris dis. Mollis aliquet vulputate euismod tortor habitasse. Scelerisque ad amet enim nisl faucibus lorem morbi. Velit est aliquam etiam semper turpis tortor felis maximus. Morbi finibus scelerisque proin eleifend cubilia. Pellentesque sit hendrerit ultrices primis cubilia massa nunc sagittis leo. Suscipit posuere augue porttitor sodales mauris lacus blandit.
    
    Lobortis penatibus tincidunt venenatis est class malesuada. Ipsum sapien commodo sollicitudin eleifend aptent vestibulum. Montes cursus maecenas mus phasellus odio magna mus ac. Vitae quisque aptent pharetra hendrerit mauris taciti quis senectus cras. Netus tincidunt ridiculus vehicula placerat mauris ullamcorper iaculis; inceptos lacinia. Eleifend lacus feugiat placerat per fermentum nec. Eros semper justo duis gravida est ut cras.
    
    Neque gravida semper quam purus consequat sapien. Varius nunc per augue magna dis. Nunc aenean penatibus ornare at convallis proin. Nibh gravida velit, sociosqu turpis laoreet habitant. Phasellus nisi habitasse non a; diam sed mi. In justo aptent cubilia ullamcorper litora finibus tincidunt viverra. Ullamcorper proin quis natoque fermentum per.
    
    Vel eros fusce luctus nec a finibus libero nec. Facilisis blandit tristique potenti nascetur turpis sodales varius eu mus. Dignissim amet pharetra commodo; quis sagittis porta. Imperdiet est egestas facilisis sed maximus donec iaculis. Imperdiet cursus cubilia varius donec habitant dignissim; potenti fringilla. Fusce massa faucibus orci id natoque habitasse finibus. Semper posuere tempor sapien purus ligula. Porta potenti ad facilisis tempus convallis velit hac purus. Per cursus at adipiscing, penatibus condimentum netus parturient. Vestibulum rutrum netus risus id nisi aptent.
    
    Eu ridiculus etiam platea etiam fringilla praesent tempus. Eget vulputate augue eros; est et feugiat. Augue mi primis platea, in cras mus finibus. Egestas ornare maecenas vel, a tempor justo. Elementum semper tempor eros purus sollicitudin velit euismod quam. Sagittis faucibus imperdiet conubia tristique euismod. Nullam ac volutpat augue vulputate iaculis sed. Nisi maximus quis aptent; vitae bibendum faucibus varius eget. Vestibulum risus penatibus risus nostra maecenas!
    
    Bibendum praesent risus nibh quis phasellus neque, suspendisse fringilla. Non pretium sagittis felis consequat vehicula facilisis. Velit sapien nisi varius ad bibendum scelerisque quisque ut. Maecenas faucibus congue adipiscing; orci neque lectus semper. Torquent lacus euismod, urna at taciti pulvinar. Donec quam sodales consequat aliquam cras consectetur malesuada.
    
    Adipiscing turpis quisque per, tincidunt suspendisse bibendum purus sem. Ante gravida habitant consectetur dapibus interdum curae cursus in. Dictum mus rutrum consequat euismod inceptos phasellus. Porta pharetra vehicula posuere dis ad imperdiet. Ex class nibh id ridiculus praesent quisque enim habitasse. Leo congue primis sit enim himenaeos.
    
    Montes facilisi at molestie lectus consectetur phasellus suspendisse. Fames ad primis quam neque parturient viverra tempor fermentum. Dis accumsan cubilia bibendum posuere non tempor nullam. Laoreet conubia integer iaculis semper in est class. Convallis laoreet bibendum sollicitudin ante fames tellus platea convallis. Taciti proin non risus ipsum nunc ut suspendisse felis. Amet et tincidunt ex erat congue senectus tempor venenatis. Auctor platea ex consequat facilisi accumsan. Hendrerit rhoncus class consequat praesent ultrices felis maecenas aenean nisl.
    """
    
    var body: some View {
        Heading1NoTabsText(text: "User Agreement", iconName: "checkmark.shield")
//        HStack {
//            Image(systemName: "checkmark.shield")
//                .font(.title)
//                .foregroundColor(Stylesheet.Colors.heading1)
//            Text("User Agreement")
//                .font(Stylesheet.Fonts.heading2)
//                .foregroundColor(Stylesheet.Colors.heading1)
//        }
//        .padding()
//        .padding(.top, 60)
//        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack {
            VStack {
//                VStack {
//                    Spacer()
                    
                    ScrollView1(content: {
                        ScrollText(text: userAgreement)
                    }, height: 500)
                    .scrollIndicators(.visible)
                    .padding(.top, 20)
                
                
                    
//                    ScrollView {
//                        Text(userAgreement)
//                            .padding()
//                            .font(Stylesheet.Fonts.body)
//                    }
//                    .background(Color.white)
//                    .frame(height: 500)
//                    .padding(.bottom, 20)
                    
                    BodyText(text: "You must accept the User Agreement to continue.")
//                        .font(Stylesheet.Fonts.body)
//                        .foregroundColor(Stylesheet.Colors.body)
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 20)
                        
                    
                    ActionButton(title: "ACCEPT AGREEMENT", action: {
                        isAccepted = true
                        SettingManager.shared.acceptUserAgreement()
                        
                        // get settings
                        let settings = SettingManager.shared.fetchSettings()
                        let setting = settings[0]
                        if !setting.is_safety_check_hidden {
                            router.navigate(to: .safety)
                        } else {
                            router.navigate(to: .diagnostic)
                        }
                    })
//                    {
//                        Text("Accept Agreement")
//                            .foregroundColor(Color.black)
//                            .padding()
//                            //.frame(maxWidth: .infinity)
//                            .background(Stylesheet.Colors.action)
//                            .cornerRadius(8)
//                            .fontWeight(.bold)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        }
        .background(Stylesheet.Colors.background)
        
        
//        ZStack {
//            //FullScreenBackground()
//            VStack {
//                Text("User Agreement")
//                    .font(Stylesheet.Fonts.heading2)
//                    .foregroundColor(Stylesheet.Colors.heading1)
//                    .padding()
//                ScrollView {
//                    Text(userAgreement)
//                        .padding()
//                        .font(Stylesheet.Fonts.body)
//                }
//                .background(Color.white)
//                .frame(height: 500)
//
////                Spacer()
//                Button(action: {
//                    isAccepted = true
//                    SettingManager.shared.acceptUserAgreement()
//
//                    // get settings
//                    let settings = SettingManager.shared.fetchSettings()
//                    let setting = settings[0]
//                    if !setting.is_safety_check_hidden {
//                        router.navigate(to: .safety)
//                    } else {
//                        router.navigate(to: .diagnostic)
//                    }
//
//
//                }) {
//                    Text("Accept Agreement")
//                        .foregroundColor(Color.black)
//                        .padding()
//                        //.frame(maxWidth: .infinity)
//                        .background(Stylesheet.Colors.action)
//                        .cornerRadius(8)
//                        .fontWeight(.bold)
//                }
//                .padding()
//            }
//            .padding()
//        }
    }
}
