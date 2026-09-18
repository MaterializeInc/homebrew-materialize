# One-time setup for the "Bump mz-deploy" workflow

`.github/workflows/bump-mz-deploy.yml` bumps `Formula/mz-deploy.rb` and pushes the
result **directly to `master`**. That needs setup only a **repo admin** can do
(creating an org-owned App additionally needs an org owner). Until it is done, the
workflow fails at its first step.

## Why this is needed

`master` is protected today by **legacy branch protection** requiring a pull request
**and at least one approving review** (`reviewDecision: REVIEW_REQUIRED`). Three facts
make the obvious approaches fail:

- The built-in `GITHUB_TOKEN` **cannot push to a protected branch**, even when its
  actor is added to the bypass list. This is a documented limitation, not a
  misconfiguration.
- Legacy branch protection is also invisible to non-admins via the API, which makes
  it hard to reason about. Rulesets report themselves to anyone with read access.
- "Open a PR and let the workflow merge it" does not help: the required approval must
  come from an identity other than the PR author, and a bot cannot approve its own PR.

The combination that works is a **GitHub App** as a bypass actor on a **ruleset**.

## Steps

### 1. Create the App

Org settings → Developer settings → GitHub Apps → **New GitHub App**.

- Name: something like `materialize-tap-bot`
- Homepage URL: this repo's URL (unused, but required)
- **Uncheck "Active" under Webhook** — it needs no webhook
- Repository permissions: **Contents: Read and write**. Nothing else.
- Where can this App be installed: **Only on this account**

Then on the App's page:

- Note the **Client ID** (starts `Iv23...`).
- **Generate a private key** and download the `.pem`.
- **Install App** → select **Only select repositories** → `homebrew-materialize`.

### 2. Migrate `master` to a ruleset

Repo settings → Rules → Rulesets → **New ruleset → New branch ruleset**.

- Name: `master`
- Enforcement status: **Active**
- Target branches: **Include default branch**
- Rules: mirror whatever the current legacy rule enforces — at minimum
  **Require a pull request before merging**. (Check the existing legacy rule under
  Settings → Branches first; it is not readable via the API without admin.)
- **Bypass list → Add bypass → GitHub Apps →** the App from step 1.
  Use the **Exempt** bypass type if offered: it silently skips enforcement, which
  suits trusted automation, versus a "break glass" bypass that raises audit signals.

Create the ruleset **first** and confirm it is enforcing, **then** delete the legacy
branch protection rule under Settings → Branches. Doing it in that order never
leaves `master` unprotected.

### 3. Add the credentials to this repo

Repo settings → Secrets and variables → Actions:

- **Variables** tab → New variable: `BUMP_APP_CLIENT_ID` = the App's Client ID
- **Secrets** tab → New secret: `BUMP_APP_PRIVATE_KEY` = the full contents of the
  `.pem`, including the `-----BEGIN...`/`-----END...` lines

Or from a shell with admin rights:

```
gh variable set BUMP_APP_CLIENT_ID --body 'Iv23...'
gh secret set BUMP_APP_PRIVATE_KEY < path/to/key.pem
```

### 4. Verify

Run the workflow against the version already in the formula:

```
gh workflow run bump-mz-deploy.yml -f version=0.7.0
```

That exercises the App token, the checkout, the download and the checksums, and
then reports "nothing to commit" without pushing. The push itself is first
exercised by the next real release — if it 403s, the bypass in step 2 did not take.

## Lighter alternative: a bypassed user + PAT

If the App and the ruleset migration are more ceremony than this tap warrants, a repo
admin can instead add a **specific user** to "Allow specified actors to bypass required
pull requests" on the existing legacy rule. That user's PAT, stored as a repo secret and
passed to `actions/checkout`, then pushes directly to `master` — one toggle and one
secret, no App, no ruleset, nothing org-wide.

The cost is a personal credential living in a repo secret: scoped to one person, needing
rotation, and carrying that person's full access. The App exists to avoid that, which is
why it is the recommendation above rather than this.

## If neither happens

The workflow can push a `mz-deploy-X.Y.Z` branch and open a pull request against
`master`, which is what the last several releases did by hand. `GITHUB_TOKEN` can do
that today given `permissions: contents: write` and `pull-requests: write` — but a human
still has to approve and merge it, because of the required review.
