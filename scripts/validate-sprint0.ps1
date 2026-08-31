param(
    [switch]$RequireClean
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $root

$failed = $false

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
    $script:failed = $true
}

function Write-Check {
    param([string]$Message)
    Write-Host "[CHECK] $Message" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================="
Write-Host " OVSA Sprint 0 Validation"
Write-Host "========================================="
Write-Host ""

# ------------------------------------------------------------
# 1. Required files
# ------------------------------------------------------------

Write-Check "Validating required files..."

$requiredFiles = @(
    "README.md",
    "CHANGELOG.md",
    ".gitignore",
    "redocly.yaml",

    "docs/architecture/01-product-vision.md",
    "docs/architecture/02-functional-scope.md",
    "docs/architecture/03-system-boundaries.md",
    "docs/architecture/04-domain-contexts.md",
    "docs/architecture/05-ubiquitous-language.md",
    "docs/architecture/06-c4-system-context.md",
    "docs/architecture/07-c4-container-view.md",
    "docs/architecture/08-c4-component-view.md",
    "docs/architecture/09-non-functional-requirements.md",

    "docs/adr/README.md",
    "docs/adr/ADR-001-use-microservices-architecture.md",
    "docs/adr/ADR-002-define-four-business-contexts.md",
    "docs/adr/ADR-003-database-per-service.md",
    "docs/adr/ADR-004-use-rest-and-domain-events.md",
    "docs/adr/ADR-005-use-hexagonal-architecture.md",
    "docs/adr/ADR-006-use-monorepo.md",

    "docs/api/README.md",
    "docs/api/api-standards.md",
    "docs/api/common-components.yaml",
    "docs/api/identity-service.openapi.yaml",
    "docs/api/inventory-service.openapi.yaml",
    "docs/api/operations-service.openapi.yaml",
    "docs/api/reporting-service.openapi.yaml",

    "docs/events/README.md",
    "docs/events/event-standards.md",
    "docs/events/event-catalog.md",
    "docs/events/reliability-patterns.md",
    "docs/events/rabbitmq-topology.md",
    "docs/events/schemas/event-envelope.schema.json",

    "docs/security/README.md",
    "docs/security/security-model.md",
    "docs/security/authentication-clients.md",
    "docs/security/jwt-claims.md",
    "docs/security/authorization-model.md",
    "docs/security/multi-tenancy.md",
    "docs/security/threat-model.md",
    "docs/security/security-requirements.md",

    "docs/testing/README.md",
    "docs/testing/testing-strategy.md",
    "docs/testing/test-matrix.md",
    "docs/testing/definition-of-done.md",

    "docs/backlog/README.md",
    "docs/backlog/product-backlog.md",
    "docs/backlog/sprint-roadmap.md",
    "docs/backlog/sprint-1-backlog.md",
    "docs/backlog/user-story-template.md",
    "docs/backlog/sprint-0-closure.md"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Pass $file
    }
    else {
        Write-Fail "Missing: $file"
    }
}

# ------------------------------------------------------------
# 2. Validate project name
# ------------------------------------------------------------

Write-Host ""
Write-Check "Checking legacy project name..."

$legacyNames = @(
    ("MA" + "GU"),
    ("Ma" + "gu"),
    ("ma" + "gu")
)

$legacyPattern = $legacyNames -join "|"

$legacyMatches = Get-ChildItem -Recurse -File |
    Where-Object {
        $_.FullName -notmatch "\\.git\\"
    } |
    Select-String -Pattern $legacyPattern -ErrorAction SilentlyContinue

if ($legacyMatches) {
    Write-Fail "Legacy project name found:"
    $legacyMatches | ForEach-Object {
        Write-Host "  $($_.Path):$($_.LineNumber)"
    }
}
else {
    Write-Pass "No legacy project name found."
}

# ------------------------------------------------------------
# 3. Validate event envelope JSON
# ------------------------------------------------------------

Write-Host ""
Write-Check "Validating JSON..."

try {
    Get-Content `
        "docs/events/schemas/event-envelope.schema.json" `
        -Raw |
        ConvertFrom-Json |
        Out-Null

    Write-Pass "Event envelope JSON is valid."
}
catch {
    Write-Fail "Invalid event envelope JSON: $($_.Exception.Message)"
}

# ------------------------------------------------------------
# 4. Validate README local links
# ------------------------------------------------------------

Write-Host ""
Write-Check "Validating README local links..."

$readme = Get-Content "README.md" -Raw

$linkMatches = [regex]::Matches(
    $readme,
    '\[[^\]]+\]\(([^)]+)\)'
)

foreach ($match in $linkMatches) {

    $target = $match.Groups[1].Value

    if (
        $target.StartsWith("http://") -or
        $target.StartsWith("https://") -or
        $target.StartsWith("#")
    ) {
        continue
    }

    $targetWithoutAnchor = $target.Split("#")[0]

    if ([string]::IsNullOrWhiteSpace($targetWithoutAnchor)) {
        continue
    }

    if (Test-Path $targetWithoutAnchor) {
        Write-Pass "README link: $target"
    }
    else {
        Write-Fail "Broken README link: $target"
    }
}

# ------------------------------------------------------------
# 5. Validate ADR count
# ------------------------------------------------------------

Write-Host ""
Write-Check "Validating ADRs..."

$adrFiles = Get-ChildItem `
    "docs/adr" `
    -Filter "ADR-*.md"

if ($adrFiles.Count -ge 6) {
    Write-Pass "$($adrFiles.Count) ADR files found."
}
else {
    Write-Fail "Expected at least 6 ADR files."
}

# ------------------------------------------------------------
# 6. Validate OpenAPI
# ------------------------------------------------------------

Write-Host ""
Write-Check "Validating OpenAPI contracts..."

$npx = Get-Command npx -ErrorAction SilentlyContinue

if ($null -eq $npx) {
    Write-Fail "npx was not found. Install Node.js before closing Sprint 0."
}
else {

    & npx --yes @redocly/cli@latest lint

    if ($LASTEXITCODE -eq 0) {
        Write-Pass "OpenAPI contracts are valid."
    }
    else {
        Write-Fail "OpenAPI validation failed."
    }
}

# ------------------------------------------------------------
# 7. Validate Git repository
# ------------------------------------------------------------

Write-Host ""
Write-Check "Validating Git..."

git rev-parse --is-inside-work-tree *> $null

if ($LASTEXITCODE -eq 0) {
    Write-Pass "Git repository detected."
}
else {
    Write-Fail "Current directory is not a Git repository."
}

# ------------------------------------------------------------
# 8. Optional clean working tree validation
# ------------------------------------------------------------

if ($RequireClean) {

    Write-Host ""
    Write-Check "Checking Git working tree..."

    $gitStatus = git status --porcelain

    if ([string]::IsNullOrWhiteSpace(($gitStatus -join ""))) {
        Write-Pass "Git working tree is clean."
    }
    else {
        Write-Fail "Git working tree contains pending changes."
        git status --short
    }
}

# ------------------------------------------------------------
# Result
# ------------------------------------------------------------

Write-Host ""
Write-Host "========================================="

if ($failed) {
    Write-Host " SPRINT 0 VALIDATION FAILED" -ForegroundColor Red
    Write-Host "========================================="
    exit 1
}

Write-Host " SPRINT 0 VALIDATION PASSED" -ForegroundColor Green
Write-Host "========================================="
exit 0