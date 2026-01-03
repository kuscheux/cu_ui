# Changelog

## 1.0.0

### CU UI Design Language - Initial Release

A comprehensive Flutter UI design language inspired by Geist UI.

#### Features

- **Design Tokens**: Complete tokenized design system
  - Color tokens with semantic colors and accent scales
  - Typography tokens with 11 predefined text styles
  - Spacing tokens with named scale
  - Border radius tokens
  - Shadow/elevation tokens
  - Animation tokens with 6 animation modes
  - Breakpoint tokens for responsive design
  - Border tokens

- **Theme System**
  - Light and dark theme presets
  - Teenage Engineering-inspired theme
  - InheritedWidget-based theme propagation
  - Context extensions for easy access

- **Components (40+ implemented)**

  **Buttons**
  - CuButton with 9 type variants and 3 sizes

  **Inputs**
  - CuInput - text input with label, icons, validation
  - CuTextarea - multi-line text input
  - CuCheckbox - checkbox with label
  - CuRadio - radio button with group support
  - CuToggle - toggle switch
  - CuSlider - range slider
  - CuSelect - dropdown selection
  - CuAutoComplete - input with suggestions

  **Layout**
  - CuGrid - responsive grid container
  - CuRow - horizontal flex container
  - CuCol - vertical flex container
  - CuSpacer - empty space
  - CuDivider - horizontal separator
  - CuPage - page container
  - CuFieldset - grouped form fields

  **Surfaces**
  - CuCard - content container
  - CuModal - dialog overlay
  - CuDrawer - sliding panel
  - CuPopover - click-triggered popup
  - CuTooltip - hover information
  - CuCollapse - expandable panel

  **Navigation**
  - CuTabs - tabbed navigation
  - CuBreadcrumbs - navigation path
  - CuPagination - page navigation
  - CuLink - styled hyperlink

  **Typography**
  - CuText - flexible text component
  - CuCode - inline code display
  - CuSnippet - code snippet with copy
  - CuKeyboard - keyboard shortcut display

  **Data Display**
  - CuAvatar - user profile image
  - CuBadge - status indicator
  - CuTag - keyword label
  - CuTable - data table
  - CuUser - user profile display
  - CuDot - status dot
  - CuCapacity - usage indicator
  - CuDescription - label + content
  - CuDisplay - hero section
  - CuImage - enhanced image
  - CuRating - star rating

  **Feedback**
  - CuSpinner - loading spinner
  - CuLoading - loading dots
  - CuProgress - progress bar
  - CuNote - highlighted message
  - CuToast - notification message

- **Animation System**
  - Particle system model
  - Wave propagation model
  - Animated text reveal
  - Custom easing curves
