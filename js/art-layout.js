(function () {
  "use strict";

  var gallery = document.getElementById("art-gallery");
  if (!gallery) return;

  var items = Array.prototype.slice.call(
    gallery.querySelectorAll(".art-item")
  );
  if (items.length === 0) return;

  var mq = window.matchMedia("(min-width: 768px)");

  function heightUnit(item) {
    var parts = item.dataset.aspect.split("/");
    var width = Number(parts[0]);
    var height = Number(parts[1]);
    return height / width;
  }

  function layoutColumns() {
    var columnCount = 3;
    var columns = [];
    var heights = [];
    for (var c = 0; c < columnCount; c++) {
      var col = document.createElement("div");
      col.className = "art-column";
      columns.push(col);
      heights.push(0);
    }

    items.forEach(function (item, index) {
      var target;
      if (index < columnCount) {
        target = index;
      } else {
        target = heights.indexOf(Math.min.apply(null, heights));
      }
      columns[target].appendChild(item);
      heights[target] += heightUnit(item);
    });

    var frag = document.createDocumentFragment();
    columns.forEach(function (col) {
      frag.appendChild(col);
    });
    gallery.innerHTML = "";
    gallery.appendChild(frag);
  }

  function layoutSingle() {
    var frag = document.createDocumentFragment();
    items.forEach(function (item) {
      frag.appendChild(item);
    });
    gallery.innerHTML = "";
    gallery.appendChild(frag);
  }

  function applyLayout() {
    if (mq.matches) {
      layoutColumns();
    } else {
      layoutSingle();
    }
  }

  applyLayout();
  mq.addEventListener("change", applyLayout);
})();
