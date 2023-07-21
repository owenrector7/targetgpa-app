//
//  ContentView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/1/22.
//
import SwiftUI
import RealmSwift
import StoreKit
import AVFoundation
import ToastUI
import Amplitude




struct MainView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State var showInfoModalView: Bool = false
    
    @EnvironmentObject var settingsStore : SettingsStore
	@EnvironmentObject var gpaClassStore: GPAClassStore
	@EnvironmentObject var semesterStore : SemesterStore
	@EnvironmentObject var gradeStore : GradeStore
	@EnvironmentObject var calculationManager : CalculationManager
    @EnvironmentObject var assignmentStore : AssignmentStore

    

    @State var showPastInfo : Bool = true
    @State var showUpdate: Bool = false
    @State var showPopup: Bool = false
    @State var showTarget: Bool = false
    
    @State var sampleDataExists: Bool = true


    @State var gpaNeeded: Double
    @State var gpaTarget: Double
    @State var gpaNow: Double
    @State var activeSheet: Sheet? = nil
    
    @State var initialTotalCredits: Double = 0.0
    @State var initialGPA: Double = 0.0
    @State var targetGPA: Double = 0.0
    
    
    var gpaFinal: Double
    
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    var body: some View {
        
        NavigationView{
            VStack {
                let currentSemesters = semesterStore.allSemesters.filter{ $0.endDate >= Date() }
                
                let pastSemesters = semesterStore.allSemesters.filter{ $0.endDate < Date() }
                
                let mostRecentSemester = semesterStore.allSemesters.last
                
				
				//let semesterGPANeeded = 3.75
                HStack(alignment: .center)  {

					
					VStack(alignment: .leading){
//						Text("Cumulative")
//							.italic()
//							.font(.system(size: 14))
//							.fontWeight(.regular)
//							.foregroundColor(Color.init(hex: 0x575757))
						Text("OVERALL GPA")
							.font(.system(size: 16, weight: .heavy))
							.tracking(2)
							.foregroundColor(.black)
						Text("\(calculationManager.getCumulativeGPA(semesters: pastSemesters+currentSemesters).isNaN ? 0 : calculationManager.getCumulativeGPA(semesters: pastSemesters+currentSemesters), specifier: "%.2f")")
							.font(.system(size: getMainGPAfontSize(), weight: .heavy))
							.foregroundColor(.black)
					}
                    .frame(minWidth :UIScreen.screenWidth / 3 )
					.padding(.leading, 30)

					Spacer()
					
                    if currentSemesters.count > 0 {
                        
                        let mainCurrentSemester = currentSemesters[0]
                        let semesterGPANeeded = calculationManager.calculateNeededGPA(SemesterId: mainCurrentSemester.id, pastSem: pastSemesters, currentSem: currentSemesters, gpaTarget: settingsStore.targetGPA).isNaN ? 0 : calculationManager.calculateNeededGPA(SemesterId: mainCurrentSemester.id, pastSem: pastSemesters, currentSem: currentSemesters, gpaTarget: settingsStore.targetGPA)
                        VStack(alignment: .leading) {
                            
                            NavigationLink(destination: SemesterDetail(currentSemester: mainCurrentSemester, gpaNeeded: semesterGPANeeded, gpaTarget: gpaTarget, gpaNow: gpaNow, pastSemesters: pastSemesters, currentSemesters: currentSemesters)){
                            
                
                            HStack{
                                
                                Text(mainCurrentSemester.name)
                                    .font(.system(size: 9))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.black)
                                    .lineLimit(2)
									.multilineTextAlignment(.leading)

                            }
                            .padding(.leading,8)
                            .padding(.trailing,8)
                            .padding(.vertical,3)
                            .background(mainCurrentSemester.color.lightColor())
                            .cornerRadius(4)
                            }
                            
                            Text("GPA NEEDED")
                                .font(.system(size: 13, weight: .heavy))
                                .tracking(2)
                                .foregroundColor(.black)
                            Text("\(semesterGPANeeded, specifier: "%.2f")")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundColor(.black)
                            Line()
                                .stroke(style: StrokeStyle(lineWidth: 0.25, dash: [2]))
                                .foregroundColor(.black)
                                .frame(height: 1)
                            
                            let localTarget = String(format: "%.2f", settingsStore.targetGPA)
                            
                            let targetText = "TARGET GPA : " + localTarget
                            Text(targetText)
                                .tracking(0.5)
                                .font(.system(size: 10))
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                                .onTapGesture{
                                    targetGPA = settingsStore.targetGPA
                                    showTarget = true
                                    
                                }
                        }
                        .onTapGesture{
                            showTarget = true
                            
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.init(hex: 0xE6E6E6), lineWidth: 1)
                        )
                        .frame(minWidth :UIScreen.screenWidth / 2.3 )
                        .padding(.leading, 30)
                        .padding(.trailing, 15)
                        
                        Spacer()
                    }

                }
				.padding(.top,45)
				.padding(.bottom,15)
                
//                Button("Final Grade Calculator"){
//
//                action: do {openFinalCalculatorView()}
//
//
//                }.font((.system(size: 16,
//                                weight: .semibold)))
//                    .padding(.vertical, 18)
//                    .frame(maxWidth: 210, maxHeight: 45)
//                    .padding(.horizontal,20)
//                    .background(Color.init(hex: 0xEBECF0))
//                    .cornerRadius(14)
//                    .foregroundColor(.black)

        
                Line()
					.stroke(style: StrokeStyle(lineWidth: 0.25, dash: [2]))
					.frame(height: 1)
                    .foregroundColor(.black)

					.padding(.vertical, 7)
					.padding(.horizontal,25)

                
                ScrollView {
                    
                    if currentSemesters.count > 0 {
                    
                    HStack{
                        Text("CURRENT TERM")
                            .font(.system(size: 11))
                            .tracking(1.5)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.leading, 25)
                              
//                        if sampleDataExists{
//                        
//                        HStack{
//                            
//                            Button {
////
//                            }label: {
//                                     Text("Delete Sample Data")
//                                        .font(.system(size: 9))
//                                        .fontWeight(.heavy)
//                                        .foregroundColor(.white)
//                                        .lineLimit(2)
//                                        .multilineTextAlignment(.leading)
//
//                            }
//
//                           
//                        }
//                        .padding(.leading,8)
//                        .padding(.trailing,8)
//                        .padding(.vertical,3)
//                        .background(.black)
//                        .cornerRadius(4)
//                        
//                    }
                        
                    }
					.padding(.top, 10)
                    .padding(.trailing, 25)
                        
                    }

					
                    VStack (spacing: 7){
                        
                        ForEach(currentSemesters){ aSemester in
                                
                                if aSemester.endDate > Date() {
                                    let semesterGPANeededTwo = calculationManager.calculateNeededGPA(SemesterId: aSemester.id, pastSem: pastSemesters, currentSem: currentSemesters, gpaTarget: settingsStore.targetGPA)
                                    NavigationLink(destination: SemesterDetail(currentSemester: aSemester, gpaNeeded: semesterGPANeededTwo, gpaTarget: gpaTarget, gpaNow: gpaNow, pastSemesters: pastSemesters, currentSemesters: currentSemesters)) {
                                        
                                        let gpaNeededLocal = calculationManager.calculateNeededGPA(SemesterId: aSemester.id, pastSem: pastSemesters, currentSem: currentSemesters, gpaTarget: gpaTarget)
                                        
                                        let currentSemGPA = calculationManager.calculateGPAFor(semesterID: aSemester.id)
                                        
                                        SemesterCardView(currentSemester: aSemester, gpaNeededLocal: gpaNeededLocal, gpaNow: currentSemGPA, gpaTarget: $gpaTarget)
                                        
                                    }
                                }
						}
                        
                        
                        if currentSemesters.count > 0 && pastSemesters.count > 0 {
                            
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 0.25, dash: [2]))
                            .frame(height: 1)
                            .foregroundColor(.black)

                            .padding(.vertical, 10)
                            .padding(.horizontal,25)
                            
                        }
                        
                        if pastSemesters.count > 0 {

                        HStack{
                            Text("PAST TERMS")
                                .font(.system(size: 11))
                                .tracking(1.5)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, 25)

                            Text("GPA: \(calculationManager.getCumulativeGPA(semesters: pastSemesters), specifier: "%.2f")")
                                .font(.system(size: 12))
                                .fontWeight(.heavy)
                                .padding(.trailing, 30)
                        }
						.padding(.top, 10)
                        }

						ForEach(pastSemesters){ aSemester in
							
							NavigationLink(destination: SemesterDetail(currentSemester: aSemester, gpaNeeded: gpaNeeded, gpaTarget: gpaTarget, gpaNow: gpaNow, pastSemesters: pastSemesters, currentSemesters: currentSemesters)) {
								
								if aSemester.endDate < Date() {
									NavigationLink(destination: PastSemesterDetail(currentSemester: aSemester, gpaNeeded: gpaNeeded, gpaTarget: gpaTarget, gpaNow: gpaNow, pastSemesters: pastSemesters, currentSemesters: currentSemesters)) {
                                        
                                        let pastSemGPA = calculationManager.calculateGPAFor(semesterID: aSemester.id)
                                        
                                        let gpaNeededLocal = calculationManager.calculateNeededGPA(SemesterId: aSemester.id, pastSem: pastSemesters, currentSem: currentSemesters, gpaTarget: gpaTarget)
                                        
                                        let currentSemGPA = calculationManager.calculateGPAFor(semesterID: aSemester.id)
                                        
                                        SemesterCardView(currentSemester: aSemester, gpaNeededLocal: gpaNeededLocal, gpaNow: pastSemGPA, gpaTarget: $gpaTarget)
									}
								}
							}
						}
                        
                        
                        
//                        HStack{
//
//                            if let mostRecentSemester = mostRecentSemester {
//                                Text("BEFORE " + mostRecentSemester.name.uppercased())
//                                    .font(.system(size: 11))
//                                    .tracking(1.5)
//                                    .fontWeight(.heavy)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .foregroundColor(.black)
//                                    .padding(.leading, 25)
//                                    .padding(.top, 10)
//                            }
//
//
//                            Button {
//
//                            }label: {
//                                Image(systemName: "questionmark.circle.fill")
//                                    .foregroundColor(.black)
//                            }
//                            Spacer()
//                                .frame(width: 10)
//                            Button {
//                                self.showPastInfo.toggle()
//                            }label: {
//                                Image(systemName: self.showPastInfo == true ? "chevron.down" : "chevron.right")
//                                    .foregroundColor(.black)
//                                    .padding(.trailing, 25)
//                            }
//                        }
//                        Spacer()
//                            .frame(height: 7)
//
//                        //if showPastInfo {
//                            VStack(alignment: .leading){
//                            HStack{
//                                Text("CUMULATIVE GPA ")
//                                    .font(.system(size: 8))
//                                    .frame(maxWidth: 100, alignment: .leading)
//                                    .foregroundColor(.black)
//                                    .padding(.leading, 25)
//
//
//                                Text("TOTAL CREDITS")
//                                    .font(.system(size: 8))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .foregroundColor(.black)
//                                    .padding(.leading, 15)
//                                Spacer()
//                            }
//
//                            Spacer()
//                                .frame(height: 8)
//
//                            HStack{
//                                TextField(settingsStore.initialGPA.description, value: $initialGPA, formatter: numberFormatter)
//                                .padding(.all)
//                                    .frame(width: 80, height: 40)
//                                    .background(Color.init(hex: 0xEBECF0))
//                                    .cornerRadius(10)
//                                    .padding(.bottom,10)
//                                    .padding(.leading, 25)
//									.keyboardType(.decimalPad)
//                                    .onTapGesture{showUpdate = true}
//
//
//
//                                TextField(settingsStore.initialTotalCredits.description, value: $initialTotalCredits, formatter: numberFormatter)
//                                    .padding(.all)
//                                    .frame(width: 90, height: 40)
//                                    .background(Color.init(hex: 0xEBECF0))
//                                    .cornerRadius(10)
//                                    .padding(.bottom,10)
//                                    .padding(.leading, 35)
//									.keyboardType(.decimalPad)
//                                    .onTapGesture{showUpdate = true}
//
//
//
////
////								if settingsStore.initialGPA != initialGPA || settingsStore.initialTotalCredits != initialTotalCredits {
////									showUpdate = true
////                                }
////
//                                if showUpdate{
//
//									Button {
//										settingsStore.initialGPA = initialGPA
//										settingsStore.initialTotalCredits = initialTotalCredits
//									}label: {
//										Text("Update")
//											.font((.system(size: 10, weight: .bold  )))
//											.frame(width: 60, height: 30)
//											.foregroundColor(.white)
//											.background(.black)
//											.cornerRadius(10)
//											.padding(.bottom,10)
//											.padding(.leading, 10)
//									}
//                                    Spacer()
//                                }
//
//                            }
//
//
//								Spacer()
//                                .frame(height: 8)
//
//                                if let mostRecentSemester = mostRecentSemester {
//                                    let helpText = "To include past semesters in your target gpa calculations, enter your cumulative GPA and total credits taken towards your GPA up until " + mostRecentSemester.name + "."
//                                    Text(helpText)
//                                    .font(.system(size: 13))
//                                    .frame(maxWidth: 330, alignment: .leading)
//                                    .foregroundColor(.black)
//                                    .padding(.leading, 25)
//                                }
//
//                                //let helpText = "To include past semesters in your target gpa calculations, enter your cumulative GPA and total credits taken towards your GPA up until "
//
//
//
//
//
//
//
//                            }
//                            .opacity(showPastInfo ? 1 : 0)
//                            .disabled(showPastInfo ? false : true)
                        //}
                        
                        
					}
                }
                
			}
            
             
            
            .overlay(
                VStack(alignment:.leading) {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        
                                            if (semesterStore.allSemesters.count == 0) {
                                                activeSheet = .addSemester
                                            } else if settingsStore.isPremium {
                                                activeSheet = .addSemester
                                            } else {
                                                openUpgrade()
                                            }


                                        })
                                        {
                                            HStack{
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundStyle(.white, .black)
                                                .font(.system(size: 45))
                                            }
                                            .padding(.horizontal, 28)
                                            .padding(.bottom, 20)
                                            //.padding(.horizontal, 20)
                                            .mask(Circle())
											.shadow(color: Color.black.opacity(0.25),radius: 3,
													x:3, y:3)

                                        }
                                }
                            }
            )
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
					Spacer()
					Image("SplashIcon")
						.resizable()
						.aspectRatio( contentMode: .fit)
						.frame(width: 30, alignment: .center)
						.offset(x:5)
                        .onTapGesture(count: 5) {
                            
                            for each in semesterStore.allSemesters {
                                semesterStore.delete(entryID: each.id)
                            }
                            
                            if let TestSem1 = semesterStore.create(name: "Fall 2022", totalCredits: 0, finalGPA: 0, startDate: Date(), endDate: getPastDate(Date(), numDays: 163), color: ColorOptionsEnum.Bluegray, includeInCumulativeGPA: true) {
                                
                                if let aPlus = gradeStore.getGradeWith(name: "A"){
            
                                    _ = gpaClassStore.create(name: "CS 2110",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem1.id)
                                    _ = gpaClassStore.create(name: "SPAN 2090",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem1.id)
                                    
                                    _ = gpaClassStore.create(name: "MATH 1920",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem1.id)
                                    
                                    _ = gpaClassStore.create(name: "CHEM 2090",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem1.id)
                                }
                                
                            }
                            
                            if let TestSem2 = semesterStore.create(name: "Spring 2022", totalCredits: 0, finalGPA: 0, startDate: Date(), endDate: getPastDate(Date(), numDays: -80), color: ColorOptionsEnum.Grape, includeInCumulativeGPA: true) {
                                
                                if let aPlus = gradeStore.getGradeWith(name: "A"){
            
                                    _ = gpaClassStore.create(name: "CS 1110",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem2.id)
                                    _ = gpaClassStore.create(name: "SPAN 2090",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem2.id)
                                    
                                    _ = gpaClassStore.create(name: "MATH 1920",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem2.id)
                                    
                                    _ = gpaClassStore.create(name: "CHEM 2090",
                                                         includeInSemesterGPA: true,
                                                         gradeID: aPlus.id,
                                                         weight: 4,
                                                         semesterID: TestSem2.id)
                                }
                            }
                                
                            
//                            self.viewRouter.currentPage = "homeView"
//                            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
                            }
					
                    Text("TARGET GPA")
                        .foregroundColor(.black)
						.font(.system(size: 17 , weight: .heavy))
						.tracking(2)
						.offset(x:5)
						
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Spacer()
                    
                                    
                    Menu{
                        Button(action: {
                            openSettingsView()
                        })
                        {
                            Label("Settings", systemImage: "gear")
                                .font(.body)
                                .foregroundColor(.black)
                        }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 2))
                        
                        Button(action: {
                            openEditGrades()
                        })
                        {
                            Label("Edit Grade Scale", systemImage: "pencil")
                                .font(.body)
                                .foregroundColor(.black)
                        }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 2))
                        
                        Button(action: {
                            showTarget = true
                        })
                        {
                            Label("Adjust Target GPA", systemImage: "target")
                                .font(.body)
                                .foregroundColor(.black)
                        }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 2))
                        
						if !settingsStore.isPremium {
							
							Button(action: {
								openUpgrade()
							})
							{
								Label("Upgrade Now", systemImage: "checkmark.rectangle")
									.font(.body)
									.foregroundColor(.black)
							}.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 8))
		
						}
                        Button(action: {
							Amplitude.instance().logEvent("Share App")
//
//							// User Analytics
//							if let identify = AMPIdentify()
//								.add("Shared",value: NSNumber(value: 1)) {
//								Amplitude.instance().identify(identify)
//							}
							
							let textToShare = "Track your classes, grades, and GPA with Target GPA."
							guard let data = URL(string: settingsStore.appURL) else { return }
							let objectsToShare = [textToShare, data] as [Any]
							
							let av = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
							UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                        })
                        {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(.body)
                                .foregroundColor(.black)
                        }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 8))
                        
                        Button(action: {
                            openFinalCalculatorView()
                        })
                        {
                            Label("Exam Impact Calculator", systemImage: "plusminus.circle")
                                .font(.body)
                                .foregroundColor(.black)
                        }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 2))
                        
                        
                        
                    } label: {
                        Label("", systemImage: "ellipsis.circle")
                            .font((.system(size: 17, weight: .regular)))
                    }.pickerStyle(.menu)
                        .foregroundColor(.black)
                    
                    Spacer()
                        .frame(width: 0)
                    
                    Button(action: {
                        initialGPA = settingsStore.initialGPA
                        initialTotalCredits = settingsStore.initialTotalCredits
                        showPopup = true
						Amplitude.instance().logEvent("Show Prior Data Popup")

                    })
                    {
                        if settingsStore.initialGPA == 0 {
                        Label("Test", systemImage: "123.rectangle")
                                                        .font((.system(size: 17, weight: .regular)))
                        
                                                        .foregroundColor(Color.black)
                        } else {
                            Label("Test", systemImage: "123.rectangle.fill")
                                                            .font((.system(size: 17, weight: .bold)))
                            
                                                            .foregroundColor(Color.black)
                        }
                    }
                    
//                    Spacer()
//                        .frame(width: 0)
//
//                    Button(action: {
//
//                    //    if (semesterStore.allSemesters.count == 0) {
//						if (semesterStore.allSemesters.count < 10) {
//                            activeSheet = .addSemester
//                        } else if settingsStore.isPremium {
//                            activeSheet = .addSemester
//                        } else {
//                            openUpgrade()
//                        }
//
//
//                    })
//                    {
//                        Label("Test", systemImage: "plus")
//                                                        .font((.system(size: 17, weight: .bold)))
//
//                                                        .foregroundColor(Color.black)
//                    }
                    
                }
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))

        }
        .navigationViewStyle(.stack)

        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        
        .toast(isPresented: $showPopup) {
             
            ToastView{
                VStack() {
                    
                    VStack(alignment: .leading){
                        
						HStack(alignment: .center) {
                              Text("PRIOR DATA")
                                    .font(.system(size: 22))
                                    .fontWeight(.heavy)
                                    .tracking(1.5)
                                    .padding(.leading, 25)
									.padding(.top, 20)
                          
							Spacer()
							
                            Button{
                                showPopup = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
									.padding(.top, 12)
									.padding(.trailing, 20)

                            }
                            
                        }
            
						Spacer()
							.frame(height: 3)
                       
						Text("Before Current Term")
							.fontWeight(.regular)
                        .font(.system(size: 14))
                        .padding(.leading, 25)
                        
                    Spacer()
                        .frame(height: 25)
                        
                        HStack{
                            Text("PRIOR GPA")
                                .font(.system(size: 10))
                                .fontWeight(.bold)
                                .frame(maxWidth: 100, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, 25)


                            Text("PRIOR CREDITS")
                                .font(.system(size: 10))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, 15)
                            Spacer()
                        }
                        
                        HStack{
                            TextField(settingsStore.initialGPA.description, value: $initialGPA, formatter: numberFormatter)
                                .padding(.all)
                                .foregroundColor(hasMoreThanOne() ? .gray : .black)
                                    .frame(width: 90, height: 40)
                                    .background(Color.init(hex: 0xE7E7E7))
                                    .cornerRadius(10)
                                    .padding(.bottom,10)
                                    .padding(.leading, 25)
                                    .keyboardType(.decimalPad)
                                    .disabled(hasMoreThanOne() ? true : false)



                            TextField(settingsStore.initialTotalCredits.description, value: $initialTotalCredits, formatter: numberFormatter)
                                .padding(.all)
                                .foregroundColor(hasMoreThanOne() ? .gray : .black)
                                .frame(width: 90, height: 40)
                                .background(Color.init(hex: 0xE7E7E7))
                                .cornerRadius(10)
                                .padding(.bottom,10)
                                .padding(.leading, 15)
                                .keyboardType(.decimalPad)
                                .disabled(hasMoreThanOne() ? true : false)
                        }

                        Spacer()
                            .frame(height: 4)

                        if hasMoreThanOne() {
                            Text("To avoid conflicts, prior data is valid only if you have no previous semesters added. To include prior data, manually add each previous semesters.")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .frame(maxWidth: 220, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, 25)
								.padding(.vertical, 5)
								.fixedSize(horizontal: false, vertical: true)

                        }
                        
                    }
                    Spacer()
                        .frame(height: 15)

                  Button {
                      Amplitude.instance().logEvent("Prior Data Added")
                      Amplitude.instance().logEvent("GPA Added: \(initialGPA.description)")
                      Amplitude.instance().logEvent("Credits Added: \(initialTotalCredits.description)")
                    showPopup = false
                      
                      
                      
                      settingsStore.initialGPA = initialGPA
                      settingsStore.initialTotalCredits = initialTotalCredits
                  } label: {
                    Text("Update")
                      .bold()
                      .frame(width: UIScreen.main.bounds.width/2)
                      .foregroundColor(.white)
                      .padding(.horizontal)
                      .padding(.vertical, 10.0)
                      .background(.black)
                      .cornerRadius(8.0)
                  }
               
                
                
                }
               
                .frame(width: UIScreen.main.bounds.width/1.5, height: 280)
                .cornerRadius(14)
            }
            .environment(\.colorScheme, .light)
            .background(Color.black.opacity(0.8).edgesIgnoringSafeArea(.all))
            
            
              
        }
            
        
        .toast(isPresented: $showTarget) {
             
            ToastView{
                VStack() {
                    
                    VStack(alignment: .center){
                        
                        HStack(alignment: .center){
							
							Image("SplashIcon")
								.resizable()
								.aspectRatio( contentMode: .fit)
								.frame(width: 30, height: 30)
							
							
                              Text("TARGET GPA")
								.font(.system(size: 25))
								.fontWeight(.heavy)
								.tracking(1.5)
							
                            
						}.padding(.top,20)
						
						Text("Type your Target GPA or use the buttons to toggle your desired target.")
							.font(.system(size: 12))
							.fontWeight(.regular)
							.frame(maxWidth: 250, alignment: .center)
							.foregroundColor(.black)
							.fixedSize(horizontal: false, vertical: true)
							.multilineTextAlignment(.center)

                        Spacer()
                            .frame(height: 20)
                        
                     
						HStack(){
							let buttonSize = 60.0
                            Button{
                                
                                let aPlusVal = gradeStore.getGradeWith(name: "A+")?.value
                                
                                if self.targetGPA < 0.05 {
                                    self.targetGPA = 0
                                } else if self.targetGPA > aPlusVal ?? 6 {
                                    self.targetGPA = aPlusVal ?? 6
                                } else{
                                    self.targetGPA -= 0.05
                                }
                                
                                
                            } label: {
                                Image(systemName: "minus.circle.fill")
									.foregroundStyle(.white, Color.init(hex: 0x414141))
                                    .font(.system(size: 22))
									.padding(0)

                            }
                            Spacer()
                                .frame(width: 0)

                            let localTarget = String(format: "%.2f", settingsStore.targetGPA)
                            TextField(localTarget, value: $targetGPA, formatter: numberFormatter)
                                .font(Font.body.bold())
                                .padding(.all)
                                .frame(width: 120, height: 40)
                                .background(Color.init(hex: 0xE7E7E7))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .keyboardType(.decimalPad)
								.multilineTextAlignment(.center)
                            
                            Spacer()
                                .frame(width: 0)

                            Button{
                                
                                let aPlusVal = gradeStore.getGradeWith(name: "A+")?.value
                                
                                if self.targetGPA >= aPlusVal ?? 6 {
                                    self.targetGPA = aPlusVal ?? 6
                                } else if self.targetGPA < 0 {
                                    self.targetGPA = 0
                                } else{
                                    self.targetGPA += 0.05
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
									.foregroundStyle(.white, Color.init(hex: 0x414141))
                                    .font(.system(size: 22))
									.padding(0)


                            }
                        }
						.frame(width: UIScreen.main.bounds.width/2)
						.padding(.vertical,10 )
						
                      
                        
                    }
                    Spacer()
                        .frame(height: 22)

					HStack{
						
						Button {
							showTarget = false
						} label: {
							Text("Cancel")
								.bold()
                                .frame(width: UIScreen.main.bounds.width/4.5)
								.foregroundColor(.white)
								.padding(.horizontal)
								.padding(.vertical, 12.0)
								.background(Color.init(hex: 0x757575))
								.cornerRadius(8.0)
						}
						//757575
						Button {
							showTarget = false
                            
                            let aPlusVal = gradeStore.getGradeWith(name: "A+")?.value
                            
                            
                            if targetGPA > aPlusVal ?? 6 {
                                targetGPA = aPlusVal ?? 6
                                settingsStore.targetGPA = targetGPA
                            } else if targetGPA < 0 {
                                targetGPA = 0
                                settingsStore.targetGPA = targetGPA
                            }
                            
                            settingsStore.targetGPA = targetGPA
                            
                            
						} label: {
							Text("Save")
								.bold()
                                .frame(width: UIScreen.main.bounds.width/4.5)
								.foregroundColor(.white)
								.padding(.horizontal)
								.padding(.vertical, 12.0)
								.background(.black)
								.cornerRadius(8.0)
						}
						
						
						
					}
                    .padding(.top,8)
                    .padding(.bottom, 20)
                
                    Spacer()
                        .frame(height: 12)
                    
                 

                }
                .padding(.top, 20)
				.padding(.horizontal,20)
                .frame(width: UIScreen.main.bounds.width/1.5, height: 240)
                .cornerRadius(14)
            }
            .environment(\.colorScheme, .light)
            .background(Color.black.opacity(0.8).edgesIgnoringSafeArea(.all))

            
              
            }
        
        
        
        .sheet(item: $activeSheet) { sheet in
              switch sheet {
              case .addSemester:
                  AddSemester_Home()
                      .environmentObject(self.settingsStore)
                      //.environmentObject(appStoreManager)
                      .environmentObject(settingsStore)
                      .environmentObject(gpaClassStore)
                      .environmentObject(semesterStore)
                      .environmentObject(gradeStore)
                      .environmentObject(calculationManager)
                      //.interactiveDismissDisabled(true)
              case .editGrades:
                 GradeView()
              case .settingsView:
                  SettingsView().environmentObject(self.settingsStore)
                      .interactiveDismissDisabled(true)
                  //SettingsView(targetgpa: String(format: "%.2f", gpaTarget)).environmentObject(self.settingsStore)
              case .upgradeView:
                  UpsellView()
              case .finalCalculatorView:
                  FinalCalculatorView()
              
//              case .classDetailView:
//                  let aClass = gpaClassStore.create(name: "className", includeInSemesterGPA: false,  gradeID: 123 , weight: 3, semesterID: 43)
//
//                  let currentSemesterTest = semesterStore.create(name: "Fall 2022", totalCredits: 0, finalGPA: 0, startDate: Date(), endDate: getPastDate(Date(), numDays: 163), color: ColorOptionsEnum.Bluegray, includeInCumulativeGPA: true)
//                  ClassDetail(existingClass: aClass, currentClass: aClass, currentSemester: currentSemesterTest)
              }
            }
		.onAppear{
            targetGPA = settingsStore.targetGPA
            initialGPA = settingsStore.initialGPA
            initialTotalCredits = settingsStore.initialTotalCredits
            
            let currentSemestersAppear = semesterStore.allSemesters.filter{ $0.endDate >= Date() }
            
            let pastSemestersAppear = semesterStore.allSemesters.filter{ $0.endDate < Date() }
            
            settingsStore.currentGPA = calculationManager.getCumulativeGPA(semesters: pastSemestersAppear+currentSemestersAppear)
            
            
			
			if semesterStore.allSemesters.count == 0 {
//                if let newSemester = semesterStore.create(name: "Fall 2020",
//                                     startDate: Date(),endDate: getPastDate(Date(), numDays: 163), color: Color(hex: 0x95A646), includeInCumulativeGPA: true)
//                {
//                }
//				if let newSemester = semesterStore.create(name: "Spring 2020",
//									 startDate: getPastDate(Date(), numDays: -893),endDate: getPastDate(Date(), numDays: -772), color: Color(hex: 0xE2DEF5), includeInCumulativeGPA: true)
//                {
//
//
//					if let aPlus = gradeStore.getGradeWith(name: "A-"){
//
//						_ = gpaClassStore.create(name: "CS 111",
//											 includeInSemesterGPA: true,
//											 gradeID: aPlus.id,
//											 weight: 4,
//											 semesterID: newSemester.id)
//
//
//						_ = gpaClassStore.create(name: "SPANISH 2940",
//											 includeInSemesterGPA: true,
//											 gradeID: aPlus.id,
//											 weight: 4,
//											 semesterID: newSemester.id)
//
//					}
//
//					if let b = gradeStore.getGradeWith(name: "B"){
//
//						_ = gpaClassStore.create(name: "WRITING 301",
//											 includeInSemesterGPA: true,
//											 gradeID: b.id,
//											 weight: 4,
//											 semesterID: newSemester.id)
//
//
//
//
//					}
//
//					if let cPlus = gradeStore.getGradeWith(name: "C+"){
//
//						_ = gpaClassStore.create(name: "MATH 3218",
//											 includeInSemesterGPA: true,
//											 gradeID: cPlus.id,
//											 weight: 4,
//											 semesterID: newSemester.id)
//
//					}
//				}
//
            }
            requestReview()
            settingsStore.appOpens += 1
			
			var versionNumber = ""
			if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
			   let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String{
				
				versionNumber = appVersion.description + "." + build.description
			}

			
			// User Analytics
			if let identify = AMPIdentify()
				.set("First Version", value: settingsStore.firstVersion as NSObject)
				.set("Current Version", value: versionNumber as NSObject)
				.set("App Opens", value: settingsStore.appOpens as NSObject)
				.set("Target GPA", value: settingsStore.targetGPA as NSObject)
				.set("Total Terms", value: semesterStore.allSemesters.count.description as NSObject)
				.set("Total Classes", value: gpaClassStore.allClasses.count.description as NSObject)
				.set("Current Overall GPA", value: settingsStore.currentGPA as NSObject)
				.set("Current Adjusted GPA", value: settingsStore.currentAdjustedGPA as NSObject)
                .set("Total Assignments", value: assignmentStore.allAssignments.count.description as NSObject){
            
				Amplitude.instance().identify(identify)
			}
            
        }
    }
    
	func getMainGPAfontSize() -> CGFloat {
		if DeviceTypeSize.IS_IPHONE_13_PRO_MAX_SIZED {
			return 58.0
		}else {
			return 52.0
		}
	}
}




struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}


extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension MainView{
    func hasMoreThanOne() -> Bool{
        
        let pastSemesters = semesterStore.allSemesters.filter{ $0.endDate < Date() }
        
        if (pastSemesters.count > 0) {
            return true
        }else{
            return false
        }
    }
    
    
    func requestReview() {
        var count = UserDefaults.standard.integer(forKey: UserDefaultKeys.appStartUpsCountKey)
                count += 1
            UserDefaults.standard.set(count, forKey: UserDefaultKeys.appStartUpsCountKey)
                print(count)
        
                if count == 5  {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }
                } else if count == 10 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }
                } else if count%10 == 0 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }
                }
//        else if settingsStore.isPremium {
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
//                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//                            SKStoreReviewController.requestReview(in: scene)
//                        }
//                    }
//                }
        }
    
    func openSettingsView() {
        activeSheet = .settingsView
    }
    
    func openFinalCalculatorView() {
        activeSheet = .finalCalculatorView
    }
    
    func openAddSemester() {
        activeSheet = .addSemester
    }
    
    func openEditGrades() {
        activeSheet = .editGrades
    }
    
    func openUpgrade() {
        activeSheet = .upgradeView
    }
    
    
    enum Sheet: Identifiable {
        case addSemester
        case editGrades
        case settingsView
        case upgradeView
        case finalCalculatorView
//        case classDetailView
        
        var id: Int {
            hashValue
        }
        
    }

}




struct SemesterCardView: View {
    
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var calculationManager : CalculationManager
    @EnvironmentObject var semesterStore : SemesterStore

    @State var activeSheetCard: Sheet3? = nil

    var currentSemester: Semester
    var gpaNeededLocal: Double
    var gpaNow = 4.0
    
    @State private var showingAlertTwo = false
	
	
    @Binding var gpaTarget: Double
//    @Binding var pastSemesters: [Semester]
//    @Binding var currentSemesters: [Semester]
    
    var body: some View {
        VStack{
			HStack(alignment:.top) {
                    
                if currentSemester.includeInCumulativeGPA {
                    Text(currentSemester.name)
                        .font(.system(size: 20))
                        .fontWeight(.heavy)
                        .frame(maxWidth: UIScreen.screenWidth / 1.2 , alignment: .topLeading)
                        .foregroundColor(.black)

                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }else{
                    Text(currentSemester.name)
                        .font(.system(size: 20))
                        .italic()
                        .fontWeight(.heavy)
                        .frame(maxWidth: UIScreen.screenWidth / 1.2 , alignment: .topLeading)
                        .foregroundColor(.black)

                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                
				

				Spacer()

                VStack{
                    
                    if currentSemester.endDate > Date() {
                        Text("CURRENT GPA")
                        .font(.system(size: 10))
                        .tracking(2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        .foregroundColor(.black)
                        
                        Text("\(calculationManager.calculateAdjustedGPA(semesterID: currentSemester.id).isNaN ? 0 : calculationManager.calculateAdjustedGPA(semesterID: currentSemester.id), specifier: "%.2f")")
                        .font(.system(size: 32))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        .foregroundColor(.black)

                    } else {
                        Text("FINAL GPA")
                        .font(.system(size: 10))
                        .tracking(2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        .foregroundColor(.black)
                        
                        Text("\(calculationManager.calculateGPAFor(semesterID: currentSemester.id).isNaN ? 0 : calculationManager.calculateGPAFor(semesterID: currentSemester.id), specifier: "%.2f")")
                        .font(.system(size: 32))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        .foregroundColor(.black)

                    }
                
					

					
                   
                }
            }
            Spacer()
            HStack{
				VStack(spacing: 3) {
                    Text("Total Credits: \(calculationManager.countCredits(semesterID: currentSemester.id).isNaN ? 0 : calculationManager.countCredits(semesterID: currentSemester.id), specifier: "%.0f")")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.black)
                    if currentSemester.endDate > Date() {
                        Text("Ends \(currentSemester.endDate, style: .date)")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundColor(.black)
                            .padding(.leading, 1)
                    } else {
                        Text("Completed \(currentSemester.endDate, style: .date)")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .foregroundColor(.black)
                            .padding(.leading, 1)
                    }
                    

				}.padding(.top, 20)
				
				Spacer()
                
//                Menu{
//                    Button(action: {
//                        activeSheetCard = .editSemester
//                    })
//                    {
//                        Label("Edit Term", systemImage: "pencil")
//                            .font(.body)
//                            .foregroundColor(.black)
//                    }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 8))
//                    
//                    Button(action: {
//                        showingAlertTwo = true
//                    })
//                    {
//                        Label("Delete Term", systemImage: "trash")
//                            .font(.body)
//                            .foregroundColor(.black)
//                    }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 8))
//                    
//                    
//                } label: {
//                    Label("", systemImage: "ellipsis.circle")
//                        .font((.system(size: 24, weight: .regular)))
//                        .offset(x: 7)
//                        .padding(.leading, 45)
//                        .padding(.top, 20)
//                        .buttonStyle(PlainButtonStyle())
//                }.pickerStyle(.menu)
//                    .foregroundColor(.black)

                
                
                
            }
        }
		.padding(.horizontal,20)
		.padding(.vertical,15)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 200)
		.background(currentSemester.color.lightColor())
        .cornerRadius(18)
		.padding(.horizontal,20)
		.padding(.vertical,5)
        
        .alert(isPresented: $showingAlertTwo, content: {
                Alert(
                    title: Text("Are you sure you want to delete this term?"),
                    message: Text("All classes and assignments will be deleted as well."),
                    primaryButton: .default(
                        Text("Delete Term"),
                        action: {deleteSem()}
                    ),
                    secondaryButton: .destructive(
                        Text("Cancel")
                    )
                )
            })
        .sheet(item: $activeSheetCard) { sheet in
              switch sheet {
              case .editSemester:
                  EditSemesterView(existingSem: currentSemester)
                      .preferredColorScheme(.light)
              }
        }
    }
    
    func deleteSem() {
                
        semesterStore.delete(entryID: currentSemester.id)
        
        for aClass in gpaClassStore.getAllClassesFor(semesterID: currentSemester.id){
            gpaClassStore.delete(entryID: aClass.id)
        }
            
    }
            
        enum Sheet3: Identifiable {
            case editSemester
            
            var id: Int {
                hashValue
            }
        }
}



