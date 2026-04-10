# Joblogic To-Do App (Senior Mobile Developer Test)

## 👤 Candidate

Nguyen Van Hung

## ⏱ Completion Time

Completed within 48 hours as required.

---

# 🚀 Overview

This project demonstrates a production-ready mobile application using:

* SwiftUI (iOS)

Following:

* Clean Architecture
* Offline-first strategy
* Scalable & testable design

---

# ✨ Features

## 1. Home

* 4 modules: To Call, To Buy, To Sell, Sync
* Realtime counters

---

## 2. To-Call (Remote API)

* Pagination
* Filtering (search)
* Retry (exponential backoff)
* Last synced timestamp

---

## 3. To-Buy (Remote API)

* Sorting
* Filtering
* Detail page
* Wishlist (local persistence)

---

## 4. To-Sell (Local DB)

* Full CRUD
* Validation
* Bulk delete
* Undo delete

---

## 5. Sync Module (Hybrid)

* Offline-first
* Manual sync
* Background sync (30s interval)
* Sync queue
* Conflict handling (client wins)

---

# 🧠 Architecture

* Clean Architecture
* Repository Pattern
* UseCase Pattern
* Dependency Injection

---

# 📁 Project Structure

See `/ToDoApp` code by swiftUI

---

# 📱 Run SwiftUI

* Open `swiftui-app/ToDoApp.xcodeproj`
* Run on simulator

---

# 🧪 Testing

Includes:

* UseCase tests
* Repository tests
* Retry tests

---

# 📊 Diagrams

Located in `/diagrams`:

* Architecture diagram
* Sequence diagram

---

# 📄 ADR

Located in `/ADR`:

* ADR-001 Clean Architecture
* ADR-002 Offline-first

---

# ⚠️ Edge Cases Handled

* API failure → retry
* Offline usage
* Sync retry
* Duplicate prevention
* Empty state
* Loading state
* Race condition

---

# 💡 Notes

Project is designed to be:

* Easily scalable
* Production-ready
* Reviewer-friendly (run < 10 minutes)
