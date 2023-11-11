//
//  ReceiptTextFormOptionView.swift
//  Ree-See.It
//
//  Created by Yongye Tan on 11/10/23.
//

import SwiftUI
import MapKit

struct ReceiptTextFormOptionView: View {
    
    
    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var category: String = "Food"
    @State private var note: String = ""
    @State private var address: String = ""
    @State private var price: Double = 0.0
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var isMapShown: Bool = false
    
    @State private var isModalShown: Bool = false
    
    @FocusState private var focusedField: FocusedField?
    
    
    var categorySelection = ["Food", "Grocery", "Education", "Gas", "Technology", "Clothes"]
    
    var isSubmitDisable: Bool {
        name.isEmpty || address.isEmpty || price == 0.0
    }
    
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                VStack {
                    Form {
                        
                        // MARK: Name
                        Section {
                            HStack {
                                Text("Name")
                                Spacer()
                                TextField("Name", text: $name)
                                    .multilineTextAlignment(.trailing)
                                    .focused($focusedField, equals: .name)
                                    .submitLabel(.done)
                            }
                            
                        }
                        
                        // MARK: DatePicker
                        LabeledContent {
                            DatePicker("",
                                       selection: $date,
                                       displayedComponents: [.date])
                            .datePickerStyle(.compact)
                        } label: {
                            FormItemLogoView(imageName: "calendar", rowLabel: "Date", rowTintColor: .green)
                        }
                        
                        
                        Section {
                            // MARK: Category
                            LabeledContent {
                                Picker("", selection: $category) {
                                    ForEach(categorySelection, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.menu)
                                
                            } label: {
                                FormItemLogoView(imageName: "tag", rowLabel: "Category", rowTintColor: .red)
                            }
                            
                            // MARK: Note
                            LabeledContent {
                                NavigationLink {
                                    ReceiptMessageView(note: $note)
                                } label: {
                                    Text("")
                                }
                            } label: {
                                FormItemLogoView(imageName: "message", rowLabel: "Note", rowTintColor: .orange)
                            }
                            
                        }
                        
                        
                        // MARK: Address
                        Section {
                            LabeledContent {
                                
                                Text("")
                                
                            } label: {
                                NavigationLink {
                                    MapView(isMapShown: $isMapShown,
                                            address: $address,
                                            latitude: $latitude,
                                            longitude: $longitude)
                                } label: {
                                    FormItemLogoView(imageName: "paperplane.fill", rowLabel: "Address", rowTintColor: .blue)
                                }
                                
                            }
                            
                            // MARK: Price
                            LabeledContent {
                                TextField("0.00", value: $price, format: .currency(code: "USD"))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                
                                
                            } label: {
                                FormItemLogoView(imageName: "dollarsign.circle.fill", rowLabel: "Price", rowTintColor: .indigo)
                            }
                        }
                        
                        VStack {
                            
                            Button(action: {
                                // TODO: Send HTTP request
                                isModalShown.toggle()
                            }) {
                                Spacer()
                                Text("Submit")
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                
                            }
                            .buttonStyle(.borderless)
                            .disabled(isSubmitDisable)
                            
                        }
                        
                        
                    }
                    
                    
                }
                .blur(radius: isModalShown ? 8 : 0)
                
                if isModalShown {
                    
                    Color.clear
                    // because swipe action is another gesture
                    // swiftui is confused on which gesture should perform first
                    // give this view for hit testing
                        .contentShape(Rectangle())  // make entire view tappable
                        .onTapGesture {
                            isModalShown.toggle()
                        }
                    
                    ModalCompletionView(showSubmission: $isModalShown)
                }
            }
            .navigationTitle("New receipt")
            .navigationBarTitleDisplayMode(.inline)
            
            
            
        }
    }
}

// a focus field to dismiss keyboard
enum FocusedField {
    case name, address
}


#Preview {
    ReceiptTextFormOptionView()
}