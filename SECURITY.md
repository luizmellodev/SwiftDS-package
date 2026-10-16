# Security Policy

## Supported Versions

SwiftDS is pre-1.0. Only the latest minor release line gets fixes; upgrade to the newest tag before reporting.

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Scope

SwiftDS is a SwiftUI component library with no networking or storage of its own. Things worth reporting:

- A component that exposes sensitive input it should hide, such as a secure field leaking its value through accessibility, logs or snapshots.
- A component that loads remote content or opens URLs in an unsafe way.
- A crash reachable from untrusted data passed into a component.

Visual bugs and accessibility issues are not security issues; please open a regular issue for those.

## Reporting a Vulnerability

Please **do not open a public issue**. Report it privately through GitHub: go to the repository's **Security** tab and click **Report a vulnerability**.

Include the SwiftDS version, platform and OS version, and steps to reproduce.

What to expect:

- **Acknowledgement** within 7 days.
- **Assessment** (accepted or declined, with the reasoning) within 14 days.
- **If accepted:** a fix in a new patch release, credited to you in the release notes unless you prefer otherwise. Please keep the details private until that release is out.
- **If declined:** an explanation of why, and you are free to discuss it publicly.

This is a personal project maintained in spare time, so these are best-effort targets.
