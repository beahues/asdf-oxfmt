<div align="center">

# asdf-oxfmt [![Build](https://github.com/barn/asdf-oxfmt/actions/workflows/build.yml/badge.svg)](https://github.com/barn/asdf-oxfmt/actions/workflows/build.yml) [![Lint](https://github.com/barn/asdf-oxfmt/actions/workflows/lint.yml/badge.svg)](https://github.com/barn/asdf-oxfmt/actions/workflows/lint.yml)

[oxfmt](https://github.com/oxc-project/oxc) plugin for the [asdf version manager](https://asdf-vm.com).


VERSION NUMBERS DON'T MATCH. Because oxc ship `oxlint` as the primary package and `oxfmt` secondary, and everything is keyed off of `oxlint`'s version. Which brilliantly doesn't match `oxfmt`.
See https://github.com/oxc-project/oxc/releases?q=apps_v1&expanded=true for how that works. I don't have a great fix.

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add oxfmt
# or
asdf plugin add oxfmt https://github.com/barn/asdf-oxfmt.git
```

oxfmt:

```shell
# Show all installable versions
asdf list-all oxfmt

# Install specific version
asdf install oxfmt latest

# Set a version globally (on your ~/.tool-versions file)
asdf global oxfmt latest

# Now oxfmt commands are available
oxfmt --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/barn/asdf-oxfmt/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Bea Hughes](https://github.com/barn/)
