document.addEventListener("DOMContentLoaded", () => {
  // Track currently open popup
  let currentPopup = null;

  // Function to close all popups
  function closeAllPopups() {
    document.querySelectorAll(".popup-commentary, .popup-author, .popup-add, .popup-del")
      .forEach(p => {
        p.style.display = "none";
        // Remove close button if it exists
        const closeBtn = p.querySelector('.popup-close');
        if (closeBtn) closeBtn.remove();
      });
    currentPopup = null;
  }

  // Function to create and add close button
  function addCloseButton(popup) {
    if (popup.querySelector('.popup-close')) return; // Don't add if already exists
    
    const closeBtn = document.createElement('button');
    closeBtn.className = 'popup-close';
    closeBtn.innerHTML = '×';
    closeBtn.setAttribute('aria-label', 'Close popup');
    
    closeBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      closeAllPopups();
    });
    
    popup.appendChild(closeBtn);
  }

  // Function to position popup optimally
  function positionPopup(popup, clickEvent) {
    const rect = clickEvent.target.getBoundingClientRect();
    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;
    
    // Show popup to calculate its dimensions
    popup.style.display = 'block';
    popup.style.visibility = 'hidden';
    
    const popupRect = popup.getBoundingClientRect();
    
    // Calculate optimal position
    let left = Math.max(20, Math.min(viewportWidth - popupRect.width - 20, rect.left + rect.width / 2 - popupRect.width / 2));
    let top = rect.bottom + 10;
    
    // If popup would be cut off at bottom, show above the element
    if (top + popupRect.height > viewportHeight - 20) {
      top = rect.top - popupRect.height - 10;
    }
    
    // Ensure popup stays within viewport
    top = Math.max(20, Math.min(viewportHeight - popupRect.height - 20, top));
    
    popup.style.left = left + 'px';
    popup.style.top = top + 'px';
    popup.style.transform = 'none';
    popup.style.visibility = 'visible';
  }

  // Handle note toggle clicks
  document.querySelectorAll(".note-toggle").forEach(btn => {
    btn.addEventListener("click", e => {
      e.stopPropagation();
      
      const popup = btn.nextElementSibling;
      const isCurrentlyOpen = popup === currentPopup;

      // Close all popups first
      closeAllPopups();

      // If this popup wasn't open, open it
      if (!isCurrentlyOpen) {
        addCloseButton(popup);
        positionPopup(popup, e);
        currentPopup = popup;
      }
    });
  });

  // Handle clicks outside of notes
  document.addEventListener("click", e => {
    if (!e.target.closest(".note")) {
      closeAllPopups();
    }
  });

  // Handle escape key
  document.addEventListener("keydown", e => {
    if (e.key === "Escape") {
      closeAllPopups();
    }
  });

  // Handle window resize
  window.addEventListener("resize", () => {
    if (currentPopup && currentPopup.style.display === 'block') {
      // Reposition current popup on resize
      const viewportWidth = window.innerWidth;
      const popupRect = currentPopup.getBoundingClientRect();
      
      if (popupRect.right > viewportWidth || popupRect.left < 0) {
        currentPopup.style.left = Math.max(20, Math.min(viewportWidth - popupRect.width - 20, viewportWidth / 2 - popupRect.width / 2)) + 'px';
      }
    }
  });
});