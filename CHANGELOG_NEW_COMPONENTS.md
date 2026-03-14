# Changelog - Novos Componentes Genéricos

**Data**: 2026-03-10  
**Versão**: 1.2.0

## 🎯 v1.2.0 - Comprehensive Accessibility Implementation

**Data**: 2026-03-10

### Accessibility Overhaul

Implementação completa de acessibilidade em todos os componentes do SwiftDS, garantindo suporte total para VoiceOver, Dynamic Type, navegação por teclado, e traits semânticos.

#### Dynamic Type Support
- **Refatorado sistema de tipografia** (`DSTypography.swift`) para usar estilos nativos do SwiftUI
- Todos os textos agora escalam automaticamente com as preferências do usuário
- Suporte completo para tamanhos de acessibilidade (até +5)
- Mantida compatibilidade com API existente

#### VoiceOver Support
- **Adicionado `DSAccessibility.swift`** com helpers para labels, hints e traits consistentes
- Todos os 30+ componentes agora têm labels descritivos e contextuais
- Estados (loading, disabled, selected) são anunciados automaticamente
- Badges e contadores convertidos para linguagem natural ("3 notifications")

#### Keyboard Navigation
- **DSFloatingTabBar**: Navegação com setas esquerda/direita entre tabs
- **Command Palette**: Navegação com setas, Enter para selecionar, Escape para fechar
- **Forms**: Ordem de foco lógica com suporte a Tab
- Atalhos de teclado padronizados (Command+Return para ações primárias)

#### Semantic Traits
- Buttons: `.isButton` trait
- Links: `.isLink` trait
- Headers: `.isHeader` trait
- Tabs: `.isButton` + `.isSelected`
- Progress: `.updatesFrequently`
- Toggles: `.isToggle`

#### Components Updated (30 files)
- **High Priority**: DSButton, DSFloatingTabBar, DSInputs, DSChip, DSMenuButton, DSLink, DSButtonGroup
- **Display**: DSProgressRing, DSBadge, DSCardCarousel, DSImageGallery, DSStatusLabel
- **Messaging**: DSMessageBubble, DSChatInputBar
- **Navigation**: DSNavigation, DSSubnavigation
- **Feedback**: DSToast, DSAlert, DSTidbit, DSFullPageInterruption
- **Remaining**: DSSelectField, DSDatePicker, DSColorSelector, DSLayout, DSProductCards, DSOnboarding, DSActivityFeed, DSMarketing, DSAnalytics, DSUserProfile, DSCommandPalette, DSSettings

#### Documentation
- **Atualizado README.md** com seção de acessibilidade precisa e detalhada
- **Criado ACCESSIBILITY.md** com guia completo de implementação e testes
- **Atualizada documentação web** com informações corretas de acessibilidade
- Removida claim de "WCAG AA compliant" (substituída por "design best practices")

---

## 🎉 v1.1.0 - Novos Componentes

**Data**: 2026-03-10

## 🎉 Novos Componentes

### 1. DSFloatingTabBar ✨
**Arquivo**: `Sources/DesignSystem/Components/Navigation/DSFloatingTabBar.swift`

Tab bar flutuante com 3 estilos diferentes e matched geometry effect para transições suaves.

**Estilos disponíveis**:
- `.capsule` - Floating capsule com ultraThinMaterial e shadow dramático (Evolve style)
- `.rounded` - Rounded rectangle com shadow médio
- `.standard` - Full-width bottom bar (similar ao DSTabs)

**Características**:
- Matched geometry effect para transição suave entre tabs
- Suporte para badges em cada tab
- Ícone + label quando selecionado, só ícone quando não selecionado
- Animações de scale e fade
- Acessibilidade completa

**Uso**:
```swift
DSFloatingTabBar(
    items: [
        DSFloatingTabItem(id: "home", label: "Home", icon: "house"),
        DSFloatingTabItem(id: "search", label: "Search", icon: "magnifyingglass", badge: 3)
    ],
    selection: $selectedTab,
    style: .capsule
)
```

**Xcode Snippet**: `DSFloatingTabBar` + Tab

---

### 2. DSProgressRing ✨
**Arquivo**: `Sources/DesignSystem/Components/DataDisplay/DSProgressRing.swift`

Progress ring circular genérico com suporte para gradientes e custom center content.

**Características**:
- Suporte para gradientes ou cores sólidas
- Animação suave de progresso
- Center content customizável (AnyView)
- Configurável: lineWidth, size, startAngle
- Componente auxiliar `DSProgressRingWithLabel`

**Uso**:
```swift
// Com gradiente
DSProgressRing(
    value: 75,
    total: 100,
    gradient: LinearGradient(
        colors: [.blue, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    ),
    lineWidth: 16,
    size: 150
)

// Com cor sólida
DSProgressRing(
    value: 60,
    total: 100,
    color: DSColor.primary,
    size: 120
)

// Com label
DSProgressRingWithLabel(
    label: "Progress",
    value: 80,
    total: 100,
    gradient: DSColor.Category.category1.gradient
)
```

**Xcode Snippet**: `DSProgressRing` + Tab

---

### 3. DSColor.Category ✨
**Arquivo**: `Sources/DesignSystem/Foundations/DSTokens.swift`

Sistema de cores temáticas para categorização e agrupamento.

**7 Categorias disponíveis**:
- `category1` - Warm terracotta (#A06848)
- `category2` - Cool blue-gray (#5A7898)
- `category3` - Forest green (#548A68)
- `category4` - Muted purple (#7A6E90)
- `category5` - Dusty rose (#8E6C7A)
- `category6` - Olive gold (#9A8A58)
- `category7` - Neutral gray (#7A7870)

**Propriedades de cada categoria**:
- `.color` - Cor base
- `.gradient` - Gradiente (topLeading → bottomTrailing)
- `.shadowColor` - Cor de sombra (25% opacity)
- `.tint` - Versão clara para backgrounds (15% opacity)
- `.muted` - Versão suave (60% opacity)

**Uso**:
```swift
// Usar cor diretamente
Text("Category 1")
    .foregroundStyle(DSColor.Category.category1.color)

// Usar gradiente
Circle()
    .fill(DSColor.Category.category2.gradient)

// Usar em badges
DSBadge("Label", category: .category3)
```

---

## 🔄 Componentes Melhorados

### 1. DSMessageBubble (Enhanced)
**Arquivo**: `Sources/DesignSystem/Components/Messaging/DSMessaging.swift`

**Novas funcionalidades**:
- ✅ Suporte para `AnyView` content (não só texto)
- ✅ Estados de loading com typing indicator animado
- ✅ Corner radius assimétrico (mais arredondado no lado oposto)
- ✅ Animações de entrada
- ✅ Avatar customizável (AnyView)

**Dois inicializadores**:
1. **Genérico** - Com AnyView content
```swift
DSMessageBubble(
    content: AnyView(MyCustomView()),
    isFromUser: false,
    avatar: AnyView(MyAvatarView()),
    isLoading: false
)
```

2. **Convenience** - Para texto simples
```swift
DSMessageBubble(
    text: "Hello!",
    isFromUser: true,
    timestamp: Date(),
    senderName: "John",
    avatarText: "JD"
)
```

**Xcode Snippet**: `DSMessageBubble` + Tab

---

### 2. DSChatInputBar (Enhanced)
**Arquivo**: `Sources/DesignSystem/Components/Messaging/DSMessaging.swift`

**Novas funcionalidades**:
- ✅ Suporte para multi-line (TextEditor) ou single-line (TextField)
- ✅ Botão de anexo opcional
- ✅ Estados (disabled, loading)
- ✅ Placeholder para multi-line
- ✅ Max lines configurável

**Uso**:
```swift
// Multi-line com attachment
DSChatInputBar(
    text: $messageText,
    onSend: { text in sendMessage(text) },
    onAttachment: { showAttachmentPicker() },
    multiline: true,
    maxLines: 5
)

// Single-line simples
DSChatInputBar(
    text: $messageText,
    onSend: { text in sendMessage(text) }
)
```

---

### 3. DSBadge (Enhanced)
**Arquivo**: `Sources/DesignSystem/Components/DataDisplay/DSDataDisplay.swift`

**Novas funcionalidades**:
- ✅ Suporte para gradientes (além de cores sólidas)
- ✅ Novo enum `DSBadgeSize` (.sm, .md, .lg)
- ✅ Init convenience para categorias

**Uso**:
```swift
// Com gradiente
DSBadge(
    "Premium",
    variant: .filled,
    gradient: LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing),
    size: .lg
)

// Com categoria
DSBadge("Legs", category: .category1, size: .md)

// Tradicional
DSBadge("Active", variant: .soft, color: DSColor.success)
```

---

## 🐛 Correções

### DSTypography → DSFont/DSTextStyle
**Problema**: O DS estava usando `DSTypography` mas o correto é `DSFont` e `DSTextStyle`.

**Solução**: Substituídas todas as 27 referências em 14 arquivos:
- `DSTypography.title3` → `.dsTextStyle(.title2)`
- `DSTypography.headline` → `.dsTextStyle(.headline)`
- `DSTypography.body` → `.dsTextStyle(.body)`
- `DSTypography.caption` → `.dsTextStyle(.caption)`
- etc.

**Arquivos corrigidos**:
- DSButtonGroup.swift
- DSMessaging.swift
- DSSubnavigation.swift
- DSFullPageInterruption.swift
- DSTidbit.swift
- DSCardCarousel.swift
- DSImageGallery.swift
- DSStatusLabel.swift
- DSMenuButton.swift
- DSLink.swift
- DSDatePicker.swift
- DSSelectField.swift
- DSColorSelector.swift
- DSChip.swift

---

## 📦 Xcode Snippets

Novos snippets adicionados:
- `DSFloatingTabBar` - Tab bar flutuante
- `DSFloatingTabItem` - Item de tab flutuante
- `DSProgressRing` - Progress ring
- `DSProgressRingWithLabel` - Progress ring com label
- `DSMessageBubble` - Message bubble

**Para instalar**:
```bash
cd XcodeSnippets
./generate_snippets.sh
./install_snippets.sh
# Reinicie o Xcode
```

---

## 📚 Documentação Atualizada

### Arquivos atualizados:
1. **README.md**
   - Atualizado de 118+ para 124+ componentes
   - Adicionada categoria "Messaging"
   - Adicionados novos componentes nas categorias existentes
   - Adicionado sistema DSColor.Category

2. **PREVIEW_LIST.md**
   - Adicionado preview "Floating Tab Bar"
   - Adicionado preview "Progress Ring"
   - Adicionado preview "Messaging"

3. **XcodeSnippets/snippets.txt**
   - Adicionados 5 novos snippets

---

## 🎯 Para o App Evolve

### Componentes Prontos para Usar:
1. ✅ `DSFloatingTabBar` - Substitui CustomTabBar
2. ✅ `DSProgressRing` - Base para WorkoutProgressRing e RestTimerRing
3. ✅ `DSMessageBubble` - Use no chat do AI
4. ✅ `DSChatInputBar` - Use no input do chat
5. ✅ `DSBadge` com categorias - Use para muscle group badges

### Componentes Específicos (criar no Evolve):
- `WorkoutProgressRing` → wrapper de `DSProgressRing`
- `RestTimerRing` → `DSProgressRing` + Timer
- `SetButton` → `DSIconButton` + estados
- `ExerciseRow` → `DSListRow` + `DSBadge`
- `MuscleGroupBadge` → `DSBadge(category: ...)`
- Voice recording → específico do Evolve

### Extension Sugerida:
```swift
extension MuscleGroup {
    var category: DSColor.Category {
        switch self {
        case .legs: return .category1
        case .chest: return .category2
        case .back: return .category3
        case .shoulders: return .category4
        case .arms: return .category5
        case .core: return .category6
        case .fullBody: return .category7
        }
    }
}
```

---

## ✅ Build Status

- ✅ Build completo com sucesso (14.05s)
- ⚠️ Apenas warnings de trailing closures (aceitáveis)
- ✅ Todos os componentes funcionando
- ✅ Todos os previews funcionando

---

## 📊 Estatísticas

**Antes**:
- 118 componentes
- 14 categorias
- 59 snippets

**Depois**:
- 124 componentes (+6)
- 15 categorias (+1)
- 64 snippets (+5)

**Arquivos modificados**: 17
**Arquivos criados**: 2
**Linhas de código adicionadas**: ~1200
