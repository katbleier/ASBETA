// Digital Edition App for Schönberg Diary
class SchönbergEdition {
    constructor() {
        this.teiDoc = null;
        this.entries = [];
        this.persons = [];
        this.places = [];
        this.works = [];
        this.organizations = [];
        this.currentEntry = 0;
        
        this.init();
    }
    
    async init() {
        try {
            await this.loadTEI();
            this.parseIndexes();
            this.parseEntries();
            this.setupNavigation();
            this.updateStats();
            this.showSection('home');
        } catch (error) {
            console.error('Fehler beim Laden der Edition:', error);
            this.showError('Die TEI-Datei konnte nicht geladen werden.');
        }
    }
    
    async loadTEI() {
        const response = await fetch('data/berliner-tagebuch.xml');
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const xmlText = await response.text();
        const parser = new DOMParser();
        this.teiDoc = parser.parseFromString(xmlText, 'text/xml');
        
        // Check for parsing errors
        const parserError = this.teiDoc.querySelector('parsererror');
        if (parserError) {
            throw new Error('XML parsing error: ' + parserError.textContent);
        }
    }
    
    parseIndexes() {
        // Parse persons
        const personNodes = this.teiDoc.querySelectorAll('listPerson person');
        this.persons = Array.from(personNodes).map(person => ({
            id: person.getAttribute('xml:id'),
            name: person.querySelector('persName').textContent.trim(),
            gnd: person.querySelector('idno[type="gnd"]')?.textContent || null,
            ref: person.querySelector('persName').getAttribute('ref') || null
        }));
        
        // Parse places
        const placeNodes = this.teiDoc.querySelectorAll('listPlace place');
        this.places = Array.from(placeNodes).map(place => ({
            id: place.getAttribute('xml:id'),
            name: place.querySelector('placeName').textContent.trim(),
            geo: place.querySelector('geo')?.textContent || null,
            ref: place.querySelector('placeName').getAttribute('ref') || null
        }));
        
        // Parse works/bibl
        const biblNodes = this.teiDoc.querySelectorAll('listBibl bibl');
        this.works = Array.from(biblNodes).map(bibl => ({
            id: bibl.getAttribute('xml:id'),
            title: bibl.querySelector('title').textContent.trim(),
            author: bibl.querySelector('author persName')?.textContent.trim() || null,
            ref: bibl.querySelector('title').getAttribute('ref') || null
        }));
        
        // Parse organizations
        const orgNodes = this.teiDoc.querySelectorAll('listOrg org');
        this.organizations = Array.from(orgNodes).map(org => ({
            id: org.getAttribute('xml:id'),
            name: org.querySelector('orgName').textContent.trim(),
            gnd: org.querySelector('idno[type="gnd"]')?.textContent || null,
            ref: org.querySelector('orgName').getAttribute('ref') || null
        }));
    }
    
    parseEntries() {
        const entryNodes = this.teiDoc.querySelectorAll('div[type="entry"]');
        this.entries = Array.from(entryNodes).map((entry, index) => {
            const dateNode = entry.querySelector('date');
            const date = dateNode ? dateNode.getAttribute('when') : null;
            const dateText = dateNode ? dateNode.textContent.trim() : `Eintrag ${index + 1}`;
            
            // Get text content for preview (first 150 chars)
            const textContent = entry.textContent.trim();
            const preview = textContent.length > 150 ? 
                textContent.substring(0, 150) + '...' : textContent;
            
            return {
                n: entry.getAttribute('n') || (index + 1),
                date: date,
                dateText: dateText,
                preview: preview,
                element: entry,
                facsimile: entry.querySelector('pb')?.getAttribute('facs') || null
            };
        });
    }
    
    setupNavigation() {
        // Main navigation
        document.getElementById('nav-entries').addEventListener('click', (e) => {
            e.preventDefault();
            this.showSection('entries');
        });
        
        document.getElementById('nav-persons').addEventListener('click', (e) => {
            e.preventDefault();
            this.showSection('persons');
        });
        
        document.getElementById('nav-places').addEventListener('click', (e) => {
            e.preventDefault();
            this.showSection('places');
        });
        
        document.getElementById('nav-works').addEventListener('click', (e) => {
            e.preventDefault();
            this.showSection('works');
        });
        
        document.getElementById('nav-orgs').addEventListener('click', (e) => {
            e.preventDefault();
            this.showSection('organizations');
        });
        
        document.getElementById('nav-about').addEventListener('click', (e) => {
            e.preventDefault();
            this.showSection('about');
        });
        
        // Home page buttons
        document.getElementById('start-reading').addEventListener('click', () => {
            this.showSection('entries');
        });
        
        document.getElementById('browse-indexes').addEventListener('click', () => {
            this.showSection('persons');
        });
        
        // Entry navigation
        document.getElementById('back-to-list').addEventListener('click', () => {
            this.showSection('entries');
        });
        
        document.getElementById('prev-entry').addEventListener('click', () => {
            if (this.currentEntry > 0) {
                this.currentEntry--;
                this.showEntry(this.currentEntry);
            }
        });
        
        document.getElementById('next-entry').addEventListener('click', () => {
            if (this.currentEntry < this.entries.length - 1) {
                this.currentEntry++;
                this.showEntry(this.currentEntry);
            }
        });
        
        // Logo/title link to home
        document.querySelector('.main-header h1').addEventListener('click', () => {
            this.showSection('home');
        });
        
        // Add cursor pointer to header
        document.querySelector('.main-header h1').style.cursor = 'pointer';
    }
    
    showSection(sectionName) {
        // Hide all sections
        document.querySelectorAll('.content-section').forEach(section => {
            section.classList.remove('active');
        });
        
        // Update navigation
        document.querySelectorAll('.main-nav a').forEach(link => {
            link.classList.remove('active');
        });
        
        // Show selected section
        document.getElementById(sectionName).classList.add('active');
        
        // Update active nav link
        const navMap = {
            'home': '',
            'entries': 'nav-entries',
            'entry-detail': 'nav-entries',
            'persons': 'nav-persons',
            'places': 'nav-places',
            'works': 'nav-works',
            'organizations': 'nav-orgs',
            'about': 'nav-about'
        };
        
        const activeNavId = navMap[sectionName];
        if (activeNavId) {
            document.getElementById(activeNavId).classList.add('active');
        }
        
        // Load content based on section
        switch(sectionName) {
            case 'entries':
                this.renderEntriesList();
                break;
            case 'persons':
                this.renderPersonsList();
                break;
            case 'places':
                this.renderPlacesList();
                break;
            case 'works':
                this.renderWorksList();
                break;
            case 'organizations':
                this.renderOrganizationsList();
                break;
        }
    }
    
    renderEntriesList() {
        const container = document.getElementById('entries-list');
        container.innerHTML = '';
        
        this.entries.forEach((entry, index) => {
            const entryCard = document.createElement('div');
            entryCard.className = 'entry-card';
            entryCard.innerHTML = `
                <div class="entry-date">${entry.dateText}</div>
                <div class="entry-preview">${entry.preview}</div>
            `;
            
            entryCard.addEventListener('click', () => {
                this.currentEntry = index;
                this.showEntry(index);
            });
            
            container.appendChild(entryCard);
        });
    }
    
    showEntry(index) {
        this.currentEntry = index;
        const entry = this.entries[index];
        
        // Show entry detail section
        this.showSection('entry-detail');
        
        // Update navigation buttons
        document.getElementById('prev-entry').disabled = index === 0;
        document.getElementById('next-entry').disabled = index === this.entries.length - 1;
        
        // Render entry content
        this.renderEntry(entry);
    }
    
    renderEntry(entry) {
        const container = document.getElementById('entry-content');
        
        // Clone and process the entry element
        const entryClone = entry.element.cloneNode(true);
        
        // Process TEI elements for display
        this.processTEIElements(entryClone);
        
        // Build HTML content
        let html = `<div class="date">${entry.dateText}</div>`;
        
        // Add facsimile link if available
        if (entry.facsimile) {
            html += `<div class="facsimile-link">
                <a href="${entry.facsimile}" target="_blank" class="btn btn-secondary">
                    📄 Faksimile anzeigen
                </a>
            </div>`;
        }
        
        // Add entry content
        html += `<div class="entry-text">${entryClone.innerHTML}</div>`;
        
        container.innerHTML = html;
        
        // Add click handlers for references
        this.addReferenceHandlers(container);
    }
    
    processTEIElements(element) {
        // Remove TEI-specific elements we don't want to display
        const toRemove = element.querySelectorAll('pb, head');
        toRemove.forEach(el => el.remove());
        
        // Process persName elements
        const persNames = element.querySelectorAll('persName');
        persNames.forEach(persName => {
            const ref = persName.getAttribute('ref');
            if (ref) {
                const personId = ref.replace('#', '');
                const person = this.persons.find(p => p.id === personId);
                if (person) {
                    persName.setAttribute('title', `Person: ${person.name}`);
                    persName.setAttribute('data-person-id', personId);
                }
            }
            persName.classList.add('persName');
        });
        
        // Process placeName elements
        const placeNames = element.querySelectorAll('placeName');
        placeNames.forEach(placeName => {
            const ref = placeName.getAttribute('ref');
            if (ref) {
                const placeId = ref.replace('#', '');
                const place = this.places.find(p => p.id === placeId);
                if (place) {
                    placeName.setAttribute('title', `Ort: ${place.name}`);
                    placeName.setAttribute('data-place-id', placeId);
                }
            }
            placeName.classList.add('placeName');
        });
        
        // Process orgName elements
        const orgNames = element.querySelectorAll('orgName');
        orgNames.forEach(orgName => {
            const ref = orgName.getAttribute('ref');
            if (ref) {
                const orgId = ref.replace('#', '');
                const org = this.organizations.find(o => o.id === orgId);
                if (org) {
                    orgName.setAttribute('title', `Organisation: ${org.name}`);
                    orgName.setAttribute('data-org-id', orgId);
                }
            }
            orgName.classList.add('orgName');
        });
        
        // Process title elements (works)
        const titles = element.querySelectorAll('title');
        titles.forEach(title => {
            const ref = title.getAttribute('ref');
            if (ref) {
                const workId = ref.replace('#', '');
                const work = this.works.find(w => w.id === workId);
                if (work) {
                    title.setAttribute('title', `Werk: ${work.title}${work.author ? ' von ' + work.author : ''}`);
                    title.setAttribute('data-work-id', workId);
                }
            }
            title.classList.add('title');
        });
        
        // Process del elements (deletions)
        const deletions = element.querySelectorAll('del');
        deletions.forEach(del => {
            del.classList.add('del');
        });
        
        // Process hi elements (highlighting)
        const highlights = element.querySelectorAll('hi');
        highlights.forEach(hi => {
            const rend = hi.getAttribute('rend');
            if (rend) {
                hi.classList.add('hi');
                hi.setAttribute('rend', rend);
            }
        });
    }
    
    addReferenceHandlers(container) {
        // Person references
        container.querySelectorAll('.persName[data-person-id]').forEach(el => {
            el.addEventListener('click', (e) => {
                e.preventDefault();
                const personId = el.getAttribute('data-person-id');
                this.showPersonPopup(personId);
            });
        });
        
        // Place references
        container.querySelectorAll('.placeName[data-place-id]').forEach(el => {
            el.addEventListener('click', (e) => {
                e.preventDefault();
                const placeId = el.getAttribute('data-place-id');
                this.showPlacePopup(placeId);
            });
        });
        
        // Organization references
        container.querySelectorAll('.orgName[data-org-id]').forEach(el => {
            el.addEventListener('click', (e) => {
                e.preventDefault();
                const orgId = el.getAttribute('data-org-id');
                this.showOrgPopup(orgId);
            });
        });
        
        // Work references
        container.querySelectorAll('.title[data-work-id]').forEach(el => {
            el.addEventListener('click', (e) => {
                e.preventDefault();
                const workId = el.getAttribute('data-work-id');
                this.showWorkPopup(workId);
            });
        });
    }
    
    showPersonPopup(personId) {
        const person = this.persons.find(p => p.id === personId);
        if (person) {
            alert(`Person: ${person.name}\n${person.gnd ? 'GND: ' + person.gnd : 'Keine GND-ID verfügbar'}`);
            // TODO: Implement proper popup/modal
        }
    }
    
    showPlacePopup(placeId) {
        const place = this.places.find(p => p.id === placeId);
        if (place) {
            alert(`Ort: ${place.name}\n${place.geo ? 'Koordinaten: ' + place.geo : 'Keine Koordinaten verfügbar'}`);
            // TODO: Implement proper popup/modal with map
        }
    }
    
    showOrgPopup(orgId) {
        const org = this.organizations.find(o => o.id === orgId);
        if (org) {
            alert(`Organisation: ${org.name}\n${org.gnd ? 'GND: ' + org.gnd : 'Keine GND-ID verfügbar'}`);
            // TODO: Implement proper popup/modal
        }
    }
    
    showWorkPopup(workId) {
        const work = this.works.find(w => w.id === workId);
        if (work) {
            alert(`Werk: ${work.title}\n${work.author ? 'Komponist: ' + work.author : 'Unbekannter Komponist'}`);
            // TODO: Implement proper popup/modal
        }
    }
    
    renderPersonsList() {
        const container = document.getElementById('persons-list');
        container.innerHTML = '';
        
        this.persons
            .sort((a, b) => a.name.localeCompare(b.name))
            .forEach(person => {
                const item = document.createElement('div');
                item.className = 'index-item';
                item.innerHTML = `
                    <h4>${person.name}</h4>
                    ${person.gnd ? `<a href="https://d-nb.info/gnd/${person.gnd}" target="_blank" class="gnd-link">GND: ${person.gnd}</a>` : '<span class="no-gnd">Keine GND-ID</span>'}
                `;
                container.appendChild(item);
            });
    }
    
    renderPlacesList() {
        const container = document.getElementById('places-list');
        container.innerHTML = '';
        
        this.places
            .sort((a, b) => a.name.localeCompare(b.name))
            .forEach(place => {
                const item = document.createElement('div');
                item.className = 'index-item';
                item.innerHTML = `
                    <h4>${place.name}</h4>
                    ${place.geo ? `<div class="coordinates">Koordinaten: ${place.geo}</div>` : ''}
                    ${place.ref ? `<a href="${place.ref}" target="_blank" class="gnd-link">Externe Referenz</a>` : ''}
                `;
                container.appendChild(item);
            });
    }
    
    renderWorksList() {
        const container = document.getElementById('works-list');
        container.innerHTML = '';
        
        this.works
            .sort((a, b) => a.title.localeCompare(b.title))
            .forEach(work => {
                const item = document.createElement('div');
                item.className = 'index-item';
                item.innerHTML = `
                    <h4>${work.title}</h4>
                    ${work.author ? `<div class="author">Komponist: ${work.author}</div>` : ''}
                    ${work.ref ? `<a href="${work.ref}" target="_blank" class="gnd-link">GND-Eintrag</a>` : ''}
                `;
                container.appendChild(item);
            });
    }
    
    renderOrganizationsList() {
        const container = document.getElementById('orgs-list');
        container.innerHTML = '';
        
        this.organizations
            .sort((a, b) => a.name.localeCompare(b.name))
            .forEach(org => {
                const item = document.createElement('div');
                item.className = 'index-item';
                item.innerHTML = `
                    <h4>${org.name}</h4>
                    ${org.gnd ? `<a href="https://d-nb.info/gnd/${org.gnd}" target="_blank" class="gnd-link">GND: ${org.gnd}</a>` : '<span class="no-gnd">Keine GND-ID</span>'}
                `;
                container.appendChild(item);
            });
    }
    
    updateStats() {
        document.getElementById('person-count').textContent = this.persons.length;
        document.getElementById('place-count').textContent = this.places.length;
        document.getElementById('work-count').textContent = this.works.length;
    }
    
    showError(message) {
        const container = document.getElementById('content');
        container.innerHTML = `
            <div class="error-message">
                <h3>Fehler</h3>
                <p>${message}</p>
                <p>Bitte stellen Sie sicher, dass die Datei 'data/diary.xml' korrekt im Repository liegt.</p>
            </div>
        `;
    }
}

// Initialize the application when the page loads
document.addEventListener('DOMContentLoaded', () => {
    new SchönbergEdition();
});