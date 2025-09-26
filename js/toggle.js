(function(){
  const saved = localStorage.getItem('viewMode') || 'reading';
  document.body.classList.add(saved === 'reading' ? 'mode-reading' : 'mode-diplomatic');
  const btn = document.getElementById('toggle-view');
  if(btn){
    const setLabel = () => btn.textContent = document.body.classList.contains('mode-reading')
      ? 'Kritische Fassung' : 'Lesefassung';
    setLabel();
    btn.addEventListener('click', () => {
      const reading = document.body.classList.toggle('mode-reading');
      document.body.classList.toggle('mode-diplomatic', !reading);
      localStorage.setItem('viewMode', reading ? 'reading' : 'diplomatic');
      setLabel();
    });
  }
})();
