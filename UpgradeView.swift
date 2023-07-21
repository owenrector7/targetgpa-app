//
//  UpgradeView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/10/22.
//

import SwiftUI

struct UpgradeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appStoreManager: AppStoreManager
    @EnvironmentObject var settingsStore : SettingsStore
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    var body: some View {
        ScrollView{
       
        VStack{
            Text("placeholder logo")
                .padding(.top, 35)
            Text("Upgrade Now")
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .padding(.top, 30)
                .padding(.bottom, 20)
            Spacer()
                .frame(height: 15)
            VStack{
                Text("This one-time, lifetime")
                    .font(.system(size: 17))
                    .fontWeight(.light)
                Text("upgrade includes:")
                    .font(.system(size: 17))
                    .fontWeight(.light)
            }
            .padding(.bottom, 15)
            Spacer()
                .frame(height: 25)
            VStack(alignment: .leading){
                Text(" • Premium Feature 1")
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .offset(x: -12)
                Spacer()
                    .frame(height: 16)
                Text(" • Premium Feature 2")
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .offset(x: -12)
                Spacer()
                    .frame(height: 16)
                Text(" • Premium Feature 3")
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .offset(x: -12)
            }
            .frame(width: 350)
    
            Spacer()
                .frame(height: 26)
            Button {
                appStoreManager.purchaseProduct(product: appStoreManager.myProducts[0])
            } label: {
                Text("Introductory Price: $$$$")
                    .fontWeight(.bold)
                    .frame(width: 280, height: 5)
                    .padding(.vertical,25)
                    .foregroundColor(.black)
                    .background(Color.init(hex: 0xEBECF0))
                    .cornerRadius(10)
            }
            Spacer()
                .frame(height: 9)
            HStack{
                Button{
                    appStoreManager.restoreProducts()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.black)
                }
                Button{
                    appStoreManager.restoreProducts()
                } label: {
                    Text("Restore Purchase")
                        .foregroundColor(.black)
                }
            
            }
            
        
        }
    }
    }
}

