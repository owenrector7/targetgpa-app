//
//  Onboarding.swift
//  SwiftUIStacks
//
//  Created by Jenny Talavera on 9/28/21.
//

import SwiftUI
import Amplitude
//import Kingfisher


struct AddSemesterClassesTwo: View {
        
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode


    @State private var showingAlert = false
    @State var showAddClassModalView: Bool = false
    @State var showClassDetailView: Bool = false
    @Binding  var selectedTabNew : Int
    @Binding  var newSemesterTwo : Semester?
    @State var activeSheet: SheetTwo?
    
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var gradeStore: GradeStore
    
    @State var selectedIndex: Int = 0

    
    @State var allClass: Array = []
    
    var body: some View {
        
        
        ZStack{
            ScrollView{

                
                VStack(alignment: .center, spacing: 3) {

                    
//                        Image("SplashIcon")
//                            .resizable()
//                            .aspectRatio( contentMode: .fit)
//                            .frame(width: isIphone() ? 50 : 60, alignment: .center)
//                            .padding(.top,isIphone() ? 50 : 70)
//
//
//
//                        Text("STEP 2 OF 3")
//                            .font((.system(size:  isIphone() ? 15 : 20, weight: .bold)))
//                            .tracking(2)
//                            .padding(.top, 10)
//                            .padding(.bottom, 2)
//                        
                        Text("Add Classes")
                            .font((.system(size: getTitleFontSize(), weight: .heavy)))
                            .padding(.horizontal,isIphone() ? (DeviceTypeSize.IS_IPHONE_MINI ? 20 : 30)
                                     : 60)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 15)
                            .padding(.top, 50)

                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Add each of this semester's classes and current grades.")
                            .font((.system(size: getSubHeadFontSize(), weight: .light  )))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,65)
                            .padding(.bottom,15)
                        Spacer()
                            .frame(height: 30)
                        VStack{
                            HStack{
                                Text("CLASS")
                                    .font(.system(size: 13))
                                    .tracking(1.5)
                                    .fontWeight(.bold)
                                    .padding(.leading, 0)
                                Spacer()
                                
                                Text("GRADE")
                                    .font(.system(size: 13))
                                    .tracking(1.5)
                                    .fontWeight(.bold)
                                    .padding(.leading, 32)
                            
                                Spacer()
                                Button {
                                    action: do {
                                        
                                        if  newSemesterTwo != nil {
                                        
                                            activeSheet = .addClass
                                        } else {
                                            showingAlert = true
                                        }
                                        
                                        
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.black, Color(UIColor(hex: "#0xF97962")!))
                                        .font(.system(size: 22))
                                }
                            
                            }
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 0.25, dash: [2]))
                            .frame(height: 1)
                            .padding(.vertical, 1)
                        
                        ScrollView{
                            VStack(alignment: .leading){
                            
                                if let newSemesterTwo = newSemesterTwo {
                                    
                                    let semesterClasses = gpaClassStore.getAllClassesFor(semesterID: newSemesterTwo.id)

                                    ForEach(Array(semesterClasses.enumerated()), id: \.element){index, aClass in
                                        

                                        ClassCardViewTwo(currentClass: aClass)
    //                                    HStack{
    //                                        Text(aClass.name)
    //                                            .font(.system(size: 18))
    //                                            .frame(maxWidth: 150, alignment: .leading)
    //                                        Divider()
    //                                            .hidden()
    //                                        let localGrade = gradeStore.getGradeWith(gradeId: aClass.gradeId)
    //                                        Text(localGrade?.name ?? "A")
    //                                            .font(.system(size: 18))
    //                                            .frame(maxWidth: 50, alignment: .leading)
    //                                        Spacer()
    //
    //                                        Button {
    //                                        action: do {
    //                                            gpaClassStore.delete(entryID: aClass.id)
    //
    //                                        }
    //                                        } label: {
    //                                            Image(systemName: "x.circle")
    //                                                .foregroundStyle(.black, .black)
    //                                                .font(.system(size: 22))
    //                                        }
    //
    //                                    }.onTapGesture {
    //                                        activeSheet = .editClass
    //                                        print("tapped")
    //                                    }
                                        

    //                                    .sheet(isPresented: $showClassDetailView) {
    //                                          AddClassView(currentSemester: newSemester)
    //                                        }
                                        Spacer()
                                            .frame(height: 8)

                                    }
                                }
                            }
                            
                        
                        }
                        .frame(minHeight: getFrame())
                        Spacer()
                        VStack{
                            //if !savePressed {
                                
                                Button(action: {
                                    
                                    withAnimation {
                                        self.presentationMode.wrappedValue.dismiss()
                                        //self.selectedTabNew = 3
                                        //impactSoft.impactOccurred()
                                    }
                                    
                                    })
                                
                                 {
                                    
                                    HStack {
                                        Text("Save")
                                            .font(.system(size: 22))
                                            .fontWeight(.bold)
                                        
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .padding(.vertical,10)
                                    .padding(.horizontal, 70)
                                    .foregroundColor(.black)
                                    .background(Color(UIColor(hex: "#0xF97962")!))
                                    .cornerRadius(10)
                                }
                            //}
                        }
                        .padding(.horizontal, 5)


//                                Button("Save") {
//
//                                    withAnimation {
//                                        self.presentationMode.wrappedValue.dismiss()
//                                        //self.selectedTabNew = 3
//                                        //impactSoft.impactOccurred()
//                                    }
//
//                                }.padding(.vertical,isIphone() ? 15 : 25)
//                                    .padding(.horizontal,isIphone() ? 70 : 100)
//                                    .font((.system(size: isIphone() ? 24 : 30,
//                                                   weight: .semibold)))
//                                    .background(Color(UIColor(hex: "#0xF97962")!))
//                                    .cornerRadius(18)
//                                    .foregroundColor(.black)
//                                    .padding(.top, 20)
                            
                        
                        }.padding(.horizontal,50)
                        
                
                    
                }
            }
        }
        .padding(.bottom, 0)

        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        //semesterStore.delete(entryID: newSem?.id ?? 0)
                    }, label: {
						Image(systemName: "xmark.circle.fill")
							.font(.system(size: 24))
                            .foregroundColor(.black)
                    })
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                }
            }
            )
        .onAppear{
            
//            if let newSemester = newSemester {
//                let classes = gpaClassStore.getAllClassesFor(semesterID: newSemester.id)
//                allClass.append(contentsOf: classes)
//
//
//            }
            
            
        }
        .padding(.bottom,5)
        .alert(isPresented: $showingAlert, content: {
            Alert(
                title: Text(newSemesterTwo == nil ? "You must first create a Semester on the previous screen." : "")
            )
        })
       
        .sheet(item: $activeSheet) { sheet in
              switch sheet {
              case .addClass:
                  if let newSemesterTwo = newSemesterTwo{
                      AddClassView(currentSemester: newSemesterTwo)
                          .preferredColorScheme(.light)
                  }
              case .editClass:
                  if let newSemesterTwo = newSemesterTwo {
                    let semesterClassesLocal = gpaClassStore.getAllClassesFor(semesterID: newSemesterTwo.id)
                      EditClassView(existingClass: semesterClassesLocal[selectedIndex])
                  }
                  }
              
            }

        
        
//        .sheet(isPresented: $showAddClassModalView) {
//
//            if let newSemester = newSemester {
//                AddClassView(currentSemester: newSemester)
//            }
//            }
    }
    
    func getFrame() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 295
        }
        else{
            return 355
        }
        
    }
    

    func getSubHeadFontSize() -> CGFloat {
        
        if isIphone() {
            if DeviceTypeSize.IS_IPHONE_8_SE_SIZED {
                return 18
            }
            else if  DeviceTypeSize.IS_IPHONE_MINI {
                return 18
            }
            else{
                return 22
            }
        }else{
            return 30
        }
    }
    
    func getTitleFontSize() -> CGFloat {
        
        if isIphone() {
            if DeviceTypeSize.IS_IPHONE_8_SE_SIZED {
                return 26
            }else{
                return 40
            }
        }else{
            return 45
        }
    }
    
    func openClassDetail() {
      showClassDetailView.toggle()
    }
    
    
    struct SuperCustomTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<_Label>) -> some View {
            configuration
                .padding()
                .multilineTextAlignment(.center)
                .border(Color.gray)
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


}

enum SheetTwo: Identifiable {
    case addClass
    case editClass
    
    var id: Int {
        hashValue
    }
    
}





struct ClassCardViewTwo: View {
    
    
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var gpaClassStore : GPAClassStore
    
    @State var currentClass: GPAClass
    //@State var currentSemester: Semester
    //@Binding var selectedClass: GPAClass?
    @State var activeSheet: Sheet?
    //@State var semesterColor: ColorOptionsEnum
    //@State var importantColor: Color
    //@Binding var adjustedCurrentClass: GPAClass
        
    //@Binding var gpaNeeded: Double
    //var mainGrade: Grade
    //@State var adjustedGrade: Grade
    
    var body: some View {
        HStack{
            Text(currentClass.name)
                .font(.system(size: 18))
                .frame(maxWidth: 150, alignment: .leading)
            Divider()
                .hidden()
            let localGrade = gradeStore.getGradeWith(gradeId: currentClass.gradeId)
            Text(localGrade?.name ?? "A")
                .font(.system(size: 18))
                .frame(maxWidth: 50, alignment: .leading)
            Spacer()
        
            Button {
            action: do {
                gpaClassStore.delete(entryID: currentClass.id)
        
            }
            } label: {
                Image(systemName: "x.circle")
                    .foregroundStyle(.black, .black)
                    .font(.system(size: 22))
            }
        
        }.onTapGesture {
            activeSheet = .editClass
            print("tapped")
        }
        
        
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
                case .editClass:
                    EditClassView(existingClass: currentClass)
                case .addClass:
                    EditClassView(existingClass: currentClass)
                    
                
                    
                    
                
            
            }
        }
    }
}

