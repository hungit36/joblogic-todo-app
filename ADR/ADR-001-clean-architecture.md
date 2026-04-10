# ADR-001: Adopt Clean Architecture

## Status

Accepted

---

## Context

The application is expected to support:

- Multiple features (To-Do, To-Sell, Sync)
- Offline-first capability
- Multiple data sources (Remote API, Local Database)
- Long-term maintainability and scalability

Additionally:

- Business logic is non-trivial (sync, retry, state transitions)
- Team collaboration requires clear separation of concerns
- Unit testing must be supported without UI or framework dependency

Traditional patterns like MVC or basic MVVM tend to:

- Mix business logic into UI layer
- Become difficult to scale with complex flows (e.g., sync, caching)
- Reduce testability

---

## Decision

We adopt **Clean Architecture** with strict layer separation:

### 1. Presentation Layer

Responsibilities:

- UI rendering (Flutter Widgets)
- State management (Bloc / Cubit)
- Handling user interaction

Characteristics:

- Depends only on Domain layer
- No direct dependency on Data layer

---

### 2. Domain Layer (Core)

Responsibilities:

- Business logic (UseCases)
- Core models (Entities)
- Repository contracts (abstract interfaces)

Characteristics:

- Framework-independent
- Pure Dart (no Flutter / API / DB dependencies)

This is the **most stable layer**.

---

### 3. Data Layer

Responsibilities:

- Repository implementations
- Data source handling (Remote API, Local DB)
- DTO ↔ Entity mapping

Includes:

- RemoteDataSource (API)
- LocalDataSource (SQLite / Hive / Memory)
- RepositoryImpl

---

## Architecture Flow

User Action  
→ UI (Widget)  
→ Bloc / Cubit  
→ UseCase  
→ Repository (interface)  
→ RepositoryImpl  
→ DataSource (Remote / Local)

---

## Dependency Rule

- Presentation → Domain
- Data → Domain
- Domain → (no dependency)

Enforced via:

- Interface abstraction
- Dependency Injection

---

## Project Structure (Example)
ToDoApp/
├── App/
│   ├── ToDoApp.swift
│   ├── AppDIContainer.swift
│
├── Core/
│   ├── Networking/
│   │   ├── APIClient.swift
│   │   ├── Endpoint.swift
│   │   ├── MockData.swift
│
│   ├── Network/
│   │   ├── NetworkMonitor.swift
│   │
│   ├── Database/
│   │   ├── StorageManager.swift
│   │
│   ├── Utils/
│   │   ├── ViewState.swift
│   │   ├── AppError.swift
│   │   ├── Logger.swift
│   │   ├── RetryPolicy.swift
│
│   ├── Extensions/
│   │   ├── Date+Ext.swift
│   │   ├── Array+Ext.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── Person.swift
│   │   ├── BuyItem.swift
│   │   ├── SellItem.swift
│   │   ├── BuySortType.swift
│
│   ├── Repositories/
│   │   ├── PersonRepository.swift
│   │   ├── BuyRepository.swift
│   │   ├── SellRepository.swift
│
│   ├── UseCases/
│   │   ├── FetchPersonsUseCase.swift
│   │   ├── FetchBuyItemsUseCase.swift
│   │   ├── CRUDSellUseCase.swift
│   │   ├── SyncSellUseCase.swift
│
├── Data/
│   ├── DTOs/
│   │   ├── BuyItemDTO.swift
│   │   ├── EmptyResponse.swift
│   │   ├── PersonDTO.swift
│   │   ├── SellItemDTO.swift
│   
│   ├── RepositoriesImpl/
│   │   ├── PersonRepositoryImpl.swift
│   │   ├── BuyRepositoryImpl.swift
│   │   ├── SellRepositoryImpl.swift
│
├── Presentation/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│
│   ├── ToCall/
│   │   ├── ToCallView.swift
│   │   ├── ToCallViewModel.swift
│
│   ├── ToBuy/
│   │   ├── ToBuyDetailView.swift
│   │   ├── ToBuyView.swift
│   │   ├── ToBuyViewModel.swift
│
│   ├── ToSell/
│   │   ├── ToSellView.swift
│   │   ├── ToSellViewModel.swift
│
│   ├── Sync/
│   │   ├── BackgroundSyncManager.swift
│   │   ├── SyncView.swift
│   │   ├── SyncViewModel.swift
│
├── ToDoAppTests/
│   ├── Mock/
│   │   ├── MockURLProtocol.swift
│   ├── APIClientTests.swift
│   ├── StorageManagerTests.swift


---

## Alternatives Considered

### MVVM Only

Rejected because:

- ViewModel becomes too large
- Business logic leaks into UI layer
- Hard to maintain with sync/offline logic

---

### MVC

Rejected because:

- Poor separation of concerns
- Not suitable for modern reactive UI

---

## Consequences

### Positive

- High testability (UseCase & Repository easily mocked)
- Scalable for large features
- Clear ownership per layer
- Easier onboarding for new developers

---

### Negative

- More boilerplate code
- Higher initial setup cost
- Requires discipline to maintain boundaries

---

## Notes

This architecture is intentionally chosen to reflect **real-world production mobile systems**, especially those requiring:

- Offline-first behavior
- Complex state management
- Long-term scalability