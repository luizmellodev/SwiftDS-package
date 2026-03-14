# Real-World Use Cases

SwiftDS includes 6 complete example applications showcasing real-world usage patterns and component compositions. These apps demonstrate how to build production-ready interfaces using the design system.

## Table of Contents

- [1. Todo List App](#1-todo-list-app)
- [2. Travel Organizer App](#2-travel-organizer-app)
- [3. AI Chat App](#3-ai-chat-app)
- [4. Bible Verses App](#4-bible-verses-app)
- [5. Daily Quotes App](#5-daily-quotes-app)
- [6. Diet Tracker App](#6-diet-tracker-app)
- [Running the Examples](#running-the-examples)
- [Learning from Examples](#learning-from-examples)

---

## 1. Todo List App

**File**: `Sources/DesignSystem/Showcase/DSAppShowcase_TodoList.swift`

### Overview

A full-featured task management app with folders, themes, and task comments. Demonstrates complex state management and component composition.

### Features

- ✅ Task creation and completion
- 📁 Folder organization (Work, Personal, Shopping)
- 🎨 3 theme variants (Classic, Mono, Bubbly)
- 💬 Task comments
- 📊 Progress tracking
- 🎉 Celebration animations on task completion

### Components Used

| Component | Usage |
|-----------|-------|
| `DSButton` | Add task, theme switcher, folder actions |
| `DSTextField` | Task input, comment input |
| `DSCard` | Task items (Classic theme) |
| `DSChip` | Folder selector (Bubbly theme) |
| `DSCheckbox` | Task completion toggle |
| `DSSegmentedControl` | Folder navigation (Classic theme) |
| `DSProgressBar` | Task completion progress |
| `DSProgressRingWidget` | Circular progress (Bubbly theme) |
| `DSToast` | Theme change notifications |
| `DSBottomSheet` | Add task sheet, comment sheet |

### Key Patterns

**Theme Switching:**
```swift
enum TodoTheme: String, CaseIterable {
    case classic, mono, bubbly
}

@State private var currentTheme: TodoTheme = .classic

// Different layouts per theme
switch currentTheme {
case .classic: classicLayout
case .mono: monoLayout
case .bubbly: bubblyLayout
}
```

**State Management:**
```swift
@State private var tasks: [AppTodoTask] = [...]
@State private var selectedFolder = "Work"
@State private var showAddSheet = false

// Computed properties for filtered data
private var filteredIndices: [Int] {
    tasks.indices.filter { tasks[$0].folder == selectedFolder }
}
```

**Component Composition:**
```swift
DSCard {
    HStack(spacing: DSSpacing.sm) {
        DSCheckbox(isChecked: $tasks[i].isCompleted)
        
        VStack(alignment: .leading) {
            Text(tasks[i].text)
            if !tasks[i].comment.isEmpty {
                Text(tasks[i].comment)
                    .foregroundColor(.dsForegroundMuted)
            }
        }
        
        Spacer()
        
        DSButton("Comment", variant: .ghost, size: .sm) {
            commentTaskId = tasks[i].id
        }
    }
}
```

### What You'll Learn

- Complex state management with multiple views
- Theme switching and dynamic layouts
- Bottom sheet patterns for modal content
- Progress tracking and celebration animations
- Folder/category organization patterns

---

## 2. Travel Organizer App

**File**: `Sources/DesignSystem/Showcase/DSAppShowcase_TravelOrganizer.swift`

### Overview

A trip planning app with itineraries, bookings, and timelines. Demonstrates timeline layouts and card-based navigation.

### Features

- ✈️ Trip planning with destinations
- 📅 Itinerary timeline
- 🏨 Booking management
- 📍 Location tracking
- 💰 Budget tracking
- 📸 Photo galleries

### Components Used

| Component | Usage |
|-----------|-------|
| `DSCard` | Trip cards, booking cards, itinerary items |
| `DSButton` | Add trip, book flight, view details |
| `DSBadge` | Trip status, booking status |
| `DSAvatar` | Traveler avatars |
| `DSProgressBar` | Budget progress, trip progress |
| `DSImageGallery` | Destination photos |
| `DSTabBar` | Navigation between trips/bookings/profile |
| `DSStepIndicator` | Booking flow steps |

### Key Patterns

**Timeline Layout:**
```swift
VStack(alignment: .leading, spacing: DSSpacing.md) {
    ForEach(itineraryItems) { item in
        HStack(alignment: .top) {
            // Timeline indicator
            VStack {
                Circle()
                    .fill(Color.dsPrimary)
                    .frame(width: 12, height: 12)
                Rectangle()
                    .fill(Color.dsBorder)
                    .frame(width: 2)
            }
            
            // Content
            DSCard {
                VStack(alignment: .leading) {
                    Text(item.time)
                    Text(item.title)
                    Text(item.location)
                }
            }
        }
    }
}
```

**Card-Based Navigation:**
```swift
ScrollView {
    LazyVStack(spacing: DSSpacing.md) {
        ForEach(trips) { trip in
            DSCard {
                VStack(alignment: .leading) {
                    Text(trip.destination)
                    Text(trip.dates)
                    
                    HStack {
                        DSBadge(trip.status)
                        Spacer()
                        DSButton("View", variant: .ghost) {
                            selectedTrip = trip
                        }
                    }
                }
            }
        }
    }
}
```

### What You'll Learn

- Timeline and itinerary layouts
- Card-based navigation patterns
- Progress tracking for budgets
- Multi-step booking flows
- Photo gallery integration

---

## 3. AI Chat App

**File**: `Sources/DesignSystem/Showcase/DSAppShowcase_AIChat.swift`

### Overview

A modern chat interface with message bubbles, typing indicators, and AI responses. Demonstrates messaging patterns and real-time updates.

### Features

- 💬 Message bubbles (user and AI)
- ⌨️ Typing indicators
- 📎 Attachment support
- 🔍 Message search
- ⭐ Message favorites
- 🎨 Code syntax highlighting

### Components Used

| Component | Usage |
|-----------|-------|
| `DSMessageBubble` | User and AI messages |
| `DSChatInputBar` | Message input with send button |
| `DSAvatar` | User and AI avatars |
| `DSButton` | Send, attach, favorite |
| `DSSpinner` | Typing indicator |
| `DSSearchBar` | Message search |
| `DSCard` | Code blocks, attachments |

### Key Patterns

**Message List:**
```swift
ScrollView {
    LazyVStack(spacing: DSSpacing.sm) {
        ForEach(messages) { message in
            HStack {
                if message.isUser { Spacer() }
                
                DSMessageBubble(
                    text: message.text,
                    isUser: message.isUser,
                    timestamp: message.timestamp
                )
                
                if !message.isUser { Spacer() }
            }
        }
    }
}
.scrollDismissesKeyboard(.interactively)
```

**Chat Input:**
```swift
VStack(spacing: 0) {
    Divider()
    
    DSChatInputBar(
        text: $messageText,
        placeholder: "Ask me anything...",
        onSend: {
            sendMessage()
        }
    )
}
```

**Typing Indicator:**
```swift
if isTyping {
    HStack {
        DSAvatar(name: "AI", size: .sm)
        
        HStack(spacing: 4) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.dsForegroundMuted)
                    .frame(width: 6, height: 6)
                    .scaleEffect(animatingDot == i ? 1.2 : 1.0)
            }
        }
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, DSSpacing.xs)
        .background(Color.dsSurface)
        .cornerRadius(DSRadius.medium)
        
        Spacer()
    }
}
```

### What You'll Learn

- Chat interface patterns
- Message bubbles and alignment
- Typing indicators
- Real-time message updates
- Keyboard handling
- Scroll to bottom on new messages

---

## 4. Bible Verses App

**File**: `Sources/DesignSystem/Showcase/DSAppShowcase_BibleVerses.swift`

### Overview

A reading app with bookmarks, search, and verse highlighting. Demonstrates content-focused layouts and reading experiences.

### Features

- 📖 Verse reading with formatting
- 🔖 Bookmarks and favorites
- 🔍 Verse search
- 📝 Notes and highlights
- 📚 Chapter navigation
- 🌓 Reading mode (light/dark)

### Components Used

| Component | Usage |
|-----------|-------|
| `DSCard` | Verse cards, chapter cards |
| `DSButton` | Bookmark, share, navigate |
| `DSBadge` | Book names, chapter numbers |
| `DSSearchBar` | Verse search |
| `DSIconButton` | Bookmark toggle, share |
| `DSSegmentedControl` | View mode (verses/chapters) |
| `DSBottomSheet` | Notes editor |

### Key Patterns

**Reading Layout:**
```swift
ScrollView {
    VStack(alignment: .leading, spacing: DSSpacing.lg) {
        // Chapter header
        VStack(alignment: .leading) {
            Text("John 3")
                .font(DSTypography.title1)
            Text("New International Version")
                .font(DSTypography.caption)
                .foregroundColor(.dsForegroundMuted)
        }
        
        // Verses
        ForEach(verses) { verse in
            HStack(alignment: .top) {
                Text("\(verse.number)")
                    .font(DSTypography.caption)
                    .foregroundColor(.dsForegroundMuted)
                    .frame(width: 30)
                
                Text(verse.text)
                    .font(DSTypography.body)
            }
            .padding(.vertical, DSSpacing.xs)
        }
    }
    .padding(DSSpacing.lg)
}
```

**Bookmark Toggle:**
```swift
DSIconButton(
    icon: verse.isBookmarked ? "bookmark.fill" : "bookmark",
    variant: verse.isBookmarked ? .primary : .ghost
) {
    verse.isBookmarked.toggle()
}
```

### What You'll Learn

- Content-focused reading layouts
- Bookmark and favorite patterns
- Chapter/section navigation
- Search and filtering
- Notes and annotations
- Reading mode optimization

---

## 5. Daily Quotes App

**File**: `Sources/DesignSystem/Showcase/DSAppShowcase_DailyQuotes.swift`

### Overview

A quote display app with favorites, sharing, and daily notifications. Demonstrates content presentation and social features.

### Features

- 📜 Daily quote display
- ⭐ Favorites collection
- 📤 Share quotes
- 🔔 Daily notifications
- 🎨 Quote cards with authors
- 📚 Quote categories

### Components Used

| Component | Usage |
|-----------|-------|
| `DSCard` | Quote cards |
| `DSButton` | Favorite, share, next quote |
| `DSIconButton` | Quick actions |
| `DSBadge` | Quote categories |
| `DSAvatar` | Author avatars |
| `DSSegmentedControl` | View mode (daily/favorites) |
| `DSEmptyState` | No favorites state |

### Key Patterns

**Quote Card:**
```swift
DSCard {
    VStack(alignment: .leading, spacing: DSSpacing.md) {
        // Quote text
        Text("\"\(quote.text)\"")
            .font(DSTypography.title3)
            .foregroundColor(.dsForeground)
        
        // Author
        HStack {
            DSAvatar(name: quote.author, size: .sm)
            
            VStack(alignment: .leading) {
                Text(quote.author)
                    .font(DSTypography.callout)
                Text(quote.source)
                    .font(DSTypography.caption)
                    .foregroundColor(.dsForegroundMuted)
            }
        }
        
        // Actions
        HStack {
            DSBadge(quote.category)
            Spacer()
            DSIconButton(icon: "heart.fill") { toggleFavorite() }
            DSIconButton(icon: "square.and.arrow.up") { share() }
        }
    }
}
```

**Empty State:**
```swift
if favorites.isEmpty {
    DSEmptyState(
        icon: "heart",
        title: "No favorites yet",
        message: "Tap the heart icon to save your favorite quotes",
        action: {
            DSButton("Browse Quotes") {
                showDaily()
            }
        }
    )
}
```

### What You'll Learn

- Content card layouts
- Favorite/like patterns
- Share sheet integration
- Empty state handling
- Category filtering
- Daily content rotation

---

## 6. Diet Tracker App

**File**: `Sources/DesignSystem/Showcase/DSAppShowcase_DietTracker.swift`

### Overview

A health tracking app with metrics, charts, and meal logging. Demonstrates data visualization and dashboard layouts.

### Features

- 📊 Calorie tracking
- 📈 Weight progress charts
- 🍎 Meal logging
- 💧 Water intake tracking
- 🎯 Goal setting
- 📅 History view

### Components Used

| Component | Usage |
|-----------|-------|
| `DSMetricCard` | Calorie, protein, carbs, fat metrics |
| `DSProgressRingWidget` | Daily goal progress |
| `DSBarChartWidget` | Weekly calorie chart |
| `DSLineChartWidget` | Weight trend chart |
| `DSButton` | Log meal, add entry |
| `DSCard` | Meal cards, history entries |
| `DSBadge` | Meal types (breakfast, lunch, dinner) |
| `DSSegmentedControl` | Time period (day/week/month) |

### Key Patterns

**Dashboard Layout:**
```swift
ScrollView {
    VStack(spacing: DSSpacing.lg) {
        // Metrics row
        HStack(spacing: DSSpacing.sm) {
            DSMetricCard(
                title: "Calories",
                value: "\(calories)",
                subtitle: "of \(goal)",
                trend: .up,
                trendValue: "+5%"
            )
            
            DSMetricCard(
                title: "Protein",
                value: "\(protein)g",
                subtitle: "of \(proteinGoal)g"
            )
        }
        
        // Progress ring
        DSProgressRingWidget(
            value: calorieProgress,
            label: "Daily Goal",
            size: 120
        )
        
        // Chart
        DSBarChartWidget(
            title: "Weekly Calories",
            data: weeklyData
        )
    }
    .padding(DSSpacing.md)
}
```

**Meal Logging:**
```swift
ForEach(meals) { meal in
    DSCard {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(meal.name)
                        .font(DSTypography.headline)
                    DSBadge(meal.type)
                }
                
                Text("\(meal.calories) cal")
                    .font(DSTypography.caption)
                    .foregroundColor(.dsForegroundMuted)
            }
            
            Spacer()
            
            Text(meal.time)
                .font(DSTypography.caption)
        }
    }
}
```

### What You'll Learn

- Dashboard layouts with metrics
- Chart integration (bar, line, donut)
- Progress tracking with rings
- Data logging patterns
- Goal setting and progress
- Time period filtering

---

## Running the Examples

### Option 1: Run in Xcode

1. Open the SwiftDS package in Xcode
2. Navigate to `Sources/DesignSystem/Showcase/`
3. Open any showcase file (e.g., `DSAppShowcase_TodoList.swift`)
4. Look for the view struct (e.g., `AppTodoListView`)
5. Create a preview or add it to your app

### Option 2: Add to Your App

```swift
import SwiftUI
import DesignSystem

struct ContentView: View {
    var body: some View {
        AppTodoListView() // Or any other showcase view
    }
}
```

### Option 3: Use as Reference

Browse the showcase files to see implementation patterns and copy relevant code to your project.

---

## Learning from Examples

### Component Composition

All showcase apps demonstrate how to combine multiple components:

```swift
// From Todo List App
DSCard {
    HStack(spacing: DSSpacing.sm) {
        DSCheckbox(isChecked: $task.isCompleted)
        Text(task.text)
        Spacer()
        DSButton("Comment", variant: .ghost, size: .sm) { }
    }
}
```

### State Management

Learn how to manage complex state with `@State` and computed properties:

```swift
@State private var tasks: [Task] = []
@State private var selectedFolder = "Work"

private var filteredTasks: [Task] {
    tasks.filter { $0.folder == selectedFolder }
}
```

### Layout Patterns

See real-world layout patterns for common UI needs:

- **Lists**: Scrollable lists with cards
- **Grids**: Responsive grids for dashboards
- **Forms**: Input forms with validation
- **Modals**: Bottom sheets and modals
- **Navigation**: Tab bars and navigation bars

### Design Tokens

All examples use design tokens consistently:

```swift
.padding(DSSpacing.md)
.font(DSTypography.body)
.foregroundColor(.dsForeground)
.background(Color.dsSurface)
.cornerRadius(DSRadius.medium)
```

---

## Common Patterns Across Examples

### 1. Card-Based Layouts

Most apps use `DSCard` for content containers:

```swift
DSCard {
    VStack(alignment: .leading) {
        Text("Title")
        Text("Description")
    }
}
```

### 2. Bottom Sheets for Actions

Modal content uses `DSBottomSheet`:

```swift
.overlay {
    if showSheet {
        DSBottomSheet(isPresented: $showSheet) {
            // Sheet content
        }
    }
}
```

### 3. Toast Notifications

Feedback uses `DSToast`:

```swift
.dsToast(
    isPresented: $showToast,
    title: "Success!",
    style: .success
)
```

### 4. Empty States

Empty states use `DSEmptyState`:

```swift
if items.isEmpty {
    DSEmptyState(
        icon: "tray",
        title: "No items",
        message: "Add your first item to get started"
    )
}
```

### 5. Loading States

Loading indicators use `DSSpinner`:

```swift
if isLoading {
    DSSpinner()
} else {
    content
}
```

---

## Next Steps

1. **Explore the code** - Open the showcase files and read through the implementations
2. **Run the examples** - See the apps in action on your device/simulator
3. **Adapt patterns** - Copy patterns that fit your use case
4. **Build your own** - Use these as inspiration for your own apps

---

## Questions?

If you have questions about any of the examples or need help adapting them to your use case, open an issue on GitHub or reach out to the team.

Happy building! 🚀
