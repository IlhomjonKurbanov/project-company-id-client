# Company ID

Flutter version: 2.8.1

Internal project for tracking time, control projects.

## Build

```bash
# debug mode ios
$ flutter build ios --debug

# debug mode android
$ flutter build apk --debug

# release mode ios
$ flutter build ios --release

# release mode android
$ flutter build apk --release
```

## Mac

For build MacOS dmg - use next commands

- rm company-od.dmg
- flutter build macos --release
- appdmg ./config.json ./company-id.dmg

## Commitlint

Commitlint is used to have a common way of writing commit messages. `Conventional Commits` extension could help with that.

Basic structure of commit message: `type: title [ref:scope]`

`type` can be: [build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test].

`scope` is a task number from jira - like AL-9999.

If you use Mac OS please check that you have right access to execute hooks. If need please change

```
chmod +x scripts/*.bash && ./scripts/install-hooks.bash
```

More information you can find on - scripts/pre-commit.md
