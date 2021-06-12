# Helm set-status plugin

Manually set the status of a helm release

Useful when helm or your cluster ran into problems mid-update and things are stuck `pending-upgrade`, but you don't want to uninstall the release and possibly suffer additional downtime.


| :warning: WARNING :warning: |
| - |
| This plugin alters the internal state of helm releases. Use with care! |

## Install

```console
helm plugin install https://github.com/brandond/helm-set-status
```

## Usage

```console
helm set-status RELEASE STATUS [flags]
```
