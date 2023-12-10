# Git Mirror Action

A GitHub Action for mirroring a public git repo to another repo with new commit via SSH.

> NOTE with new commit, ignoring origin commits from source repo.

## Step Example

```yml
- uses: sunn4room/git-mirror-with-new-commit@main
  with:
    source_repo: "domain:xxx/xxx" # require
    source_branch: "main"
    source_key: ${{ secrets.SSH_PRIVATE_KEY }}
    destination_repo: "domain:xxx/xxx" # require
    destination_branch: "main"
    destination_key: ${{ secrets.SSH_PRIVATE_KEY }}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
