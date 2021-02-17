# Platform interface for the `pay` plugin

A common platform interface for the [`pay`](../pay) plugin.

This interface allows platform-specific implementations of the `pay` plugin, as well as the plugin itself, and ensure they are supporting the same interface.

Take a look at the [guide about plugin development](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins) if you'd like to learn more.

# Usage

To implement a new platform-specific implementation of `pay`, extend [`PayPlatform`](lib/pay_platform_interface.dart) with an implementation that performs the platform-specific behavior.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface) over breaking changes for this package.

Take a look at [this discussion](https://flutter.dev/go/platform-interface-breaking-changes) on why a less-clean interface is preferable to a breaking change.