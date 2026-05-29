---
applyTo:
  - 'BackEnd/**'
---

# Backend Path-Specific Instructions

## 適用範圍
- 本檔案只適用於 `BackEnd/` 目錄下的程式碼、資料庫腳本、測試與技術文件。
- 若任務同時涉及 `Docs/`，僅可在角色 prompt 或使用者明確要求下，更新允許範圍內的文件。

## 後端技術基準
- 後端技術棧以 C#、.NET、ASP.NET Core Web API、MS SQL 為主。
- 預設採用 CQRS + MediatR + Clean Architecture。
- 資料存取以 EF Core + Dapper 為主，依 Spec 或既有專案策略決定使用邊界。
- 驗證優先使用 FluentValidation。
- 錯誤回應優先沿用 ProblemDetails、ValidationProblemDetails 或專案既定統一格式。

## 架構與分層規則
- 優先維持 Domain、Application、Infrastructure、WebApi 的清楚邊界。
- Controller 應保持精簡，只負責 HTTP 輸入輸出、授權邊界與轉交應用層。
- 商業邏輯不可堆在 Controller。
- 每個 Use Case 優先對應清楚的 Command / Query、Handler、Validator、DTO。
- 優先採用 folder-per-feature 或既有功能聚合結構，不要無限制平鋪檔案。
- 依賴方向應由外向內，Domain 不可依賴 Infrastructure 或 WebApi。

## Data Access 規則
- 若 Spec 未另行指定，預設：
  - Command 類操作優先使用 EF Core
  - Query 類操作優先使用 Dapper
- 使用 Dapper 時必須全面參數化查詢，禁止字串拼接 SQL。
- Query 不應偷偷修改資料；Command 不應承擔複雜報表查詢。
- 若同一功能同時使用 EF Core 與 Dapper，需明確區分責任。
- 若查詢邏輯複雜，應將 SQL 組織成可維護結構，不得散落於多處。

## CQRS / MediatR 規則
- 每個 API 行為應對應到明確的 Command 或 Query。
- Command 與 Query 應分別建立獨立檔案與處理流程，避免混用。
- Handler 應聚焦單一 Use Case。
- Cross-cutting concerns 應優先透過 MediatR Pipeline Behaviors 處理。
- Pipeline Behaviors 至少應包含 Validation Behavior。
- 不應在 Controller 中重複撰寫驗證、交易、快取等橫切邏輯。

## API 與契約規則
- API 實作必須嚴格遵守 `Docs/Spec/` 中定義的 API 名稱、Route、HTTP Method、Request / Response JSON、Error Response、Status Codes 與 Auth 規則。
- 不得任意新增、刪除或修改 API 契約。
- Response DTO、Request DTO、Query Model、Command Model 應與 Spec 一致。
- JSON 欄位命名與 API 路徑命名應保持一致且可預測。

## 驗證與錯誤處理規則
- 所有 Command / Query 輸入都必須驗證。
- 驗證應使用 FluentValidation，並與 Command / Query 一一對應。
- 驗證流程應優先透過 MediatR Validation Behavior 統一處理，不應散落於 Controller。
- API 錯誤回應應使用 ProblemDetails、ValidationProblemDetails 或專案既定統一錯誤格式，且不得洩漏敏感資訊。
- 驗證失敗、授權失敗、找不到資料、狀態衝突與未預期錯誤，應回傳一致且可預期的格式。
- 若專案已有全域例外處理 Middleware / Exception Handler，應優先沿用既有機制。

## 精準度與安全規則
- 金額、匯率、數量、報酬率等高精度數值優先使用 `decimal`，禁止使用 `float` 或 `double`。
- EF Core 對應 MS SQL decimal 欄位時，若 Spec 無指定，預設使用 `.HasPrecision(18, 4)`。
- 不可將 Token、密碼、連線字串、Stack Trace 或內部錯誤細節暴露到 API 回應中。
- 若涉及交易一致性，應明確處理 transaction 範圍與 rollback 邏輯。
- 若涉及 Redis 快取，需明確說明 key、TTL 與 invalidation 策略。
- 所有輸入都應視為不可信，不可過度信任前端。

## 資料庫異動與 SQL Script 規則
- 只要涉及資料庫 Schema、Table、Index、Constraint、Seed Data 的建立或修改，必須產出對應 `.sql` 腳本並存放於 `BackEnd/DB/需求名稱/`。
- `需求名稱` 應與 Spec / Task 的需求名稱一致，並使用英文命名。
- 檔名必須包含時間戳記與簡短描述，例如：
  - `20260529_Init_Asset_Tables.sql`
  - `20260529_Add_Asset_Index.sql`
- 修改既有資料表時，必須以獨立 `ALTER` 腳本處理，不可覆蓋原建立腳本。
- 若專案同時使用 EF Core Migration，仍需保留 SQL 腳本作為可追蹤版本紀錄。
- 腳本內容應可讀、可重放、可審查。

## 測試與交付規則
- 變更商業邏輯時，優先補齊對應單元測試。
- 變更 Command / Query / Handler / Validator / Pipeline Behavior 時，應優先補齊應用層測試。
- 對重要 API 流程，應補充整合測試或至少提出建議測試清單。
- 若本次無法補齊測試，需清楚列出測試缺口與風險。
- 若角色 prompt 已要求更新 Task 狀態或提供 git commit message，請遵守該格式。
