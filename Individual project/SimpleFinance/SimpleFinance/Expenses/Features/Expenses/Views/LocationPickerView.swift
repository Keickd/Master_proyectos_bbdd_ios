//
//  LocationPickerView.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 11/12/24.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Binding var showingLocationPicker: Bool
    @Binding var position: MapCameraPosition
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var showingSaveDialog: Bool
    @Binding var locationName: String
    var viewModel: ExpenseViewModel
    
    @State private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position) {
                    if let locationInfo = viewModel.expense?.locationInfo {
                       /* Marker(
                            coordinate: CLLocationCoordinate2D(
                                latitude: locationInfo.latitude,
                                longitude: locationInfo.longitude
                            )
                        ) {
                            VStack {
                                Text(
                                    locationInfo.name ?? "No name"
                                )
                                .font(
                                    .caption
                                )
                                .padding(
                                    5
                                )
                                .background(
                                    Color.white
                                )
                                .cornerRadius(
                                    5
                                )
                                .shadow(
                                    radius: 3
                                )
                                Image(
                                    systemName: "mappin.circle.fill"
                                )
                                .font(
                                    .largeTitle
                                )
                                .foregroundColor(
                                    .blue
                                )
                            }
                        }*/
                    }
                    
                    if let selectedLocation = selectedLocation {
                        Marker(
                            coordinate: selectedLocation
                        ) {
                            VStack {
                                Text(
                                    "Selected"
                                )
                                .font(
                                    .caption
                                )
                                .padding(
                                    5
                                )
                                .background(
                                    Color.white
                                )
                                .cornerRadius(
                                    5
                                )
                                .shadow(
                                    radius: 3
                                )
                                Image(
                                    systemName: "mappin.circle.fill"
                                )
                                .font(
                                    .largeTitle
                                )
                                .foregroundColor(
                                    .red
                                )
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapPitchToggle()
                    MapCompass()
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(
                        position,
                        from: .local
                    ) {
                        selectedLocation = coordinate
                        showingSaveDialog = true
                    }
                }
                .onAppear {
                    locationManager.requestLocationPermission()
                    
                    if let locationData = viewModel.expense?.locationInfo,
                       let locationInfo = LocationInfoTransformer().reverseTransformedValue(locationData) as? LocationInfo {
                        position = .region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: locationInfo.latitude,
                                    longitude: locationInfo.longitude
                                ),
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.05,
                                    longitudeDelta: 0.05
                                )
                            )
                        )
                    } else {
                        position = .userLocation(fallback: .automatic)
                    }

                }
            }
            
            VStack {
                HStack {
                    Button(
                        action: {
                            showingLocationPicker = false
                        }) {
                            Image(
                                systemName: "xmark.circle.fill"
                            )
                            .foregroundColor(
                                .red
                            )
                            .font(
                                .largeTitle
                            )
                            .padding()
                        }
                    Spacer()
                }
                Spacer()
                
                if showingSaveDialog {
                    VStack(
                        spacing: 16
                    ) {
                        Text(
                            "Save location"
                        )
                        .font(
                            .headline
                        )
                        Text(
                            "Enter a name for the location:"
                        )
                        .font(
                            .subheadline
                        )
                        TextField(
                            "Location name ",
                            text: $locationName
                        )
                        .textFieldStyle(
                            RoundedBorderTextFieldStyle()
                        )
                        .padding(
                            .horizontal
                        )
                        
                        HStack {
                            Button(
                                "Cancel"
                            ) {
                                showingSaveDialog = false
                                selectedLocation = nil
                            }
                            .foregroundColor(
                                .red
                            )
                            
                            Spacer()
                            
                            Button(
                                "Save"
                            ) {
                                if selectedLocation != nil && !locationName.isEmpty {
                                    viewModel
                                        .saveLocation(
                                            name: locationName,
                                            coordinate: selectedLocation!
                                        )
                                    showingSaveDialog = false
                                    selectedLocation = nil
                                }
                            }
                            .disabled(
                                locationName.isEmpty
                            )
                            .foregroundColor(
                                locationName.isEmpty ? .gray : .blue
                            )
                        }
                        .padding(
                            .horizontal
                        )
                    }
                    .padding()
                    .background(
                        Color(
                            UIColor.systemBackground
                        )
                    )
                    .cornerRadius(
                        12
                    )
                    .shadow(
                        radius: 10
                    )
                    .frame(
                        maxWidth: 300
                    )
                    .padding(
                        20
                    )
                }
            }
        }
    }
}

