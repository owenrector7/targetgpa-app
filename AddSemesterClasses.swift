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
import Amplitude


struct AddSemesterClasses: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var settingsStore : SettingsStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    @State private var showingAlert = false
    @State private var showNewAlert = false
    
    @Binding  var selectedTabNew : Int
    @Binding  var newSemesterTwo : Semester?
    
    @State var showAddClassModalView: Bool = false
    @State var showClassDetailView: Bool = false

    @State private var isToggle : Bool = true
    @State var selectedColor = ColorOptionsEnum.Bluegray
    @State var semName = ""
    @State var semTotalCredits = 0
    @State var semGPA = 0.0
    @State var startDate = Date()
    @State var endDate = Date().addingTimeInterval(5184000)
    @State var endDatePast = Date().addingTimeInterval(-5184000)
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
            
            let currentSemesters = semesterStore.allSemesters.filter{ $0.endDate >= Date() }
            
            let pastSemesters = semesterStore.allSemesters.filter{ $0.endDate < Date() }
            
            HStack{
                
            
            Text("ADD SEMESTER")
                    .font((.system(size: 25, weight: .heavy)))
                    .tracking(2)
                    .foregroundColor(.primary)
                    .padding(.leading, 50)
                    .padding(.top, getFrame())
                    .padding(.bottom, 50)
                
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.white, .black)
                    .padding(.top, getFrame())
                    .padding(.bottom, 50)
                    .padding(.leading, 70)
            })
            
            }
            
            
                
                //let semesterClasses = gpaClassStore.getAllClassesFor(semesterID: newSemester.id)
            
                VStack(alignment: .leading){
                    
                    Text("SEMESTER NAME")
                            .font(.system(size: 14))
                            .tracking(1.5)
                            .fontWeight(.bold)
                            .padding(.leading, 50)
                    Spacer()
                        .frame(height: 10)
                    TextField(isPastSemester(endDate: endDate) ? "Ex. Spring 2022" : "Ex Fall 2022", text: $semName)
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
                        
                        if let newSemesterTwo = newSemesterTwo{
                            
                        } else {
                        
                            if currentSemesters.count == 0 {
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
                                .accentColor(.black)  // << this one !!

                            } else {
                                HStack{
                                    DatePicker(selection: $endDatePast, in: ...Date().addingTimeInterval(-86400), displayedComponents: .date)
                                    { Text("END DATE")
                                            .font(.system(size: 16))
                                            .tracking(1.5)
                                            .fontWeight(.bold)
                                            .padding(.leading, 50)
                                    }
                                    .padding(.trailing, 100)
                                }
                                .accentColor(.black) 
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
                            Text("Color")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
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
                    VStack(alignment: .leading){
                            HStack{
                                Toggle(isOn: $isToggle, label: {
                                            Text("INCLUDE IN GPA CALCULATIONS")
                                        .font(.system(size: 14))
                                        .fontWeight(.bold)
                                        })
                                    .padding(.horizontal, 50)
    
    
                            }
                        Spacer()
                            .frame(height: 20)
                            
                            if (!isToggle) {
                            Text("Note: Terms not included in GPA calculations will appear in italic font.")
                                .font(.system(size: 9))
                                .fontWeight(.bold)
                                .padding(.leading, 50)
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
//                        .sheet(isPresented: $showAddClassModalView) {
//                            AddClassView(currentSemester: newSemester)
//                            }

                
            }
                
                Spacer()
                VStack{
                    
                    if !semName.isEmpty {
                        if let newSemesterTwo = newSemesterTwo {
                            Button("Update"){
                                
                                guard !semName.isEmpty else { showingAlert = true
                                    return }
                                
                                hideKeyboard()
                            
                                if currentSemesters.count == 1 && pastSemesters.count == 0 {
                                    _ = semesterStore.update(entryID: newSemesterTwo.id, name: semName, totalCredits: semTotalCredits, finalGPA: semGPA, startDate: Date(), endDate: endDate, color: newSemesterTwo.color, includeInCumulativeGPA: true)
                                } else {
                                    _ = semesterStore.update(entryID: newSemesterTwo.id, name: semName, totalCredits: semTotalCredits, finalGPA: semGPA, startDate: Date(), endDate: endDatePast, color: newSemesterTwo.color, includeInCumulativeGPA: true)
                                }

                            withAnimation {
                                self.selectedTabNew = 1
                                //impactSoft.impactOccurred()

                            }
                            
                        }.padding(.vertical,isIphone() ? 15 : 25)
                            .padding(.horizontal,isIphone() ? 100 : 130)
                            .font((.system(size: isIphone() ? 24 : 30,
                                           weight: .semibold)))
                            .background( Color(UIColor(hex: "#0xF97962")!))
                            .cornerRadius(14)
                            .foregroundColor(.black)
                        } else {
                        Button("Create Semester"){
                            
                            guard !semName.isEmpty else { showingAlert = true
                                return }
                            
                            hideKeyboard()
                            
                            if currentSemesters.count == 0 {
                                newSemesterTwo = semesterStore.create(name: semName, totalCredits: semTotalCredits, finalGPA: semGPA, startDate: Date(), endDate: endDate, color: selectedColor, includeInCumulativeGPA: isToggle)
                                
                            } else{
                                newSemesterTwo = semesterStore.create(name: semName, totalCredits: semTotalCredits, finalGPA: semGPA, startDate: Date(), endDate: endDatePast, color: selectedColor, includeInCumulativeGPA: isToggle)
                                
                                settingsStore.initialGPA = 0
                                settingsStore.initialTotalCredits = 0
                            }
                            
							Amplitude.instance().logEvent("Term Created", withEventProperties: ["Name": semName])
							
                
                            withAnimation {
                                self.selectedTabNew = 1
                                //impactSoft.impactOccurred()

                            }
                            
                        }.padding(.vertical,isIphone() ? 15 : 25)
                                .frame(alignment: .bottom)
                            .padding(.horizontal,isIphone() ? 70 : 100)
                            .font((.system(size: isIphone() ? 24 : 30,
                                           weight: .semibold)))
                            .background(semName.isEmpty ? settingsStore.lightGray : Color(UIColor(hex: "#0xF97962")!))
                            .cornerRadius(18)
                            .foregroundColor(.black)
                    }
                    }
                    
                        
//                        Button(action: {
//
//
//
////                            if !isPastSemester(endDate: endDate){
////                                showNewAlert = true
////                            }
//
//                            if semName.isEmpty {
//
//                                showingAlert = true
//
//                                //self.presentationMode.wrappedValue.dismiss()
//                                //semesterStore.delete(entryID: newSemester.id)
//                            }else {
//                                //self.presentationMode.wrappedValue.dismiss()
//
//
//                                newSemesterTwo =  semesterStore.create(name: semName, totalCredits: semTotalCredits, finalGPA: semGPA, startDate: Date(), endDate: endDate, color: selectedColor, includeInCumulativeGPA: isToggle)
//
//                                    if isPastSemester(endDate: endDate) {
//                                        settingsStore.initialGPA = 0
//                                        settingsStore.initialTotalCredits = 0
//                                    }
//
//                                withAnimation {
//                                    self.selectedTabNew = 1
//                                    //impactSoft.impactOccurred()
//
//                                }
//                                    //savePressed = true
//
//
//                            }
//                        }
//                        ) {
//
//                            HStack {
//                                Text("Create Semester")
//                                    .font(.system(size: 22))
//                                    .fontWeight(.bold)
//
//                            }
//                            .frame(minWidth: 0, maxWidth: 320)
//                            .padding(.vertical,25)
//                            .foregroundColor(.black)
//                            .background(Color(UIColor(hex: "#0xF97962")!))
//                            .cornerRadius(10)
//                        }
                    
                }
                .padding(.bottom, 15)
                .padding(.horizontal, 45)

        //}
                
        
            //}
        }
        .frame(maxHeight: .infinity, alignment: .leading)
//        .overlay(
//            HStack {
//                Spacer()
//                VStack {
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }, label: {
//
//						Image(systemName: "xmark.circle.fill")
//							.font(.system(size: 24))
//                            .foregroundColor(.black)
//                    })
//                    .padding(.trailing, 40)
//                    .padding(.top, 75)
//
//
//                    Spacer()
//
//                }
//            }
//            )
        .alert(isPresented: $showingAlert, content: {
                Alert(
                    title: Text("Add a Semester name before continuing."),
                    message: Text(""),
                    primaryButton: .default(
                        Text("Continue")
                        //action: dismissSem

                    ),
                    secondaryButton: .destructive(
                        Text("Cancel")
                    )
                )
            })

        .onAppear{
        
//            // Only create a new semester object if one does not already exist.
//            if newSem == nil {
//                newSem = semesterStore.create(name: "", totalCredits: 0, finalGPA: 0, startDate: Date(), endDate: Date(), color: ColorOptionsEnum.Rouge, includeInCumulativeGPA: isToggle)
//            }
        }
    }
}

extension AddSemesterClasses {
    
    func getFrame() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 40
        }
        else{
            return 80
        }
        
    }
    
    
    func dismissSem() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
  func openClassDetail() {
    showClassDetailView.toggle()
  }
}


 
