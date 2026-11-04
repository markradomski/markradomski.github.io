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

  function openViewer(link) {
    var thumb = link.querySelector("img");
    viewerImg.src = link.getAttribute("href");
    viewerImg.alt = thumb ? thumb.alt : "";
    titleEl.textContent = link.dataset.title || "";
    metaEl.textContent = link.dataset.meta || "";
    dialog.showModal();
  }

  document.querySelectorAll(".art-link").forEach(function (link) {
    link.addEventListener("click", function (event) {
      event.preventDefault();
      openViewer(link);
    });
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
  });
})();
