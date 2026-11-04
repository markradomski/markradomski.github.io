(function () {
  "use strict";

  var dialog = document.getElementById("art-viewer");
  if (!dialog || typeof dialog.showModal !== "function") {
    return;
  }

  var viewerImg = dialog.querySelector("img");
  var titleEl = dialog.querySelector(".art-viewer-title");
  var metaEl = dialog.querySelector(".art-viewer-meta");
  var closeBtn = dialog.querySelector(".art-viewer-close");
  var prevBtn = dialog.querySelector(".art-viewer-prev");
  var nextBtn = dialog.querySelector(".art-viewer-next");

  // Sorted by data-index since art-layout.js reparents these into columns.
  var links = Array.prototype.slice
    .call(document.querySelectorAll(".art-link"))
    .sort(function (a, b) {
      return Number(a.dataset.index) - Number(b.dataset.index);
    });

  var currentIndex = -1;
  var lastTrigger = null;

  function updateNavButtons() {
    prevBtn.disabled = currentIndex <= 0;
    nextBtn.disabled = currentIndex >= links.length - 1;
  }

  // Centres the close button in the gutter right of the image, vertically centred on the image's top edge, clamped so it never clips the dialog.
  function positionCloseButton() {
    var dialogRect = dialog.getBoundingClientRect();
    var imgRect = viewerImg.getBoundingClientRect();
    var halfWidth = closeBtn.offsetWidth / 2;
    var halfHeight = closeBtn.offsetHeight / 2;
    var centerX = (imgRect.right + dialogRect.right) / 2 - dialogRect.left;
    var centerY = imgRect.top - dialogRect.top;
    centerX = Math.min(
      Math.max(centerX, halfWidth),
      dialogRect.width - halfWidth
    );
    centerY = Math.min(
      Math.max(centerY, halfHeight),
      dialogRect.height - halfHeight
    );
    closeBtn.style.left = centerX + "px";
    closeBtn.style.top = centerY + "px";
  }

  function openViewer(index) {
    var link = links[index];
    if (!link) return;
    var thumb = link.querySelector("img");
    viewerImg.src = link.getAttribute("href");
    viewerImg.alt = thumb ? thumb.alt : "";
    titleEl.textContent = link.dataset.title || "";
    metaEl.textContent = link.dataset.meta || "";
    currentIndex = index;
    updateNavButtons();
    if (!dialog.open) {
      dialog.showModal();
    }
    positionCloseButton();
    closeBtn.focus();
  }

  viewerImg.addEventListener("load", positionCloseButton);
  window.addEventListener("resize", function () {
    if (dialog.open) positionCloseButton();
  });

  links.forEach(function (link, index) {
    link.addEventListener("click", function (event) {
      event.preventDefault();
      lastTrigger = link;
      openViewer(index);
    });
  });

  prevBtn.addEventListener("click", function () {
    if (currentIndex > 0) openViewer(currentIndex - 1);
  });

  nextBtn.addEventListener("click", function () {
    if (currentIndex < links.length - 1) openViewer(currentIndex + 1);
  });

  dialog.addEventListener("keydown", function (event) {
    if (event.key === "ArrowLeft" && currentIndex > 0) {
      event.preventDefault();
      openViewer(currentIndex - 1);
    } else if (event.key === "ArrowRight" && currentIndex < links.length - 1) {
      event.preventDefault();
      openViewer(currentIndex + 1);
    }
  });

  closeBtn.addEventListener("click", function () {
    dialog.close();
  });

  dialog.addEventListener("click", function (event) {
    if (event.target === dialog) {
      dialog.close();
    }
  });

  dialog.addEventListener("close", function () {
    viewerImg.src = "";
    currentIndex = -1;
    if (lastTrigger) {
      lastTrigger.focus({ preventScroll: true });
      lastTrigger = null;
    }
  });
})();
