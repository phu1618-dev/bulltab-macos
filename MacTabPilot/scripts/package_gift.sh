#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${PROJECT_ROOT}/.." && pwd)"

APP_NAME="Bulltab"
BUNDLE_ID="com.local.bulltab"

cd "${PROJECT_ROOT}"

echo "🔨 [1/5] Building Universal Binary (arm64 + x86_64)..."
swift build -c release --triple arm64-apple-macosx13.0 --product "${APP_NAME}"
swift build -c release --triple x86_64-apple-macosx13.0 --product "${APP_NAME}"

ARM64_BIN="${PROJECT_ROOT}/.build/arm64-apple-macosx/release/${APP_NAME}"
X86_64_BIN="${PROJECT_ROOT}/.build/x86_64-apple-macosx/release/${APP_NAME}"

APP_BUNDLE_DIR="${PROJECT_ROOT}/build/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

rm -rf "${PROJECT_ROOT}/build"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

lipo -create -output "${MACOS_DIR}/${APP_NAME}" "${ARM64_BIN}" "${X86_64_BIN}"
chmod +x "${MACOS_DIR}/${APP_NAME}"
cp "${PROJECT_ROOT}/Info.plist" "${CONTENTS_DIR}/Info.plist"
if [ -d "${PROJECT_ROOT}/Resources" ]; then
    cp -R "${PROJECT_ROOT}/Resources/"* "${RESOURCES_DIR}/"
fi

echo "🔏 [2/5] Signing Universal App Bundle..."
codesign --force --deep --sign - --identifier "${BUNDLE_ID}" "${APP_BUNDLE_DIR}"
xattr -cr "${APP_BUNDLE_DIR}"

echo "🔍 Architecture check:"
lipo -info "${MACOS_DIR}/${APP_NAME}"

# Prepare staging directory for Gift Packages
DIST_DIR="${REPO_ROOT}/Goi_Qua_Tang_Mac_Bulltab"
STAGING_APP_DIR="${PROJECT_ROOT}/build/Bulltab-macOS"
rm -rf "${DIST_DIR}" "${STAGING_APP_DIR}"
mkdir -p "${DIST_DIR}" "${STAGING_APP_DIR}"

cp -R "${APP_BUNDLE_DIR}" "${STAGING_APP_DIR}/"
cp "${PROJECT_ROOT}/README.md" "${STAGING_APP_DIR}/HƯỚNG DẪN CÀI ĐẶT & PHÍM TẮT.md"

# Create 1-Click Installer .command script
INSTALLER_SCRIPT="${STAGING_APP_DIR}/Cài đặt Bulltab (1-Click).command"
cat << 'EOF' > "${INSTALLER_SCRIPT}"
#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_SRC="${DIR}/Bulltab.app"

echo "========================================================"
echo "🐂 CÀI ĐẶT BULLTAB CHO MACOS (ALTTAB + RECTANGLE)"
echo "========================================================"

if [ ! -d "${APP_SRC}" ]; then
    echo "❌ Không tìm thấy Bulltab.app trong cùng thư mục!"
    read -p "Nhấn Enter để thoát..."
    exit 1
fi

# Try installing to /Applications if writable, otherwise ~/Applications
TARGET_DIR="/Applications"
if [ ! -w "/Applications" ]; then
    TARGET_DIR="${HOME}/Applications"
    mkdir -p "${TARGET_DIR}"
fi

echo "📦 Đang sao chép Bulltab.app vào ${TARGET_DIR}..."
pkill -x "Bulltab" 2>/dev/null || true
rm -rf "${TARGET_DIR}/Bulltab.app"
cp -R "${APP_SRC}" "${TARGET_DIR}/Bulltab.app"

echo "🔓 Đang gỡ bỏ cờ cách ly Gatekeeper (Quarantine) của macOS..."
xattr -cr "${TARGET_DIR}/Bulltab.app" 2>/dev/null || true

echo "🚀 Đang khởi động Bulltab..."
open "${TARGET_DIR}/Bulltab.app"

echo ""
echo "✅ CÀI ĐẶT THÀNH CÔNG!"
echo "👉 Bước cuối cùng: Hãy bấm vào biểu tượng 🐂 trên thanh Menu Bar (góc trên bên phải)"
echo "   và cấp quyền Trợ năng (Accessibility) trong System Settings để bắt đầu sử dụng!"
echo "========================================================"
sleep 2
EOF
chmod +x "${INSTALLER_SCRIPT}"
xattr -cr "${STAGING_APP_DIR}"

echo "💿 [3/5] Creating macOS DMG Installer..."
DMG_STAGING="${PROJECT_ROOT}/build/dmg_staging"
rm -rf "${DMG_STAGING}"
mkdir -p "${DMG_STAGING}"
cp -R "${STAGING_APP_DIR}/"* "${DMG_STAGING}/"
ln -s /Applications "${DMG_STAGING}/Applications"

DMG_PATH="${DIST_DIR}/Bulltab-macOS-Installer.dmg"
hdiutil create -volname "Bulltab Installer" -srcfolder "${DMG_STAGING}" -ov -format UDZO "${DMG_PATH}"

echo "🗜️ [4/5] Creating App-Only Gift ZIP..."
APP_ZIP_PATH="${DIST_DIR}/Bulltab-macOS-App-Only.zip"
ditto -c -k --norsrc --keepParent "${STAGING_APP_DIR}" "${APP_ZIP_PATH}"

echo "📦 [5/5] Creating Full Repo + App Gift ZIP (Clean without .build cache)..."
REPO_STAGING="${PROJECT_ROOT}/build/Bulltab-Full-Repo"
rm -rf "${REPO_STAGING}"
mkdir -p "${REPO_STAGING}"

# Copy root markdown docs
cp "${REPO_ROOT}/"*.md "${REPO_STAGING}/" 2>/dev/null || true
cp "${PROJECT_ROOT}/README.md" "${REPO_STAGING}/README.md"

# Copy clean MacTabPilot project (without .build or staging)
mkdir -p "${REPO_STAGING}/MacTabPilot"
cp "${PROJECT_ROOT}/Info.plist" "${REPO_STAGING}/MacTabPilot/"
cp "${PROJECT_ROOT}/Package.swift" "${REPO_STAGING}/MacTabPilot/"
cp "${PROJECT_ROOT}/ManualTestMatrix.md" "${REPO_STAGING}/MacTabPilot/"
cp "${PROJECT_ROOT}/README.md" "${REPO_STAGING}/MacTabPilot/"
cp -R "${PROJECT_ROOT}/Resources" "${REPO_STAGING}/MacTabPilot/"
cp -R "${PROJECT_ROOT}/Sources" "${REPO_STAGING}/MacTabPilot/"
cp -R "${PROJECT_ROOT}/scripts" "${REPO_STAGING}/MacTabPilot/"

# Also include the pre-built Universal Bulltab.app and 1-Click Installer at the root of the Repo ZIP!
cp -R "${APP_BUNDLE_DIR}" "${REPO_STAGING}/"
cp "${INSTALLER_SCRIPT}" "${REPO_STAGING}/"
xattr -cr "${REPO_STAGING}"

FULL_ZIP_PATH="${DIST_DIR}/Bulltab-Full-Repo-And-App.zip"
ditto -c -k --norsrc --keepParent "${REPO_STAGING}" "${FULL_ZIP_PATH}"

# Copy README to DIST_DIR as well
cp "${PROJECT_ROOT}/README.md" "${DIST_DIR}/HƯỚNG DẪN CÀI ĐẶT & PHÍM TẮT.md"

# Clean temporary staging folders
rm -rf "${STAGING_APP_DIR}" "${DMG_STAGING}" "${REPO_STAGING}"

echo "🎉 Hoàn tất đóng gói tại: ${DIST_DIR}"
ls -lh "${DIST_DIR}"
