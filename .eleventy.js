module.exports = function (eleventyConfig) {
  // Site-wide static assets
  eleventyConfig.addPassthroughCopy({ css: "css" });
  eleventyConfig.addPassthroughCopy({ images: "images" });
  eleventyConfig.addPassthroughCopy({ js: "js" });
  eleventyConfig.addPassthroughCopy({ "favicon.ico": "favicon.ico" });

  // Apps that are self-contained builds (React/Vue SPAs) and are not part
  // of the templated site — copied through untouched.
  eleventyConfig.addPassthroughCopy({
    "app/fidouchebaggery": "app/fidouchebaggery",
  });
  eleventyConfig.addPassthroughCopy({
    "app/professional-interactions": "app/professional-interactions",
  });
  eleventyConfig.addPassthroughCopy({
    "app/profile-viewer": "app/profile-viewer",
  });
  eleventyConfig.addPassthroughCopy({
    "app/sedition-art": "app/sedition-art",
  });

  // Per-project asset folders for the templated case-study pages
  eleventyConfig.addPassthroughCopy({ "app/anosmia/images": "app/anosmia/images" });
  eleventyConfig.addPassthroughCopy({ "app/anosmia/media": "app/anosmia/media" });
  eleventyConfig.addPassthroughCopy({ "app/az-drugs/media": "app/az-drugs/media" });
  eleventyConfig.addPassthroughCopy({ "app/bezor-software/images": "app/bezor-software/images" });
  eleventyConfig.addPassthroughCopy({ "app/data-viz/assets": "app/data-viz/assets" });
  eleventyConfig.addPassthroughCopy({ "app/data-viz/images": "app/data-viz/images" });
  eleventyConfig.addPassthroughCopy({ "app/data-viz/pollywaffle": "app/data-viz/pollywaffle" });
  eleventyConfig.addPassthroughCopy({ "app/farnsworth-711/images": "app/farnsworth-711/images" });
  eleventyConfig.addPassthroughCopy({ "app/preppr/images": "app/preppr/images" });
  eleventyConfig.addPassthroughCopy({ "app/reading-eggs/media": "app/reading-eggs/media" });
  eleventyConfig.addPassthroughCopy({ "app/scare-tactics/media": "app/scare-tactics/media" });
  eleventyConfig.addPassthroughCopy({ "app/there-will-be-blood/images": "app/there-will-be-blood/images" });
  eleventyConfig.addPassthroughCopy({ "app/vickers-vimy/media": "app/vickers-vimy/media" });
  eleventyConfig.addPassthroughCopy({ "app/wallsnap/images": "app/wallsnap/images" });
  eleventyConfig.addPassthroughCopy({ "app/wallsnap/media": "app/wallsnap/media" });
  eleventyConfig.addPassthroughCopy({ "app/womad/images": "app/womad/images" });

  return {
    dir: {
      input: "src",
      includes: "_includes",
      output: "_site",
    },
    htmlTemplateEngine: "njk",
    markdownTemplateEngine: "njk",
  };
};
