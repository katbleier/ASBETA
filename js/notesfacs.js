// synoptic.js - Handle synoptic view switching
document.addEventListener("DOMContentLoaded", () => {
  const synopticBtn = document.getElementById('toggle-synoptic');
  const textBtn = document.getElementById('toggle-text');
  const synopticContent = document.querySelector('.synoptic-content');
  const textOnlyContent = document.querySelector('.text-only-content');
  const columnHeaders = document.querySelector('.column-headers');

  if (synopticBtn && textBtn) {
    // Handle synoptic view button
    synopticBtn.addEventListener('click', () => {
      synopticBtn.classList.add('active');
      textBtn.classList.remove('active');
      
      if (synopticContent) synopticContent.style.display = 'flex';
      if (textOnlyContent) textOnlyContent.style.display = 'none';
      if (columnHeaders) columnHeaders.style.display = 'grid';
    });

    // Handle text-only view button
    textBtn.addEventListener('click', () => {
      textBtn.classList.add('active');
      synopticBtn.classList.remove('active');
      
      if (synopticContent) synopticContent.style.display = 'none';
      if (textOnlyContent) textOnlyContent.style.display = 'block';
      if (columnHeaders) columnHeaders.style.display = 'none';
    });
  }
});