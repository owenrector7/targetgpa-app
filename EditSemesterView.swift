//
//  AddClassView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/3/22.
//
import SwiftUI
import RealmSwift
import AVFoundation


struct EditSemesterView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    @State var showAddClassModalView: Bool = false
    @State var showClassDetailView: Bool = false

    @State private var isToggle : Bool = true
    @State var selectedColor = ColorOptionsEnum.Bluegray
    var existingSem: Semester
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

            
            HStack{
            Text("EDIT SEMESTER")
                .font((.system(size: 25, weight: .heavy)))
                .tracking(2)
                .foregroundColor(.black)
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
//                Spacer()
//                    .frame(height: 20)
            Text("SEMESTER NAME")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .tracking(1.5)
                    .fontWeight(.bold)
                    .padding(.leading, 50)
            Spacer()
                .frame(height: 10)
            TextField(existingSem.name, text: $semName)
            .padding(.all)
                .frame(width: 300, height: 60)
                .foregroundColor(.black)
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
                let currentSemesters = semesterStore.allSemesters.filter{ $0.endDate >= Date() }
                
                if currentSemesters.contains(existingSem) {
                    HStack{
                        DatePicker(selection: $endDate, in: Date().addingTimeInterval(86400)..., displayedComponents: .date)

                        { Text("END DATE")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .tracking(1.5)
                                .fontWeight(.bold)
                                .padding(.leading, 50)
                                .accentColor(.black)
                        }
                        .padding(.trailing, 100)
                    }
                    .foregroundColor(.black)
                    .accentColor(.black)
                } else {
                    HStack{
                        DatePicker(selection: $endDate, in: ...Date().addingTimeInterval(-86400), displayedComponents: .date)
                        { Text("END DATE")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .tracking(1.5)
                                .fontWeight(.bold)
                                .padding(.leading, 50)
                                .accentColor(.black)

                        }
                        .padding(.trailing, 100)
                    }
                    .foregroundColor(.black)
                    .accentColor(.black)
                }

                

                
                
//                if isPastSemester(endDate: endDate){
//                
//                    Spacer()
//                        .frame(height: 15)
//                    
//                    HStack{
//                        Text("CREDITS TAKEN TOWARD GPA")
//                                .font(.system(size: 16))
//                                .tracking(1.5)
//                                .fontWeight(.bold)
//                                .padding(.leading, 50)
//                                //.padding(.trailing, 50)
//                        Divider()
//                            .hidden()
//                        TextField(semTotalCredits.description, value: $semTotalCredits, formatter: numberFormatter)
//                        .padding(.all)
//                            .frame(width: 75, height: 40)
//                            .background(Color.init(hex: 0xEBECF0))
//                            .cornerRadius(10)
//                            //.padding(.leading, 50)
//                            .padding(.trailing, 60)
//                            .keyboardType(.decimalPad)
//
//                    }
//                    
//                    Spacer()
//                        .frame(height: 10)
//                    
//                    HStack{
//                        Text("FINAL GPA")
//                                .font(.system(size: 16))
//                                .tracking(1.5)
//                                .fontWeight(.bold)
//                                .padding(.leading, 50)
//                                //.padding(.trailing, 50)
//                        Spacer()
//                            .frame(width: 60)
//                        Divider()
//                            .hidden()
//                        TextField(semGPA.description, value: $semGPA, formatter: numberFormatter)
//                        .padding(.all)
//                            .frame(width: 75, height: 40)
//                            .background(Color.init(hex: 0xEBECF0))
//                            .cornerRadius(10)
//                            //.padding(.leading, 50)
//                            .padding(.trailing, 80)
//                            .keyboardType(.decimalPad)
//
//                    }
//                }

//                VStack{
////                    HStack{
////                        DatePicker(selection: $startDate, displayedComponents: .date)
////                        {
////                            Text("Start Date")
////                                .font(.system(size: 20))
////                                .fontWeight(.bold)
////                                .padding(.leading, 50)
////                        }
////                        .padding(.trailing, 100)
////                    }
////                    Spacer()
////                        .frame(height: 25)
//                    HStack{
//                        DatePicker(selection: $endDate, displayedComponents: .date)
//                        { Text("Semester End Date")
//                                .font(.system(size: 20))
//                                .fontWeight(.bold)
//                                .padding(.leading, 50)
//                        }
//                        .padding(.trailing, 100)
//                    }
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
                                    .foregroundColor(.black)
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
//                            Text("Semester Classes:")
//                                .font(.system(size: 18))
//                                .fontWeight(.bold)
//                                .padding(.leading, 40)
//                            Spacer()
//                                .frame(width: 157)
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
//                                      AddClassView(currentSemester: existingSem)
//                                    }
//                                Spacer()
//                                    .frame(height: 8)
//
//
//                        }
//                    }
//                    }
                    }
                    .sheet(isPresented: $showAddClassModalView) {
                        AddClassView(currentSemester: existingSem)
                        }
                Spacer()
                VStack{
                    if !savePressed {
                        
                        Button(action: {
                            
                            if semName.isEmpty {
                                //add later
                            }else {
                                self.presentationMode.wrappedValue.dismiss()
                                
                                if let _ = semesterStore.update(entryID: existingSem.id, name: semName, totalCredits: semTotalCredits, finalGPA: semGPA, startDate: startDate, endDate: endDate, color: selectedColor, includeInCumulativeGPA: isToggle){
                                    savePressed = true
                                    
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
                .padding(.bottom, getFrameTwo())
            
        }
        //}
        
        
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)      // << here !!
        .background(Color.white.edgesIgnoringSafeArea(.all))


        .onAppear{
            semName = existingSem.name
            startDate = existingSem.startDate
            endDate = existingSem.endDate
            semTotalCredits = existingSem.totalCredits
            semGPA = existingSem.finalGPA
            selectedColor = existingSem.color
            isToggle = existingSem.includeInCumulativeGPA
            
        }
    }
}

extension EditSemesterView {
    func getFrame() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 40
        }
        else{
            return 80
        }
    }
    
    func getFrameTwo() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 40
        }
        else{
            return 0
        }
    }
    
  func openClassDetail() {
    showClassDetailView.toggle()
  }
}

struct NewClassInSemesterFormViewTwo: View {
    
    
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

    
//struct AddSemesterView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSemesterView(presentationMode: <#T##Environment<Binding<PresentationMode>>#>, semester: <#T##SemesterDB#>)
//    }
//}

