# How to Contribute
_See also: [Flutter's code of conduct](https://flutter.io/design-principles/#code-of-conduct)_

We'd love to accept your patches and contributions to this project. There are just a few small guidelines you need to
follow.

Please use the
[Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) and
[design principles](https://flutter.io/design-principles/) before
working on anything non-trivial. These guidelines are intended to
keep the code consistent and avoid common pitfalls.

## Contributor License Agreement

Contributions to this project must be accompanied by a Contributor License Agreement (CLA). You (or your employer)
retain the copyright to your contribution; this simply gives us permission to use and redistribute your contributions as
part of the project. Head over to <https://cla.developers.google.com/> to see your current agreements on file or to sign
a new one.

You generally only need to submit a CLA once, so if you've already submitted one (even if it was for a different
project), you probably don't need to do it again.

## 1. Things you will need

- Linux, Mac OS X, or Windows.
- [git](https://git-scm.com) (used for source version control).
- An SSH client (used to authenticate with GitHub).
- An IDE such as [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/).
- [`tuneup`](https://pub.dev/packages/tuneup) locally activated.

## 2. Forking & cloning the repository

- Fork the [repository](repo-url) into your own GitHub account.
- If you haven't configured your machine with an SSH key that's known to github, then
  follow [GitHub's directions](https://help.github.com/articles/generating-ssh-keys/)
  to generate an SSH key.
- Clone your new forked repository: `git clone git@github.com:<your_name_here>/plugins.git`
- Add the original repository to the list of remotes: `git remote add upstream git@github.com:flutter/plugins.git`

## 3. Running examples

To run an example, run the `flutter run` command from the `example` directory of each plugins' main
directory. For example, for the `pay` example:

```bash
cd pay/example
flutter run
```

## 4. Running tests

This plugin comprises of a number of end-to-end (e2e) and unit tests.

### Unit tests

Unit tests are responsible for ensuring expected behavior whilst developing the plugins Dart code. Unit tests do not
interact with 3rd party services, and mock where possible. To run unit tests for a specific plugin, run the
`flutter test` command from the plugins root directory. For example:

```bash
cd pay
flutter test
```

### End-to-end (e2e) tests

E2e tests are those which directly communicate with Flutter, whose results cannot be mocked. **These tests run directly from
an example application.**

To run e2e tests, run the `flutter drive` command from the plugins' main `example` directory, targeting the
entry e2e test file.

```bash
cd pay/example
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/payment_flow_test.dart
```

## 5. Start contributing
To start working on a patch:

1. `git fetch upstream`
2. `git checkout upstream/main -b <name_of_your_branch>`
3. Hack away!

Once you have made your changes, ensure that it passes the internal analyzer & formatting checks. The following
commands can be run locally to highlight any issues before committing your code:

Assuming all is successful, commit and push your code:

1. `git commit -a -m "<your informative commit message>"`
2. `git push origin <name_of_your_branch>`

### Commit Messages

We follow the [Conventional Commits specification][conventional-commits] to help keep the commit history readable and to
automate release process with updated changelog details.

The commit messages should follow this format:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

For example:

`fix(pay_android): fixed a bug!`

Refer to the [specification][conventional-commits] for more information.

## 6. Create a pull request
Go to the [repository](repo-url) and click the "Compare & pull request" button

Plugins tests are run automatically on contributions using GitHub Actions. Depending on your code contributions, various tests will be run against your updated code automatically.

Once you've gotten an LGTM from a project maintainer and once your PR has received the green light from all our automated testing, wait for one the package maintainers to merge the pull request.

## 7. The review process

Newly opened PRs first go through initial triage which results in one of:

- **Merging the PR** - if the PR can be quickly reviewed and looks good.
- **Closing the PR** - if the PR maintainer decides that the PR should not be merged.
- **Moving the PR to the backlog** - if the review requires non trivial effort and the issue isn't a priority; in this case the maintainer will:
  - Make sure that the PR has an associated issue labeled with "plugin".
  - Add the "backlog" label to the issue.
  - Leave a comment on the PR explaining that the review is not trivial and that the issue will be looked at according to priority order.
- **Starting a non trivial review** - if the review requires non trivial effort and the issue is a priority; in this case the maintainer will:
  - Add the "in review" label to the issue.
  - Self assign the PR.

## 8. The release process

Changelogs and version updates are automatically updated by a project maintainer. The new version is automatically
generated via the commit types and changelogs via the commit messages.

## Community Guidelines

This project follows [Google's Open Source Community Guidelines](https://opensource.google/conduct/).

[conventional-commits]: https://www.conventionalcommits.org/en/v1.0.0/
[repo-url]: https://github.com/flutter/plugins