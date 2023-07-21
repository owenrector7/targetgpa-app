//
//  PastSemesterDetail.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/2/22.
//
import SwiftUI
import ToastUI
import AVFoundation
import Amplitude

struct PastSemesterDetail: View {
    
    @Environment(\.presentationMode) var presentationMode

    
    @State var showInfoModalView: Bool = false
    @State var showClassDetailView: Bool = false
    @State private var showingAlert = false
   
    @EnvironmentObject var settingsStore : SettingsStore
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager

    var currentSemester: Semester

    @State var gpaNeeded: Double
    @State var gpaTarget: Double
    @State var gpaNow: Double
    @State var adjustedGPA: Double = 3.5
    
    @State var pastSemesters: [Semester]
    @State var currentSemesters: [Semester]
    
    
    @State var adjustedClasses: [GPAClass] = [GPAClass]()
    @State var semesterClasses: [GPAClass] = [GPAClass]()
    @State var activeSheet: Sheet?
    
    @State var selectedClass: GPAClass?
    @State var selectedIndex: Int = 0
    @State var selectedClassId: Int = 0
    
    var body: some View {
        
        let semesterClasses = gpaClassStore.getAllClassesFor(semesterID: currentSemester.id)
        
        VStack(spacing: 0){
                HStack {
                    VStack(alignment: .leading){
                    //    Text(currentSemester.name)
						Text("TOTAL CREDITS")
							.font(.system(size: 14, weight: .heavy))
							.tracking(1)
							.foregroundColor(.black)
                            .padding(.leading, 20)
                            .lineLimit(2)

                        Spacer()
                            .frame(height: 5)
                        Text("\(calculationManager.countCredits(semesterID: currentSemester.id), specifier: "%.0f") Credits Taken")
                            .font(.system(size: 15, weight: .light))
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Spacer()
                            .frame(height: 30)
						Text("COMPLETED")
							.font(.system(size: 14, weight: .heavy))
							.tracking(1)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Text("\(currentSemester.endDate, style: .date)")
							.font(.system(size: 15, weight: .light))
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        
                    }
                    .frame(minWidth: UIScreen.screenWidth / 2.1 , minHeight: 100)
                    .cornerRadius(10)
                    
                    
                    VStack(alignment: .leading){
                            Text("Term")
                                .font(.system(size: 12, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                            Text("FINAL GPA")
                                .font(.system(size: 18, weight: .heavy))
								.tracking(2)
                                .foregroundColor(.black)
                        Text("\(calculationManager.calculateGPAFor(semesterID: currentSemester.id).isNaN ? 0 : calculationManager.calculateGPAFor(semesterID: currentSemester.id), specifier: "%.2f")")
                                    .font(.system(size: 60, weight: .heavy))
                                    .foregroundColor(.black)
                            
                            }
                    .padding(.top, 12)

                    .frame(minWidth: UIScreen.screenWidth / 1.8 , minHeight: 100)
                        .cornerRadius(10)

                }
                .padding(.top, 30)
                .padding(.bottom, 60)
                .background(currentSemester.color.lightColor())
               
				
				HStack (alignment: .center) {
					VStack {

						Text("Class")
							.frame(width: 150, alignment: .topLeading)
							.font(.system(size: 12, weight: .bold, design: .rounded))
							.foregroundColor(.black)
							.offset(x: 16, y: -18)

					}
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
					.offset(x: 25, y:20)

					


					VStack {
						Text("Credits")
							.font(.system(size: 12, weight: .bold, design: .rounded))
							.frame(width: 150, alignment: .leading)
							.foregroundColor(.black)
							.offset(x: 15, y: -18)

					}
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
					.offset(x: -10, y:20)
                    
                    VStack {
                        Text("Final Grade")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .frame(width: 150, alignment: .topLeading)
                            .foregroundColor(.black)
                            .offset(x: 11, y: -18)

                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .offset(x: -70, y:20)

				}
				.frame(width: 490, height: 40)
				.background(currentSemester.color.lightestColor())
				.offset(x:25)

				
				Spacer()
					.frame(height: 22)

				
				
                HStack {
                    ScrollView{
                    VStack{
                        
                        ForEach(Array(semesterClasses)){aClass in
                            
                            let importantColorNew = currentSemester.color.lightColor()

                            NavigationLink(destination: ClassDetail(existingClass: aClass, semesterClasses: semesterClasses, currentClass: aClass, currentSemester: currentSemester)) {
                                PastClassCardView(currentClass: aClass, importantColor: importantColorNew)
                            }
                           
                                Spacer()
                                    .frame(height: 15)
                                LineTwo()
                                    .stroke(style: StrokeStyle(lineWidth: 0.25, dash: [4]))
                                    .frame(height: 1)
                                    .foregroundColor(.black)

                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                }

                    }
                
            }
            .foregroundColor(.black)
            
            }
        }
            .background(Color.white.edgesIgnoringSafeArea(.all))

            .overlay(
                VStack(alignment:.leading) {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: openAddClassDetailTwo) {
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
                            activeSheet = .editSemester
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
                            action: delete
                        ),
                        secondaryButton: .destructive(
                            Text("Cancel")
                        )
                    )
                })
            .sheet(item: $activeSheet) { sheet in
                  switch sheet {
                  case .editClass:
                      let selectedClass = semesterClasses[selectedIndex]
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



    
}

struct PastClassCardView: View {
	
	@EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var gpaClassStore : GPAClassStore

    
	
	var currentClass: GPAClass
	@State var activeSheet: Sheet2?
    @State var importantColor: Color
	//@Binding var selectedClass: GPAClass?
	//@Binding var adjustedCurrentClass: GPAClass
	
	//@Binding var gpaNeeded: Double
	//var mainGrade: Grade
	//@State var adjustedGrade: Grade
	
    var body: some View {
        
        HStack{
            
            let fontSize : CGFloat = 16
            
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
                        let newGrade = gradeStore.getGradeWith(gradeId: nextAdjustedGrade.id)
                        Amplitude.instance().logEvent("New Grade: " + newGrade!.name ?? "")
                        
                        
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
//                Button(action: {
//                    activeSheetCurrentSem = .editClass
//
//                }, label:{
//                    Label("Edit Class", systemImage: "pencil")
//                        .foregroundColor(.black)
//                        .font(.body)
//                        .padding(.trailing, 15)
//                        .offset(x:-8)
//                })
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

//		HStack{
//
//			if let currentClassGrade = gradeStore.getGradeWith(gradeId: currentClass.adjustedGradeId){
//
//                let fontSize : CGFloat = 16
//
//                if currentClass.includeInSemesterGPA{
//                    Text(currentClass.name)
//                        .font(.system(size: fontSize))
//                            .fontWeight(.bold)
//                            .frame(width: UIScreen.screenWidth / 4, alignment: .leading)
//                            .padding(.trailing, 58)
//                            .offset(x: 10)
//
//
//                } else {
//                    Text(currentClass.name)
//                        .font(.system(size: fontSize))
//                        .italic()
//                            .fontWeight(.bold)
//                            .frame(width: UIScreen.screenWidth / 4, alignment: .leading)
//                            .padding(.trailing, 58)
//                            .offset(x: 10)
//
//
//                }
//
//
//                Divider()
//                    .hidden()
//
//
//
//
//				Text("\(currentClass.weight, specifier: "%.0f")")
//					.font(.system(size: 15, weight: .bold))
//					.frame(width: UIScreen.screenWidth / 4, alignment: .leading)
//                    .offset(x: 10)
//
//
//                Divider()
//                    .hidden()
//
//
//                let classGradeAdjusted = gradeStore.getGradeWith(gradeId: currentClass.adjustedGradeId)
//
//                Text(classGradeAdjusted?.name ?? "")
//                    .font(.system(size: fontSize))
//                    .fontWeight(.bold)
//                    .frame(width: UIScreen.screenWidth / 6, alignment: .leading)
//                    .offset(x: 7)
//
//
//                Image(systemName: "chevron.right")
//                    .foregroundColor(Color.init(hex: 0x7f7f7f))
//                    .offset(x: -15)
//
//
////                Menu{
////                    Button(action: {
////                        activeSheet = .editClass
////
////                    }, label:{
////                        Label("Edit Class", systemImage: "pencil")
////                            .foregroundColor(.black)
////                            .font(.body)
////                            .padding(.trailing, 15)
////                            .offset(x:-8)
////                    })
////                Button(action: {
////                    gpaClassStore.delete(entryID: currentClass.id)
////
////                }, label:{
////                    Label("Delete Class", systemImage: "trash")
////                        .foregroundColor(.black)
////                        .font(.body)
////                        .padding(.trailing, 15)
////                        .offset(x:-8)
////                })
////
////
////                }label: {
////                    Label("", systemImage: "ellipsis")
////                        .foregroundColor(.black)
////                        .font(.body)
////                        .contentShape(Rectangle())
////                        .padding(.trailing, 37)
////                        .padding(.bottom, 8)
////                }.pickerStyle(.menu)
////                    .foregroundColor(.black)
//
//
//
//			}
//
//
//		}
		.sheet(item: $activeSheet) { sheet in
			switch sheet {
				case .editClass:
                    EditClassView(existingClass: currentClass)
                        .preferredColorScheme(.light)
                case .upgradeView:
                    UpsellView()
					
					
				
			}
		}
		
	}
}

enum Sheet2: Identifiable {
	case editClass
    case upgradeView
	
	var id: Int {
		hashValue
	}
}

extension PastSemesterDetail {
    
    func delete() {
                
        semesterStore.delete(entryID: currentSemester.id)
        
        for aClass in gpaClassStore.getAllClassesFor(semesterID: currentSemester.id){
            gpaClassStore.delete(entryID: aClass.id)
        }
            
    }
    
    func openUpgrade() {
        activeSheet = .upgradeView
    }
  
    func openAddClassDetailTwo() {
        if (gpaClassStore.allClasses.count < 5) {
            activeSheet = .addClass
        } else if settingsStore.isPremium {
            activeSheet = .addClass
        } else {
            print(gpaClassStore.allClasses.count)
            openUpgrade()
        }
        
    }
    
    func calculateAdjustedGPA(semesterID: Int) -> Double {
        var gradeSum: Double
        var weightSum: Double
        if adjustedClasses.count > 0 {
            gradeSum = 0
            weightSum = 0
            for aClass in adjustedClasses{
                weightSum += aClass.weight
                let classGrade = self.gradeStore.getGradeWith(gradeId: aClass.gradeId)
                gradeSum += aClass.weight * classGrade!.value ?? 4
            }
            return gradeSum/weightSum
        } else {
            return gpaNeeded
        }
    }
    
    func calculateCumulativeAdjustedGPA(semesterID: Int) -> Double {
        var pastGPA: Double = 0
        var pastCred: Double = 0
        var currentCred: Double = 0
        var semesterAdjusted: Double = 0
        var totalGrade: Double = 0
        
        pastGPA = calculationManager.getCumulativeGPA(semesters: pastSemesters)
        pastCred = calculationManager.getTotalCredits(semesters: pastSemesters)
        currentCred = calculationManager.getTotalCredits(semesters: currentSemesters)
        semesterAdjusted = calculateAdjustedGPA(semesterID: currentSemester.id)
        totalGrade = ((pastGPA*pastCred)+(currentCred*semesterAdjusted)) / (currentCred+pastCred)
        return totalGrade
        
    }
   
    enum Sheet: Identifiable {
      case addClass
      case editClass
      case editSemester
      case upgradeView
      
      var id: Int {
        hashValue
      }
    }
}


