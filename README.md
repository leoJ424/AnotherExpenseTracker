# AnotherExpenseTracker                                                                                                    
                                                   
A native macOS expense tracker built with SwiftUI and SwiftData.
                                                                                                                            
This is a learning project — my first app in Swift/Xcode — and a spiritual successor to my earlier Windows WPF app,
[JustAnotherExpenseTracker](https://github.com/leoJ424/JustAnotherExpenseTracker).                                         
                                                                                                                            
## Goals                                    
                                                                                                                            
- Track personal expenses on the Mac with a clean, native interface
- Learn SwiftUI, SwiftData, and the Xcode toolchain along the way                                                          
- Start with a minimal MVP and iterate   
                                                                                                                            
## Tech stack                            
                                                                                                                            
- **SwiftUI** — UI framework                     
- **SwiftData** — local persistence (SQLite-backed, no manual schema)
- **Swift Charts** — spending visualizations                                                 
- **macOS 14+** — minimum deployment target (required for SwiftData)
                                                                                                                            
## Roadmap                                  
                                                                                                                            
### MVP                                     
- [x] Phase 0 — Project scaffolding & GitHub setup                                                                         
- [x] Phase 1 — App shell with navigation layout 
- [x] Phase 2 — Expense model and SwiftData setup                                                                          
- [x] Phase 3 — Display expense list                                                                                       
- [x] Phase 4 — Add expense sheet                                                                                          
- [x] Phase 5 — Edit and delete expenses                                                                                   
- [x] Phase 6 — Filtering and search                                                                                       
                                                
### Post-MVP                                     
- [x] Phase 7 — Charts and summaries                                                                                       
- [x] Phase 8 — Accounts / cards  
    - 8.1 — `Account` model, mandatory relationship on `Expense`, default Cash account seeded on launch
    - 8.2 — Account picker in the expense editor; account shown on each expense row                                                                 
    - 8.3 — Accounts management view with edit and delete (default account and accounts with linked expenses are protected from deletion)           
    - 8.4 — Filter expenses by account in the main list                                                                                         
- [x] Phase 9 — Budgets per category                                                                                                              
    - 9.1 — `Budget` model (sparse by design — no record means no budget set) + container registration                                            
    - 9.2 — Budgets view with per-category progress bars, upsert editor, and over-budget tint                                                     
    - 9.3 — Over-budget flag in Summary view (warning icon + red tint + hover tooltip)                                                                                                              
- [x] Phase 10 — Recurring expenses
    - 10.1 — `RecurringExpense` model + `Frequency` enum + `sourceSchedule` back-reference on `Expense` (additive migration)                                             
    - 10.2 — Recurring list view + sidebar entry, computed next-due date per row                                                                                         
    - 10.3 — Editor sheet with create / edit / delete, optional end date via toggle                                                                                      
    - 10.4 — Auto-generation on app launch and after save (idempotent catch-up via `lastGeneratedDate`)                                                                  
    - 10.5 — Cleared-field fix across editors, Account picker placeholder, Account deletion guard now counts recurring schedules                                                                                                           
- [ ] Phase 11 — Polish (icon, settings, export, shortcuts)                                                                                       
- [ ] Phase 12 — DB-side filtering (migrate in-memory filters to `#Predicate`)                                                              
                                            
## Building                                                                                                                
                                        
1. Open `AnotherExpenseTracker.xcodeproj` in Xcode 15 or later                                                             
2. Select the **My Mac** run destination         
3. Hit ⌘R                                                                                                                  
                                                                                                                            
## License                                                                                                                 
                                                                                                                            
MIT — see LICENSE.     
