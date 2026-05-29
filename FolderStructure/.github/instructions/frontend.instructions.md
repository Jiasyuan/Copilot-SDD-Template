---
applyTo:
  - 'FrontEnd/**'
---

# Frontend Path-Specific Instructions

## 適用範圍
- 本檔案只適用於 `FrontEnd/` 目錄下的頁面、元件、stores、api、router、types、composables、utils、測試與前端技術文件。
- 不得將後端規則混入前端實作；若涉及 API 契約衝突，應先回報。

## 前端技術基準
- 前端技術棧以 Vue 3、Vite、TypeScript、Pinia、Axios、Vue Router、Tailwind CSS 為主。
- 一律優先採用 `<script setup>` 與 Composition API。
- 嚴禁使用 `any`；API request / response、Store state、Props、Emit、Form model 均需明確定義型別。
- 若專案已有既定資料夾結構與元件風格，優先沿用。

## 結構與狀態管理規則
- 頁面應放在 `views/`，高複用元件放在 `components/`，跨頁面共享狀態優先使用 Pinia。
- API 呼叫應集中封裝在 `api/` 或對應 service / composable，不要將大量 Axios 邏輯散落在 view component。
- Vue Router 應使用清楚的 route meta 與 navigation guards 控制登入與權限。
- 不要把畫面、API 串接、表單驗證與商業邏輯全部塞進單一元件。

## UX 與防禦性規則
- 所有非同步操作應有 loading、error、empty 狀態。
- 所有提交行為應防止 double-submit；送出後按鈕需 disabled，直到 API 回應結束。
- 錯誤訊息應優雅呈現，不可直接暴露後端內部錯誤或 Stack Trace。
- 畫面需維持基本 Responsive Design，避免桌機可用但手機崩壞。

## 金融數值與顯示規則
- 金額、損益、報酬率、庫存等數值需經過格式化後再顯示。
- 若 API 回傳 `null`、`undefined`、空字串或非數值，畫面應顯示 `—`、`0` 或 Spec 定義值，不可裸露 `NaN` 或 `undefined`。
- 若前端需進行金額計算，應避免浮點數誤差；若未使用大數套件，需採取防禦性寫法。
- 台灣市場慣例必須一致：正損益顯示紅色、負損益顯示綠色、零值顯示中性色。

## 測試與交付規則
- 重要 composables、utils、stores 與關鍵元件互動應補齊測試，若專案已有測試框架則優先沿用。
- 若本次無法補齊測試，需清楚列出缺口與風險。
- 若角色 prompt 已要求更新 Task 狀態或提供 git commit message，請遵守該格式。
