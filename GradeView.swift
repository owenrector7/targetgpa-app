//
//  GradeView.swift
//  GPA-Plus
//
//  Created by Owen Rector on 7/7/22.
//

import SwiftUI

struct GradeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    @State var defaultGrade: Grade?
    
    init() {
               let navBarAppearance = UINavigationBar.appearance()
               navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
               navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
             }

    var body: some View {
        
        let gradesArray = gradeStore.allGrades[0...12]
        NavigationView{
            Form {
                Section(header: Text("Edit Grade Scale")) {
                
            ForEach(gradesArray){ aGrade in
                
                GradeCardView(defaultGrade: aGrade, gradeValue: aGrade.value)
                
            }
            
            
            Spacer()
                .frame(height: 15)
        }
            }
            .environment(\.colorScheme, .light)

            //.background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text("Grade Scale"))
            .navigationBarHidden(false)
        }
        
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        
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
    }
    
}

struct GradeCardView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    @State var defaultGrade: Grade
    
    @State var gradeValue: Double = 0.0
    
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
        
    var body: some View {
        HStack{
            Text(defaultGrade.name)
                .frame(maxWidth: 30, alignment: .leading) 
            Spacer()
                .frame(width: 65)
            Text("\(gradeValue, specifier: "%.2f")")
                .font(Font.body.bold())
                .multilineTextAlignment(.leading)
                .keyboardType(.decimalPad)
                .frame(minWidth: 10, maxWidth: 48)
//            TextField("", value: $gradeValue, formatter: numberFormatter)
//                            .font(Font.body.bold())
//                            .multilineTextAlignment(.leading)
//                            .keyboardType(.decimalPad)
//                            .frame(minWidth: 10, maxWidth: 48)
            Spacer()
            Stepper {
                Text("\(gradeValue)")
                    } onIncrement: {
                        incrementStep()
                        gradeStore.update(entryID: defaultGrade.id, name: defaultGrade.name, value: gradeValue)
                    } onDecrement: {
                        decrementStep()
                        gradeStore.update(entryID: defaultGrade.id, name: defaultGrade.name, value: gradeValue)
                    }
                            .labelsHidden()
                            .multilineTextAlignment(.trailing)
        }

//            HStack{
//
//                Text(defaultGrade.name)
//                    .frame(width: 30, alignment: .leading)
//                    .padding(.horizontal, 105)
//                Spacer()
//                    .frame(width: -45)
//                TextField(defaultGrade.value.description, text: $gradeValue)
//                    .keyboardType(.decimalPad)
//
//                //this should be text field ^^, and should pull track edited value in defaultGrade.value property
//                    .frame(alignment: .leading)
//            }
        
    }
    
    
    func incrementStep() {
        gradeValue += 0.01
            
        }
    
    func decrementStep() {
        
        if gradeValue <= 0 {
            gradeValue = 0
        } else {
            gradeValue -= 0.01
        }
        }

}

