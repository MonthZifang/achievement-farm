# 🏅 achievement-farm

> 用 GitHub Actions 自动做**真实操作**，解锁 GitHub 上**靠自己就能达成**的成就徽章。

## 自动解锁的成就

| 徽章 | 怎么刷到 | 说明 |
|------|----------|------|
| **Pull Shark** | 自动建分支 → 提 PR → 合并 | 每天合 1 个 PR，累计可升级 tier（2/8/16/32） |
| **YOLO** | 不经审查直接合并 PR | 与 Pull Shark 同一次 PR 顺带拿到 |
| **Quickdraw** | 开 issue 并秒关 | 每天开 + 秒关若干 issue |
| **Open Sourcerer** | 多语言仓库贡献 | 仓库内含 10 种语言文件 |
| **Deploy 🚀** | 成功部署一次 | 仓库已开启 GitHub Pages（一次性） |
| **Discussion 💬** | 创建一条 Discussion | 仓库已开启 Discussions 并建了一条（一次性） |
| **Husky 🐕** | 关闭一个带 `wontfix`/`enhancement` 等的 issue | 每天开带标签 issue 后关闭 |
| **Investigatory 🔍** | 关闭一个带 `question` 的 issue | 同上，标签 `question` |
| **Bug Crusher 🐛** | 关闭一个带 `bug` 的 issue | 同上，标签 `bug` |
| **Super Detective 🕵️** | 把 issue 标为 `duplicate` 后关闭 | 同上，标签 `duplicate` + reason=duplicate |

> 标签类成就由 `farm.yml` 的「Quickdraw + issue-label achievements」步骤每日覆盖：`bug` / `enhancement` / `question` 以 `not planned` 关闭，`duplicate` 以 `duplicate` 关闭。

## 自动刷不到的成就（需他人互动 / 历史不可得）

- **Starstruck ⭐**：需要别人给你的仓库 star。
- **Galaxy Brain 🧠**：需要别人把你的 Discussion 标记为答案。
- **Pair Extraordinaire 👥**：需要合著提交（另一人 co-author）。
- **Public Sponsor 💗 / GitHub Sponsor ❤️**：需要你赞助别人 / 被别人赞助（需支付方式）。
- **Security Sentry 🛡️**：需发布真实安全公告（不建议造假）。
- **Arctic Code Vault / Mars 2020 🧊**：2020 年存档历史，已成过去，无法再得。

这些无法纯程序触发，得靠真实作品 + 主动分发（参见其他仓库的 README 优化）。

## 工作原理

每天 00:30 北京时间（`cron: '30 16 * * *'`，即 UTC 16:30），GitHub Actions 自动运行 `.github/workflows/farm.yml`：

1. 取一个时间戳分支，提交一次，开 PR 并**无审查合并** → Pull Shark + YOLO；
2. 开若干带标签的 issue 并立刻关闭（分别带 `bug` / `enhancement` / `question` / `duplicate`）→ Quickdraw + Husky + Investigatory + Bug Crusher + Super Detective；
3. 全程用 **个人 PAT** 推送，贡献计入 **PAT 所属账号**（提交者身份 / 目标仓库 / 默认分支都按 PAT 自动推断，无需改代码）。

> Open Sourcerer 由仓库里的 `lang/hello.*`（10 种语言）直接满足 —— 只要这些文件在 `main` 上，贡献进去即可累计多语言。Deploy 与 Discussion 为一次性手动开启（见上表）。

> ⚠️ 娱乐性质：成就徽章对求职/作品集帮助有限，真正加分的是 star 与真实项目。本仓库只是让贡献图与成就墙更热闹。

## 配置（必做，否则 Actions 会因缺少 `PAT` 报错）

本仓库必须用一个**个人访问令牌（PAT）**驱动，而不能用默认的 `GITHUB_TOKEN`：成就只记在「用户」名下，bot token 不算数，Pull Shark / YOLO / Quickdraw 也就刷不到。

1. 生成一个 PAT（账号：`Settings → Developer settings → Personal access tokens → Tokens (classic)`）：
   - 作用域勾选 `repo`（含 `workflow` 更稳，可一并勾上）；
   - 过期可按需设置（到期后续期并重设 secret 即可）。
2. 在本仓库 `Settings → Secrets and variables → Actions → New repository secret`：
   - Name 填 **`PAT`**（必须完全一致）；
   - Secret 填刚生成的令牌。
3. 启用 Actions：仓库 `Actions` 标签页若显示 “disabled”，点 `I understand…` 启用。
4. 验证：到 `Actions → Achievement Farm → Run workflow` 手动跑一次，看是否拿到一次提交 / PR / issue。

> 也可在本地用 `make setup` 打印上述步骤；实际填令牌仍需在网页完成（令牌不外泄）。

> **Fine-grained PAT 必看**：若用细粒度令牌，创建时要给本仓库 **Contents = Read and write**、**Pull requests = Read and write**、**Issues = Read and write** 三项写权限（仅 Read 会在 `git push` 时报 `403 Permission denied to <user>`）。权限不够时不必重发令牌，直接在令牌页 **编辑权限** 补上写权限即可，令牌值不变、secret 不用重设。

## License

[MIT](LICENSE)
