# dotfiles
These are my dotfiles. This repo uses [stow][] to manage symlinks. To use stow, git clone this repo and do:

Install using [just][] taskrunner:

```sh
cd dotfiles
just install 
```

If you do not have `just` installed. You can manually run the command with:

```sh
cd dotfiles
stow --restow */
```

You can also prune all the symlinks with:

```sh
cd dotfiles
just remove
```

or without `just`:

```sh
cd dotfiles
stow --delete */
```

Note: If you have an existing `.bash_profile` and/or `.bashrc`, the `just` commands will back up your file as `*.orig`. If the `*.orig` file remains, it will restore it when you use just remove.

[stow]: https://www.gnu.org/software/stow/
[just]: https://just.systems/

Self Note:
`.gitconfig` is not managed with stow. A starter one for myself is here.
