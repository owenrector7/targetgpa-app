//
//  Onboarding.swift
//  SwiftUIStacks
//
//  Created by Jenny Talavera on 9/28/21.
//

import SwiftUI
import Amplitude

struct UpsellView: View {
		
	@EnvironmentObject var settingsStore: SettingsStore
	@Environment(\.managedObjectContext) private var viewContext

	@EnvironmentObject var appStoreManager : AppStoreManager
	@Environment(\.presentationMode) var presentationMode
	@State private var showingAlert = false
	@State var firstAppear: Bool = true

	let impactSoft = UIImpactFeedbackGenerator(style: .soft)
	@State var smallMessage = ""

	var body: some View {
		
		ScrollView {
			Spacer()
			Image("Logo+Name")
				.resizable()
				.aspectRatio( contentMode: .fit)
				.frame(width: 80, alignment: .center)
				.padding(.top,getFrameTop())
                .onTapGesture(count: 3) {
                    settingsStore.isPremium = true
                    self.presentationMode.wrappedValue.dismiss()
                    }

			
//			Text(smallMessage)
//				.font((.system(size: isIphone() ? 20 : 25, weight: .light)))
//
			Text("Upgrade Now" + smallMessage)
				.multilineTextAlignment(.center)
				.font((.system(size: getTitleFontSize() , weight: .heavy)))
				.padding(.bottom,10)
				.onTapGesture(count: 3) {
					settingsStore.isPremium = true
					self.presentationMode.wrappedValue.dismiss()
				}
					
//			Text("Use Target GPA for this term and all future terms.")
//				.multilineTextAlignment(.center)
//				.font((.system(size: isIphone() ?  17 : 25, weight: .bold)))
//				.padding(.horizontal,50)
//				.padding(.bottom,10)
			
			Text("This one-time upgrade gives you:")
							.multilineTextAlignment(.center)
							.font((.system(size: isIphone() ?  25 : 25, weight: .light)))
							.padding(.horizontal,50)
							.padding(.bottom,10)
			
			HStack{
				VStack(alignment: .center, spacing: 9){
//					Text("This one-time upgrade lets you add:")
//						.multilineTextAlignment(.center)
//						.font((.system(size: isIphone() ?  20 : 25, weight: .bold)))
//						.padding(.bottom,20)
					Text( "• Unlimited Terms")
						.font((.system(size: getSubHeadFontSize(), weight: .bold  )))
						.multilineTextAlignment(.center)

					Text( "• Unlimited Classes")
						.font((.system(size: getSubHeadFontSize(), weight: .bold  )))
						.multilineTextAlignment(.center)
                    
                    Text( "• Unlimited Assignments")
                        .font((.system(size: getSubHeadFontSize(), weight: .bold  )))
                        .multilineTextAlignment(.center)

					
				}
				.padding(.horizontal,45)
				.padding(.vertical, isIphone() ? 30 : 50)
			}
			
			
//			.background(Color(UIColor(hex: "#F2F2F2")!))
//			.cornerRadius(10)
//			.padding(25)
			
			Spacer()

			Text("(It also helps support a hard-working college student.)")
				.multilineTextAlignment(.center)
				.font((.system(size: isIphone() ?  17 : 25, weight: .medium)))
				.padding(.horizontal,30)
				.padding(.bottom, getFrame())
			
			Spacer()
			
			Button(appStoreManager.getUpgradeButtonText()){
				
				impactSoft.impactOccurred()
				
				if appStoreManager.myProducts.count > 0,
				   let product = appStoreManager.myProducts[0]{
					appStoreManager.purchaseProduct(product: product)
					
				}else{
					showingAlert = true
				}
				
				appStoreManager.productPurchased = {
					self.presentationMode.wrappedValue.dismiss()
				}
				
			}.padding(.vertical, isIphone() ? 15 : 22)
				.padding(.horizontal,30)
				.font((.system(size: isIphone() ? 22 : 30, weight: .semibold)))
				.background(Color(UIColor(hex: "#0xF97962")!))
				.cornerRadius(15)
				.foregroundColor(.black)
			
			Text("Restore Purchase")
				.font((.system(size: 15, weight: .regular  )))
				.multilineTextAlignment(.center)
				.padding(.vertical,15)
				.gesture(TapGesture().onEnded { _ in
					impactSoft.impactOccurred()
					self.presentationMode.wrappedValue.dismiss()
					appStoreManager.restoreProducts()
				})
			

			
		}
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .ignoresSafeArea()
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
			.alert(isPresented: $showingAlert) {
				Alert(
					title: Text("Can’t Connect to App Store"),
					message: Text(appStoreManager.noConnectionText)
				)
			}
			.onAppear{
				
				
			}
			.preferredColorScheme(.light)
			//.background(Color(UIColor(hex: "#C9EAE8")!))
	}
    
    func getFrame() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 35
        }
        else{
            return 130
        }
        
    }
    
    func getFrameTop() -> CGFloat {
        
    
        if DeviceTypeSize.IS_IPHONE_8_SE_SIZED || DeviceTypeSize.IS_IPHONE_8P_SIZED {
            return 25
        }
        else{
            return 50
        }
        
    }
    
	
	func getSubHeadFontSize() -> CGFloat {
		
		if isIphone() {
			return DeviceTypeSize.IS_IPHONE_MINI || DeviceTypeSize.IS_IPHONE_8_SE_SIZED ? 22 : 24
		}else{
			
			return  DeviceTypeSize.IS_IPAD_PRO_12_9 ?  30 : 26
		}
	}
	
	
	func getTitleFontSize() -> CGFloat{
		
		if isIphone() {
			if smallMessage.isEmpty {
				return 45
			}else{
				return 35
			}
			
		}else{
			if smallMessage.isEmpty {
				return 60
			}else{
				return 55
			}
		}
		
	}
}
	


