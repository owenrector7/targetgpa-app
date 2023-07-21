//
//  SettingsView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/10/22.
//

import SwiftUI
import Amplitude

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appStoreManager : AppStoreManager

    @EnvironmentObject var settingsStore : SettingsStore
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    @State private var showingUpgradeSheet = false
    
	@State var startDate = Date()
    @State var initialTotalCredits: Double = 0.0
    @State var initialGPA: Double = 0.0
    @State var targetGPA: Double = 3.00
    
    @State var value: Int = 0
    
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    init() {
               let navBarAppearance = UINavigationBar.appearance()
               navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
               navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
             }
    


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Target GPA")) {

                    HStack{
                        Text("Target GPA:")
                        TextField("", value: $targetGPA, formatter: numberFormatter)
                                        //.font(Font.body.bold())
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.decimalPad)
                                        .frame(minWidth: 10, maxWidth: 48)
                        Spacer()
                        Stepper {
                            Text("")
                                } onIncrement: {
                                    incrementStepTarget()
                                } onDecrement: {
                                    decrementStepTarget()
                                }
                                        .labelsHidden()
                                        .multilineTextAlignment(.trailing)
                    }
					
					Text("Enter the GPA you are trying to achieve.")
						.font((.system(size: 12, weight: .light  )))

				
                }

//                Section(header: Text("Starting GPA Information")) {
//                    
//				
//                    HStack{
//                        Text("Starting GPA:")
//                        TextField("", value: $initialGPA, formatter: numberFormatter)
//                                        //.font(Font.body.bold())
//                                        .multilineTextAlignment(.leading)
//                                        .keyboardType(.decimalPad)
//                                        .frame(minWidth: 10, maxWidth: 48)
//                        Spacer()
//                        Stepper {
//                            Text("")
//                                } onIncrement: {
//                                    incrementStep()
//                                } onDecrement: {
//                                    decrementStep()
//                                }
//                                        .labelsHidden()
//                                        .multilineTextAlignment(.trailing)
//                    }
//					
//                    HStack{
//                        Text("Starting Credits:")
//                        TextField("", value: $initialTotalCredits, formatter: NumberFormatter())
//                                        //.font(Font.body.bold())
//                                        .multilineTextAlignment(.leading)
//                                        .keyboardType(.numberPad)
//                                        .frame(minWidth: 10, maxWidth: 48)
//                        Spacer()
//                                    Stepper("Value", value: $initialTotalCredits, in: 0...150)
//                                        .foregroundColor(.white)
//                                        .labelsHidden()
//                                        .multilineTextAlignment(.trailing)
//                    }
////                    HStack{
////                        Text("Starting Date:")
////                        DatePicker(selection: $startDate, displayedComponents: .date)
////                            {}
////                    }
//					
//					Text("To perform GPA Calculations based on your current academic situation, enter your GPA and the amount of credits taken to this point. If you prefer to manually enter past semesters, class grades, and credits, leave this area blank.")
//						.font((.system(size: 12, weight: .light  )))
//					
//
//					
//                }
                
                
                Section(header: Text("For support, feedback, hello:")) {
                    Button(action: {
                        UIPasteboard.general.string = settingsStore.supportEmail

                    }) {
                        Text(settingsStore.supportEmail)
                    }

                    if let linkURL = URL(string: settingsStore.featureRequestFormURL){

                        Link("Request a Feature", destination: linkURL)
                    }
                    
                    
                }
                
                if settingsStore.isPremium {
//                    Section(header: Text("Restore Purchase")) {
//                        Button(action: {
//                            appStoreManager.restoreProducts()
//                        }, label: {
//                            Text("Restore Purchase")
//                        })
//                        
//                        
//                    }
                } else {
                    Section(header: Text("Upgrade")) {
                        Button(action: {
                            showingUpgradeSheet.toggle()
                        }, label: {
                            Text("Upgrade Now")
                        })
                        
                        Button(action: {
                            appStoreManager.restoreProducts()
                        }, label: {
                            Text("Restore Purchase")
                        })
                        
                        
                    }
                }
                
                
				if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
					
					Section(header: Text("")){
						
						Text(appVersion)
					}

					
				}
                
            }
            .environment(\.colorScheme, .light)
            //.background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text("Settings"))
        }
        //.background(Color.white.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingUpgradeSheet) {
            //UpgradeView()
            UpsellView().environmentObject(self.settingsStore)
                .environmentObject(settingsStore)
        }
        
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        //settingsStore.initialTotalCredits = Double(initialTotalCredits) ?? 0.0
						//settingsStore.initialGPADate = startDate
						//settingsStore.initialGPA = Double(initialGPA) ?? 0.0
                        let aPlusVal = gradeStore.getGradeWith(name: "A+")?.value
                        
                       
                        if targetGPA > aPlusVal ?? 6 {
                            targetGPA = aPlusVal ?? 6
                            settingsStore.targetGPA = targetGPA
                        } else if targetGPA < 0 {
                            targetGPA = 0
                            settingsStore.targetGPA = targetGPA
                        }
                        
                        settingsStore.targetGPA = Double(targetGPA) ?? 3.0
						
						
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    })
                    .padding(.trailing, 22)
                    .padding(.top, 65)
                    Spacer()
                }
            }
        )
        .onAppear{
            //UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
            
            
			//startDate = settingsStore.initialGPADate
			initialGPA = settingsStore.initialGPA
			initialTotalCredits = settingsStore.initialTotalCredits
            targetGPA = settingsStore.targetGPA
        }
    }
    
    
    func incrementStep() {
            initialGPA += 0.01
            
        }
    
    func decrementStep() {
        if initialGPA <= 0 {
            initialGPA = 0
            settingsStore.initialGPA = Double(initialGPA) ?? 0.0
        } else {
            initialGPA -= 0.01
        }
    }
    
    func incrementStepTarget() {
        let aPlusVal = gradeStore.getGradeWith(name: "A+")?.value
        
        if (targetGPA >= aPlusVal ?? 6) {
            targetGPA = aPlusVal ?? 6
            settingsStore.targetGPA = Double(targetGPA) ?? 3.0
        } else if targetGPA < 0{
            targetGPA = 0
            settingsStore.targetGPA = Double(targetGPA) ?? 3.0
        } else {
            targetGPA += 0.01

        }
            
        }
    
    func decrementStepTarget() {
        let aPlusVal = gradeStore.getGradeWith(name: "A+")?.value
        
        if targetGPA <= 0 {
            targetGPA = 0
            settingsStore.targetGPA = Double(targetGPA) ?? 3.0
        } else if targetGPA > aPlusVal ?? 6 {
            targetGPA = aPlusVal ?? 6
            settingsStore.targetGPA = Double(targetGPA) ?? 3.0
        } else {
            targetGPA -= 0.01
        }
    }
        
}
