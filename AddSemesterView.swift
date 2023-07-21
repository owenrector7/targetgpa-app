//
//  AddClassView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/3/22.
//
import SwiftUI
import RealmSwift
import StoreKit
import AVFoundation


struct AddSemesterView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var settingsStore : SettingsStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    @State private var showingAlert = false
    @State private var showNewAlert = false

    
    @State var showAddClassModalView: Bool = false
    @State var showClassDetailView: Bool = false

    @State private var isToggle : Bool = true
    @State var selectedColor = ColorOptionsEnum.Bluegray
    @State var semName = ""
    @State var semTotalCredits = 0
    @State var semGPA = 0.0
    @State var startDate = Date()
    @State var endDate = Date()
    @State var showDatePicker: Bool = false
    @State var savePressed = false
	@State var newSem: Semester?
    
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
        
    var body: some View {
        
        
        //ScrollView{
        VStack(alignment: .leading){
            
            Text(isPastSemester(endDate:endDate) ? "ADD PAST SEMESTER" : "ADD SEMESTER")
                    .font((.system(size: 25, weight: .heavy)))
                    .tracking(2)
                    .foregroundColor(.primary)
                    .padding(.leading, 50)
                    .padding(.top, 80)
                    .padding(.bottom, 50)
            
                    
			
            
				
                //let semesterClasses = gpaClassStore.getAllClassesFor(semesterID: newSemester.id)
            
                VStack(alignment: .leading){
                    
                    Text("SEMESTER NAME")
                            .font(.system(size: 14))
                            .tracking(1.5)
                            .fontWeight(.bold)
                            .padding(.leading, 50)
                    Spacer()
                        .frame(height: 10)
                    TextField(isPastSemester(endDate: endDate) ? "Ex. Spring 2023" : "Ex Fall 2022", text: $semName)
					.padding(.all)
						.frame(width: 300, height: 60)
						.background(Color.init(hex: 0xEBECF0))
						.cornerRadius(10)
						.padding(.bottom,20)
						.padding(.leading, 50)
						.padding(.trailing, 80)
					Spacer()
						.frame(height: 20)
                    VStack(alignment: .leading){
	//                    HStack{
	//                        DatePicker(selection: $startDate, displayedComponents: .date)
	//                        {
	//                            Text("Start Date")
	//                                .font(.system(size: 20))
	//                                .fontWeight(.bold)
	//                                .padding(.leading, 50)
	//                        }
	//                        .padding(.trailing, 100)
	//                    }
	//                    Spacer()
	//                        .frame(height: 25)
                        if semesterStore.allSemesters.count >= 1 {
                            HStack{
                                DatePicker(selection: $endDate, in: ...Date().addingTimeInterval(-86400), displayedComponents: .date)
                                { Text("END DATE")
                                        .font(.system(size: 16))
                                        .tracking(1.5)
                                        .fontWeight(.bold)
                                        .padding(.leading, 50)
                                }
                                .padding(.trailing, 100)
                            }
                        } else {
                            HStack{
                                DatePicker(selection: $endDate, in: Date().addingTimeInterval(86400)..., displayedComponents: .date)
                                { Text("END DATE")
                                        .font(.system(size: 16))
                                        .tracking(1.5)
                                        .fontWeight(.bold)
                                        .padding(.leading, 50)
                                }
                                .padding(.trailing, 100)
                            }
                        }
                        
                        
//                        if isPastSemester(endDate: endDate){
//                        
//                            Spacer()
//                                .frame(height: 15)
//                            
//                            HStack{
//                                Text("CREDITS TAKEN TOWARD GPA")
//                                        .font(.system(size: 16))
//                                        .tracking(1.5)
//                                        .fontWeight(.bold)
//                                        .padding(.leading, 50)
//                                        .padding(.trailing, 50)
//                                Divider()
//                                    .hidden()
//                                TextField(semTotalCredits.description, value: $semTotalCredits, formatter: numberFormatter)
//                                .padding(.all)
//                                    .frame(width: 75, height: 40)
//                                    .background(Color.init(hex: 0xEBECF0))
//                                    .cornerRadius(10)
//                                    //.padding(.leading, 50)
//                                    .padding(.trailing, 60)
//                                    .keyboardType(.decimalPad)
//
//                            }
//                            
//                            Spacer()
//                                .frame(height: 10)
//                            
//                            HStack{
//                                Text("FINAL GPA")
//                                        .font(.system(size: 16))
//                                        .tracking(1.5)
//                                        .fontWeight(.bold)
//                                        .padding(.leading, 50)
//                                        .padding(.trailing, 50)
//                                Spacer()
//                                    .frame(width: 60)
//                                Divider()
//                                    .hidden()
//                                TextField(semGPA.description, value: $semGPA, formatter: numberFormatter)
//                                .padding(.all)
//                                    .frame(width: 75, height: 40)
//                                    .background(Color.init(hex: 0xEBECF0))
//                                    .cornerRadius(10)
//                                    //.padding(.leading, 50)
//                                    .padding(.trailing, 80)
//                                    .keyboardType(.decimalPad)
//
//                            }
//                        }
                        
						Spacer()
							.frame(height: 30)
						VStack(alignment: .leading) {
							Text("COLOR")
								.font(.system(size: 16))
								.foregroundColor(.black)
								.tracking(1.5)
								.fontWeight(.bold)
								.padding(.leading, 50)

							let gI = GridItem(.flexible())
							let  gridItemLayout = [gI, gI, gI, gI, gI, gI,gI]


							LazyVGrid(columns: gridItemLayout, spacing: 7 ) {
								ForEach(ColorOptionsEnum.allCases, id: \.self) {  (i) in

									Button(action: {
										selectedColor = i
									}) {
											ZStack {
											Circle()
													.fill(i.darkColor())
													
											Circle()
													.strokeBorder(.gray, lineWidth: 3)
													.opacity(i == selectedColor ? 1 : 0)
										}
										.frame(width: 30, height: 30)
									}
								}
							}
							.padding(.bottom,10)
							.padding(.leading, 45)
							.padding(.trailing, 45)
							.gesture(TapGesture().onEnded { _ in
								
							})

						}
					}
	//                    HStack{
	//                        Text("Color")
	//                            .font(.system(size: 20))
	//                            .fontWeight(.bold)
	//                            .frame(minWidth: 0, maxWidth: 350, minHeight: 5, maxHeight: 60, alignment: .leading)
	//
	//
	//                    }
						Spacer()
							.frame(height: 25)
						VStack(){
	                        HStack{
	                            Toggle(isOn: $isToggle, label: {
	                                        Text("INCLUDE IN GPA CALCULATIONS")
	                                    .font(.system(size: 14))
	                                    .fontWeight(.bold)
	                                    })
	                                .padding(.horizontal, 50)
	
	
	                        }
							Spacer()
								.frame(height: 35)
	//                        HStack{
	//                            Text("Add Semester Classes:")
	//                                .font(.system(size: 18))
	//                                .fontWeight(.bold)
	//                                .padding(.leading, 50)
	//                            Spacer()
	//                                .frame(width: 40)
	//                            Button {
	//                            action: do {showAddClassModalView = true}
	//                            } label: {
	//                                Image(systemName: "plus.circle.fill")
	//                                    .foregroundStyle(.white, .black)
	//                                    .font(.system(size: 32))
	//                            }
	//                        }
							Spacer()
								.frame(height: 10)
	//                        ScrollView{
	//                        VStack{
	//
	//                            ForEach(Array(semesterClasses.enumerated()), id: \.element){index, aClass in
	//
	//                                Button(action: openClassDetail) {
	//                                    NewClassInSemesterFormView(currentClass: aClass)
	//                                }
	//
	//                                .sheet(isPresented: $showClassDetailView) {
	//                                      AddClassView(currentSemester: newSemester)
	//                                    }
	//                                Spacer()
	//                                    .frame(height: 8)
	//
	//
	//                        }
	//                    }
	//                    }
						}
//						.sheet(isPresented: $showAddClassModalView) {
//							AddClassView(currentSemester: newSemester)
//							}

				
			}
				
				Spacer()
				VStack{
					if !savePressed {
						
						Button(action: {
                            
//                            if !isPastSemester(endDate: endDate){
//                                showNewAlert = true
//                            }
							
							if semName.isEmpty {
								
								showingAlert = true
								
								self.presentationMode.wrappedValue.dismiss()
								//semesterStore.delete(entryID: newSemester.id)
							}else {
								self.presentationMode.wrappedValue.dismiss()
								
                                if let _ =  semesterStore.create(name: semName, totalCredits: semTotalCredits, finalGPA: semGPA, startDate: Date(), endDate: endDate, color: selectedColor, includeInCumulativeGPA: isToggle){
                                    
                                    if isPastSemester(endDate: endDate) {
                                        settingsStore.initialGPA = 0
                                        settingsStore.initialTotalCredits = 0
                                    }
									
									//savePressed = true
									
								}
							}
						}
						) {
							
							HStack {
								Text("Save")
									.font(.system(size: 22))
									.fontWeight(.bold)
								
							}
							.frame(minWidth: 0, maxWidth: 320)
							.padding(.vertical,25)
							.foregroundColor(.white)
							.background(Color.black)
							.cornerRadius(10)
						}
					}
				}
				.padding(.horizontal, 45)

        //}
                
        
			//}
        }
		.frame(maxHeight: .infinity, alignment: .leading)
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        //semesterStore.delete(entryID: newSem?.id ?? 0)
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.black)
							.frame(width: 100, height: 100)

                    })
                    .padding(.trailing, 40)
                    .padding(.top, 85)
                    
                    Spacer()
                    
                }
            }
            )
        .alert(isPresented: $showNewAlert, content: {
                Alert(
                    title: Text("You have already added a current semester."),
                    message: Text("Add a name to distinguish semesters from one another."),
                    primaryButton: .default(
                        Text("Continue"),
                        action: dismissSem

                    ),
                    secondaryButton: .destructive(
                        Text("Cancel")
                    )
                )
            })

		.onAppear{
		
//			// Only create a new semester object if one does not already exist.
//			if newSem == nil {
//                newSem = semesterStore.create(name: "", totalCredits: 0, finalGPA: 0, startDate: Date(), endDate: Date(), color: ColorOptionsEnum.Rouge, includeInCumulativeGPA: isToggle)
//			}
		}
    }
}

extension AddSemesterView {
    func dismissSem() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
  func openClassDetail() {
    showClassDetailView.toggle()
  }
}

struct NewClassInSemesterFormView: View {
    
    
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var gpaClassStore : GPAClassStore
    
    @State var currentClass: GPAClass
    
    var body: some View {
        HStack{
            Text(currentClass.name)
                    .fontWeight(.medium)
                    .frame(width: 140, alignment: .leading)
                    .padding(.leading, 48)
                    .foregroundColor(.black)
            }
               
            
        }
    }

 
