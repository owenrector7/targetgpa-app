import SwiftUI
import RealmSwift
import Amplitude


class ClassGrade_ObsObject: ObservableObject {
    @Published var classGradee: Double = 0.0
}

struct ClassDetail: View {
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var gpaClassStore: GPAClassStore
	@EnvironmentObject var semesterStore : SemesterStore
	@EnvironmentObject var gradeStore : GradeStore
	@EnvironmentObject var settingsStore : SettingsStore
	
	@State private var showingAlert = false
    @State private var showingAlertAssignment = false
	
	@EnvironmentObject var assignmentStore : AssignmentStore
	
	
	@EnvironmentObject var calculationManager : CalculationManager
	
	
	@State private var isToggle : Bool = true
	@State private var isPF : Bool = false
	
    var existingClass: GPAClass
	
	@State var className = ""
	@State var credits: Double = 4
	@State var savePressed = false
	@State var activeSheetNew: SheetTwo? = nil
    
    @State var semesterClasses: [GPAClass]
    
//    @State var currentGrade: Grade
	
	@State var currentClass: GPAClass?
	
	@State var nextNumber = 2
	
	@State var currentGradeNow: Double = 0.0
	
	@State var classAssignments = [ClassAssignment]()
	
	@State var classGrade: Double = 0.0
    
    @StateObject var classGradeObsObject = ClassGrade_ObsObject()
	
	var currentSemester: Semester
	
	var body: some View {
        
        NavigationLink(destination: EmptyView()) {
            EmptyView()
        }
        
		VStack{
			HStack(alignment: .center)  {
				VStack(alignment: .leading){
					
					Spacer()
						.frame(height: 20)
					Text(existingClass.name)
						.italic()
						.font(.system(size: 12))
						.fontWeight(.regular)
						.foregroundColor(.black)
					Text("CLASS GRADE")
						.font(.system(size: 14, weight: .heavy))
						.tracking(2)
						.foregroundColor(.black)
                    Text("\(classGradeObsObject.classGradee.isNaN ? 0 : classGradeObsObject.classGradee, specifier: "%.0f")%")
                        .font(.system(size: getMainGPAfontSize(), weight: .heavy))
						.foregroundColor(.black)
				}
				.frame(minWidth :UIScreen.screenWidth / 3 )
				.padding(.leading, 30)
				.padding(.trailing, 15)
				.padding(.vertical, 5)
				.padding(.bottom, 25)
				
				//                if currentAssignments.count > 0 {
				
				VStack(alignment: .leading) {
					HStack{
						Text("EXAM IMPACT")
							.font(.system(size: 13, weight: .medium))
							.tracking(2)
							.foregroundColor(.black)
					}
					
					Text("CALCULATOR")
						.font(.system(size: 13, weight: .heavy))
						.tracking(2)
						.foregroundColor(.black)
					
					HStack{
						
						Button(action: {
							activeSheetNew = .finalGradeCalc
						}, label: {
							Text("Click Here")
								.font(.system(size: 14))
								.fontWeight(.heavy)
								.foregroundColor(.black)
								.lineLimit(2)
								.padding(5)
								.multilineTextAlignment(.leading)
						})
						
					}.padding(.leading,15)
						.padding(.trailing,15)
						.padding(.vertical,3)
						.background(currentSemester.color.lightColor())
						.cornerRadius(4)
					
					
					
					
					Spacer()
						.frame(height: 10)
					
				}
				.padding(.top, 20)
				.padding(.horizontal, 16)
				.background(currentSemester.color.lightestColor())
				.cornerRadius(14)
				.frame(maxWidth :UIScreen.screenWidth / 2.5 )
				.padding(.leading, 20)
				
				Spacer()
				//                }
				
				
			}.padding(.vertical,20)
				.background(currentSemester.color.lightColor())
			
			
			
			Spacer()
				.frame(height: 0)
			
			
			
			
			HStack (alignment: .center) {
				VStack {
					
					Text("Assignment")
						.frame(width: 150, alignment: .topLeading)
						.font(.system(size: 12, weight: .bold, design: .rounded))
						.foregroundColor(.black)
						.offset(x: 10, y: -18)
					
				}
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
				.offset(x: 30, y:20)
				
				VStack {
					Text("Grade (%)")
						.font(.system(size: 12, weight: .bold, design: .rounded))
						.frame(width: 150, alignment: .topLeading)
						.foregroundColor(.black)
						.offset(x: 19, y: -18)
					
				}
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
				.offset(x: -10, y:20)
				
				
				VStack {
					Text("Weight (%)")
						.font(.system(size: 12, weight: .bold, design: .rounded))
						.frame(width: 150, alignment: .leading)
						.foregroundColor(.black)
						.offset(x: 22, y: -18)
					
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
					ForEach(Array(classAssignments.enumerated()), id: \.element){index, anAssignment in
						let importantColorNew = currentSemester.color.lightColor()
						
						
                        AssignmentCardView(currentClass: existingClass, currentSemester: currentSemester, importantColor: importantColorNew, index: index, currentAssignment: anAssignment, existingClass: existingClass, classG: classGradeObsObject, classAssignments: $classAssignments)
						
						
						LineTwo()
							.stroke(style: StrokeStyle(lineWidth: 0.25, dash: [4]))
							.frame(height: 1)
							.foregroundColor(.black)
						
							.padding(.horizontal)
							.padding(.vertical, 10)
						Spacer()
							.frame(height: 10)
						
					}
					
					
				}
				
				
				
				Spacer()
					.frame(height: 75)
				
			}
            .alert(isPresented: $showingAlertAssignment, content: {
                Alert(
                    title: Text("Are you sure youuuuuu want to delete this class?"),
                    message: Text("All assignment data will be deleted as well."),
                    primaryButton: .default(
                        Text("Delete Class"),
                        action: deleteClass
                    ),
                    secondaryButton: .destructive(
                        Text("Cancel")
                    )
                )
            })
		}
		.background(Color.white.edgesIgnoringSafeArea(.all))
		
        
		.overlay(
			VStack(alignment:.leading) {
				Spacer()
				HStack {
					Spacer()
					Button(action: {
                        Amplitude.instance().logEvent("Assignment Added")

                        
                        if settingsStore.isPremium {
						
                            
                            if let newAssignemnt = assignmentStore.create(name: "", gradePercent:  0, gradeWeight:  0, classID: existingClass.id){
                                
                                classAssignments.append(newAssignemnt)
                            }
                        } else {
                            
                        
                            
                            if classAssignments.count >= 4 {
                                openUpgrade()
                            } else {
                                if let newAssignemnt = assignmentStore.create(name: "", gradePercent:  0, gradeWeight:  0, classID: existingClass.id){
                                    
                                    classAssignments.append(newAssignemnt)
                                }
                            }
                            
                        }
						
					}, label: {
						HStack {
							Image(systemName: "plus.circle.fill")
								.foregroundStyle(.white, .black)
								.font(.system(size: 45))
						}
						.padding(.horizontal, 68)
						.padding(.bottom, 10)
						.mask(Circle())
						.shadow(color: Color.black.opacity(0.25),radius: 3,
								x:3, y:3)
					})
				}
			}
		)
		.alert(isPresented: $showingAlert, content: {
			Alert(
				title: Text("Are you sure you want to delete this class?"),
				message: Text("All assignment data will be deleted as well."),
				primaryButton: .default(
					Text("Delete Class"),
					action: deleteClass
				),
				secondaryButton: .destructive(
					Text("Cancel")
				)
			)
		})
        .navigationViewStyle(.stack)
		.navigationBarTitle("")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarLeading) {
				
				Button(action: {
					self.presentationMode.wrappedValue.dismiss()
                    print(existingClass)
                    
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
                        activeSheetNew = .editClass
                    }
					)
					{
						Label("Edit Class", systemImage: "pencil")
							.font(.body)
							.foregroundColor(.black)
					}.padding(EdgeInsets(top: 0, leading:0, bottom:0, trailing: 8))
					
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
		.sheet(item: $activeSheetNew) { sheet in
			switch sheet {
				case .editClass:
					EditClassView(existingClass: existingClass)
                    .preferredColorScheme(.light)
				case .finalGradeCalc:
					FinalCalculatorView()
                    .preferredColorScheme(.light)
                case .upgradeView:
                    UpsellView()
                    .preferredColorScheme(.light)
                case .editSemester:
                   EditSemesterView(existingSem: currentSemester)
                        .preferredColorScheme(.light)
			}
		}
		.onAppear{
            
    
			classAssignments =  assignmentStore.getAllAssignmentsFor(classID: existingClass.id)
            
			classGradeObsObject.classGradee = calculationManager.calculateClassGrade(semeseterAssignments: classAssignments)
          
		}
		
	}
    
    enum SheetTwo: Identifiable {
      case editClass
      case editSemester
      case finalGradeCalc
      case upgradeView
    
      var id: Int {
        hashValue
      }
    }
    
    func getMainGPAfontSize() -> CGFloat {
        if DeviceTypeSize.IS_IPHONE_13_PRO_MAX_SIZED {
            return 46.0
        }else {
            return 43.0
        }
    }
    
    func deleteClass() {
                
        gpaClassStore.delete(entryID: existingClass.id)
            
    }
    
    func openEditClass() {
        activeSheetNew = .editClass
    }
    
    func openUpgrade() {
        activeSheetNew = .upgradeView
    }

}

struct LineTwo: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
