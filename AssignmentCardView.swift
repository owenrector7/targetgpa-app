//
//  AssignementCard.swift
//  GPA-Plus
//
//  Created by Jenny Talavera on 1/15/23.
//

import SwiftUI
import RealmSwift
import Amplitude


struct AssignmentCardView: View {
	
	
	@EnvironmentObject var calculationManager : CalculationManager
	
	
	@EnvironmentObject var gradeStore : GradeStore
	@EnvironmentObject var gpaClassStore : GPAClassStore
	@EnvironmentObject var assignmentStore : AssignmentStore
	
	
	@State var currentClass: GPAClass
	@State var currentSemester: Semester
	//@Binding var selectedClass: GPAClass?
	//@State var semesterColor: ColorOptionsEnum
	@State var importantColor: Color
	@State var assignmentName = ""
	@State var assignmentPercent = ""
	@State var assignmentWeight = ""
	@State var index: Int
	@State var currentAssignment: ClassAssignment
	@State var isEditing = false
    
    @State var showingAlertAssignment = false
    
    @State var existingClass: GPAClass
	
	@ObservedObject var classG : ClassGrade_ObsObject
	
	@Binding var classAssignments : [ClassAssignment]
	
	//@ var adjustedCurrentClass: GPAClass
	
	//@Binding var gpaNeeded: Double
	//var mainGrade: Grade
	//@State var adjustedGrade: Grade
	
	
	
	var body: some View {
		
		
		HStack(spacing: 20) {
			
			TextField("Ex. HW", text: self.$currentAssignment.name)
				.multilineTextAlignment(.leading)
				.padding(.all)
				.frame(width: UIScreen.screenWidth / 4, height: 40, alignment: .leading)
                .foregroundColor(.black)
				.background(Color.init(hex: 0xEBECF0))
				.cornerRadius(10)
				.offset(x: -18)
				.onTapGesture {
					isEditing = true
				}
			TextField("0", value: self.$currentAssignment.gradePercent, formatter: NumberFormatter())
				.multilineTextAlignment(.center)
				.padding(.all)
				.keyboardType(.decimalPad)
				.frame(width: UIScreen.screenWidth / 5, height: 40, alignment: .leading)
                .foregroundColor(.black)
				.background(Color.init(hex: 0xEBECF0))
				.cornerRadius(10)
				.offset(x: -12)
				.onTapGesture {
					isEditing = true
				}
			
			TextField("0", value: self.$currentAssignment.gradeWeight, formatter: NumberFormatter())
				.multilineTextAlignment(.center)
				.padding(.all)
				.keyboardType(.decimalPad)
				.frame(width: UIScreen.screenWidth / 5, height: 40, alignment: .leading)
                .foregroundColor(.black)
				.background(Color.init(hex: 0xEBECF0))
				.cornerRadius(10)
				.offset(x: 0)
				.onTapGesture {
					isEditing = true
				}
			
			Button(action: {
				
				if isEditing{
					
					updateAssigment(entryId: currentAssignment.id, name: currentAssignment.name, gradeWeight: currentAssignment.gradeWeight, gradePercent: currentAssignment.gradePercent)
                    
                    Amplitude.instance().logEvent("Assignment Updated: " + currentAssignment.name + "-" + currentAssignment.gradePercent.description + "%")
                    
					
				} else {
					let entryIdToRemove = currentAssignment.id
					
					classAssignments = classAssignments.filter { $0.id != entryIdToRemove }
					
					assignmentStore.delete(entryID: currentAssignment.id)
                    
                    classAssignments = assignmentStore.getAllAssignmentsFor(classID: existingClass.id)
                    
                    classG.classGradee = calculationManager.calculateClassGrade(semeseterAssignments: classAssignments)
                    
                    
				}
				
				
			}, label:{
				if isEditing {
					Image(systemName: "checkmark.circle")
						.foregroundColor(Color.init(hex: 0x006400))
						.font(.body)
						.padding(.leading, 10)
						.offset(x: -5)
				} else {
					Image(systemName: "x.circle.fill")
                        // make lighter..
                    
                        .foregroundColor(Color.init(hex: 0xd3d3d3))
						.font(.body)
						.padding(.leading, 10)
						.offset(x: -5)
				}
				
				
			})
                }
		.padding(.leading, 20)
        
		
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
	
	func updateAssigment(entryId: Int, name: String, gradeWeight: Double, gradePercent: Double) {
        
       
		assignmentStore.updateAssignment(entryID: entryId, name: name, gradePercent: gradePercent, gradeWeight: gradeWeight)
        
        classAssignments = assignmentStore.getAllAssignmentsFor(classID: existingClass.id)
		
        classG.classGradee = calculationManager.calculateClassGrade(semeseterAssignments: classAssignments)

		isEditing = false
	}
	
	
}


