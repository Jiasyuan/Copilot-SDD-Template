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

## 資料存取規則
- 若 Spec 未另行指定，預設：
  - Command 類操作優先使用 EF Core
  - Query 類操作優先使用 Dapper
- 使用 Dapper 時必須全面參數化查詢，禁止字串拼接 SQL。
- Query 不應偷偷修改資料；Command 不應承擔複雜報表查詢。
- 若同一功能同時使用 EF Core 與 Dapper，需明確區分責任。

## 精準度與安全規則
- 金額、匯率、數量、報酬率等高精度數值優先使用 `decimal`，禁止使用 `float` 或 `double`。
- EF Core 對應 MS SQL decimal 欄位時，應明確設定 precision；若 Spec 無指定，預設使用 `.HasPrecision(18, 4)`。
- 不可將 Token、密碼、連線字串、Stack Trace 或內部錯誤細節暴露到 API 回應中。
- 若涉及交易一致性，應明確處理 transaction 範圍與 rollback 邏輯。
- 若涉及 Redis 快取，需明確說明 key、TTL 與 invalidation 策略。

## 測試與交付規則
- 變更商業邏輯時，優先補齊對應單元測試。
- 變更 Command / Query / Handler / Validator / Pipeline Behavior 時，應優先補齊應用層測試。
- 若本次無法補齊測試，需清楚列出測試缺口與風險。
- 若角色 prompt 已要求更新 Task 狀態或提供 git commit message，請遵守該格式。
