# Email Build Standards

**Purpose:** Authoritative technical standards for all HTML email builds.

**Authoritative for all email builds.**

*Last updated: 2026-05-15*

---

## Code Standards — Build Baseline

Every build must conform to these patterns without exception. Do not deviate unless the brief explicitly overrides a specific item.

### Head — required meta tags (in this order)

```html
<title>[Subject line]</title>
<!--[if !mso]><!-->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!--<![endif]-->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="format-detection" content="telephone=no, date=no, address=no, email=no, url=no">
<meta name="x-apple-disable-message-reformatting">
<meta name="color-scheme" content="light dark">
<meta name="supported-color-schemes" content="light dark">
```

### Head — MSO Office settings block

```html
<!--[if mso]>
<noscript><xml>
<o:OfficeDocumentSettings>
<o:AllowPNG/>
<o:PixelsPerInch>96</o:PixelsPerInch>
</o:OfficeDocumentSettings>
</xml></noscript>
<![endif]-->
```

### Head — Google Fonts (non-MSO clients only)

Always scope `<link>` to non-MSO via conditional comment. Outlook cannot load web fonts; don't send the request.

```html
<!--[if !mso]><!-->
<link href="https://fonts.googleapis.com/css?family=Inter:400,700" rel="stylesheet" type="text/css">
<!--<![endif]-->
```

Do not use `@font-face` declarations in addition — the `<link>` is sufficient for all supporting clients.

### Head — style block: CSS resets

```css
/* Core resets */
#outlook a { padding: 0; }
body { margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
table, td { border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; }
p { display: block; margin: 13px 0; }

/* Whitespace killer — required for all inline-block column grids */
div.wa { font-size: 0; }

/* Apple Mail / iOS — suppress auto-detection of dates, addresses, phone numbers */
a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; }
[x-apple-data-detectors-type="calendar-event"] { color: inherit !important; -webkit-text-decoration-color: inherit !important; }

/* Outlook.com / Hotmail — prevent link auto-colouring */
#MessageViewBody a { color: inherit !important; text-decoration: none !important; }

/* Samsung Mail — suppress auto-detection on common link types */
u + .emailify a[href^="tel:"],
u + .emailify a[href^="mailto:"],
u + .emailify a[href*="maps.google"] {
  color: inherit !important;
  text-decoration: none !important;
}
```

### Head — Outlook 2007–2019 style overrides (MSO conditional)

```html
<!--[if gte mso 9]>
<style>
a:link { mso-style-priority: 99; color: inherit; text-decoration: none; }
a:visited { mso-style-priority: 99; color: inherit; text-decoration: none; }
li { margin-left: -1em !important; }
table, td, p, div, span, ul, ol, li, a, h1, h2, h3, h4, h5, h6 { mso-hyphenate: none; }
sup, sub { font-size: 100% !important; }
img { background-color: transparent !important; }
</style>
<![endif]-->
```

### Body tag

Always set `lang`, `link`, `vlink` (Outlook link colour), and the base inline styles:

```html
<body lang="en" link="#[brand-primary]" vlink="#[brand-primary]" class="emailify"
  style="mso-line-height-rule: exactly; mso-hyphenate: none; word-spacing: normal; background-color: #[bg-colour];">
```

### Preheader

Hidden div immediately after `<body>` open, before the email wrapper:

```html
<div style="display: none; font-size: 1px; color: #ffffff; line-height: 1px; max-height: 0; max-width: 0; opacity: 0; overflow: hidden;">
  [Preheader text]&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;
</div>
```

### Multi-column grid layout — hybrid/spongy pattern

Use percentage-based column widths (not fixed pixel `inline-block` divs) combined with MSO conditional ghost tables. This survives Outlook and scales naturally on tablets without additional media queries.

**Calculating percentages:** for two equal columns inside a 540px container with a 30px gap: each column = (540 − 30) / 2 = 255px → 255 / 540 = **47.2222%**; gap column = 30 / 540 = **5.5556%**.

```html
<!-- Wrapper td: padding handles outer spacing -->
<td style="padding: 30px 30px 15px 30px;">
  <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td style="width: 540px;"><![endif]-->
  <div class="wa" style="font-size: 0; line-height: 0; text-align: left; display: inline-block; width: 100%; direction: ltr;">
    <!--[if mso | IE]><table border="0" cellpadding="0" cellspacing="0" role="presentation"><tr><td style="vertical-align: top; width: 254px;"><![endif]-->
    <div style="font-size: 0; text-align: left; direction: ltr; display: inline-block; vertical-align: top; width: 47.2222%;">
      <!-- Column content -->
    </div>
    <!--[if mso | IE]></td><td style="vertical-align: top; width: 30px;"><![endif]-->
    <div style="font-size: 0; text-align: left; direction: ltr; display: inline-block; vertical-align: top; width: 5.5556%;">
      <!-- Spacer column — empty -->
    </div>
    <!--[if mso | IE]></td><td style="vertical-align: top; width: 254px;"><![endif]-->
    <div style="font-size: 0; text-align: left; direction: ltr; display: inline-block; vertical-align: top; width: 47.2222%;">
      <!-- Column content -->
    </div>
    <!--[if mso | IE]></td></tr></table><![endif]-->
  </div>
  <!--[if mso | IE]></td></tr></table><![endif]-->
</td>
```

### Campaign Monitor — unsubscribe tag

Use bare `<unsubscribe>` tags. CM creates the link itself. Do **not** wrap an `<a>` tag inside `<unsubscribe>` — that is non-standard and breaks CM's link injection.

```html
<!-- Correct -->
<span style="text-decoration: underline;"><unsubscribe>Unsubscribe</unsubscribe></span>

<!-- Wrong — do not do this -->
<unsubscribe><a href="#">Unsubscribe</a></unsubscribe>
```

---

## Deliverables Standard

Every email build ships **four items**, no exceptions:

| File | Description |
|------|-------------|
| `[campaign-slug].html` | Production HTML email |
| `plain-text-version.txt` | Plain text alternative — all links in `(URL)` format after their anchor text |
| `previews.html` | Self-contained preview harness — desktop iframe (700px wide) + mobile iframe (iPhone selector: 430/393/375/360/320px) |
| `images.zip` | All images in `images/` folder, zipped for ESP upload |

**`previews.html` template:**

```html
<!doctype html>
<html>
<head>
  <title>[Campaign Name] (Preview)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex">
  <style>
    body { font-family: Arial, sans-serif; margin: 0; padding: 32px 16px; background: #fff; }
    h2 { color: #111; font-size: 24px; font-weight: bold; margin: 0; }
    .preview-table { width: 100%; border-spacing: 0 8px; margin-top: 8px; }
    .subject { color: #202124; font-size: 14px; }
    .preheader { color: #5f6368; opacity: 0.7; font-size: 14px; }
    .creative { display: flex; justify-content: space-around; margin: 30px 0 100px; gap: 40px; flex-wrap: wrap; }
    .col h3 { color: #666; font-size: 14px; font-weight: normal; margin: 0 0 8px 0; }
    .frame-desktop { border: 0; display: block; border-radius: 4px; background: #1e1e1e; width: 720px; height: 700px; }
    .frame-mobile { border: 0; display: block; border-radius: 24px; border: 12px solid #111; width: 393px; height: 852px; transition: width 220ms ease; }
    select { padding: 8px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; cursor: pointer; }
  </style>
</head>
<body>
  <h2>[Campaign Name]</h2>
  <table class="preview-table">
    <tr><td class="subject">[Subject line]<span class="preheader"> - [Preheader text]</span></td></tr>
  </table>
  <div class="creative">
    <div class="col">
      <h3>Desktop Preview (600px)</h3>
      <iframe class="frame-desktop" style="width: 720px; height: 3400px;" src="[campaign-slug]/index.html"></iframe>
    </div>
    <div class="col">
      <h3>Mobile Preview</h3>
      <select onchange="resizeMobile(this)">
        <option value="430">iPhone 16 Pro Max (430px)</option>
        <option value="393" selected>iPhone 16 (393px)</option>
        <option value="375">iPhone 13 Mini (375px)</option>
        <option value="360">iPhone 12 Mini (360px)</option>
        <option value="320">iPhone SE (320px)</option>
      </select>
      <br><br>
      <iframe class="frame-mobile" src="[campaign-slug]/index.html"></iframe>
    </div>
  </div>
  <script>
    function resizeMobile(sel) {
      const sizes = { "430": 932, "393": 852, "375": 812, "360": 780, "320": 568 };
      const w = parseInt(sel.value);
      document.querySelectorAll('.frame-mobile').forEach(f => {
        f.style.width = w + 'px';
        f.style.height = (sizes[w] || 852) + 'px';
      });
    }
  </script>
</body>
</html>
```

**Plain text rules:**
- All copy blocks in order, no HTML
- Buttons rendered as: `[Button label]\n(URL)`
- Images omitted (logo/signature/decorative)
- Social icons: `Facebook: (URL)` etc.
- Unsubscribe: `Unsubscribe: [unsubscribe link placeholder]`
