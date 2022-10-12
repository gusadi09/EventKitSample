//
//  EventKitSampleApp.swift
//  EventKitSample
//
//  Created by Gus Adi on 04/10/22.
//

import SwiftUI
import Shift

@main
struct EventKitSampleApp: App {

	init() {
		Shift.configureWithAppName("MyApp")
	}
	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
