# ADR-002: Offline-First Data Strategy

## Status

Accepted

---

## Context

The application must support:

- Full functionality without internet
- Data persistence across app restarts
- Syncing data to server when network is available

Key user requirements:

- Create / update / delete items offline
- Mark items as sold without connectivity
- Sync data later without losing changes

Challenges:

- Network instability
- Data consistency
- Conflict resolution

---

## Decision

We adopt an **Offline-First architecture** where:

> Local Database is the Single Source of Truth

---

## Core Principles

1. UI always reads from Local DB  
2. All writes go to Local DB first  
3. Sync runs asynchronously in background  

---

## Implementation Strategy

### 1. Local-First Writes

All operations:

- Add item
- Update item
- Delete item
- Mark as sold

→ Saved immediately to Local DB

---

### 2. Sync Metadata

Each record includes:

- `isSynced` (bool)
- `updatedAt`
- `operationType` (create/update/delete)

---

### 3. Sync Queue

Unsynced records are:

- Stored locally
- Processed sequentially

---

### 4. Sync Trigger

Sync is triggered by:

- Manual action (user presses Sync)
- Background worker (interval-based or network restored)

---

### 5. Sync Flow

Local Change  
→ Save to DB  
→ Mark `isSynced = false`  
→ Add to queue  
→ Sync Worker  
→ Call API  
→ Update `isSynced = true`

---

## Conflict Resolution

Strategy: **Client Wins**

Reason:

- Simpler implementation
- Suitable for demo / test project
- Avoids complex merge logic

Future upgrade:

- Server timestamp comparison
- Field-level merge

---

## Error Handling

- Network failure → retry later
- API error → keep unsynced state
- Partial sync → continue remaining items

---

## Edge Cases

Handled scenarios:

- App restart → data persists in DB
- Duplicate sync → prevented by unique ID
- Interrupted sync → resumes next cycle
- Multiple updates before sync → only latest state is pushed

---

## Alternatives Considered

### Online-Only

Rejected because:

- Breaks when offline
- Poor UX

---

### Server as Source of Truth

Rejected because:

- Requires constant connectivity
- Increases latency
- Not aligned with offline requirement

---

## Consequences

### Positive

- Works fully offline
- Fast UI response (local read/write)
- Better user experience

---

### Negative

- Increased implementation complexity
- Need to manage sync state
- Temporary data inconsistency possible

---

## Notes

This pattern is widely used in production apps such as:

- Note-taking apps
- E-commerce draft systems
- Field service / logistics apps

It demonstrates the ability to design **resilient mobile systems under unreliable network conditions**.