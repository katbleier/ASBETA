document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".note-toggle").forEach(btn => {
    btn.addEventListener("click", e => {
      const popup = btn.nextElementSibling;
      const isVisible = popup.style.display === "block";

      // Hide all other popups first
      document.querySelectorAll(".note-popup").forEach(p => {
        p.style.display = "none";
      });

      // Toggle this one
      popup.style.display = isVisible ? "none" : "block";
    });
  });

  // Close popup if clicking elsewhere
  document.addEventListener("click", e => {
    if (!e.target.closest(".note.commentary") && !e.target.closest(".note.author")) {
      document.querySelectorAll(".note-popup").forEach(p => {
        p.style.display = "none";
      });
    }
  });
});
