import SwiftUI


struct ContentView: View {
    @State private var resultOutput: String = ""
    @State private var newSolution: Bool = true
    @State private var isShowingSettings = false
    @State private var isRunning = false
    @State private var timeElapsed: TimeInterval = 0
    @State private var startDate: Date? = nil
    @State private var timer: Timer? = nil
    @State private var puzzle_type: Int = 1
    @State private var day: Int = {
            // take todays day or fallback to 1
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.month, .day], from: now)

            if let month = components.month,
               let day = components.day,
               month == 12,
               (1...12).contains(day) {
                return day
            } else {
                return 1
            }
        }()
    @State var buttonTitle: Label = Label("Start", systemImage: "arrow.clockwise.circle")

    let days = (1...12)

    var body: some View {
        VStack(spacing: 40) {
            Text("Advent of Code 2025")
                .font(.largeTitle)
                .fontWeight(.light)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(formattedTime)
                    .font(.system(size: 60))
                    .fontWeight(.light)
                    .monospacedDigit()

                Text(formattedTimeMs)
                    .font(.system(size: 30))
                    .fontWeight(.light)
                    .monospacedDigit()
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            
            Picker("Day", selection: $day) {
                            ForEach(days, id: \.self) {
                                Text($0.description)
                            }
                        }
            .pickerStyle(.menu)
            .frame(width: 130)

            
            Picker(selection: $puzzle_type, label: Text("Puzzle:")) {
                Text("Part 1").tag(1)
                Text("Part 2").tag(2)
            }.pickerStyle(RadioGroupPickerStyle())
   
            Button(action: {
              
                buttonTitle = Label("Start", systemImage: "play.circle");
                
                startRun()
            }) {
                buttonTitle
            }
            .buttonStyle(.bordered)
            .disabled(isRunning)
            
            
            Text("Result:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack(alignment: .center, spacing: 8) {
                Text(resultOutput)
                    .font(.body)
                    .padding(8)
                    .frame(minWidth: 200, alignment: .leading)
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(resultOutput, forType: .string)
                }) {
                    Image(systemName: "doc.on.doc")
                        .frame(width: 32, height: 32) // Adjust size to match text height
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .help("Copy to Clipboard")
                .disabled(resultOutput.isEmpty)
                
                Text("Not a new Solution!")
                    .font(.body)
                    .foregroundColor(.red)
                    .opacity(newSolution ? 0 : 1)
            }
            .frame(maxWidth: .infinity)
            .offset(x: 16 + 64)
            
            Button(action: {
                isShowingSettings = true
            }) {
                Label("Settings", systemImage: "gearshape")
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }

        }
        .padding(.top, 60)
        .padding(.bottom, 60)
        .onAppear {
                if BookmarkManager.shared.resolveURL() == nil {
                    isShowingSettings = true
                }
            }
    }

    // MARK: - FORMATTING
    var formattedTime: String {
        let totalMs = Int(timeElapsed)
        let hours = totalMs / 3_600
        let minutes = (totalMs / 60) % 60
        let seconds = (totalMs ) % 60
        return String(format: "%02d:%02d:%02d.", hours, minutes, seconds)
    }
    
    var formattedTimeMs: String {
        let totalMs = Int(timeElapsed * 1000)
        let ms = totalMs % 1000
        return String(format: "%03d", ms)
    }

    // MARK: - LOGIC
    func startRun() {
        guard !isRunning else { return }

        // Reset previous output
        resultOutput = ""

        startTimer()

        // Run puzzle in background
        DispatchQueue.global(qos: .userInitiated).async {
  
            var day_class: Day
            var filename: String

            switch day {
            case 1:  day_class = Day01(); filename = "puzzle_1.txt"
            case 2:  day_class = Day02(); filename = "puzzle_2.txt"
            case 3:  day_class = Day03(); filename = "puzzle_3.txt"
            case 4:  day_class = Day04(); filename = "puzzle_4.txt"
            case 5:  day_class = Day05(); filename = "puzzle_5.txt"
            case 6:  day_class = Day06(); filename = "puzzle_6.txt"
            case 7:  day_class = Day07(); filename = "puzzle_7.txt"
            case 8:  day_class = Day08(); filename = "puzzle_8.txt"
            case 9:  day_class = Day09(); filename = "puzzle_9.txt"
            case 10: day_class = Day10(); filename = "puzzle_10.txt"
            case 11: day_class = Day11(); filename = "puzzle_11.txt"
            case 12: day_class = Day12(); filename = "puzzle_12.txt"
            default: day_class = Day01(); filename = "puzzle_1.txt"
            }

            if let workingDir = BookmarkManager.shared.resolveURL() {
                let fullPath = workingDir.appendingPathComponent(filename).path

                var result = ""
                switch puzzle_type {
                case 1:
                    result = day_class.part_1(filename: fullPath)
                case 2:
                    result = day_class.part_2(filename: fullPath)
                default:
                    print("invalid puzzle type")
                }
                
                if let oldSolution = NSPasteboard.general.string(forType: .string) {
                    if oldSolution == result {
                        self.newSolution = false
                    } else {
                        self.newSolution = true
                    }
                }
                
                let pb = NSPasteboard.general
                pb.clearContents()
                pb.setString(result, forType: .string)

                workingDir.stopAccessingSecurityScopedResource()

                // Update UI on main thread
                DispatchQueue.main.async {
                    self.resultOutput = result
                    stopTimer()
                }
            } else {
                DispatchQueue.main.async {
                    stopTimer()
                }
            }
        }
    }

    func startTimer() {
        isRunning = true
        startDate = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            if let start = startDate {
                timeElapsed = Date().timeIntervalSince(start)
            }
        }
    }

    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
}

#Preview {
    ContentView()
}
