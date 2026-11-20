## What and why

<!-- What does this change, and why? Link the issue: "Fixes #123". -->

## How it was tested

<!-- Commands you ran (for example make test, make check-migrations, make build) and what you checked by hand. -->

## Checklist

- [ ] Every commit is signed off (`git commit -s`, see CONTRIBUTING.md)
- [ ] Tests added or updated, and `make test` passes
- [ ] Schema changes are in both `app/Infrastructure/Db/Migrations` and `docker/mysql/init` (`make check-migrations`), and work on SQLite and MySQL
- [ ] Docs updated where behavior changed (README.md and README.pt-BR.md for user-facing changes)
- [ ] Still runs on shared hosting: no daemon, Redis or `exec()`-family call
- [ ] `vendor/` is not part of the change

Accepted pull requests are applied upstream with `git am`, keeping your authorship, and reach this repository in the next release (see CONTRIBUTING.md).
