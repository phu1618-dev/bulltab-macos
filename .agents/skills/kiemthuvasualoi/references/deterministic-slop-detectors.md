# Bộ Dò AI Slop Định Lượng, Bố Cục Đóng Hộp & Vật Lý Chuyển Động (`Deterministic Slop Detectors v2.1`)

> Chắt lọc và chuẩn hóa cho Playwright `page.evaluate()` từ:
> - [`Manavarya09/design-extract`](https://github.com/Manavarya09/design-extract) (`MIT`: `src/slop/detectors.js`, `src/darkdiff.js`)
> - [`pbakaus/impeccable`](https://github.com/pbakaus/impeccable) (`Apache-2.0`: `craft-floor.md` — `skill-layout-cards-lazy`, `skill-ban-side-stripe-borders`, `skill-layout-spacing-rhythm`)
> - [`emilkowalski/skill`](https://github.com/emilkowalski/skill) & [`ibelick/ui-skills`](https://github.com/ibelick/ui-skills) (`MIT`: `transition: all` & compositor performance checks)

---

## 1. Tám Chỉ Số Bắt Tận Gốc AI Slop Cấp Độ 1, 2 & 3 (Không Phụ Thuộc Cảm Tính)

1. **HSL Indigo/Violet Band (`indigoHslHits`):** Nền rơi vào dải **`h ∈ [230°, 280°]`, `s >= 45%`, `15% < l < 85%`** $\rightarrow$ `OBSERVED_P1`.
2. **Đồng phục bo góc (`uniformRadiusViolation`):** `>= 85%` phần tử bo góc từ `6px..24px` dùng chung đúng 1 trị số phẳng lì.
3. **Lạm dụng căn giữa (`centeredOveruseViolation`):** Diện tích văn bản căn giữa chiếm `>= 70%` tổng diện tích chữ.
4. **Lồng thẻ trong thẻ (`nestedCardHits` — `Impeccable`):** Thẻ có nền + viền + bo góc (`rounded >= 8px`) nằm lồng bên trong một thẻ có viền + bo góc khác (`Card-in-Card Soup`).
5. **Vạch màu dọc 1 bên hộp (`sideStripeHits` — `Impeccable`):** Phần tử dùng `border-left-width >= 3px` trong khi 3 cạnh còn lại `< 2px` (`border-l-4` — dấu hiệu AI cổ điển).
6. **Nhịp tiêu đề ngược (`headingSpacingHits` — `Impeccable`):** Tiêu đề `h2/h3` đứng sau phần tử anh em nhưng lại có `marginBottom > marginTop` (làm tiêu đề dính vào khối trên thay vì khối nội dung bên dưới).
7. **Lạm dụng `transition: all` (`transitionAllHits` — `Emil Kowalski`):** Gây tính toán lại layout ngoài ý muốn và tụt khung hình; bắt buộc chỉ định rõ `transform, opacity`.
8. **Dark Mode Token Diff (`darkdiff`):** Các biến `--bg-*`, `--surface-*`, `--card-*` giữ nguyên độ sáng cao khi bật `.dark`.

---

## 2. Snippet Playwright Đo Trọn Bộ 7 Chỉ Số DOM/CSS Trong 1 Lượt `page.evaluate()`

```javascript
() => {
  const els = Array.from(document.querySelectorAll('main *, section *, article *'));
  const radiiMap = new Map();
  let totalArea = 0;
  let centeredArea = 0;
  const indigoHits = [];
  const nestedCardHits = [];
  const sideStripeHits = [];
  const headingSpacingHits = [];
  const transitionAllHits = [];

  const rgbToHsl = (r, g, b) => {
    r /= 255; g /= 255; b /= 255;
    const max = Math.max(r, g, b), min = Math.min(r, g, b);
    let h = 0, s = 0, l = (max + min) / 2;
    if (max !== min) {
      const d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
      if (max === r) h = ((g - b) / d + (g < b ? 6 : 0)) * 60;
      else if (max === g) h = ((b - r) / d + 2) * 60;
      else h = ((r - g) / d + 4) * 60;
    }
    return { h, s: s * 100, l: l * 100 };
  };

  const isCardLike = (node, cs) => {
    if (!node || ['BUTTON', 'INPUT', 'SELECT', 'TEXTAREA', 'A', 'SPAN', 'TH', 'TD'].includes(node.tagName)) return false;
    const br = parseFloat(cs.borderTopLeftRadius) || 0;
    const bw = parseFloat(cs.borderTopWidth) || 0;
    const pad = parseFloat(cs.paddingTop) || 0;
    const hasBg = cs.backgroundColor !== 'rgba(0, 0, 0, 0)' && cs.backgroundColor !== 'transparent';
    return br >= 10 && bw >= 0.5 && pad >= 12 && hasBg;
  };

  for (const el of els) {
    const rect = el.getBoundingClientRect();
    if (rect.width <= 0 || rect.height <= 0) continue;
    const cs = window.getComputedStyle(el);

    // 1. Uniform radius check
    const br = parseFloat(cs.borderTopLeftRadius);
    if (br > 0 && br < 100) {
      const key = `${Math.round(br)}px`;
      radiiMap.set(key, (radiiMap.get(key) || 0) + 1);
    }

    // 2. Centered-everything area share
    if (['P', 'H1', 'H2', 'H3', 'H4', 'SPAN', 'LI'].includes(el.tagName) && el.textContent?.trim()) {
      const area = rect.width * rect.height;
      totalArea += area;
      if (cs.textAlign === 'center') centeredArea += area;
    }

    // 3. HSL Indigo band check
    const m = cs.backgroundColor.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)/);
    if (m && (m[4] === undefined || parseFloat(m[4]) > 0.15)) {
      const { h, s, l } = rgbToHsl(+m[1], +m[2], +m[3]);
      if (h >= 230 && h <= 280 && s >= 45 && l > 15 && l < 85 && indigoHits.length < 10) {
        indigoHits.push({ tag: el.tagName, cls: String(el.className).slice(0, 60), bg: cs.backgroundColor, hue: Math.round(h) });
      }
    }

    // 4. Impeccable: Nested Card-in-Card check
    if (nestedCardHits.length < 10 && isCardLike(el, cs) && rect.width >= 180 && rect.height >= 80) {
      let p = el.parentElement;
      while (p && p !== document.body) {
        const pcs = window.getComputedStyle(p);
        const prect = p.getBoundingClientRect();
        if (isCardLike(p, pcs) && prect.width - rect.width < 120 && pcs.backgroundColor === cs.backgroundColor) {
          nestedCardHits.push({ childCls: String(el.className).slice(0, 50), parentCls: String(p.className).slice(0, 50) });
          break;
        }
        p = p.parentElement;
      }
    }

    // 5. Impeccable: Side-stripe border-l-4 AI tell
    const bl = parseFloat(cs.borderLeftWidth) || 0;
    const bt = parseFloat(cs.borderTopWidth) || 0;
    const brw = parseFloat(cs.borderRightWidth) || 0;
    if (bl >= 3 && bt < 2 && brw < 2 && el.tagName !== 'BLOCKQUOTE' && sideStripeHits.length < 10) {
      sideStripeHits.push({ tag: el.tagName, cls: String(el.className).slice(0, 60), borderLeft: cs.borderLeft });
    }

    // 6. Impeccable: Heading spacing rhythm (marginBottom > marginTop after sibling)
    if (['H2', 'H3'].includes(el.tagName) && el.previousElementSibling && headingSpacingHits.length < 10) {
      const mt = parseFloat(cs.marginTop) + parseFloat(cs.paddingTop);
      const mb = parseFloat(cs.marginBottom) + parseFloat(cs.paddingBottom);
      if (mb > mt && mb >= 12) {
        headingSpacingHits.push({ text: el.textContent?.trim().slice(0, 40), mt: Math.round(mt), mb: Math.round(mb) });
      }
    }

    // 7. Emil Kowalski: transition: all violation
    if (cs.transitionProperty === 'all' && parseFloat(cs.transitionDuration) > 0 && transitionAllHits.length < 10) {
      transitionAllHits.push({ tag: el.tagName, cls: String(el.className).slice(0, 60) });
    }
  }

  const totalRounded = [...radiiMap.values()].reduce((a, b) => a + b, 0);
  const topRadius = [...radiiMap.entries()].sort((a, b) => b[1] - a[1])[0] || null;
  const uniformRadiusRatio = topRadius && totalRounded >= 5 ? Number((topRadius[1] / totalRounded).toFixed(2)) : 0;
  const centeredShare = totalArea > 0 ? Number((centeredArea / totalArea).toFixed(2)) : 0;

  return {
    indigoHslHits: indigoHits,
    uniformRadiusViolation: uniformRadiusRatio >= 0.85 && parseFloat(topRadius[0]) >= 6 && parseFloat(topRadius[0]) <= 24,
    dominantRadius: topRadius,
    uniformRadiusRatio,
    centeredOveruseViolation: centeredShare >= 0.7,
    centeredShare,
    nestedCardHits,
    sideStripeHits,
    headingSpacingHits,
    transitionAllHits,
  };
};
```

---

## 3. Kiểm Toán Biến CSS Light vs Dark (`Dark Diff Check`)

Khi chạy Playwright kiểm tra chế độ tối (`.dark` hoặc `colorScheme: 'dark'`), thu thập toàn bộ `--*` custom properties ở `document.documentElement` trước và sau khi bật Dark Mode. Bất kỳ biến bề mặt (`--bg-*`, `--surface-*`, `--card-*`, `--border-*`) nào có giá trị sáng (`l > 80%`) vẫn giữ nguyên không đổi trong Dark Mode đều là nguyên nhân gốc của lỗi `White-Box Flash`.
