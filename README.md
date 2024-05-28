# Fork Sync

    自动实现fork代码同步

`.github/workflows/fork-sync.yml`
```shell
name: sync a fork
on:
    schedule:
        - cron: "1 * * * *"
    workflow_dispatch: 

jobs:
    sync:
        runs-on: ubuntu-latest
        steps:
            - name: clone
              uses: actions/checkout@v4.1.5
            - name: sync fork
              uses: guodf/fork-sync@v0.0.1
              with:
                  branchs: main
                  upstream_repo: "xxx/xxx"
```