document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".note-toggle").forEach(btn => {
    btn.addEventListener("click", e => {
      const popup = btn.nextElementSibling;
      const isVisible = popup.style.display === "block";

      // Alle Kommentar-/Autor-Popups schließen
      document.querySelectorAll(".popup-commentary, .popup-author")
        .forEach(p => p.style.display = "none");

      // Toggle aktuelle
      popup.style.display = isVisible ? "none" : "block";
    });
  });

  // Schließen, wenn außerhalb geklickt
  document.addEventListener("click", e => {
    if (!e.target.closest(".note")) {
      document.querySelectorAll(".popup-commentary, .popup-author")
        .forEach(p => p.style.display = "none");
    }
  });
});
