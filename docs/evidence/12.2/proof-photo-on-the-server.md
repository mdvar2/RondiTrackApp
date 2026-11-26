# The proof photo on the server (2026-11-26, the local API, seed persona Sipho)

The input was a camera-style JPEG: 4000 × 3000, 11.9 MB, EXIF orientation 6
(sideways), with GPS (29°07'12" S, 26°13'05" E) in its EXIF.

It went through the app's own `prepareProof`
(`lib/features/proofs/domain/prepare_proof.dart`, run byte for byte on another
isolate), then was uploaded as the app uploads it: multipart, field `file`,
named `proof.jpg`, to `POST /api/v1/contributions/{id}/proof` as Sipho for his
Mabena Family contribution.

| | |
|---|---|
| Prepared | 3 083 KB, JPEG quality 85 (the first quality tried was under 5 MB) |
| Upload | **200**; the server stored `proof.jpg`, `image/jpeg`, **3 157 754 bytes** (limit 5 242 880) |
| Downloaded back | 1500 × 2000 (turned upright, longest side 2000), the same bytes as sent |
| EXIF | **0 tags**, **no GPS** |

Picking a photo with the phone's camera is checked by hand (README "What isn't
tested").
