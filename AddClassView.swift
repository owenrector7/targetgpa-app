//
//  AddClassView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/3/22.

import SwiftUI
import AVFoundation
import Amplitude

struct AddClassView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var settingsStore: SettingsStore

    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    
    @State private var isToggle : Bool = true
    @State private var isPF : Bool = false
    var currentSemester: Semester
    
    @State var className = ""
    @State var credits: Double = 4
    @State var savePressed = false
    @State var activeSheet: Sheet?

    
    @State var defaultGrade: Grade?


    var body: some View {
		
		
		
        VStack(alignment: .leading, spacing: 0) {
            
            HStack{
			Text("ADD CLASS")
				.font((.system(size: 25, weight: .heavy)))
				.tracking(2)
				.foregroundColor(.primary)
				.padding(.leading, 50)
				.padding(.top, 65)
				.padding(.bottom, 50)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.white, .black)
                    .padding(.top, 65)
                    .padding(.bottom, 50)
                    .padding(.leading, 110)
            })
                    .contentShape(Circle())
            }
			
			
			Spacer()
                .frame(height: 20)
            Text("CLASS NAME")
				.font(.system(size: 16))
				.tracking(1.5)
				.fontWeight(.bold)
				.padding(.leading, 50)
                .padding(.bottom, 10)
            
            TextField("Enter Class Name", text: $className)
            .padding(.all)
                .frame(width: 300, height: 60)
                .foregroundColor(.black)
                .background(Color.init(hex: 0xEBECF0))
                .cornerRadius(10)
                .padding(.bottom,20)
                .padding(.leading, 50)
                .padding(.trailing, 80)
            Spacer()
                .frame(height: 10)
            
            VStack (alignment: .leading){
                HStack{
                    Text("CREDITS")
						.font(.system(size: 16))
                        .fontWeight(.bold)
						.tracking(1.5)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50, alignment: .leading)
                        .padding(.leading, 50)
                        .offset(x: 0, y: -2)
                    Spacer()
                        .frame(width: 120)
					
					let size = 20.0
					
                    Button{
                        AudioServicesPlaySystemSound(1104)

                        self.credits -= 1
                        
                        if self.credits < 1 {
                            self.credits = 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.black,Color.init(hex: 0xEBECF0))
							.font(.system(size: size))
                    }
                    Text("\(credits, specifier: "%.0f")")
						.font(.system(size: size))
                        .fontWeight(.bold)
						.padding(.horizontal,5)
                    Button{
                        AudioServicesPlaySystemSound(1104)

                        self.credits += 1
                        
                        if self.credits > 8 {
                            self.credits = 8
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.black, Color.init(hex: 0xEBECF0))
							.font(.system(size: size))
                        //.offset(x:35)
                    }
                }
                Spacer()
                    .frame(height: 25)
				HStack (alignment: .center){
					let size = 20.0

                    Text("CURRENT GRADE")
						.font(.system(size: 16))
						.fontWeight(.bold)
						.tracking(1.5)
                        .foregroundColor(.black)
                        .frame(width: 160, height: 50, alignment: .leading)
                        .padding(.leading, 50)
                        .offset(x: 0, y: -2)
					
					Button {
						openGrades()
					}label: {
						Image(systemName: "info.circle")
							.font(.system(size: 12))
							.foregroundColor(.black)
                            .padding(.bottom, 3)
					}
                    Spacer()
                        .frame(width: 40)
                    Button{
                        AudioServicesPlaySystemSound(1104)

                        if defaultGrade?.index == 14{
                            if let localDefaultGrade = defaultGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialPreviousGrade(grade: localDefaultGrade){
                                self.defaultGrade = nextAdjustedGrade
                            }
                        } else if defaultGrade?.index == 15 {
                            if let localDefaultGrade = defaultGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialNextGrade(grade: localDefaultGrade){
                                self.defaultGrade = nextAdjustedGrade
                            }
                        } else {
                            if let localDefaultGrade = defaultGrade,
                                let nextAdjustedGrade = gradeStore.getPreviousGrade(grade: localDefaultGrade){
                                self.defaultGrade = nextAdjustedGrade
                            }
                        }
                        
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.black, Color.init(hex: 0xEBECF0))
							.font(.system(size: size))
                    }

                    Text(defaultGrade?.name ?? "")
						.font(.system(size: size))
                        .fontWeight(.bold)
						.padding(.horizontal,5)

                    Button{
                        AudioServicesPlaySystemSound(1104)

                        if defaultGrade?.index == 14{
                            if let localDefaultGrade = defaultGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialPreviousGrade(grade: localDefaultGrade){
                                self.defaultGrade = nextAdjustedGrade
                            }
                        } else if defaultGrade?.index == 15 {
                            if let localDefaultGrade = defaultGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialNextGrade(grade: localDefaultGrade){
                                self.defaultGrade = nextAdjustedGrade
                            }
                        } else {
                            if let localDefaultGrade = defaultGrade,
                                let nextAdjustedGrade = gradeStore.getNextGrade(grade: localDefaultGrade){
                                self.defaultGrade = nextAdjustedGrade
                            }
                        }
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.black, Color.init(hex: 0xEBECF0))
							.font(.system(size: size))
                        //.offset(x:35)
                    }
                    Spacer()
                        .frame(width: 25)
                   
                }
                Spacer()
                    .frame(height: 40)
//                HStack{
//                    Toggle(isOn: $isPF, label: {
//                                Text("PASS OR FAIL COURSE")
//                            .font(.system(size: 15))
//                            .fontWeight(.bold)
//                            })
//                        .padding(.horizontal, 50)
//                        .onChange(of: isPF) { value in
//                            if !isPF{
//                                defaultGrade = gradeStore.getGradeWith(name: "A")
//                                if !isToggle{
//                                    isToggle.toggle()
//                                }
//                            } else{
//                                defaultGrade = gradeStore.getGradeWith(name: "Pass")
//                                if isToggle{
//                                    isToggle.toggle()
//                                }
//                            }
//                                }
//                   
//                }
//                Spacer()
//                    .frame(height: 25)
                HStack{
                    Toggle(isOn: $isToggle, label: {
                                Text("INCLUDE IN TERM GPA")
							.font(.system(size: 14))
							.fontWeight(.bold)
							.tracking(1.5)                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            })
                        .padding(.leading, 50)
                        .padding(.trailing, 70)
                    
                   
                }
                Spacer()
                    .frame(height: 20)
                    
                    if (!isToggle) {
                    Text("Note: Classes not included in GPA calculations will appear in italic font.")
                        .font(.system(size: 9))
                        .fontWeight(.bold)
                        .padding(.leading, 50)
                    }
                Spacer()
                    .frame(height: getFrame())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)      // << here !!
        .background(Color.white.edgesIgnoringSafeArea(.all))


//        .overlay(
//            HStack {
//                Spacer()
//                VStack {
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }, label: {
//                        Image(systemName: "xmark.circle.fill")
//							.font(.system(size: 24))
//                            .foregroundStyle(.white, .black)
//
//                    })
//					.padding(.trailing, 40)
//					.padding(.top, 85)
//
//
//                    Spacer()
//
//                }
//            }
//            )
            .background(Color.white.edgesIgnoringSafeArea(.all))

            .onAppear{
                defaultGrade = gradeStore.getGradeWith(name: "A")
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                    case .editGrades:
                        GradeView()
                        }
            }
        
            VStack{
                if !savePressed {
                    
                    Button(action: {
                        
                        if className.isEmpty {
                                                                
                            self.presentationMode.wrappedValue.dismiss()
                        }else {
                            self.presentationMode.wrappedValue.dismiss()
                            if let defaultGrade = defaultGrade,
                               let _ = gpaClassStore.create(name: className, includeInSemesterGPA: isToggle,  gradeID: defaultGrade.id , weight: credits, semesterID: currentSemester.id){
                                
                                savePressed = true
                                
								Amplitude.instance().logEvent("Class Created",
															  withEventProperties: ["Name": className,
																					"Grade" : defaultGrade.name,
																					"Credits" : credits.description])

                                
                            }
                        }
                    }
                    
                    ) {
                        
                        HStack {
                            Text("Save")
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                    
                        }
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding(.vertical,25)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                        }
                }
                

                    
            }
            .padding(.bottom, getFrameTwo())

//                Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
//                    Text("Save")
//                        .font(.system(size: 30))
//                        .fontWeight(.bold)
//                }
//                .padding()
//                .frame(width: 300, height: 70)
//                .foregroundColor(.white)
//                .background(Color.black)
//                .cornerRadius(18)
    }
}

extension AddClassView{
    func getFrameTwo() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 80
        }
        else{
            return 40
        }
    }
    
    func getFrame() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 20
        }
        else{
            return 100
        }
    }
    
    
    func openGrades() {
        activeSheet = .editGrades
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    enum Sheet: Identifiable {
        case editGrades
        
        var id: Int {
            hashValue
        }
        
    }
    
    
}




//struct AddClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddClassView()
//    }
//}

