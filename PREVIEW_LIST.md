# Lista de Previews para Screenshots

Esta lista contém todos os previews disponíveis no SwiftDS Design System, organizados por categoria para facilitar o processo de captura de screenshots.

## Como Usar

1. Abra o projeto no Xcode
2. Para cada preview listado abaixo, abra o arquivo correspondente
3. Clique no preview no canvas do Xcode (ou use Cmd+Option+Return)
4. Tire o screenshot do preview
5. Marque o item como concluído

## Testando Acessibilidade nos Previews

Todos os previews podem ser testados com acessibilidade:
- **VoiceOver**: Cmd+F5 para ativar no simulador
- **Dynamic Type**: Settings > Accessibility > Display & Text Size
- **Keyboard**: Use Tab, setas, e atalhos para navegar

---

## Componentes Básicos

### Buttons (1 preview)
- [ ] **Buttons** - `Sources/DesignSystem/Components/Buttons/DSButton.swift`
  - Preview: `#Preview("Buttons")`
  - Componentes: DSButton com todas as variantes (primary, secondary, tertiary, ghost, destructive)

### Inputs (1 preview)
- [ ] **Inputs** - `Sources/DesignSystem/Components/Inputs/DSInputs.swift`
  - Preview: `#Preview("Inputs")`
  - Componentes: DSTextField, DSSecureField, DSSearchBar, DSTextArea, DSToggle, DSCheckbox, DSRadioGroup, DSSlider, DSStepper

---

## Data Display

### Data Display (2 previews)
- [ ] **Data Display** - `Sources/DesignSystem/Components/DataDisplay/DSDataDisplay.swift`
  - Preview: `#Preview("Data Display")`
  - Componentes: DSCard, DSAvatar, DSAvatarGroup, DSBadge (com gradientes e sizes), DSTable, DSEmptyState, DSSkeleton

- [ ] **Progress Ring** - `Sources/DesignSystem/Components/DataDisplay/DSProgressRing.swift`
  - Preview: `#Preview("Progress Ring")`
  - Componentes: DSProgressRing (com gradientes, cores, sizes), DSProgressRingWithLabel, DSColor.Category

---

## Navigation

### Navigation (2 previews)
- [ ] **Navigation** - `Sources/DesignSystem/Components/Navigation/DSNavigation.swift`
  - Preview: `#Preview("Navigation")`
  - Componentes: DSNavigationBar, DSTabBar, DSSidebar, DSSegmentedControl, DSBreadcrumb

- [ ] **Floating Tab Bar** - `Sources/DesignSystem/Components/Navigation/DSFloatingTabBar.swift`
  - Preview: `#Preview("Floating Tab Bar")`
  - Componentes: DSFloatingTabBar (capsule, rounded, standard styles), DSFloatingTabItem

---

## Layout

### Layout (1 preview)
- [ ] **Layout** - `Sources/DesignSystem/Components/Layout/DSLayout.swift`
  - Preview: `#Preview("Layout")`
  - Componentes: DSContainer, DSStack, DSGrid, DSDivider, DSSection, DSPageLayout, DSDashboardGrid

---

## Feedback

### Feedback (1 preview)
- [ ] **Feedback** - `Sources/DesignSystem/Components/Feedback/DSFeedback.swift`
  - Preview: `#Preview("Feedback")`
  - Componentes: DSSpinner, DSToast, DSAlert, DSNoticeBar, DSStepIndicator, DSProgressBar, DSStarRating, DSModal, DSBottomSheet

---

## Marketing

### Marketing (2 previews)
- [ ] **Hero Section** - `Sources/DesignSystem/Components/Marketing/DSMarketing.swift`
  - Preview: `#Preview("Hero Section")`
  - Componentes: DSHeroSection, DSFeatureGrid

- [ ] **FAQ + CTA** - `Sources/DesignSystem/Components/Marketing/DSMarketing.swift`
  - Preview: `#Preview("FAQ + CTA")`
  - Componentes: DSFAQSection, DSCTABanner

---

## Product Cards

### Product Cards (2 previews)
- [ ] **Feature Cards** - `Sources/DesignSystem/Components/ProductCards/DSProductCards.swift`
  - Preview: `#Preview("Feature Cards")`
  - Componentes: DSFeatureCard com diferentes layouts

- [ ] **Pricing Cards** - `Sources/DesignSystem/Components/ProductCards/DSProductCards.swift`
  - Preview: `#Preview("Pricing Cards")`
  - Componentes: DSPricingCard com diferentes tiers

---

## Onboarding

### Onboarding (2 previews)
- [ ] **Onboarding Carousel** - `Sources/DesignSystem/Components/Onboarding/DSOnboarding.swift`
  - Preview: `#Preview("Onboarding Carousel")`
  - Componentes: DSOnboardingCarousel com múltiplos steps

- [ ] **Setup Checklist** - `Sources/DesignSystem/Components/Onboarding/DSOnboarding.swift`
  - Preview: `#Preview("Setup Checklist")`
  - Componentes: DSChecklist com tarefas de setup

---

## Activity

### Activity (2 previews)
- [ ] **Activity Feed** - `Sources/DesignSystem/Components/Activity/DSActivityFeed.swift`
  - Preview: `#Preview("Activity Feed")`
  - Componentes: DSActivityFeed com diferentes tipos de eventos

- [ ] **Notification Center** - `Sources/DesignSystem/Components/Activity/DSActivityFeed.swift`
  - Preview: `#Preview("Notification Center")`
  - Componentes: DSNotificationCenter com notificações agrupadas

---

## Analytics

### Analytics (1 preview)
- [ ] **Analytics Dashboard** - `Sources/DesignSystem/Components/Analytics/DSAnalytics.swift`
  - Preview: `#Preview("Analytics Dashboard")`
  - Componentes: DSMetricCard, DSBarChartWidget, DSLineChartWidget, DSDonutChartWidget, DSProgressRingWidget, DSSparkline

---

## User Profile

### User Profile (2 previews)
- [ ] **Profile Hero** - `Sources/DesignSystem/Components/UserProfile/DSUserProfile.swift`
  - Preview: `#Preview("Profile Hero")`
  - Componentes: DSProfileHeroCard com informações do usuário

- [ ] **Team Grid** - `Sources/DesignSystem/Components/UserProfile/DSUserProfile.swift`
  - Preview: `#Preview("Team Grid")`
  - Componentes: DSTeamGrid com múltiplos membros

---

## Command Palette

### Command Palette (2 previews)
- [ ] **Command Palette** - `Sources/DesignSystem/Components/CommandPalette/DSCommandPalette.swift`
  - Preview: `#Preview("Command Palette")`
  - Componentes: DSCommandPalette com busca e comandos

- [ ] **Search Interface** - `Sources/DesignSystem/Components/CommandPalette/DSCommandPalette.swift`
  - Preview: `#Preview("Search Interface")`
  - Componentes: DSSearchInterface com resultados

---

## Settings

### Settings (2 previews)
- [ ] **Settings Screen** - `Sources/DesignSystem/Components/Settings/DSSettings.swift`
  - Preview: `#Preview("Settings Screen")`
  - Componentes: DSSettingsScreen, DSSettingsSection, DSSettingsItem

- [ ] **Danger Zone** - `Sources/DesignSystem/Components/Settings/DSSettings.swift`
  - Preview: `#Preview("Danger Zone")`
  - Componentes: DSDangerZone com ações destrutivas

---

## Messaging

### Messaging (1 preview)
- [ ] **Messaging** - `Sources/DesignSystem/Components/Messaging/DSMessaging.swift`
  - Preview: `#Preview("Messaging")`
  - Componentes: DSMessageBubble (com AnyView content, loading states, avatares), DSChatInputBar (multi-line, attachment button)

---

## Advanced Showcase

### Advanced (1 preview)
- [ ] **Advanced Showcase** - `Sources/DesignSystem/Showcase/DSAdvancedShowcase.swift`
  - Preview: `#Preview("Advanced Showcase")`
  - Componentes: Composições avançadas de múltiplos componentes

---

## Showcase Apps (Demos Completos)

Estes arquivos não têm `#Preview` mas são apps completos que podem ser executados no simulador para screenshots:

### Todo List App
- [ ] **DSAppShowcase_TodoList.swift**
  - Arquivo: `Sources/DesignSystem/Showcase/DSAppShowcase_TodoList.swift`
  - Descrição: App completo de gerenciamento de tarefas com 3 variantes de tema
  - Componentes: DSButton, DSTextField, DSCard, DSChip, DSCheckbox, DSSegmentedControl

### Travel Organizer App
- [ ] **DSAppShowcase_TravelOrganizer.swift**
  - Arquivo: `Sources/DesignSystem/Showcase/DSAppShowcase_TravelOrganizer.swift`
  - Descrição: App de planejamento de viagens com itinerários
  - Componentes: DSCard, DSButton, DSBadge, DSAvatar, DSProgressBar

### AI Chat App
- [ ] **DSAppShowcase_AIChat.swift**
  - Arquivo: `Sources/DesignSystem/Showcase/DSAppShowcase_AIChat.swift`
  - Descrição: Interface de chat com IA
  - Componentes: DSMessageBubble, DSChatInputBar, DSAvatar, DSButton

### Bible Verses App
- [ ] **DSAppShowcase_BibleVerses.swift**
  - Arquivo: `Sources/DesignSystem/Showcase/DSAppShowcase_BibleVerses.swift`
  - Descrição: App de leitura e marcação de versículos
  - Componentes: DSCard, DSButton, DSBadge, DSSearchBar

### Daily Quotes App
- [ ] **DSAppShowcase_DailyQuotes.swift**
  - Arquivo: `Sources/DesignSystem/Showcase/DSAppShowcase_DailyQuotes.swift`
  - Descrição: App de exibição de citações diárias
  - Componentes: DSCard, DSButton, DSIconButton, DSBadge

### Diet Tracker App
- [ ] **DSAppShowcase_DietTracker.swift**
  - Arquivo: `Sources/DesignSystem/Showcase/DSAppShowcase_DietTracker.swift`
  - Descrição: App de rastreamento de dieta e saúde
  - Componentes: DSMetricCard, DSProgressRing, DSButton, DSCard, DSBarChart

---

## Resumo

**Total de Previews**: 22 previews
- **Componentes com #Preview**: 20 previews em 15 arquivos
- **Showcase Apps**: 6 apps completos (sem #Preview, mas executáveis)

**Componentes Faltando Previews**: 13 arquivos
- DSChip.swift
- DSColorSelector.swift
- DSSelectField.swift
- DSDatePicker.swift
- DSButtonGroup.swift
- DSLink.swift
- DSMenuButton.swift
- DSStatusLabel.swift
- DSImageGallery.swift
- DSCardCarousel.swift
- DSTidbit.swift
- DSFullPageInterruption.swift
- DSSubnavigation.swift
- DSMessaging.swift

---

## Dicas para Screenshots

1. **Resolução**: Use iPhone 15 Pro ou similar para consistência
2. **Modo Claro/Escuro**: Tire screenshots em ambos os modos quando relevante
3. **Organização**: Crie pastas por categoria (Buttons, Inputs, etc.)
4. **Nomenclatura**: Use o nome do preview (ex: `buttons.png`, `inputs.png`)
5. **Canvas do Xcode**: Use Cmd+Option+Return para abrir o preview rapidamente
