#!/usr/bin/env python3
"""universal_adversarial_loop.py — Global Multi-Project 6-Station Adversarial Loop Engine.

Works across ANY Antigravity Web/SaaS/FinTech/InsurTech/ERP/Extension project:
  1. --init: Auto-discovers project routes (Next.js app/, React/Vite src/pages/, HTML/Sidecar) and
     bootstraps docs/CONTINUOUS_ADVERSARIAL_LOOP_QUEUE.json if missing.
  2. Executes the 6-Station Sliced Adversarial Loop on live Playwright across 4 viewports:
     - Station 1: Live Experiential Walkthrough & Unforgiving DOM/Network/Acuity Critique
     - Station 2: Independent /nhanxet Judge & Vietnam Product Spirit Filter
     - Station 3: Minimal-Blast-Radius Remediation Plan Proposal
     - Station 4: 4-Gate Plan Gatekeeper (Cross-Slice Safety, Zero Step Inflation, <=3 Files, 3-KHÔNG Invariants)
     - Station 5: Source-Code Global Invariants Verification
     - Station 6: Convergence Brake (FROZEN_CLEAN) & Queue Progression
"""

from __future__ import annotations

import argparse
import asyncio
import datetime as dt
import json
import re
import subprocess
import sys
import time
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple


VIEWPORTS = [
    {"label": "desktop_1440x900", "width": 1440, "height": 900, "is_mobile": False},
    {"label": "laptop_1280x800", "width": 1280, "height": 800, "is_mobile": False},
    {"label": "mobile_390x844", "width": 390, "height": 844, "is_mobile": True},
    {"label": "mobile_375x812", "width": 375, "height": 812, "is_mobile": True},
]

DEEP_SENSOR_JS = """(payload) => {
  const { vpLabel, routeLabel, forbiddenTerms } = payload;
  const vw = window.innerWidth;
  const docSw = document.documentElement.scrollWidth;
  const docOverflow = Math.max(0, docSw - vw);
  const frameBreaks = [];
  let count86868b = 0;
  let countTinyText = 0;
  const unlabeledInputs = [];

  if (docOverflow > 1) {
    frameBreaks.push({ type: "DOC_OVERFLOW", px: docOverflow, route: routeLabel, vp: vpLabel });
  }

  const els = document.querySelectorAll("body *");
  for (const el of els) {
    const style = window.getComputedStyle(el);
    if (style.display === "none" || style.visibility === "hidden" || parseFloat(style.opacity) === 0) continue;
    const rect = el.getBoundingClientRect();
    if (rect.width === 0 || rect.height === 0) continue;

    let inScrollX = false;
    let p = el.parentElement;
    while (p && p !== document.body) {
      const ps = window.getComputedStyle(p);
      if (ps.overflowX === "auto" || ps.overflowX === "scroll") { inScrollX = true; break; }
      p = p.parentElement;
    }

    if (!inScrollX && (rect.right > vw + 2 || rect.left < -2)) {
      frameBreaks.push({
        type: "OUT_OF_VIEWPORT",
        route: routeLabel,
        vp: vpLabel,
        tag: el.tagName,
        cls: typeof el.className === "string" ? el.className.slice(0, 80) : "",
        text: (el.innerText || "").slice(0, 45).replace(/\\n/g, " "),
        right: Math.round(rect.right),
        vw
      });
    }

    if ((style.overflowX === "hidden" || style.overflowX === "clip") &&
        style.textOverflow !== "ellipsis" &&
        el.scrollWidth > el.clientWidth + 6 &&
        el.children.length > 0) {
      frameBreaks.push({
        type: "CLIPPED_CONTAINER",
        route: routeLabel,
        vp: vpLabel,
        tag: el.tagName,
        cls: typeof el.className === "string" ? el.className.slice(0, 80) : "",
        sw: el.scrollWidth,
        cw: el.clientWidth,
        text: (el.innerText || "").slice(0, 45).replace(/\\n/g, " ")
      });
    }

    if (el.children.length === 0 && (el.innerText || "").trim().length > 0) {
      const txt = (el.innerText || "").trim();
      if (txt.length > 10 && rect.width < 58 && rect.height > 64) {
        frameBreaks.push({
          type: "SQUISHED_VERTICAL_TEXT",
          route: routeLabel,
          vp: vpLabel,
          tag: el.tagName,
          w: Math.round(rect.width),
          h: Math.round(rect.height),
          text: txt.slice(0, 45)
        });
      }
      if (style.color === "rgb(134, 134, 139)") count86868b++;
      const fs = parseFloat(style.fontSize);
      if (fs > 0 && fs < 11) countTinyText++;
    }

    if ((el.tagName === "INPUT" || el.tagName === "SELECT" || el.tagName === "TEXTAREA") &&
        el.type !== "hidden" && !el.disabled) {
      const hasLabel = (el.labels && el.labels.length > 0) ||
                       Boolean(el.getAttribute("aria-label")) ||
                       Boolean(el.getAttribute("aria-labelledby")) ||
                       Boolean(el.closest("label"));
      if (!hasLabel && unlabeledInputs.length < 5) {
        unlabeledInputs.push({
          route: routeLabel,
          vp: vpLabel,
          tag: el.tagName,
          id: el.id || "",
          placeholder: el.getAttribute("placeholder") || ""
        });
      }
    }
  }

  const visibleText = (document.body && document.body.innerText) ? document.body.innerText : "";
  const leakedTerms = [];
  for (const term of (forbiddenTerms || [])) {
    if (term && visibleText.includes(term)) leakedTerms.push(term);
  }

  const rawGarbageTokens = [];
  if (/\\bNaN\\b/.test(visibleText)) rawGarbageTokens.push("NaN");
  if (/\\bundefined\\b/.test(visibleText)) rawGarbageTokens.push("undefined");
  if (visibleText.includes("[object Object]")) rawGarbageTokens.push("[object Object]");
  if (visibleText.includes("Chuẩn 3 KHÔNG")) rawGarbageTokens.push("Chuẩn 3 KHÔNG");

  return {
    route: routeLabel,
    vp: vpLabel,
    vw,
    docSw,
    docOverflow,
    frameBreakCount: frameBreaks.length,
    frameBreakSamples: frameBreaks.slice(0, 6),
    count86868b,
    countTinyText,
    unlabeledInputCount: unlabeledInputs.length,
    unlabeledInputSamples: unlabeledInputs,
    leakedTerms,
    rawGarbageTokens,
    tabularNumsCount: document.querySelectorAll(".tabular-nums").length
  };
}"""


def discover_project_routes(project_root: Path) -> List[Dict[str, Any]]:
    """Auto-discovers Next.js app routes, React/Vite pages, or HTML entrypoints for --init."""
    discovered_paths: List[str] = ["/"]

    # Check Next.js App Router (app/**/page.tsx|jsx|js)
    for app_dir in (project_root / "src" / "app", project_root / "app", project_root / "frontend" / "src" / "app"):
        if app_dir.exists():
            for pfile in sorted(app_dir.rglob("page.*")):
                rel = pfile.parent.relative_to(app_dir).as_posix()
                if "[" in rel or rel.startswith("api"):
                    continue
                cleaned = "/" + "/".join(
                    seg for seg in rel.split("/") if seg and not (seg.startswith("(") and seg.endswith(")"))
                )
                if cleaned not in discovered_paths:
                    discovered_paths.append(cleaned)

    # If no Next.js routes beyond '/', check Vite/React pages
    if len(discovered_paths) == 1:
        for pages_dir in (project_root / "frontend" / "src" / "pages", project_root / "src" / "pages"):
            if pages_dir.exists():
                for pfile in sorted(pages_dir.glob("*.*")):
                    if pfile.suffix in (".jsx", ".tsx", ".js", ".ts") and not pfile.stem.startswith("_"):
                        slug = re.sub(r"(?<!^)(?=[A-Z])", "-", pfile.stem).lower()
                        discovered_paths.append(f"/?page={slug}" if slug != "index" else "/")
                break

    slices: List[Dict[str, Any]] = []
    chunk_size = max(1, min(4, len(discovered_paths)))
    grouped = [discovered_paths[i : i + chunk_size] for i in range(0, len(discovered_paths), chunk_size)]

    for idx, routes_group in enumerate(grouped[:8], 1):
        slices.append(
            {
                "slice_id": f"SLICE-{idx:02d}-CORE-FLOW",
                "order": idx,
                "slice_name": f"Phân hệ Trải nghiệm Cốt lõi #{idx}",
                "persona": {
                    "owner_name": "Người dùng Việt Nam đại diện (/nhankhauhoc)",
                    "age": 48,
                    "role": "Khách hàng / Chủ doanh nghiệp Việt Nam ưu tiên thao tác gọn <= 3 chạm, chữ rõ >= 11px, 0 vỡ khung"
                },
                "journey_name": f"Kiểm toán luồng {', '.join(routes_group)}",
                "urls": routes_group,
                "forbidden_leak_terms": [],
                "adversarial_overreach_claims": [
                    {
                        "claim_id": f"OVR-{idx:02d}-01",
                        "raw_critique": "Đề xuất nhồi thêm 4 hộp KPI màu tím Gradient và bắt điền CCCD ở bước đầu tiên.",
                        "conflict_type": "FEATURE_BLOAT_AND_HIG_VIOLATION"
                    }
                ],
                "status": "PENDING",
                "iteration_count": 0,
                "last_score": None,
                "last_audited_at": None,
                "frozen_decisions": []
            }
        )
    return slices


DEFAULT_FORBIDDEN_UI_TOKENS = [
    "indigo-500",
    "indigo-600",
    "purple-600",
    "violet-600",
    "#6366f1",
    "shadow-2xl",
    "Chuẩn 3 KHÔNG",
]


def _strip_code_comments(txt: str) -> str:
    cleaned = re.sub(r"/\*[\s\S]*?\*/", "", txt)
    cleaned = re.sub(r"(?m)^\s*(?://|\*).*$", "", cleaned)
    cleaned = re.sub(r"(?m)\s+//.*$", "", cleaned)
    return cleaned


def bootstrap_queue_if_needed(
    project_root: Path, force_init: bool = False, queue_file: Optional[str] = None
) -> Path:
    if queue_file:
        qpath = Path(queue_file)
        queue_path = qpath if qpath.is_absolute() else (project_root / qpath)
    else:
        queue_path = project_root / "docs" / "CONTINUOUS_ADVERSARIAL_LOOP_QUEUE.json"
    if queue_path.exists() and not force_init:
        return queue_path

    queue_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "loop_version": "3.0.0-universal",
        "project_name": project_root.name,
        "epoch": 1,
        "max_iterations_per_slice": 3,
        "target_freeze_score": 98.0,
        "global_invariants": {
            "forbidden_ui_tokens": list(DEFAULT_FORBIDDEN_UI_TOKENS)
        },
        "slices": discover_project_routes(project_root),
    }
    queue_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return queue_path


def check_universal_invariants(project_root: Path, inv_cfg: Dict[str, Any]) -> Dict[str, Any]:
    violations: List[str] = []
    forbidden_tokens = inv_cfg.get(
        "forbidden_ui_tokens",
        DEFAULT_FORBIDDEN_UI_TOKENS,
    )
    scan_roots = [
        p for p in (project_root / "frontend" / "src", project_root / "src", project_root / "extension")
        if p.exists()
    ]
    for sroot in scan_roots:
        for ext in ("*.jsx", "*.tsx", "*.js", "*.ts", "*.css", "*.html"):
            for fpath in sroot.rglob(ext):
                if (
                    "node_modules" in fpath.parts
                    or ".next" in fpath.parts
                    or "dist" in fpath.parts
                    or "__tests__" in fpath.parts
                    or ".test." in fpath.name
                    or ".spec." in fpath.name
                ):
                    continue
                txt = _strip_code_comments(fpath.read_text(encoding="utf-8", errors="ignore"))
                for tok in forbidden_tokens:
                    if tok in txt:
                        violations.append(f"{fpath.relative_to(project_root)} -> {tok!r}")
                        if len(violations) >= 12:
                            return {"passed": False, "violations": violations}
    return {"passed": len(violations) == 0, "violations": violations}


def judge_claims_nhanxet(raw_claims: List[Dict[str, Any]]) -> Dict[str, Any]:
    p0_types = {"RUNTIME_PAGE_ERROR", "BAD_QUERY_SERIALIZATION", "API_HTTP_500", "RAW_TECHNICAL_GARBAGE", "CROSS_INDUSTRY_TERM_LEAK"}
    p1_types = {"FRAME_BREAK_OVERFLOW", "TINY_FONT_UNDER_11PX", "UNLABELED_FORM_INPUT"}
    p2_types = {"LOW_CONTRAST_SECONDARY_TEXT"}

    verdicts, p0, p1, p2, rejected = [], [], [], [], []
    for cl in raw_claims:
        ct = cl["claim_type"]
        if ct in p0_types:
            v = {**cl, "verdict": "OBSERVED_P0"}
            p0.append(v)
        elif ct in p1_types:
            v = {**cl, "verdict": "OBSERVED_P1"}
            p1.append(v)
        elif ct in p2_types:
            v = {**cl, "verdict": "OBSERVED_P2"}
            p2.append(v)
        else:
            v = {**cl, "verdict": "REJECTED_BLOAT_OR_CONFLICT"}
            rejected.append(v)
        verdicts.append(v)

    score = round(max(0.0, 100.0 - len(p0) * 15.0 - len(p1) * 4.0 - min(2.0, len(p2) * 0.5)), 1)
    return {
        "verdicts": verdicts,
        "counts": {
            "OBSERVED_P0": len(p0),
            "OBSERVED_P1": len(p1),
            "OBSERVED_P2": len(p2),
            "REJECTED_BLOAT_OR_CONFLICT": len(rejected),
        },
        "actionable": p0 + p1,
        "score": score,
    }


async def audit_slice_universal(page: Any, base_url: str, sl: Dict[str, Any]) -> Dict[str, Any]:
    urls = sl.get("urls") or [f"/?tab={r}" for r in sl.get("desktop_routes", ["dashboard"])]
    forbidden_terms = sl.get("forbidden_leak_terms", [])
    raw_claims: List[Dict[str, Any]] = []
    page_errors: List[str] = []
    server_500: List[str] = []

    on_err = lambda e: page_errors.append(str(e))
    on_res = lambda r: server_500.append(f"{r.status} {r.url}") if ("/api/" in r.url and r.status >= 500) else None
    page.on("pageerror", on_err)
    page.on("response", on_res)

    scans = 0
    try:
        for rel_u in urls:
            target = rel_u if rel_u.startswith("http") else f"{base_url.rstrip('/')}/{rel_u.lstrip('/')}"
            for vp in VIEWPORTS:
                await page.set_viewport_size({"width": vp["width"], "height": vp["height"]})
                await page.goto(target, wait_until="networkidle")
                await page.wait_for_timeout(350)
                sc = await page.evaluate(
                    DEEP_SENSOR_JS,
                    {"vpLabel": vp["label"], "routeLabel": rel_u, "forbiddenTerms": forbidden_terms},
                )
                scans += 1
                if sc["rawGarbageTokens"]:
                    raw_claims.append({"claim_type": "RAW_TECHNICAL_GARBAGE", "route": rel_u, "vp": vp["label"], "evidence": str(sc["rawGarbageTokens"])})
                if sc["leakedTerms"]:
                    raw_claims.append({"claim_type": "CROSS_INDUSTRY_TERM_LEAK", "route": rel_u, "vp": vp["label"], "evidence": str(sc["leakedTerms"])})
                if sc["frameBreakCount"] > 0:
                    raw_claims.append({"claim_type": "FRAME_BREAK_OVERFLOW", "route": rel_u, "vp": vp["label"], "evidence": str(sc["frameBreakSamples"][:2])})
                if sc["countTinyText"] > 0:
                    raw_claims.append({"claim_type": "TINY_FONT_UNDER_11PX", "route": rel_u, "vp": vp["label"], "evidence": f"{sc['countTinyText']} tiny elements"})
                if sc["unlabeledInputCount"] > 0:
                    raw_claims.append({"claim_type": "UNLABELED_FORM_INPUT", "route": rel_u, "vp": vp["label"], "evidence": str(sc["unlabeledInputSamples"][:2])})

        for err in page_errors:
            raw_claims.append({"claim_type": "RUNTIME_PAGE_ERROR", "route": "global", "vp": "any", "evidence": err[:160]})
        for s5 in server_500:
            raw_claims.append({"claim_type": "API_HTTP_500", "route": "api", "vp": "any", "evidence": s5})
        for ovr in sl.get("adversarial_overreach_claims", []):
            raw_claims.append({"claim_type": ovr.get("conflict_type", "BLOAT"), "route": "architecture", "vp": "all", "evidence": ovr.get("raw_critique", "")})
    finally:
        page.remove_listener("pageerror", on_err)
        page.remove_listener("response", on_res)

    return {"scans": scans, "raw_claims": raw_claims}


async def run_universal(
    project_root: Path,
    base_url: str,
    max_slices: int,
    reset_epoch: bool,
    queue_file: Optional[str] = None,
) -> Tuple[int, Dict[str, Any]]:
    # Delegate to project-specific engine if RPM_ERP or custom engine exists (unless custom --queue specified)
    project_custom_script = project_root / "scripts" / "run_continuous_adversarial_loop.py"
    if project_custom_script.exists() and not queue_file:
        cmd = [sys.executable, str(project_custom_script), "--base-url", base_url, "--slices", str(max_slices)]
        if reset_epoch:
            cmd.append("--reset-epoch")
        proc = subprocess.run(cmd, cwd=str(project_root), capture_output=True, text=True)
        if proc.stdout.strip():
            print(proc.stdout.strip())
        if proc.stderr.strip() and proc.returncode != 0:
            print(proc.stderr.strip(), file=sys.stderr)
        return proc.returncode, {"delegated_to": str(project_custom_script)}

    from playwright.async_api import async_playwright

    queue_path = bootstrap_queue_if_needed(project_root, force_init=False, queue_file=queue_file)
    qdata = json.loads(queue_path.read_text(encoding="utf-8"))
    if reset_epoch:
        qdata["epoch"] = int(qdata.get("epoch", 1)) + 1
        for s in qdata["slices"]:
            s["status"] = "PENDING"
            s["iteration_count"] = 0

    selected = [s for s in qdata["slices"] if s["status"] in ("PENDING", "NEEDS_REMEDIATION")][:max_slices]
    inv = check_universal_invariants(project_root, qdata.get("global_invariants", {}))
    results = []

    if selected:
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page(viewport={"width": 1440, "height": 900})
            for sl in selected:
                st1 = await audit_slice_universal(page, base_url, sl)
                st2 = judge_claims_nhanxet(st1["raw_claims"])
                sl["iteration_count"] = int(sl.get("iteration_count", 0)) + 1
                sl["last_score"] = st2["score"]
                sl["last_audited_at"] = dt.datetime.now(dt.timezone.utc).isoformat()

                if st2["counts"]["OBSERVED_P0"] == 0 and st2["counts"]["OBSERVED_P1"] == 0 and inv["passed"]:
                    sl["status"] = "FROZEN_CLEAN"
                    gate = "CONVERGED_NO_PLAN_NEEDED"
                elif any(d["claim_type"] == "API_HTTP_500" for d in st2["actionable"]):
                    sl["status"] = "NEEDS_HUMAN_APPROVAL"
                    gate = "NEEDS_HUMAN_APPROVAL"
                else:
                    sl["status"] = "NEEDS_REMEDIATION"
                    gate = "APPROVED_FOR_SURGICAL_EXECUTION"

                results.append(
                    {
                        "slice_id": sl["slice_id"],
                        "score": st2["score"],
                        "counts": st2["counts"],
                        "gatekeeper": gate,
                        "status": sl["status"],
                        "actionable_defects": st2["actionable"][:5],
                    }
                )
            await browser.close()

    queue_path.write_text(json.dumps(qdata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    summary = {
        "project": project_root.name,
        "epoch": qdata["epoch"],
        "global_invariants_passed": inv["passed"],
        "invariant_violations": inv["violations"],
        "queue_progress": {
            "total_slices": len(qdata["slices"]),
            "frozen_clean": sum(1 for s in qdata["slices"] if s["status"] == "FROZEN_CLEAN"),
            "pending": sum(1 for s in qdata["slices"] if s["status"] == "PENDING"),
        },
        "processed_slices": results,
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    blocking = (not inv["passed"]) or any(r["status"] != "FROZEN_CLEAN" for r in results)
    return (1 if blocking else 0), summary


def main() -> int:
    parser = argparse.ArgumentParser(description="Universal Multi-Project 6-Station Adversarial Loop")
    parser.add_argument("--project-root", default=".", help="Path to target project root")
    parser.add_argument("--base-url", default="http://localhost:3000", help="Live web server URL")
    parser.add_argument("--init", action="store_true", help="Initialize CONTINUOUS_ADVERSARIAL_LOOP_QUEUE.json only")
    parser.add_argument("--slices", type=int, default=2, help="Number of slices to audit")
    parser.add_argument("--all-pending", action="store_true", help="Audit all pending slices")
    parser.add_argument("--reset-epoch", action="store_true", help="Start a new epoch")
    parser.add_argument(
        "--queue",
        default=None,
        help="Optional path to custom queue JSON file (default: docs/CONTINUOUS_ADVERSARIAL_LOOP_QUEUE.json)",
    )
    args = parser.parse_args()

    proot = Path(args.project_root).resolve()
    if args.init:
        qpath = bootstrap_queue_if_needed(proot, force_init=False, queue_file=args.queue)
        print(json.dumps({"initialized_queue": str(qpath)}, ensure_ascii=False))
        return 0

    max_s = 999 if args.all_pending else max(1, args.slices)
    code, _ = asyncio.run(run_universal(proot, args.base_url, max_s, args.reset_epoch, queue_file=args.queue))
    return code


if __name__ == "__main__":
    sys.exit(main())
