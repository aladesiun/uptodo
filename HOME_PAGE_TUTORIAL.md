# Building a Task Management Home Page in Flutter

## Overview

This tutorial will guide you through building a complete task management home page with all its interactive widgets. We'll cover the main home screen, task creation bottom sheet, date/time pickers, priority selection, category management, and empty states.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Home Content Widget](#home-content-widget)
3. [Add Task Bottom Sheet](#add-task-bottom-sheet)
4. [Date Picker Dialog](#date-picker-dialog)
5. [Time Picker Dialog](#time-picker-dialog)
6. [Priority Picker Dialog](#priority-picker-dialog)
7. [Category Picker Dialog](#category-picker-dialog)
8. [Create Category Page](#create-category-page)
9. [Empty State Implementation](#empty-state-implementation)
10. [Best Practices](#best-practices)

---

## Project Structure

Before we begin, let's understand the folder structure:

```
lib/home/
├── home_content.dart              # Main home screen
├── add_task_bottom_sheet.dart     # Task creation bottom sheet
├── create_category_page.dart      # Full-screen category creation
├── widgets/
│   ├── date_picker_dialog.dart    # Custom date picker
│   ├── time_picker_dialog.dart    # Custom time picker
│   ├── priority_picker_dialog.dart # Priority selection
│   └── category_picker_dialog.dart # Category selection
```

This modular structure keeps our code organized and maintainable.

---

## Home Content Widget

### Understanding the Layout

The home content widget is the main screen that displays tasks. It consists of:

1. **Header Section**: Search icon, title, and user avatar
2. **Search Bar**: Input field for searching tasks
3. **Task Sections**: Expandable sections for "Today" and "Completed" tasks
4. **Empty State**: Displayed when no tasks exist

### Widget Structure

**Main Widget:**
- `HomeContent` (StatefulWidget)
- `_HomeContentState` (State)

**State Variables:**
- `_todayExpanded` (bool)
- `_completedExpanded` (bool)
- `_todayTasks` (List<Map<String, dynamic>>)
- `_completedTasks` (List<Map<String, dynamic>>)

**Key Methods:**
- `build()` - Main build method
- `_buildSectionHeader()` - Creates expandable section headers
- `_buildTaskCard()` - Builds individual task cards
- `_buildEmptyState()` - Displays empty state when no tasks exist

### Layout Components

**Header:**
- `Row` with `MainAxisAlignment.spaceBetween`
- `Icon` (search icon)
- `Text` (title)
- `CircleAvatar` (user profile)

**Search Bar:**
- `Padding` wrapper
- `Container` with `BoxDecoration`
- `TextField` with custom styling

**Task Sections:**
- `ListView` for scrollable content
- `_buildSectionHeader()` for section titles
- Conditional rendering with `if` statements
- `_buildTaskCard()` for each task

**Task Card Components:**
- Checkbox container
- Task title and time
- Category tag with icon
- Priority flag with number

---

## Add Task Bottom Sheet

### Understanding Bottom Sheets

Bottom sheets slide up from the bottom of the screen and are perfect for task creation forms. They provide a focused interface without navigating away from the current screen.

### Widget Structure

**Main Widget:**
- `AddTaskBottomSheet` (StatefulWidget)
- `_AddTaskBottomSheetState` (State)

**Controllers:**
- `_taskTitleController` (TextEditingController)
- `_descriptionController` (TextEditingController)

**Key Methods:**
- `build()` - Main build method
- `dispose()` - Cleanup controllers
- `_showDatePicker()` - Opens date picker dialog
- `_showPriorityPicker()` - Opens priority picker dialog
- `_showCategoryPicker()` - Opens category picker dialog

### Layout Components

**Container Structure:**
- `Container` with rounded top corners
- `Padding` for content spacing
- `Column` for vertical layout

**Form Elements:**
- Title text ("Add Task")
- Task title `TextField`
- Description `TextField` (expandable with `maxLines: null`)
- Action icons row with:
  - Clock icon (date/time picker)
  - Location icon (category picker)
  - Flag icon (priority picker)
  - Send icon (submit action)

---

## Date Picker Dialog

### Understanding Custom Dialogs

Custom dialogs provide full control over the user experience. We'll create a calendar-based date picker.

### Widget Structure

**Main Widget:**
- `CustomDatePickerDialog` (StatefulWidget)
- `_CustomDatePickerDialogState` (State)

**State Variables:**
- `_selectedDate` (DateTime)
- `_displayedMonth` (DateTime)

**Key Methods:**
- `build()` - Main build method
- `initState()` - Initialize with current date
- `_previousMonth()` - Navigate to previous month
- `_nextMonth()` - Navigate to next month
- `_selectDate()` - Handle date selection
- `_getDaysInMonth()` - Generate calendar grid days
- `_isSameDay()` - Compare two dates
- `_isCurrentMonth()` - Check if date belongs to displayed month
- `_showTimePicker()` - Open time picker after date selection

### Layout Components

**Dialog Structure:**
- `Dialog` with transparent background
- `Container` with rounded corners
- `Column` for vertical layout

**Calendar Components:**
- Month navigation header with:
  - Previous month button
  - Month and year display
  - Next month button
- Days of week header (SUN-SAT)
- `GridView.builder` for calendar grid (7 columns, 6 rows)
- Action buttons (Cancel, Choose Time)

---

## Time Picker Dialog

### Understanding Wheel Scrollers

Time pickers use wheel scrollers for an intuitive selection experience. Flutter's `ListWheelScrollView` provides this functionality.

### Widget Structure

**Main Widget:**
- `CustomTimePickerDialog` (StatefulWidget)
- `_CustomTimePickerDialogState` (State)

**Controllers:**
- `_hourController` (FixedExtentScrollController)
- `_minuteController` (FixedExtentScrollController)
- `_ampmController` (FixedExtentScrollController)

**State Variables:**
- `_selectedHour` (int)
- `_selectedMinute` (int)
- `_isPM` (bool)

**Key Methods:**
- `build()` - Main build method
- `initState()` - Initialize controllers with current time
- `dispose()` - Cleanup controllers
- `_buildWheel()` - Creates wheel scroll view component
- `_buildWheelItem()` - Builds individual wheel items

### Layout Components

**Dialog Structure:**
- `Dialog` with transparent background
- `Container` with rounded corners
- `Column` for vertical layout

**Time Selection:**
- `Row` containing three wheels:
  - Hour wheel (1-12)
  - Colon separator
  - Minute wheel (0-59)
  - AM/PM wheel
- Action buttons (Cancel, Save)

**Wheel Configuration:**
- `ListWheelScrollView.useDelegate`
- `FixedExtentScrollPhysics` for snapping
- Custom `diameterRatio` and `perspective` for 3D effect

---

## Priority Picker Dialog

### Grid-Based Selection

Priority selection uses a grid layout for visual clarity.

### Widget Structure

**Main Widget:**
- `PriorityPickerDialog` (StatefulWidget)
- `_PriorityPickerDialogState` (State)

**State Variables:**
- `_selectedPriority` (int)

**Key Methods:**
- `build()` - Main build method
- `_buildPriorityButton()` - Creates priority selection buttons

### Layout Components

**Dialog Structure:**
- `Dialog` with transparent background
- `Container` with rounded corners
- `Column` for vertical layout

**Priority Grid:**
- Title and divider
- Three rows of priority buttons:
  - Row 1: Priorities 1-4
  - Row 2: Priorities 5-8
  - Row 3: Priorities 9-10
- Action buttons (Cancel, Save)

**Priority Button:**
- `GestureDetector` for tap handling
- `Container` with conditional styling
- Flag icon and priority number
- Visual feedback for selected state

---

## Category Picker Dialog

### Grid Layout for Categories

Categories are displayed in a grid for easy selection.

### Widget Structure

**Main Widget:**
- `CategoryPickerDialog` (StatefulWidget)
- `_CategoryPickerDialogState` (State)

**Data:**
- `_categories` (List<Map<String, dynamic>>)

**Key Methods:**
- `build()` - Main build method
- `_buildCategoryButton()` - Creates category selection buttons
- `_buildCreateNewButton()` - Creates "Create New" button
- `_showCreateCategoryDialog()` - Navigates to create category page

### Layout Components

**Dialog Structure:**
- `Dialog` with transparent background
- `Container` with rounded corners
- `Column` for vertical layout

**Category Grid:**
- Title and divider
- `GridView.builder` with 3 columns
- Category buttons with:
  - Colored background
  - Icon
  - Category name
- "Create New" button in grid
- "Add Category" button at bottom

**Category Button:**
- `GestureDetector` for tap handling
- `Container` with category color
- Icon and text label

---

## Create Category Page

### Full-Screen Navigation

Category creation uses a full-screen page for a focused experience.

### Widget Structure

**Main Widget:**
- `CreateCategoryPage` (StatefulWidget)
- `_CreateCategoryPageState` (State)

**Controllers:**
- `_categoryNameController` (TextEditingController)

**State Variables:**
- `_selectedIcon` (IconData)
- `_selectedColor` (Color)
- `_colors` (List<Color>)

**Key Methods:**
- `build()` - Main build method
- `dispose()` - Cleanup controller

### Layout Components

**Page Structure:**
- `Scaffold` with black background
- `AppBar` with back button and title
- `SafeArea` wrapper
- `SingleChildScrollView` for scrollable content

**Form Fields:**
- Category name label and `TextField`
- Category icon label and button
- Category color label
- Horizontal scrolling `ListView.builder` for color selection
- "Create Category" button

**Color Picker:**
- `SizedBox` with fixed height
- `ListView.builder` with `Axis.horizontal`
- Circular color swatches
- White border for selected color

---

## Empty State Implementation

### When to Show Empty State

Empty states provide guidance when no data exists. They should be informative and actionable.

### Widget Structure

**Method:**
- `_buildEmptyState()` - Returns empty state widget

### Layout Components

**Empty State:**
- `Column` with centered content
- `Image.asset` for empty checklist image
- Primary text ("What do you want to do today?")
- Secondary text ("Tap + to add your tasks")

### Conditional Rendering

**Implementation:**
- Check if both `_todayTasks` and `_completedTasks` are empty
- Use ternary operator to show either:
  - `_buildEmptyState()` when empty
  - `ListView` with task sections when tasks exist

---

## Best Practices

### Code Organization

1. **Modular Structure**: Separate widgets into their own files
2. **Consistent Naming**: Use clear, descriptive names
3. **Reusable Components**: Extract common patterns into methods
4. **State Management**: Dispose controllers and resources properly

### Design Principles

1. **Consistency**: Maintain consistent spacing, colors, and typography
2. **Visual Hierarchy**: Use size, weight, and color to guide attention
3. **Feedback**: Provide clear visual feedback for user interactions
4. **Accessibility**: Ensure adequate touch targets and contrast

### Performance Considerations

1. **Lazy Loading**: Use `ListView.builder` for long lists
2. **Image Optimization**: Use appropriate image sizes
3. **Controller Management**: Always dispose controllers
4. **State Updates**: Minimize unnecessary rebuilds

### User Experience

1. **Loading States**: Show loading indicators for async operations
2. **Error Handling**: Provide clear error messages
3. **Empty States**: Guide users when no data exists
4. **Navigation**: Use appropriate navigation patterns (dialogs, sheets, pages)

---

## Summary

This tutorial covered:

1. **Home Content Widget**: Main screen with header, search, and task sections
2. **Add Task Bottom Sheet**: Task creation interface with expandable fields
3. **Date Picker Dialog**: Custom calendar implementation
4. **Time Picker Dialog**: Wheel-based time selection
5. **Priority Picker Dialog**: Grid-based priority selection
6. **Category Picker Dialog**: Category selection with grid layout
7. **Create Category Page**: Full-screen category creation
8. **Empty State**: Guidance when no tasks exist

Each component follows Flutter best practices and maintains a consistent design language. By understanding these patterns, you can build similar interfaces for other features in your application.

---

## Exercises

1. Add validation to the task creation form
2. Implement task editing functionality
3. Add swipe-to-delete gesture for tasks
4. Create a filter system for tasks
5. Implement search functionality
6. Add animations to transitions between states
7. Create a dark/light theme toggle
8. Implement task completion with checkboxes

---

## Additional Resources

- Flutter Widget Catalog
- Material Design Guidelines
- Flutter Layout Tutorials
- State Management Best Practices
