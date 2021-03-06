# JHBuild module set

This module set is an offspring of [gtk-osx](https://gitlab.gnome.org/GNOME/gtk-osx). It differs from it as follows:

- Remove any software packages that we don't need to improve maintainability.
- Update packages as required, but don't needlessly divert from upstream. This way we can still benefit from using a largely identical base configuration in terms of stability, required patches etc.
- Keep the file layout mostly intact so diff'ing with upstream remains helpful.
- gitg specific packages area added to `gitg.modules`.
- Use `gitg.modules` as entry point, not `gtk-osx.modules`.
