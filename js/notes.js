document.addEventListener("DOMContentLoaded", () => {
  // Toggle for commentary & author notes (already there)
  document.querySelectorAll(".note-toggle").forEach(...);

  // NEW: toggle for textcritical popups
  document.querySelectorAll(".textcrit .del-text, .textcrit .add-text").forEach(el => {
    el.addEventListener("click", e => {
      const popup = el.nextElementSibling;
      const isVisible = popup.style.display === "block";

      // Hide all others
      document.querySelectorAll(".del-popup, .add-popup").forEach(p => p.style.display = "none");

      // Toggle current
      popup.style.display = isVisible ? "none" : "block";
    });
  });

  // Close when clicking outside
  document.addEventListener("click", e => {
    if (!e.target.closest(".textcrit")) {
      document.querySelectorAll(".del-popup, .add-popup").forEach(p => p.style.display = "none");
    }
  });
});
