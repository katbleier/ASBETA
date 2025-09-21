(function(){
  const panel = document.getElementById('notes-panel');
  if(!panel) return;
  document.addEventListener('click', (e)=>{
    const icon = e.target.closest('.note-icon');
    const closer = e.target.closest('[data-close-notes]');
    if(icon){
      panel.classList.add('open');
      const target = icon.getAttribute('data-note-id');
      if(target){
        const el = panel.querySelector(`[data-note="${target}"]`);
        if(el){ el.scrollIntoView({behavior:'smooth', block:'start'}); }
      }
    } else if(closer){
      panel.classList.remove('open');
    }
  });
})();
