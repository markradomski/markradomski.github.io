# Art images

Put artwork images for the `/art.html` gallery here.

Each piece needs one image file. There's no fixed naming scheme — use
whatever's clear, e.g. `untitled-study-01.jpg` or `self-portrait-2022.jpg`.

To add a piece to the gallery, open `art.html` and copy the commented
example `<figure class="art-item">` block inside `#art-gallery`, then:

1. Set both `href` (on the `<a>`) and `src` (on the `<img>`) to the image
   path, e.g. `images/art/untitled-study-01.jpg`.
2. Write real `alt` text describing the piece for screen readers.
3. Set `data-title` / `data-meta` on the `<a>` and the matching
   `.art-title` / `.art-meta` text in the `<figcaption>` — title, medium,
   dimensions and year, as available. Omit anything you don't have.
4. Delete the `<p class="art-empty-state">` placeholder once at least one
   piece is added.

The gallery preserves each image's natural aspect ratio — no cropping — so
images can be any orientation or size. Clicking a piece opens it larger in
a built-in viewer (`images/art/` files load lazily, so uploading full-
resolution images is fine).
