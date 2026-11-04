# Art images

Put artwork images for the `/art.html` gallery here.

The catalogue itself lives in `src/_data/artwork.js` — that file is the
single source of truth for gallery order, and the page template
(`src/art.njk`) renders it. The 3-column desktop layout is computed at
runtime from that order (`js/art-layout.js`): the first three pieces go
into columns 1/2/3 left to right, and each piece after that goes into
whichever column is currently shortest. Don't hardcode column assignments
anywhere — just edit the catalogue order.

To add a piece:

1. Drop the image file here, e.g. `images/art/untitled-study-01.jpg`.
2. Get its pixel width/height (e.g. `sips -g pixelWidth -g pixelHeight
   <file>` on macOS) — the gallery needs these to reserve layout space and
   avoid shifting as images load.
3. Add an entry to the array in `src/_data/artwork.js`: `src`, `width`,
   `height`, `title`, and `medium` (set `medium` to `null` to omit it from
   both the gallery caption and the full-size viewer if unknown).
4. Write real `alt` text for the piece once you know what it depicts.

The gallery preserves each image's natural aspect ratio — no cropping — so
images can be any orientation or size. Clicking a piece opens it larger in
a built-in viewer with previous/next navigation (`images/art/` files load
lazily, so uploading full-resolution images is fine).
