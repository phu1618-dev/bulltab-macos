#!/usr/bin/env bash
set -e

# Change directory to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${PROJECT_ROOT}"

APP_NAME="Bulltab"
BUNDLE_ID="com.local.bulltab"

echo "🔨 Building ${APP_NAME} (Universal Binary: arm64 + x86_64 Release mode)..."
swift build -c release --triple arm64-apple-macosx13.0 --product "${APP_NAME}"
swift build -c release --triple x86_64-apple-macosx13.0 --product "${APP_NAME}"

ARM64_BIN="${PROJECT_ROOT}/.build/arm64-apple-macosx/release/${APP_NAME}"
X86_64_BIN="${PROJECT_ROOT}/.build/x86_64-apple-macosx/release/${APP_NAME}"

APP_BUNDLE_DIR="${PROJECT_ROOT}/build/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "📦 Creating Universal App Bundle at ${APP_BUNDLE_DIR}..."
rm -rf "${APP_BUNDLE_DIR}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

lipo -create -output "${MACOS_DIR}/${APP_NAME}" "${ARM64_BIN}" "${X86_64_BIN}"
chmod +x "${MACOS_DIR}/${APP_NAME}"
cp "${PROJECT_ROOT}/Info.plist" "${CONTENTS_DIR}/Info.plist"
if [ -d "${PROJECT_ROOT}/Resources" ]; then
    cp -R "${PROJECT_ROOT}/Resources/"* "${RESOURCES_DIR}/"
fi

echo "🔏 Applying ad-hoc code signature with bundle identifier ${BUNDLE_ID}..."
codesign --force --deep --sign - --identifier "${BUNDLE_ID}" "${APP_BUNDLE_DIR}"
xattr -cr "${APP_BUNDLE_DIR}"

# Install into ~/Applications to bypass macOS App Translocation quarantine
USER_APPS_DIR="${HOME}/Applications"
mkdir -p "${USER_APPS_DIR}"
echo "🚚 Installing into ${USER_APPS_DIR}/${APP_NAME}.app..."
rm -rf "${USER_APPS_DIR}/${APP_NAME}.app"
# Clean up legacy name if present
rm -rf "${USER_APPS_DIR}/MacTabPilot.app"
cp -R "${APP_BUNDLE_DIR}" "${USER_APPS_DIR}/"
xattr -cr "${USER_APPS_DIR}/${APP_NAME}.app"

echo "✅ Build & Install complete! App is ready at:"
echo "   ${USER_APPS_DIR}/${APP_NAME}.app"
