---
applyTo: 'FrontEnd/**'
---

# Frontend Path-Specific Instructions

## 適用範圍
- 本檔案只適用於 `FrontEnd/` 目錄下的頁面、元件、stores、api、router、types、composables、utils、測試與前端技術文件。
- 不得將後端規則混入前端實作；若涉及 API 契約衝突，應先回報。

## 前端技術基準
- 前端技術棧以 Vue 3、Vite、TypeScript、Pinia、Axios、Vue Router、Tailwind CSS 為主。
- 一律優先採用 `<script setup>` 與 Composition API。[web:323][web:243]
- 嚴禁使用 `any`；API request / response、Store state、Props、Emit、Form model 均需明確定義型別。
- 若專案已有既定資料夾結構與元件風格，優先沿用。

## 目錄結構與模組規則
- 所有程式碼應優先放在 `FrontEnd/src/` 對應目錄下。
- 頁面應放在 `views/`，高複用元件放在 `components/`，跨頁面共享狀態優先使用 Pinia。[web:327][web:330]
- API 呼叫應集中封裝在 `api/`、service 或 composable，不要將大量 Axios 邏輯散落在 view component。
- `router/` 應管理 Vue Router 設定與 navigation guards。
- `types/`、`composables/`、`utils/` 應清楚分工，避免把型別、邏輯、工具函式混在頁面元件內。
- 若現有專案已採 folder-per-feature 或模組化結構，應優先沿用，不強制改成單一平鋪結構。

## API 與型別契約規則
- 前端實作必須嚴格遵守 `Docs/Spec/` 中定義的 API 名稱、Route、HTTP Method、Request JSON、Response JSON、Error Response 與 Auth 規則。
- 不得任意修改 API request / response contract。
- 若 Spec 與後端實際 API 不一致，應先回報差異並請使用者確認。
- 所有 API 對應型別應明確定義，並保持命名一致。
- 畫面元件不得直接依賴鬆散結構的原始 API 回傳，應經過型別明確的轉換或封裝。

## 狀態管理與路由規則
- 跨頁面或跨組件共享狀態應使用 Pinia，不應濫用 props drilling 或全域變數。[web:327][web:332]
- Store 應保持單一責任，不將不相關模組邏輯混在同一個 Store。
- Vue Router 應使用清楚的 route meta 與 navigation guards 控制登入與權限。
- 路由權限應優先透過 route meta 定義，例如 `requiresAuth`、`roles`。
- 若未登入或權限不足，應導向明確頁面，而不是讓頁面進入半壞狀態。

## Axios 與錯誤處理規則
- 使用 Axios 統一封裝 API 呼叫。
- 應建立統一的 request / response interceptors，用於 token 附加、401 / 403 / 500 處理與錯誤訊息格式統一。
- 不得在每個頁面重複撰寫相同的錯誤處理邏輯。
- 若需要 retry、timeout、cancel 行為，應優先在共用層處理。
- 前端應能優雅處理 loading、empty、error 三種基本狀態。

## UX 與表單規則
- 所有非同步操作應有 loading、error、empty 狀態。
- 所有提交行為應防止 double-submit；送出後按鈕需 disabled，直到 API 回應結束。
- 錯誤訊息應優雅呈現，不可直接暴露後端內部錯誤或 Stack Trace。
- 畫面需維持基本 Responsive Design，避免桌機可用但手機崩壞。
- 前端表單驗證應與 Spec 中的欄位規則一致。
- 前端驗證只負責提升 UX，不可取代後端驗證。
- 若 API 回傳欄位級錯誤，前端應能映射並顯示給使用者。

## 金融數值與顯示規則
- 金額、損益、報酬率、庫存等數值需經過格式化後再顯示。
- 若 API 回傳 `null`、`undefined`、空字串或非數值，畫面應顯示 `—`、`0` 或 Spec 定義值，不可裸露 `NaN` 或 `undefined`。
- 若前端需進行金額計算，應避免浮點數誤差；若未使用大數套件，需採取防禦性寫法。
- 台灣市場慣例必須一致：正損益顯示紅色、負損益顯示綠色、零值顯示中性色。
- 顏色與數值格式規則必須全站一致，不可同一系統內出現不同標準。

## 測試與交付規則
- 重要 composables、utils、stores 與關鍵元件互動應補齊測試，若專案已有測試框架則優先沿用。
- 對重要頁面流程，應補充整合測試或至少提出建議測試清單。
- 若本次無法補齊測試，需清楚列出缺口與風險。
- 測試不應只覆蓋 happy path，也應包含 loading、error、empty、validation failure 等關鍵場景。
- 若角色 prompt 已要求更新 Task 狀態或提供 git commit message，請遵守該格式。
