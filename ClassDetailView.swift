//
//  EditClassView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/7/22.
//
import SwiftUI
import AVFoundation


struct ClassDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    @State private var showingAlert = false

    @State var assignments: [Assignment] = [
            Assignment(name: "Assignment 1", grade: 85, total: 100),
            Assignment(name: "Assignment 2", grade: 90, total: 100)
        ]
    
    
    @State private var isToggle : Bool = true
    @State private var isPF : Bool = false

    var existingClass: GPAClass
    
    @State var className = ""
    @State var credits: Double = 4
    @State var savePressed = false
    @State var activeSheet: Sheet?

    @State var currentGrade: Grade?
        
    var body: some View {
        VStack(alignment: .leading){
            
            Text("EDIT CLASS NAME")
                .font(.system(size: 14))
                .tracking(1.5)
                .fontWeight(.bold)
                .padding(.leading, 50)
                .padding(.bottom, 10)
            TextField(existingClass.name, text: $className)
            .padding(.all)
                .frame(width: 300, height: 60)
                .foregroundColor(.black)
                .background(Color.init(hex: 0xEBECF0))
                .cornerRadius(10)
                .padding(.bottom,5)
                .padding(.leading, 50)
                .padding(.trailing, 80)
            VStack (alignment: .leading){
                HStack{
                    Text("CREDITS")
                        .font(.system(size: 14))
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
                HStack (alignment: .center){
                    let size = 20.0

                    Text("CURRENT GRADE")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .tracking(1.5)
                        .foregroundColor(.black)
                        .frame(width: 140, height: 50, alignment: .leading)
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
                        .frame(width: 55)
                    Button{
                        AudioServicesPlaySystemSound(1104)
                        if currentGrade?.index == 14{
                            if let currentGrade = currentGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialPreviousGrade(grade: currentGrade){
                                self.currentGrade = nextAdjustedGrade
                            }
                        } else if currentGrade?.index == 15{
                            if let currentGrade = currentGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialNextGrade(grade: currentGrade){
                                self.currentGrade = nextAdjustedGrade
                            }
                        } else {
                            if let currentGrade = currentGrade,
                                let nextAdjustedGrade = gradeStore.getPreviousGrade(grade: currentGrade){
                                self.currentGrade = nextAdjustedGrade
                            }
                        }
                        
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.black, Color.init(hex: 0xEBECF0))
                            .font(.system(size: size))
                    }

                    Text(currentGrade?.name ?? "")
                        .font(.system(size: size))
                        .fontWeight(.bold)
                        .padding(.horizontal,5)
                Button{
                        AudioServicesPlaySystemSound(1104)
                        if currentGrade?.index == 14{
                            if let currentGrade = currentGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialPreviousGrade(grade: currentGrade){
                                self.currentGrade = nextAdjustedGrade
                            }
                        } else if currentGrade?.index == 15{
                            if let currentGrade = currentGrade,
                                let nextAdjustedGrade = gradeStore.getSpecialNextGrade(grade: currentGrade){
                                self.currentGrade = nextAdjustedGrade
                            }
                        } else {
                            if let currentGrade = currentGrade,
                                let nextAdjustedGrade = gradeStore.getNextGrade(grade: currentGrade){
                                self.currentGrade = nextAdjustedGrade
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.black, Color.init(hex: 0xEBECF0))
                            .font(.system(size: size))
                        //.offset(x:35)
                    }
                
                    
                
                }
                
//                HStack{
//                    Toggle(isOn: $isPF, label: {
//                                Text("PASS/FAIL COURSE")
//                            .font(.system(size: 15))
//                            .fontWeight(.bold)
//                            })
//                        .padding(.horizontal, 50)
//                        .onChange(of: isPF) { value in
//                            if !isPF{
//                                currentGrade = gradeStore.getGradeWith(name: "A")
//                                if !isToggle{
//                                    isToggle.toggle()
//                                }
//                            } else{
//                                currentGrade = gradeStore.getGradeWith(name: "Pass")
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
                    .frame(height: 10)
                
                    
            }
        }
        .padding(.top, 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)      // << here !!
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
        
                    .onAppear{
                        currentGrade = gradeStore.getGradeWith(gradeId: existingClass.gradeId)
                        className = existingClass.name
                        credits = existingClass.weight
                        // there is a bug here
                        if currentGrade?.index == 14 || currentGrade?.index == 15 {
                            isPF = true
                        }
                        isToggle = existingClass.includeInSemesterGPA
                    }
                    .sheet(item: $activeSheet) { sheet in
                        switch sheet {
                            case .editGrades:
                                GradeView()
                                }
                    }
                    .navigationBarTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .alert(isPresented: $showingAlert, content: {
                        Alert(
                                        title: Text("Confirm:"),
                                        message: Text("Are you sure you want to delete this class?"),
                                        primaryButton: .default(Text("Delete Class")) {
                                            deleteClass()
                                        },
                                        secondaryButton: .cancel(Text("Cancel")) {
                                            
                                        }
                                    )
                        })
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
                                Text(existingClass.name.uppercased())
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
                                   showingAlert = true
                                })
                                {
                                    Label("Delete Class", systemImage: "trash")
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
        VStack{
                if !savePressed {
                    
                    Button(action: {
                        
                        if className.isEmpty {
                                                                
                            self.presentationMode.wrappedValue.dismiss()
                        }else {
                            self.presentationMode.wrappedValue.dismiss()
//                            if let currentGrade = currentGrade{
//                               
//                                if currentGrade.index == 14 || currentGrade.index == 15 {
//                                    gpaClassStore.update(entryID: existingClass.id, name: className, note: "", gradeId: currentGrade.id, weight: credits, includeInSemesterGPA: isToggle)
//                                    
//                                    isPF = true
//                                    savePressed = true
//                                } else {
//                                    gpaClassStore.update(entryID: existingClass.id, name: className, note: "", gradeId: currentGrade.id, weight: credits, includeInSemesterGPA: isToggle)
//                                    
//                                    savePressed = true
//                                }
//                                
//                            }
                            
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
        }
}

struct Assignment: Identifiable {
    let id = UUID()
    var name: String
    var grade: Int
    var total: Int
}

extension ClassDetailView{
    
    func deleteClass() {
        gpaClassStore.delete(entryID: existingClass.id)
    }
    
    
    func getFrameTwo() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 80
        }
        else{
            return 40
        }
    }
    
    func getFrameThree() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 20
        }
        else{
            return 0
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
    
    enum Sheet: Identifiable {
        case editGrades
        
        var id: Int {
            hashValue
        }
        
    }
}
