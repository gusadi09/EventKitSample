//
//  ContentView.swift
//  EventKitSample
//
//  Created by Gus Adi on 04/10/22.
//

import SwiftUI

struct ContentView: View {

	@ObservedObject var notificationManager = LocalNotificationManager()
	
    var body: some View {
        VStack {
			Button {
				self.notificationManager.sendNotification(title: "Hurray!", subtitle: nil, body: "If you see this text, launching the local notification worked!", launchIn: 5)
			} label: {
				Text("Set new date")
			}

        }
        .padding()
		.onAppear {
			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
				print(error?.localizedDescription)
			}

			UNUserNotificationCenter.current().delegate = notificationManager
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date {
	func toString(format: DateFormat) -> String {
		let formatter = DateFormatter()
		formatter.locale = Locale.current
		formatter.dateFormat = format.rawValue

		return formatter.string(from: self)
	}
}

enum DateFormat: String {
	case utc = "yyyy-MM-dd'T'HH:mm:ss'Z'"
	case utcV2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
	case ddMMMyyyy = "dd MMM yyyy"
	case yyyyMMdd = "yyyy-MM-dd"
	case ddMMMMyyyy = "dd MMMM yyyy"
	case ddMMMyyyyHHmm = "dd MMM yyyy, HH:mm"
	case EEEEddMMMMyyyy = "EEEE, dd MMMM yyyy"
	case HHmm = "HH.mm"
	case HHmmss = "HH:mm:ss"
	case ddMMyyyyHHmm = "dd/MM/yyyy HH:mm"
}

extension String {
	func toDate(format: DateFormat) -> Date? {
		let formatter = DateFormatter()
		formatter.locale = Locale.current
		formatter.dateFormat = format.rawValue

		return formatter.date(from: self)
	}
}

class LocalNotificationManager: NSObject, ObservableObject {
	var notifications = [Notification]()

	init(notifications: [Notification] = [Notification]()) {
		self.notifications = notifications

	}

	func sendNotification(title: String, subtitle: String?, body: String, launchIn: Double) {

		let content = UNMutableNotificationContent()
		content.title = title
		if let subtitle = subtitle {
			content.subtitle = subtitle
		}
		content.body = body

		var dateComponent = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: "2022-10-11T07:10:00.000Z".toDate(format: .utcV2) ?? Date())

		dateComponent.timeZone = TimeZone.current

		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)


		UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
	}
}

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

		completionHandler([.alert, .badge, .sound])
	}
}
