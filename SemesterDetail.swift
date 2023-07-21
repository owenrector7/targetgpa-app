//
//  SemesterDetail.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/2/22.
//
import SwiftUI
import ToastUI
import AVFoundation
import Amplitude

struct SemesterDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var showPastInfo : Bool = true
    @State var showUpdate: Bool = true
    @State var showTarget: Bool = false

    @State var showInfoModalView: Bool = false
    @State var showClassDetailView: Bool = false
    @State private var showingAlert = false

    @EnvironmentObject var settingsStore : SettingsStore
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
	@EnvironmentObject var calculationManager : CalculationManager
    
    @State var initialTotalCredits: Double = 0.0
    @State var initialGPA: Double = 0.0

    var currentSemester: Semester
    @State var gpaNeeded: Double
    @State var targetGPA: Double = 0.0
    @State var gpaTarget: Double
    @State var gpaNow: Double
    @State var adjustedGPA: Double = 3.5
    @State var selectedIndex: Int = 0
    @State var activeSheetCurrentSem: Sheet? = nil
    
    @State var selectedClass: GPAClass?
    @State var pastSemesters: [Semester]
    @State var currentSemesters: [Semester]
//    @State var semesterClasses: [GPAClass]
        
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
        
    var body: some View {
        
        let semesterClasses = gpaClassStore.getAllClassesFor(semesterID: currentSemester.id)
        
        let mostRecentSemester = semesterStore.allSemesters.last

            VStack{
				HStack(alignment: .center)  {
					
					VStack(alignment: .leading){
//						Text("Semester")
//							.italic()
//							.font(.system(size: 12))
//							.fontWeight(.regular)
//							.foregroundColor(Color.init(hex: 0x575757))
//						Text("TERM GPA")
//							.font(.system(size: 14, weight: .heavy))
//							.tracking(2)
//							.foregroundColor(.black)
//						Text("\(calculationManager.calculateGPAFor(semesterID: currentSemester.id).isNaN ? 0 : calculationManager.calculateGPAFor(semesterID: currentSemester.id), specifier: "%.2f")")
//							.font(.system(size: getMainGPAfontSize(), weight: .heavy))
//							.foregroundColor(.black)
                        Spacer()
                            .frame(height: 20)
                        Text(currentSemester.name)
                            .italic()
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                        Text("TERM GPA")
                            .font(.system(size: 14, weight: .heavy))
                            .tracking(2)
                            .foregroundColor(.black)
                        let adjustedSemesterGPA = calculationManager.calculateAdjustedGPA(semesterID: currentSemester.id).isNaN ? 0 : calculationManager.calculateAdjustedGPA(semesterID: currentSemester.id)
                        Text("\(adjustedSemesterGPA, specifier: "%.2f")")
                            .font(.system(size: getMainGPAfontSize(), weight: .heavy))
                            .foregroundColor(.black)
					}
                    .frame(minWidth :UIScreen.screenWidth / 3 )
					.padding(.leading, 30)
					.padding(.trailing, 15)
					.padding(.vertical, 5)
                    .padding(.bottom, 25)
					
                    if currentSemesters.count > 0 {
                        
                        VStack(alignment: .leading) {
                            HStack{
                                Text("Cumulative")
                                    .italic()
									.font(.system(size: 11))
									.fontWeight(.regular)
                                    .foregroundColor(.black)
                            }
                            
                            Text("OVERALL GPA")
								.font(.system(size: 13, weight: .heavy))
								.tracking(2)
                                .foregroundColor(.black)
                            let adjustedCumulativeGPA = calculationManager.calculateCumulativeAdjustedGPA(semesterID: currentSemester.id).isNaN ? 0 : calculationManager.calculateCumulativeAdjustedGPA(semesterID: currentSemester.id)
                            let adjustedGPALocal = String(format: "%.2f", gpaNeeded)
                            let localAdjustedTarget = String(format: "%.2f", settingsStore.targetGPA)

                            
                            HStack{
                        
                          
								Text("\(adjustedCumulativeGPA, specifier: "%.2f")")
									.font(.system(size: 30, weight: .heavy))
									.foregroundColor(.black)
									.padding(.vertical,1)
									.padding(.leading, 5)
									
									if adjustedCumulativeGPA >= settingsStore.targetGPA {
										Image(systemName: "checkmark.circle.fill")
											.foregroundStyle(currentSemester.color.darkColor(), .white)
									}
							}
                            
                            
                               
                            let targetText = "TARGET GPA"
                            
                            Spacer()
                                .frame(height: 10)
                            HStack{
                            Text(targetText)
                                    .foregroundColor(.black)
                                .italic()
                                .font(.system(size: 9))
                               // .tracking(1.2)
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)
                                
                            
                            Text(localAdjustedTarget)
                                .foregroundColor(.black)
                                .fontWeight(.heavy)
                                .font(.system(size: 11))
                                .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(currentSemester.color.lightColor())
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, maxHeight: 30)
                            .onTapGesture{
                                targetGPA = settingsStore.targetGPA
                                showTarget = true
                                
                            }
                            //.padding(.leading, 20)

                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .background(currentSemester.color.lightestColor())
                        .cornerRadius(14)
                        .frame(maxWidth :UIScreen.screenWidth / 2.5 )
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    
				}.padding(.vertical,20)
                .background(currentSemester.color.lightColor())
				
				
				
                Spacer()
                    .frame(height: 0)
                
				
				
				
                HStack (alignment: .center) {
                    VStack {

                        Text("Class")
                            .frame(width: 150, alignment: .topLeading)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .offset(x: 10, y: -18)

                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .offset(x: 30, y:20)

                    VStack {
                        Text("Credits")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .frame(width: 150, alignment: .topLeading)
                            .foregroundColor(.black)
                            .offset(x: 19, y: -18)

                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .offset(x: -10, y:20)


                    VStack {
                        Text("Grade")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .frame(width: 150, alignment: .leading)
                            .foregroundColor(.black)
                            .offset(x: 24, y: -18)

                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                    .offset(x: -70, y:20)

                }
                .frame(width: 490, height: 40)
                .background(currentSemester.color.lightestColor())
                .offset(x:25)
                Spacer()
                    .frame(height: 20)


                
                ScrollView{
                    
                    
                VStack{

                    ForEach(Array(semesterClasses.enumerated()), id: \.element){index, aClass in

                        let importantColorNew = currentSemester.color.lightColor()
                        

                        NavigationLink(destination: ClassDetail(existingClass: aClass, semesterClasses: semesterClasses, currentClass: aClass, currentSemester: currentSemester)) {
                            
                            ClassCardView(currentClass: aClass, currentSemester: currentSemester, importantColor: importantColorNew)
                        }.isDetailLink(false)
                           
                        
                        


                        LineTwo()
                            .stroke(style: StrokeStyle(lineWidth: 0.25, dash: [4]))
                            .frame(height: 1)
                            .foregroundColor(.black)

                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        Spacer()
                            .frame(height: 10)



                }

                Spacer()
                    .frame(height: 75)

            }
//            .foregroundColor(.black)
            }
                
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))

            .overlay(
                VStack(alignment:.leading) {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                            
                                            openAddClassDetail()
                                           
                                        
                                    }
                                    ) {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundStyle(.white, .black)
                                                .font(.system(size: 45))
                                        }
                                        .padding(.horizontal, 88)
                                        .padding(.bottom, 20)
                                        .mask(Circle())
										.shadow(color: Color.black.opacity(0.25),radius: 3,
												x:3, y:3)
                                    }
                                }
                            }
            )
        .navigationViewStyle(.stack)
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                        .font((.system(size: 17, weight: .regular)))
                })
                
                
				Button(action: {
					self.presentationMode.wrappedValue.dismiss()
				}, label: {
					Text(currentSemester.name.uppercased())
						.font(.system(size: 17 , weight: .heavy))
						.tracking(2)
						.offset(x:3)
						.foregroundColor(.black)
                        .frame(maxWidth: UIScreen.main.bounds.width/1.3)
				})
				
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                //Spacer()
                
                Menu{
                    Button(action: {
                        activeSheetCurrentSem = .editSemester
                    })
                    {
                        Label("Edit Term", systemImage: "pencil")
                            .font(.body)
                            .foregroundColor(.black)
                    }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 8))
                    
                    Button(action: {
                        showingAlert = true
                    })
                    {
                        Label("Delete Term", systemImage: "trash")
                            .font(.body)
                            .foregroundColor(.black)
                    }.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 8))
                    
                    
                } label: {
                    Label("", systemImage: "ellipsis.circle")
                        .font((.system(size: 17, weight: .regular)))
                }.pickerStyle(.menu)
                    .foregroundColor(.black)
            }
        }
        .alert(isPresented: $showingAlert, content: {
                Alert(
                    title: Text("Are you sure you want to delete this term?"),
                    message: Text("All classes and assignments will be deleted as well."),
                    primaryButton: .default(
                        Text("Delete Term"),
                        action: deleteSem
                    ),
                    secondaryButton: .destructive(
                        Text("Cancel")
                    )
                )
            })
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
                            
                            if targetGPA > 6 {
                                targetGPA = 6
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
						
						
						
					}.padding(.top,8)
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
    .sheet(item: $activeSheetCurrentSem) { sheet in
          switch sheet {
          case .addClass:
            AddClassView(currentSemester: currentSemester)
                  .preferredColorScheme(.light)
          case .editSemester:
             EditSemesterView(existingSem: currentSemester)
                  .preferredColorScheme(.light)
          case .upgradeView:
              UpsellView()
          }
        }
        .onAppear{
            targetGPA = settingsStore.targetGPA
            initialGPA = settingsStore.initialGPA
            initialTotalCredits = settingsStore.initialTotalCredits
            
            
            settingsStore.currentAdjustedGPA = calculationManager.calculateCumulativeAdjustedGPA(semesterID: currentSemester.id)
            
//            semesterClasses = gpaClassStore.getAllClassesFor(semesterID: currentSemester.id)
//            if adjustedClasses.isEmpty{
//                adjustedClasses = semesterClasses
//            }
            
        }
        

    
      
}

//struct SemesterDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SemesterDetail(gpaNeeded: 3.70, gpaTarget: 3.70, gpaNow: 3.65, currentSemester: <#Semester#>)
//    }
//}


struct LineTwo: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}


struct ClassCardView: View {
    
    
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var gpaClassStore : GPAClassStore
    
    @State var currentClass: GPAClass
	@State var currentSemester: Semester
    //@Binding var selectedClass: GPAClass?
//    @State var activeSheetCurrentSem: Sheet? = nil
	//@State var semesterColor: ColorOptionsEnum
    @State var importantColor: Color
	//@Binding var adjustedCurrentClass: GPAClass
        
    //@Binding var gpaNeeded: Double
    //var mainGrade: Grade
    //@State var adjustedGrade: Grade
    
    var body: some View {
        HStack{
			
			let fontSize : CGFloat = 13
            
            if currentClass.includeInSemesterGPA {
                Text(currentClass.name)
                    .font(.system(size: fontSize))
                        .fontWeight(.bold)
                        .frame(width: UIScreen.screenWidth / 4, alignment: .leading)
                        .padding(.leading,45)
                        .offset(x: 16)
                        .foregroundColor(.black)
            } else {
                Text(currentClass.name)
                    .font(.system(size: fontSize))
                    .italic()
                        .fontWeight(.bold)
                        .frame(width: UIScreen.screenWidth / 4, alignment: .leading)
                        .padding(.leading,45)
                        .offset(x: 16)
                        .foregroundColor(.black)
            }
			
            
            Divider()
                .hidden()
            
            if let currentClassGrade = gradeStore.getGradeWith(gradeId: currentClass.gradeId),
                let adjustedClassGrade = gradeStore.getGradeWith(gradeId: currentClass.adjustedGradeId){
				
                Text("\(currentClass.weight, specifier: "%.0f")")
					.font(.system(size: fontSize))
					.fontWeight(.bold)
					.frame(width: UIScreen.screenWidth / 6, alignment: .leading)
					.offset(x:15)
					.padding(.leading,30)
//                    .offset(x: 10)
                    .foregroundColor(.black)
				
            
                HStack{
				Button{
                    AudioServicesPlaySystemSound(1104)
                    Amplitude.instance().logEvent(currentClass.name + ": Grade Adjusted Down")
					if let nextAdjustedGrade = gradeStore.getSpecialPreviousGrade(grade: adjustedClassGrade){
                        gpaClassStore.updateAdjustedGrade(entryID: currentClass.id, adjustedGradeId: nextAdjustedGrade.id)
                        
					}
				} label: {
					Image(systemName: "minus.circle.fill")
						.foregroundStyle(.black, importantColor)
                        .font(.system(size: 20))
				}
				
				let classGradeAdjusted = gradeStore.getGradeWith(gradeId: currentClass.adjustedGradeId)
                
                if (classGradeAdjusted) == (currentClassGrade) {
                    
                    Text(classGradeAdjusted?.name ?? "-")
						.fontWeight(.bold)
                        .frame(width: 28)
                        .font(.system(size: fontSize))
                        .foregroundColor(.black)
                } else {
                    Text(classGradeAdjusted?.name ?? "-")
                        .fontWeight(.bold)
                        .frame(width: 28)
                        .foregroundColor(.black)

					
                        .font(.system(size: fontSize))
                }
				

				Button{
                    AudioServicesPlaySystemSound(1104)
                    Amplitude.instance().logEvent(currentClass.name + ": Grade Adjusted Up")
                    
                    if let nextAdjustedGrade = gradeStore.getSpecialNextGrade(grade: adjustedClassGrade){
                        gpaClassStore.updateAdjustedGrade(entryID: currentClass.id, adjustedGradeId: nextAdjustedGrade.id)
                        let newGrade = gradeStore.getGradeWith(gradeId: nextAdjustedGrade.id)
                        Amplitude.instance().logEvent("New Grade: " + newGrade!.name ?? "")
                        
                    }
                    
				} label: {
					Image(systemName: "plus.circle.fill")

                        .foregroundStyle(.black, importantColor)
						.font(.system(size: 20))
				}
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.init(hex: 0x7f7f7f))
                        .padding(.leading, 15)
                        
                    
                    
                    
                    
                    
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
			
			}
            
//            Menu{
//				Button(action: {
//                    activeSheetCurrentSem = .editClass
//
//				}, label:{
//					Label("Edit Class", systemImage: "pencil")
//						.foregroundColor(.black)
//						.font(.body)
//						.padding(.trailing, 15)
//						.offset(x:-8)
//				})
//            Button(action: {
//                gpaClassStore.delete(entryID: currentClass.id)
//
//            }, label:{
//                Label("Delete Class", systemImage: "trash")
//                    .foregroundColor(.black)
//                    .font(.body)
//                    .padding(.trailing, 15)
//                    .offset(x:-8)
//            })
//
//
//            }label: {
//                Label("", systemImage: "ellipsis")
//                    .foregroundColor(.black)
//                    .font(.body)
//                    .contentShape(Rectangle())
//                    .padding(.trailing, 50)
//                    .padding(.bottom, 11)
//                    //.offset(x:-8, y: -5)
//            }.pickerStyle(.menu)
//                .foregroundColor(.black)
        }
        .padding(.trailing, 85)
        .padding(.leading, 35)
//        .sheet(item: $activeSheetCurrentSem) { sheet in
//            switch sheet {
//                case .upgradeView:
//                    UpsellView()
//               case .addClass:
//                    UpsellView()
//               case .editSemester:
//                    UpsellView()
//
//            }
//        }
        .onAppear{
            
        }
    }
        
}
    
    
}

extension SemesterDetail {
    
    func openUpgrade() {
        activeSheetCurrentSem = .upgradeView
    }
    
    func openAddClassDetail() {
        if (gpaClassStore.allClasses.count < 5) {
            activeSheetCurrentSem = .addClass
        } else if settingsStore.isPremium {
            activeSheetCurrentSem = .addClass
        } else {
            openUpgrade()
        }
        
        
    }
    
//    func calculateAdjustedGPA(semesterID: Int) -> Double {
//        var gradeSum: Double
//        var weightSum: Double
//        let semesterClasses = gpaClassStore.getAllClassesFor(semesterID: currentSemester.id)
//        if semesterClasses.count > 0 {
//            gradeSum = 0
//            weightSum = 0
//            for aClass in semesterClasses{
//                if aClass.includeInSemesterGPA{
//                weightSum += aClass.weight
//                if let classGrade = self.gradeStore.getGradeWith(gradeId: aClass.adjustedGradeId){
//                    gradeSum += aClass.weight * classGrade.value
//                }
//                } else{
//                    
//                }
//            }
//            return gradeSum/weightSum
//        } else {
//            return calculationManager.calculateGPAFor(semesterID: currentSemester.id)
//        }
//    }
    
//    func calculateCumulativeAdjustedGPA(semesterID: Int) -> Double {
//        var pastGPA: Double = 0
//        var pastCred: Double = 0
//        var currentCred: Double = 0
//        var semesterAdjusted: Double = 0
//        var totalGrade: Double = 0
//
//
//        pastGPA = calculationManager.getCumulativeGPA(semesters: pastSemesters)
//        pastCred = calculationManager.getTotalCredits(semesters: pastSemesters) + settingsStore.initialTotalCredits
//        if !currentSemester.includeInCumulativeGPA{
//            currentCred = 0
//            semesterAdjusted = 0
//        } else{
//            currentCred = calculationManager.countCredits(semesterID: currentSemester.id)
//            semesterAdjusted = calculationManager.calculateAdjustedGPA(semesterID: currentSemester.id)
//        }
//        totalGrade = ((pastGPA*pastCred)+(currentCred*semesterAdjusted)) / (currentCred+pastCred)
//        return totalGrade
//
//    }
    
	func getMainGPAfontSize() -> CGFloat {
		if DeviceTypeSize.IS_IPHONE_13_PRO_MAX_SIZED {
			return 46.0
		}else {
			return 43.0
		}
	}
	
    func deleteSem() {
                
        semesterStore.delete(entryID: currentSemester.id)
        
        for aClass in gpaClassStore.getAllClassesFor(semesterID: currentSemester.id){
            gpaClassStore.delete(entryID: aClass.id)
        }
            
    }
    
    
    enum Sheet: Identifiable {
        case addClass
        case editSemester
        case upgradeView
        
        var id: Int {
            hashValue
        }
        
    }
   
}



