
//
//  Onboarding.swift
//  SwiftUIStacks
//
//  Created by Owen Rector on 9/28/21.
//

import SwiftUI
import Amplitude
import ToastUI



struct FinalCalculatorView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var finalPercentage: Double = 0.0
    @State private var currentGrade: Double = 0.0
    @State private var desiredGrade: Double = 0.0
    @State private var showingAlert = false
    

        
    @State var showPopup: Bool = false



    var body: some View {
        
        ScrollView{
        VStack(alignment: .center) {
            
            
            Text("Exam Impact Calculator")
                .font(.system(size: 39, weight: .heavy))
                .tracking(1)
                .foregroundColor(.black)
                .bold()
                .padding(.top, 90)
                .multilineTextAlignment(.center)

                
            
            
            Spacer()
                .frame(height: 60)

            
            Text("CURRENT GRADE (%)")
                .font(.system(size: 14, weight: .heavy))
                .tracking(2)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.bottom,2)
                .padding(.horizontal, 50)

            TextField("Current Grade", value: $currentGrade, formatter: NumberFormatter())
                .multilineTextAlignment(.center)
                .padding(.all)
                .keyboardType(.decimalPad)
                .frame(width: 170, height: 60)
                .foregroundColor(.black)
                .background(Color.init(hex: 0xEBECF0))
                .cornerRadius(10)
                .padding(.bottom,20)
                .padding(.leading, 80)
                .padding(.trailing, 80)
            
            Text("DESIRED GRADE (%)")
                .font(.system(size: 14, weight: .heavy))
                .tracking(2)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.bottom,2)
                .padding(.horizontal, 50)

            TextField("Desired Grade", value: $desiredGrade, formatter: NumberFormatter())
                .multilineTextAlignment(.center)
                .padding(.all)
                .keyboardType(.decimalPad)
                .frame(width: 170, height: 60)
                .foregroundColor(.black)
                .background(Color.init(hex: 0xEBECF0))
                .cornerRadius(10)
                .padding(.bottom,20)
                .padding(.leading, 80)
                .padding(.trailing, 80)
            
            Text("EXAM WEIGHT (%)")
                .font(.system(size: 14, weight: .heavy))
                .tracking(2)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.bottom,2)
                .padding(.horizontal, 50)

            TextField("Exam Weight", value: $finalPercentage, formatter: NumberFormatter())                .multilineTextAlignment(.center)
                .padding(.all)
                .foregroundColor(.black)
                .keyboardType(.decimalPad)
                .frame(width: 170, height: 60)
                .background(Color.init(hex: 0xEBECF0))
                .cornerRadius(10)
                .padding(.bottom,20)
                .padding(.leading, 80)
                .padding(.trailing, 80)
            
            Spacer()
                .frame(height: 50)

            VStack{
                Button(action: {
                    if finalPercentage == 0 || currentGrade == 0 || desiredGrade == 0 {
                        showingAlert = true
                    } else {
                        showPopup = true
                    }
                }, label: {
                    Text("Calculate")
                        .padding(.vertical, 18)
                        .frame(maxHeight: 55)
                        .padding(.horizontal,100)
                        .font((.system(size: 24, weight: .semibold)))
                        .background(Color(UIColor(hex: "#0xCAE4FB")!))
                        .cornerRadius(14)
                        .foregroundColor(.black)
                })
                
            }
        

        }
    }
        .environment(\.colorScheme, .light)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        
        .toast(isPresented: $showPopup) {
            
                 
                ToastView{
                    
                    VStack() {
                        
                        let gradeNdded = (calculateNeededGPA(finalPercentage: finalPercentage, currentGrade: currentGrade, desiredGrade: desiredGrade))
                        
                        switch gradeNdded {
                                    case 0..<80:
                                        Text("You Got This.")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: 230, alignment: .center)
                                            .foregroundColor(.black)
                                            .padding(.leading, 15)
                                            .padding(.vertical, 5)
                                            .fixedSize(horizontal: false, vertical: true)
                                    case 80..<95:
                                        Text("Study Hard!")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: 230, alignment: .center)
                                            .foregroundColor(.black)
                                            .padding(.leading, 15)
                                            .padding(.vertical, 5)
                                            .fixedSize(horizontal: false, vertical: true)
                                    case 95..<101:
                                        Text("Don't Give Up!")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: 230, alignment: .center)
                                            .foregroundColor(.black)
                                            .padding(.leading, 15)
                                            .padding(.vertical, 5)
                                            .fixedSize(horizontal: false, vertical: true)
                                    default:
                                        Text("Not Looking Good.")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: 230, alignment: .center)
                                            .foregroundColor(.black)
                                            .padding(.leading, 15)
                                            .padding(.vertical, 5)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                    }
                           
                        
                        Text("To achieve a grade of \(formatDesiredGrade(desiredGrade))%, you need a score of \(formatDesiredGrade(calculateNeededGPA(finalPercentage: finalPercentage, currentGrade: currentGrade, desiredGrade: desiredGrade)))% on your exam.")
                            .font(.system(size: 20))
                            .frame(maxWidth: 230, alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.leading, 15)
                            .padding(.vertical, 5)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        
                        Button {
                          showPopup = false
                            
                            
                            
                        } label: {
                          Text("Close")
                            .bold()
                            .frame(width: UIScreen.main.bounds.width/2)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 10.0)
                            .background(.black)
                            .cornerRadius(8.0)
                        }
                        
                        
                    }
                   
                    .frame(width: UIScreen.main.bounds.width/1.5, height: 280)
                    .cornerRadius(14)
                }
                .environment(\.colorScheme, .light)
                .background(Color.black.opacity(0.8).edgesIgnoringSafeArea(.all))
                
                
                  
            }
        .overlay(HStack {
            Spacer()
            VStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                })
                    .padding(.trailing, 15)
                    .padding(.top, 40)
                Spacer()
            }
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Error"), message: Text("One or more fields are empty. Please enter values for all fields."), dismissButton: .default(Text("OK")))
        })
        
    }
    
        
    
    func formatDesiredGrade(_ grade: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            return formatter.string(for: grade) ?? "-"
        }
    
    func calculateNeededGPA(finalPercentage: Double, currentGrade: Double, desiredGrade: Double) -> Double {
        let gradeNeeded: Double = ((desiredGrade/100) - ((currentGrade/100) * (1 - (finalPercentage/100)))) / (finalPercentage/100)
        return gradeNeeded*100
    }
        
        
    
}
