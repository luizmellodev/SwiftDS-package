// MARK: - Date Picker

import SwiftUI

/// Date (and optional time) picker with optional label; uses native DatePicker with DS tint.
///
/// - Parameters:
///   - label: Optional label above field.
///   - selection: Binding to selected date.
///   - displayedComponents: .date, .hourAndMinute, or both.
///   - range: Optional valid date range.
///   - accessibilityLabel: Optional accessibility label.
public struct DSDatePicker: View {
    let label: String?
    @Binding var selection: Date
    let displayedComponents: DatePickerComponents
    let range: ClosedRange<Date>?
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme

    public init(
        label: String? = nil,
        selection: Binding<Date>,
        displayedComponents: DatePickerComponents = .date,
        in range: ClosedRange<Date>? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.label = label
        self._selection = selection
        self.displayedComponents = displayedComponents
        self.range = range
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
            }

            if let range {
                DatePicker("", selection: $selection, in: range, displayedComponents: displayedComponents)
                    .labelsHidden()
                    .tint(DSColor.primary)
            } else {
                DatePicker("", selection: $selection, displayedComponents: displayedComponents)
                    .labelsHidden()
                    .tint(DSColor.primary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel ?? label ?? "Date selection")
        .accessibilityHint("Double-tap to change date")
        .accessibilityValue(selection.formatted(date: .long, time: displayedComponents.contains(.hourAndMinute) ? .shortened : .omitted))
        .accessibilityValue(selection.formatted(date: .abbreviated, time: displayedComponents.contains(.hourAndMinute) ? .shortened : .omitted))
    }
}

#Preview("Date Picker") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Date Only")
                    .dsTextStyle(.title2)

                DateOnlyExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Date and Time")
                    .dsTextStyle(.title2)

                DateTimeExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With Date Range")
                    .dsTextStyle(.title2)

                DateRangeExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In a Form")
                    .dsTextStyle(.title2)

                FormExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Multiple Pickers")
                    .dsTextStyle(.title2)

                MultipleExample()
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct DateOnlyExample: View {
    @State private var selectedDate = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSDatePicker(
                label: "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )

            Text("Selected: \(selectedDate.formatted(date: .long, time: .omitted))")
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)
        }
    }
}

private struct DateTimeExample: View {
    @State private var selectedDateTime = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSDatePicker(
                label: "Select Date & Time",
                selection: $selectedDateTime,
                displayedComponents: [.date, .hourAndMinute]
            )

            Text("Selected: \(selectedDateTime.formatted(date: .abbreviated, time: .shortened))")
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)
        }
    }
}

private struct DateRangeExample: View {
    @State private var selectedDate = Date()

    let today = Date()
    var futureRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: 30, to: today) ?? today
        return today...endDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSDatePicker(
                label: "Appointment Date (Next 30 days)",
                selection: $selectedDate,
                displayedComponents: .date,
                in: futureRange
            )

            Text("Selected: \(selectedDate.formatted(date: .long, time: .omitted))")
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)
        }
    }
}

private struct FormExample: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var meetingTime = Date()

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Schedule Meeting")
                    .dsTextStyle(.headline)

                DSDatePicker(
                    label: "Start Date",
                    selection: $startDate,
                    displayedComponents: .date
                )

                DSDatePicker(
                    label: "End Date",
                    selection: $endDate,
                    displayedComponents: .date
                )

                DSDatePicker(
                    label: "Meeting Time",
                    selection: $meetingTime,
                    displayedComponents: .hourAndMinute
                )

                DSButton("Schedule", variant: .primary) {
                    print("Meeting scheduled")
                }
            }
        }
    }
}

private struct MultipleExample: View {
    @State private var birthDate = Date()
    @State private var appointmentDate = Date()
    @State private var reminderTime = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSDatePicker(
                label: "Birth Date",
                selection: $birthDate,
                displayedComponents: .date
            )

            DSDatePicker(
                label: "Appointment",
                selection: $appointmentDate,
                displayedComponents: [.date, .hourAndMinute]
            )

            DSDatePicker(
                label: "Reminder Time",
                selection: $reminderTime,
                displayedComponents: .hourAndMinute
            )
        }
    }
}
