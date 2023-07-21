//
//  Onboarding_home.swift
//  Just Steps
//
//  Created by Jenny Talavera on 9/28/21.
//

import SwiftUI

struct AddSemester_Home : View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var appStoreManager : AppStoreManager
    @EnvironmentObject var gpaClassStore: GPAClassStore
    @EnvironmentObject var semesterStore : SemesterStore
    @EnvironmentObject var gradeStore : GradeStore
    @EnvironmentObject var calculationManager : CalculationManager
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTabNew = 0
    @State private var newSemesterTwo : Semester?
    
    var body: some View {
        
            TabView(selection: $selectedTabNew) {
                AddSemesterClasses(selectedTabNew: $selectedTabNew, newSemesterTwo: $newSemesterTwo)
                    .preferredColorScheme(.light)
                    .tag(0)
                AddSemesterClassesTwo(selectedTabNew: $selectedTabNew, newSemesterTwo: $newSemesterTwo)
                    .preferredColorScheme(.light)
                    .tag(1)
            }.animation(.default)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            
    }
}
