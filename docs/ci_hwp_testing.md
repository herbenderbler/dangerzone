# HWP/HWPX testing and CI (issue #968)

This note tracks **where** Hancom HWP/HWPX conversion is exercised in automation, how to **interpret flakes**, and what **“done”** means for [issue #968](https://github.com/freedomofpress/dangerzone/issues/968).

## Where real conversion runs

| Environment | Real LibreOffice + `h2orestart.oxt` in the sandbox? | Notes |
|-------------|------------------------------------------------------|--------|
| Linux `run-tests` (`.github/workflows/ci.yml`) | Yes | Full CLI tests via `dev_scripts/env.py` + Podman. |
| Windows (`windows` job) | Yes | Podman/WSL path; `DUMMY_CONVERSION` is not set. |
| macOS arm64 (`ci_macos.yml`) | No | `DUMMY_CONVERSION=1` because nested virtualization is unavailable; HWP tests do not exercise real conversion. |
| macOS Intel (scheduled / non–PR) | Yes | Same workflow without dummy conversion when the runner can use the real stack. |

## Signals when investigating flakes

- **JUnit**: CI uploads `test-results/junit.xml` (artifact name includes OS/matrix).
- **Pytest summary**: `PYTEST_ADDOPTS=-r fEr` so the log shows **failed**, **errors**, and **rerun** lines (see `pytest-rerunfailures`).
- **Converter stderr**: Failures from the sandbox now include clipped **stdout/stderr** from failed subprocesses (e.g. LibreOffice) and extra context when LibreOffice exits 0 but produces no PDF ([#494](https://github.com/freedomofpress/dangerzone/issues/494)).

## Local stress loop

To run only the Hancom CLI tests repeatedly (e.g. after changing conversion or CI):

```bash
./dev_scripts/stress_hwp_test.sh 20
```

Default iteration count is 10.

## Suggested closure criteria for #968

Close the issue when one of the following holds:

1. **Root cause fixed** — e.g. reproducible bug in timeouts, extension install, or LibreOffice invocation, with a regression test or documented mitigation; **or**
2. **Operational confidence** — after the observability changes above ship, a **monitoring window** (e.g. several weeks of CI) shows **no unexplained** HWP failures, or remaining failures are **explained** by captured logs (and optional follow-up issues are filed).

Avoid closing on **more reruns alone** without understanding failure modes.
