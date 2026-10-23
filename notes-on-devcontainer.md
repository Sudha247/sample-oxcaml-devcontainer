
## Run it locally

With VS Code and the Dev Containers extension: open the folder and choose
**Reopen in Container**.

With the [devcontainer CLI](https://github.com/devcontainers/cli):

```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . dune exec bin/hello.exe
```

Or with plain Docker:

```bash
docker run --rm -it -v "$PWD:/work" -w /work \
  ghcr.io/sudha247/sample-oxcaml-devcontainer:latest \
  bash -lc 'dune build && dune exec bin/hello.exe'
```

## How the image gets built

The **Devcontainer image** workflow runs on every push:

- If `.devcontainer/Dockerfile` changed (or it was started
  from the Actions tab, or by the weekly schedule), it compiles OxCaml from
  source for amd64 and arm64, publishes both to GHCR and merges them into the
  `:latest` tag. Expect 30 to 45 minutes.
- In every case it then checks out the repo inside `:latest`, builds, and
  runs the hello world.

The first push to a new repository therefore triggers a full build. Until it
finishes, there is no image to pull and a Codespace cannot start.

## Updating OxCaml

Change `OXCAML_COMPILER` in `.devcontainer/Dockerfile` to another version
from the oxcaml repository's `packages/oxcaml-compiler` directory and push.
The workflow rebuilds and republishes the image.

Note that as of October 2026 the newer `5.4.0-ox7` compiler builds, but the
repository's `merlin` and `ocaml-lsp-server` packages still require
`ocaml < 5.3`, so a 5.4 switch has no editor tooling yet. Stay on a
`5.2.0minusNN` release until that changes.

To add more tools, extend the `opam install` line in the Dockerfile.
`ocamlformat` and `utop` have `+ox` builds too, and the Jane Street
libraries (`base`, `core`, `parallel`, `await`) install from the same

## Run it on GitHub Codespaces

1. Wait for the **Devcontainer image** workflow to be green.
2. Make the package visible to Codespaces. The simplest option is to set it
   to **Public** under *your profile → Packages → sample-oxcaml-devcontainer
   → Package settings*. (A package pushed by this repository's own workflow
   is also linked to the repository, which is enough for Codespaces on a
   private package.)
3. On the repository page click **Code → Codespaces → Create codespace on
   main**. The container starts in a minute or two and `postCreateCommand`
   runs `dune build`.
4. In the Codespace terminal:

   ```bash
   dune exec bin/hello.exe
   ```

   Opening `bin/hello.ml` shows hover types and diagnostics from
   ocaml-lsp-server through the OCaml Platform extension.

Or from the command line:

```bash
gh codespace create --repo Sudha247/sample-oxcaml-devcontainer
gh codespace ssh
```

Delete the Codespace afterwards with `gh codespace delete` to avoid charges.

repository.